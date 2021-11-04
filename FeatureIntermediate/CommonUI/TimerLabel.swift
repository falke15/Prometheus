//
//  TimerLabel.swift
//  exKeeper
//
//  Created by Pyretttt on 16.09.2021.
//

import UIKit

public class TimerLabel: UILabel {
		
	private var dotsCounter: Int = 0
	private var displayLink: CADisplayLink?
	
	public func startAnimating() {
		displayLink = CADisplayLink(target: self, selector: #selector(animate))
		displayLink?.preferredFramesPerSecond = 5
		displayLink?.add(to: .main, forMode: .common)
	}
	
	public func stopAnimation() {
		displayLink?.isPaused = true
	}
	
	@objc private func animate() {
		if dotsCounter == 3 {
			dotsCounter = 0
			let textCount = text?.count ?? 0
			text = String(text?.prefix(textCount - 3) ?? Substring())
			return
		}
		
		text?.append(".")
		dotsCounter += 1
	}
	
	deinit {
		displayLink?.invalidate()
	}
}
