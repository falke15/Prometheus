//
//  EntryPoint.swift
//  RetainCycle
//
//  Created by Pyretttt on 07.10.2021.
//

import FeatureIntermediate
import UIKit

final class RetainCycleFeature: FeatureProtocol {
	static let shared: FeatureProtocol = RetainCycleFeature()
	
	private(set) var isAvailable: Bool
	private(set) var identifier: String = Bundle(for: RetainCycleFeature.self).bundleIdentifier ?? ""
	private(set) var name: String = "Graphs"
	private(set) var image: UIImage?
	private(set) var featureType: FeatureType = .promo
	
	private init() {
		self.isAvailable = true
		self.image = UIImage(named: "retainCycle")
	}
	
	func start(params: [String : String]?) {
		
	}
}
