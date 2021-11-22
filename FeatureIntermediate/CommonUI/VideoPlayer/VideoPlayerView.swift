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
		static let seekInterval: Double = 10
		
		static let unknownRemainingTime = "N/A"
		
		static let controlTintColor: UIColor = Pallete.Gray.gray1
	}
	
	private struct Images {
		let play = ImageSource.play.image
		let pause = ImageSource.pause.image
		let dead = ImageSource.dead.image
		let dotsVertical = ImageSource.ic24_dotsHorizontal.image
		let fullScreen = ImageSource.ic24_fullScreen.image
	}
	
	private enum State {
		case initial
		case loading
		case error
		case playing
		case paused
	}

	private let config: Configuration
	
	private let images = Images()
	private var state: State = .initial {
		didSet {
			transitionToState(state: state)
		}
	}

	private var player: AVPlayer? {
		get { playerLayer.player }
		set { playerLayer.player = newValue }
	}
	
	private var _observationToken: NSKeyValueObservation?
	private var observationToken: NSKeyValueObservation? {
		get { _observationToken }
		set {
			if _observationToken != nil {
				_observationToken?.invalidate()
			}
			_observationToken = newValue
		}
	}
	private var progressObserver: Any? {
		willSet { resetProgressObserver() }
	}
	
	// MARK: - Visual elements
	
	private lazy var backgrounderView: UIView = {
		let view = UIView()
		view.backgroundColor = config.primaryColor
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()

	private let playerLayer: AVPlayerLayer = {
		let layer = AVPlayerLayer()
		return layer
	}()
	
	private lazy var contentView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Pallete.Utility.transparent
		
		return view
	}()
	
	private lazy var optionsButton: UIButton = {
		let view = UIButton()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.setImage(images.dotsVertical, for: .normal)
		view.contentMode = .scaleAspectFit
		view.imageView?.tintColor = Constants.controlTintColor
		
		return view
	}()
	
	private let remainingTimeLabel: UILabel = {
		let view = UILabel()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.numberOfLines = 0
		view.font = TextFont.base.withSize(NumericValues.medium)
		view.textColor = Pallete.Light.white1
		view.text = Constants.unknownRemainingTime
		view.setContentHuggingPriority(.defaultLow, for: .horizontal)
		view.setContentCompressionResistancePriority(.required, for: .horizontal)
		
		return view
	}()
	
	private lazy var progressView: UISlider = {
		let view = UISlider()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.thumbTintColor = Pallete.Lilac.lilac1
		view.minimumTrackTintColor = Pallete.Lilac.lilac1
		view.maximumTrackTintColor = Pallete.Gray.gray4
		view.isContinuous = false
		view.setContentHuggingPriority(.required, for: .horizontal)
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
		view.setImage(images.fullScreen, for: .normal)
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
	
	public init(config: Configuration = .base) {
		self.config = config
		super.init(frame: .zero)
		setupUI()
		
		transitionToState(state: self.state)
	}
	
	@available(*, unavailable)
	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		playerLayer.frame = bounds.inset(by: safeAreaInsets)
	}
	
	private func transitionToState(state: State) {
		playPauseButton.isHidden = false
		spinningView.isHidden = true
		spinningView.stopAnimation()
		
		switch state {
		case .paused:
			player?.pause()
			playPauseButton.setImage(images.play, for: .normal)
		case .loading:
			spinningView.isHidden = false
			spinningView.startAnimation()
		case .playing:
			player?.play()
			playPauseButton.setImage(images.pause, for: .normal)
		case .error:
			remainingTimeLabel.text = Constants.unknownRemainingTime
			playPauseButton.setImage(images.dead, for: .normal)
		case .initial:
			remainingTimeLabel.text = Constants.unknownRemainingTime
			playPauseButton.isHidden = true
			spinningView.isHidden = true
			player?.pause()
		}
	}
	
	deinit {
		_observationToken?.invalidate()
		resetProgressObserver()
	}
	
	// MARK: - Setup UI
	
	private func setupUI() {
		let views: [UIView] = [backgrounderView, contentView, spinningView]
		views.forEach { addSubview($0) }
		let contentViews = [playPauseButton, topItemsStack, bottomItemsStack]
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

			spinningView.centerXAnchor.constraint(equalTo: centerXAnchor),
			spinningView.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
		
		[optionsButton, screenRotationButton].forEach {
			NSLayoutConstraint.activate([
				$0.heightAnchor.constraint(equalToConstant: Constants.iconEdgeSize),
				$0.widthAnchor.constraint(equalTo: $0.heightAnchor)
			])
		}
	}
	
	// MARK: - Data
	
	public func playVideo(videoURL: URL) {
		let playerItem = AVPlayerItem(url: videoURL)
		observePlayerItem(item: playerItem)
		player = AVPlayer(playerItem: playerItem)
		state = .loading
		
		// TODO: - Delete later
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
			self.contentView.isHidden = true
		}
	}
	
	private func observePlayerItem(item: AVPlayerItem) {
		observationToken = item.observe(\.status,
										 options: .new) { [weak self] item, _ in
			guard let self = self else { return }
			
			switch item.status {
			case .readyToPlay:
				self.state = .playing
				self.observeProgress()
			case .failed, .unknown:
				self.state = .error
			@unknown default:
				print("@unknown default occured at: ", #function)
			}
		}
	}
	
	private func observeProgress() {
		let time = CMTimeMake(value: 1, timescale: 600)
		progressObserver = player?.addPeriodicTimeObserver(forInterval: time,
														   queue: DispatchQueue.main,
														   using: { [weak self] _ in
			guard let self = self,
				  let playedTime = self.player?.currentTime(),
				  let itemDuration = self.player?.currentItem?.duration,
				  playedTime.isValid ,
				  itemDuration.isValid else { return }
		
			self.progressView.value = Float(CMTimeGetSeconds(playedTime) / CMTimeGetSeconds(itemDuration))
			
			// Update remaining time
			let remainingTime = CMTimeGetSeconds(itemDuration - playedTime)
			let mins = Int(remainingTime / 60)
			let seconds = Int(remainingTime.truncatingRemainder(dividingBy: 60))
			self.remainingTimeLabel.text = String(format: "%02i:%02i", mins, seconds)
		})
	}
	
	private func resetProgressObserver() {
		if let previousObserver = progressObserver {
			player?.removeTimeObserver(previousObserver)
		}
	}
	
	// MARK: - Actions
	
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		contentView.isHidden = false
	}
	
	@objc
	private func didTapPlayButton() {
		switch state {
		case .paused:
			state = .playing
		case .playing:
			state = .paused
		default:
			assertionFailure("Unallowed state for transition: \(state)")
		}
	}
	
	@objc
	private func didTapRotateButton() {
		let currentOrientation = UIDevice.current.orientation
		let portraitOrientations: [UIDeviceOrientation] = [.portrait, .unknown]
		if portraitOrientations.contains(currentOrientation) {
			UIDevice.current.forceRotation(.landscapeRight)
		} else {
			UIDevice.current.forceRotation(.portrait)
		}
	}
	
	@objc
	private func didChangeProgressValue() {
		guard let duration = player?.currentItem?.duration else { return }
		let currentTime = Float64(progressView.value) * CMTimeGetSeconds(duration)
		let jumpTimeStamp = CMTimeMake(value: CMTimeValue(currentTime), timescale: 1)
		player?.seek(to: jumpTimeStamp)
	}
	
	@objc
	private func pausePlayer() {
		state = .paused
	}
	
	@objc
	private func resumePlayer() {
		state = .playing
	}
}
