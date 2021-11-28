//
//  VideoPlayerView.swift
//  FeatureIntermediate
//
//  Created by Pyretttt on 07.11.2021.
//

import AVFoundation
import UIKit

open class VideoPlayerView: UIView {
	
	private enum Constants {
		static let iconSize: CGFloat = 56
		static let actionBarHeight: CGFloat = 24
		static let iconEdgeSize: CGFloat = NumericValues.xLarge
		static let disappearDelay: TimeInterval = 3
		
		static let unknownRemainingTime = "N/A"
		
		static let primaryColor: UIColor = Pallete.Black.black4
		static let controlTintColor: UIColor = Pallete.Gray.gray1
	}
	
	private enum Images {
		static let play = ImageSource.play.image
		static let pause = ImageSource.pause.image
		static let dead = ImageSource.dead.image
		static let dotsVertical = ImageSource.ic24_dotsHorizontal.image
		static let fullScreen = ImageSource.ic24_fullScreen.image
	}
	
	let player: AVPlayer = AVPlayer()
	private lazy var playbackAssistant: PlaybackAssistant = PlaybackAssistant()
	
	private var state: PlaybackAssistant.PlaybackState = .initial
	
	// MARK: - Visual elements
	
	private lazy var backgrounderView: UIView = {
		let view = UIView()
		view.backgroundColor = Constants.primaryColor
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	private lazy var playerLayer: AVPlayerLayer = {
		let layer = AVPlayerLayer()
		layer.player = player
		return layer
	}()
	
	private(set) lazy var contentView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Pallete.Utility.transparent
		
		return view
	}()
	
	private lazy var optionsButton: UIButton = {
		let view = UIButton()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.setImage(Images.dotsVertical, for: .normal)
		view.contentMode = .scaleAspectFit
		view.imageView?.tintColor = Constants.controlTintColor
		view.menu = optionsMenu
		view.showsMenuAsPrimaryAction = true
		
		return view
	}()
	
	private lazy var optionsMenu: UIMenu = {
		var speedOptions: [UIAction] = []
		for i in 1...4 {
			let speed: Float = Float(i) / 2
			let action = UIAction(title: "\(speed)X",
								  image: nil) { [weak self] _ in
				guard let self = self else { return }
				self.playbackAssistant.videoPlayView(self, changePlaybackRate: speed)
			}
			speedOptions.append(action)
		}
		
		let view = UIMenu(title: "Скорость воспроизведения",
						  image: nil,
						  children: speedOptions)
		
		return view
	}()
	
	let remainingTimeLabel: UILabel = {
		let view = UILabel()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.numberOfLines = 0
		view.font = TextFont.base.withSize(NumericValues.medium)
		view.textColor = Pallete.Light.white1
		view.text = Constants.unknownRemainingTime
		view.setContentHuggingPriority(.required, for: .horizontal)
		view.setContentCompressionResistancePriority(.required, for: .horizontal)
		
		return view
	}()
	
	private(set) lazy var progressView: UISlider = {
		let view = UISlider()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.thumbTintColor = Pallete.Lilac.lilac1
		view.minimumTrackTintColor = Pallete.Lilac.lilac1
		view.maximumTrackTintColor = Pallete.Gray.gray4
		view.setContentHuggingPriority(.defaultLow, for: .horizontal)
		view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
		
		view.addTarget(self, action: #selector(didChangeProgressValue), for: .valueChanged)
		view.addTarget(self, action: #selector(pausePlayer), for: .touchDown)
		view.addTarget(self, action: #selector(resumePlayer), for: .touchUpInside)
		view.addTarget(self, action: #selector(resumePlayer), for: .touchUpOutside)
		
		return view
	}()
	
	private lazy var screenRotationButton: UIButton = {
		let view = UIButton()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.setImage(Images.fullScreen, for: .normal)
		view.contentMode = .scaleAspectFit
		view.imageView?.tintColor = Constants.controlTintColor
		view.addTarget(self, action: #selector(didTapRotateButton), for: .touchUpInside)
		
		return view
	}()
	
	private let spinningView: SpinningView = {
		let view = SpinningView()
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	private lazy var playPauseButton: UIButton = {
		let view = UIButton()
		view.imageView?.tintColor = Constants.controlTintColor
		view.translatesAutoresizingMaskIntoConstraints = false
		view.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
		
		return view
	}()
	
	private lazy var topItemsStack: UIStackView = { itemsStackViewVertical }()
	private lazy var bottomItemsStack: UIStackView = { itemsStackViewVertical }()
	private var itemsStackViewVertical: UIStackView {
		let view = UIStackView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.axis = .horizontal
		view.alignment = .center
		view.distribution = .fill
		view.spacing = NumericValues.large
		
		return view
	}
	
	// MARK: - Lifecycle
	
	public init() {
		super.init(frame: .zero)
		setupUI()
		
		transition(to: .initial)
	}
	
	@available(*, unavailable)
	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		playerLayer.frame = bounds.inset(by: safeAreaInsets)
	}
	
	// MARK: - Setup UI
	
	private func setupUI() {
		let views: [UIView] = [backgrounderView, contentView]
		views.forEach { addSubview($0) }
		let contentViews = [playPauseButton, topItemsStack, bottomItemsStack, spinningView]
		contentViews.forEach { contentView.addSubview($0) }
		
		let topBarViews = [SpacerView(), optionsButton]
		topBarViews.forEach { topItemsStack.addArrangedSubview($0) }
		let bottomBarViews = [remainingTimeLabel, progressView, screenRotationButton]
		bottomBarViews.forEach { bottomItemsStack.addArrangedSubview($0) }
		
		setupConstraints()
		layer.insertSublayer(playerLayer, above: backgrounderView.layer)
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			backgrounderView.topAnchor.constraint(equalTo: topAnchor),
			backgrounderView.leadingAnchor.constraint(equalTo: leadingAnchor),
			backgrounderView.trailingAnchor.constraint(equalTo: trailingAnchor),
			backgrounderView.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
			
			topItemsStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: NumericValues.small),
			topItemsStack.heightAnchor.constraint(equalToConstant: Constants.actionBarHeight),
			topItemsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
												   constant: NumericValues.medium),
			topItemsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
													constant: -NumericValues.medium),
			
			bottomItemsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
													 constant: -NumericValues.small),
			bottomItemsStack.heightAnchor.constraint(equalToConstant: Constants.actionBarHeight),
			bottomItemsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
													  constant: NumericValues.medium),
			bottomItemsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
													   constant: -NumericValues.medium),
			
			playPauseButton.heightAnchor.constraint(equalToConstant: Constants.iconSize),
			playPauseButton.widthAnchor.constraint(equalTo: playPauseButton.heightAnchor),
			playPauseButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			playPauseButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			
			spinningView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			spinningView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])
		
		[optionsButton, screenRotationButton].forEach {
			NSLayoutConstraint.activate([
				$0.heightAnchor.constraint(equalToConstant: Constants.iconEdgeSize),
				$0.widthAnchor.constraint(equalTo: $0.heightAnchor)
			])
		}
	}
	
	// MARK: - Data
	
	func transition(to newState: PlaybackAssistant.PlaybackState) {
		state = newState
		
		spinningView.isHidden = true
		topItemsStack.isHidden = true
		playPauseButton.isEnabled = true
		playPauseButton.isHidden = false
		spinningView.stopAnimation()
		
		switch state {
		case .paused:
			topItemsStack.isHidden = false
			playPauseButton.setImage(Images.play, for: .normal)
		case .loading:
			spinningView.isHidden = false
			playPauseButton.isHidden = true
			spinningView.startAnimation()
		case .playing:
			topItemsStack.isHidden = false
			optionsButton.isHidden = false
			playPauseButton.setImage(Images.pause, for: .normal)
		case .error:
			remainingTimeLabel.text = Constants.unknownRemainingTime
			playPauseButton.setImage(Images.dead, for: .normal)
			playPauseButton.isEnabled = false
		case .initial:
			remainingTimeLabel.text = Constants.unknownRemainingTime
			contentView.isHidden = false
		}
	}
	
	public func launchVideo(videoURL: URL) {
		playbackAssistant.videoPlayer(self, launchVideoAt: videoURL)
	}
	
	// MARK: - Actions
	
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		if contentView.isHidden {
			playbackAssistant.videoPlayerView(self, hideControlsAfter: Constants.disappearDelay)
		}
		contentView.isHidden.toggle()
	}
	
	@objc
	private func didTapPlayButton() {
		switch state {
		case .paused:
			resumePlayer()
		case .playing:
			pausePlayer()
		default:
			break
		}
	}
	
	@objc
	private func didChangeProgressValue() {
		playbackAssistant.videoPlayer(player, seekTo: progressView.value)
	}
	
	@objc
	private func pausePlayer() {
		playbackAssistant.videoPlayerViewPausePlayback(self)
		playbackAssistant.nullifyDisappearanceCountDown()
	}
	
	@objc
	private func resumePlayer() {
		playbackAssistant.videoPlayerViewResumePlayback(self)
		playbackAssistant.videoPlayerView(self, hideControlsAfter: Constants.disappearDelay)
	}
	
	@objc
	private func didTapRotateButton() {
		let currentOrientation = UIDevice.current.orientation
		let portraitOrientations: [UIDeviceOrientation] = [.portrait, .portraitUpsideDown, .unknown]
		if portraitOrientations.contains(currentOrientation) {
			UIDevice.current.forceRotation(.landscapeRight)
		} else {
			UIDevice.current.forceRotation(.portrait)
		}
	}
}
