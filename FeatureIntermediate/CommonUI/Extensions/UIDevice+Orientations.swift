//
//  UIDevice+Orientations.swift
//  FeatureIntermediate
//
//  Created by Pyretttt on 22.11.2021.
//

import UIKit

public extension UIDevice {
	func forceRotation(_ orientationMask: UIInterfaceOrientation) {
		let value = Int(orientationMask.rawValue)
		Self.current.setValue(value, forKey: "orientation")
	}
}
