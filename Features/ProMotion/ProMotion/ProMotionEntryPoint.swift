//
//  ProMotionEntryPoint.swift
//  ProMotion
//
//  Created by Pyretttt on 04.11.2021.
//

import FeatureIntermediate

final class ProMotionEntryPoint: FeatureEntryPointProtocol {
	static let shared: FeatureEntryPointProtocol = ProMotionEntryPoint()
	
	private(set) var identifier: String = Bundle(for: ProMotionEntryPoint.self).bundleIdentifier ?? ""
	private(set) var processName: String = "ProMotion"
	private(set) var description: String = "Watching videos, have never been that nice"
	private(set) var imageName: String = ImageSource.gradient.rawValue
	
	private init() {}
	
	func enter() {
		let navigationController = UINavigationController.upper()
		navigationController?.pushViewController(MediaPickerViewController(), animated: true)
	}
}

