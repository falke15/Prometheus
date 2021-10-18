//
//  SensorFeature.swift
//  Sensor
//
//  Created by Pyretttt on 10.10.2021.
//

import UIKit
import FeatureIntermediate

final class SensorFeature: FeatureProtocol {
	static let shared: FeatureProtocol = SensorFeature()
	
	private(set) var isAvailable: Bool
	private(set) var identifier: String = Bundle(for: SensorFeature.self).bundleIdentifier ?? ""
	private(set) var name: String = "Sensor"
	private(set) var image: UIImage?
	private(set) var featureType: FeatureType = .atom
	
	private init() {
		self.isAvailable = true
		self.image = UIImage(named: "retainCycle")
	}
	
	func start(params: [String : String]?) {
		
	}
}
