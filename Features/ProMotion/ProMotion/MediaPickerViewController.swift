//
//  MediaPickerViewController.swift
//  ProMotion
//
//  Created by Pyretttt on 05.11.2021.
//

import FeatureIntermediate
import RxSwift

final class MediaPickerViewController: UIViewController, UIRotatable {
	
	private enum Constants {
		static let primaryColor: UIColor = Pallete.Gray.gray3
	}
	
	// MARK: - Visual elements
	
	private let videoPlayerView: VideoPlayerView = {
		let view = VideoPlayerView()
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	// MARK: - Constraints
	
	private lazy var compactPlayerContraints: [NSLayoutConstraint] = [
		videoPlayerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
		videoPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
		videoPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		videoPlayerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250)
	]
	
	private lazy var regularPlayerContraints: [NSLayoutConstraint] = [
		videoPlayerView.topAnchor.constraint(equalTo: view.topAnchor),
		videoPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
		videoPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		videoPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
	]
	
	// MARK: - UIViewController
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		.allButUpsideDown
	}
	
	// MARK: - Lifecycle
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: animated)
		navigationController?.navigationBar.applyStyle(.standard)
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		let bundle = Bundle(for: Self.self)
		let videoURL = bundle.url(forResource: "Example", withExtension: "MP4")
		videoPlayerView.playVideo(videoURL: videoURL!)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		UIDevice.current.forceRotation(.portrait)
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		guard let previousTraitCollection = previousTraitCollection else {
			return
		}

		if traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass
			|| traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass {
			
			if traitCollection.horizontalSizeClass == .regular {
				self.navigationController?.setNavigationBarHidden(true, animated: false)
				activateRegularConstraints()
			} else {
				activateCompactConstraints()
				self.navigationController?.setNavigationBarHidden(false, animated: false)
			}
		}
	}
	
	// MARK: - Setup UI
	
	private func setupUI() {
		view.backgroundColor = Constants.primaryColor
		
		let views = [videoPlayerView]
		views.forEach { view.addSubview($0) }
		setupConstraints()
	}
	
	private func activateCompactConstraints() {
		NSLayoutConstraint.deactivate(regularPlayerContraints)
		NSLayoutConstraint.activate(compactPlayerContraints)
	}
	
	private func activateRegularConstraints() {
		NSLayoutConstraint.deactivate(compactPlayerContraints)
		NSLayoutConstraint.activate(regularPlayerContraints)
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate(compactPlayerContraints + [
		])
	}
}
