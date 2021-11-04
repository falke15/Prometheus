//
//  UIView+Animation.swift
//  Prometheus
//
//  Created by Pyretttt on 22.10.2021.
//

import UIKit

public extension UIView {
	func animate<Value>(keyPath: String,
						values: (from: Value, to: Value),
						duration: TimeInterval,
						shouldRemoveOnCompletion: Bool = false) {
		let animation = CABasicAnimation(keyPath: keyPath)
		animation.duration = duration
		animation.fromValue = values.from
		animation.toValue = values.to
		animation.fillMode = .forwards
		animation.isRemovedOnCompletion = shouldRemoveOnCompletion
		animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		layer.add(animation, forKey: keyPath)
	}
	
	func removeAnimations() {
		layer.removeAllAnimations()
	}
}
