//
//  VideoPlayerView+PlaybackAssistant.swift
//  FeatureIntermediate
//
//  Created by Pyretttt on 28.11.2021.
//

import AVFoundation

extension VideoPlayerView {
	class PlaybackAssistant {
		
		enum PlaybackState {
			case initial
			case loading
			case playing
			case paused
			case error
		}
		
		private var currentPlaybackRate: Float = 1
		
		// MARK: - Observations
		
		private var playerItemObservationToken: NSKeyValueObservation?
		private var disappearanceTimer: Timer?
		private var progressObserver: Any?
		private var progressObserverDealocation: (() -> Void)?
		
		// MARK: - Lifecycle
		
		deinit {
			resetObservers()
		}
		
		private func resetObservers() {
			playerItemObservationToken?.invalidate()
			progressObserverDealocation?()
			disappearanceTimer?.invalidate()
		}
		
		// MARK: - Playback
		
		func videoPlayer(_ videoPlayerView: VideoPlayerView, launchVideoAt URL: URL) {
			// reset previous video observers
			resetObservers()
			
			let playerItem = AVPlayerItem(url: URL)
			videoPlayerView.player.replaceCurrentItem(with: playerItem)
			videoPlayerView.transition(to: .loading)
			observePlayerItem(videoPlayerView: videoPlayerView, item: playerItem)
		}
		
		private func observePlayerItem(videoPlayerView: VideoPlayerView, item: AVPlayerItem) {
			// previous token reset
			playerItemObservationToken?.invalidate()
			
			// TODO: Make token local variable -> indavidate in subscription block
			
			playerItemObservationToken = item.observe(\.status,
													   options: .new) { [weak self, weak videoPlayerView] item, _ in
				guard let self = self,
					  let videoPlayerView = videoPlayerView else { return }
				
				switch item.status {
				case .readyToPlay:
					videoPlayerView.player.play()
					self.observeItemProgress(videoPlayewView: videoPlayerView)
					videoPlayerView.transition(to: .playing)
				case .failed:
					videoPlayerView.transition(to: .error)
					print("Error due to: \(String(describing: item.error?.localizedDescription))")
				case .unknown:
					videoPlayerView.transition(to: .loading)
				@unknown default:
					print("@unknown default occured at: ", #function)
				}
			}
		}
		
		private func observeItemProgress(videoPlayewView: VideoPlayerView) {
			let time = CMTimeMake(value: 1, timescale: 600)
			let player = videoPlayewView.player
			progressObserver = player.addPeriodicTimeObserver(forInterval: time,
															  queue: DispatchQueue.main,
															  using: { [weak self, weak videoPlayewView] _ in
				guard let self = self,
					  let videoPlayewView = videoPlayewView else { return }
				
				let playedTime = self.timePlayed(by: videoPlayewView.player)
				let itemDuration = self.itemDuration(at: videoPlayewView.player)
				videoPlayewView.progressView.value = Float(CMTimeGetSeconds(playedTime) / CMTimeGetSeconds(itemDuration))
				
				// Update remaining time
				let remainingTime = CMTimeGetSeconds(itemDuration - playedTime)
				let mins = Int(remainingTime / 60)
				let seconds = Int(remainingTime.truncatingRemainder(dividingBy: 60))
				videoPlayewView.remainingTimeLabel.text = String(format: "%02i:%02i", mins, seconds)
			})
			
			progressObserverDealocation = { [weak player, weak self] in
				guard let self = self,
					  let player = player else { return }
				
				if let observer = self.progressObserver {
					player.removeTimeObserver(observer)
				}
			}
		}
		
		/// Переместить воспроизведение к выбранному моменту
		/// - Parameter point: отметка воспроизведения, от 0 до 1
		func videoPlayer(_ player: AVPlayer, seekTo point: Float) {
			guard let duration = player.currentItem?.duration else { return }
			let currentTime = Float64(point) * CMTimeGetSeconds(duration)
			let seekTimeStamp = CMTimeMake(value: CMTimeValue(currentTime), timescale: 1)
			player.seek(to: seekTimeStamp)
		}
		
		func videoPlayerViewResumePlayback(_ videoPlayerView: VideoPlayerView) {
			videoPlayerView.player.rate = currentPlaybackRate
			videoPlayerView.transition(to: .playing)
		}
		
		func videoPlayerViewPausePlayback(_ videoPlayerView: VideoPlayerView) {
			videoPlayerView.player.pause()
			videoPlayerView.transition(to: .paused)
		}
		
		func videoPlayerView(_ videoPlayerView: VideoPlayerView, hideControlsAfter delay: CGFloat) {
			disappearanceTimer?.invalidate()
			disappearanceTimer = Timer.scheduledTimer(withTimeInterval: delay,
													  repeats: false,
													  block: { [weak videoPlayerView] timer in
				guard let videoPlayerView = videoPlayerView else { return }
				videoPlayerView.contentView.isHidden = true
				timer.invalidate()
			})
		}
		
		func nullifyDisappearanceCountDown() {
			disappearanceTimer?.invalidate()
		}
		
		func videoPlayView(_ videoPlayerView: VideoPlayerView,
						   changePlaybackRate newRate: Float) {
			currentPlaybackRate = newRate
			// apply changes if player is already playing
			if videoPlayerView.player.rate > 0 {
				videoPlayerView.player.rate = newRate
			}
		}
		
		// MARK: - Helpers
		
		func timePlayed(by player: AVPlayer) -> CMTime {
			let playedTime = player.currentTime()
			guard playedTime.isValid else {
				return CMTime(seconds: 0, preferredTimescale: 600)
			}
			
			return playedTime
		}
		
		func itemDuration(at player: AVPlayer) -> CMTime {
			guard let itemDuration = player.currentItem?.duration,
				  itemDuration.isValid else {
					  return CMTime(seconds: 0, preferredTimescale: 600)
				  }
			
			return itemDuration
		}
	}
}
