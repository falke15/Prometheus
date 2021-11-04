//
//  SensorFeature.swift
//  Sensor
//
//  Created by Pyretttt on 10.10.2021.
//

import FeatureIntermediate

final class SensorEntryPoint: FeatureEntryPointProtocol {
	static let shared: FeatureEntryPointProtocol = SensorEntryPoint()
	
	private(set) var identifier: String = Bundle(for: SensorEntryPoint.self).bundleIdentifier ?? ""
	private(set) var processName: String = "Sensor"
	private(set) var description: String = "AR Tracker"
	private(set) var imageName: String = ImageSource.gradient.rawValue
	
	private init() {}
	
	func enter() {
		let navigationController = UINavigationController.upper()
		navigationController?.pushViewController(UIViewController(), animated: true)
	}
}
