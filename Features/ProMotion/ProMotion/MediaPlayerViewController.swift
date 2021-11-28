//
//  MediaPickerViewController.swift
//  ProMotion
//
//  Created by Pyretttt on 05.11.2021.
//

import FeatureIntermediate
import RxSwift
import PhotosUI

protocol MediaPlayerPresenterProtocol {
}

final class MediaPlayerViewController: UIViewController, UIRotatable {
	
	private enum Constants {
		static let primaryColor: UIColor = Pallete.Gray.gray3
		
		static let requiredMediaType: String = UTType.movie.identifier
	}

	// MARK: - Visual elements
	
	private let videoPlayerView: VideoPlayerView = {
		let view = VideoPlayerView()
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	private let launchMovieButton: PlainButton = {
		let view = PlainButton()
		view.setTitle("Запустить видео", for: .normal)
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	private lazy var videoPickerController: PHPickerViewController = {
		var config = PHPickerConfiguration()
		config.filter = .videos
		config.preferredAssetRepresentationMode = .current
		config.selectionLimit = 1
		let controller = PHPickerViewController(configuration: config)
		controller.delegate = self
		
		return controller
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
		setupActions()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: animated)
		navigationController?.navigationBar.applyStyle(.standard)
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
			
			let portraitOrienntations: [UIDeviceOrientation] = [.portrait, .portraitUpsideDown, .unknown]
			let landscapeOrienntations: [UIDeviceOrientation] = [.landscapeLeft, .landscapeRight]
			let currentOrientation = UIDevice.current.orientation
			
			if portraitOrienntations.contains(currentOrientation) {
				self.navigationController?.setNavigationBarHidden(false, animated: false)
				NSLayoutConstraint.deactivate(regularPlayerContraints)
				NSLayoutConstraint.activate(compactPlayerContraints)
			} else if landscapeOrienntations.contains(currentOrientation) {
				NSLayoutConstraint.deactivate(compactPlayerContraints)
				NSLayoutConstraint.activate(regularPlayerContraints)
				self.navigationController?.setNavigationBarHidden(true, animated: false)
			}
		}
	}
	
	// MARK: - Setup UI
	
	private func setupUI() {
		view.backgroundColor = Constants.primaryColor
		
		let views = [videoPlayerView, launchMovieButton]
		views.forEach { view.addSubview($0) }
		setupConstraints()
		
		view.bringSubviewToFront(videoPlayerView)
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate(compactPlayerContraints + [
			launchMovieButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
													  constant: -NumericValues.large),
			launchMovieButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
													   constant: NumericValues.large),
			launchMovieButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
														constant: -NumericValues.large)
		])
	}
	
	// MARK: - Actions
	
	private func setupActions() {
		launchMovieButton.action = { [weak self] in
			guard let self = self else { return }
			self.present(self.videoPickerController, animated: true)
		}
	}
}

extension MediaPlayerViewController: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		guard results.count == 1,
			  let result = results.first?.itemProvider,
			  result.hasItemConformingToTypeIdentifier(Constants.requiredMediaType) else {
				  picker.dismiss(animated: true)
				  return
			  }
		
		result.loadFileRepresentation(forTypeIdentifier: Constants.requiredMediaType) { [weak self] videoURL, error in
			if let error = error {
				print(error.localizedDescription)
			}
			
			let fm = FileManager.default
			guard let url = videoURL,
				  let cachesDirectoryURL = fm.urls(for: .cachesDirectory, in: .userDomainMask).first else {
					  return
				  }
			let destionationURL = cachesDirectoryURL.appendingPathComponent(url.lastPathComponent)
			
			do {
				if fm.fileExists(atPath: destionationURL.path) {
					try fm.removeItem(atPath: destionationURL.path)
				}
				try fm.copyItem(at: url, to: destionationURL)
				
				DispatchQueue.main.async {
					self?.videoPickerController.dismiss(animated: true, completion: {
						self?.videoPlayerView.launchVideo(videoURL: destionationURL)
					})
				}
			} catch {
				print(error.localizedDescription)
			}
		}
	}
}
