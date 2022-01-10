//
//  EntryPoint.swift
//  RetainCycle
//
//  Created by Pyretttt on 07.10.2021.
//

import FeatureIntermediate

final class RetainCycleEntryPoint: FeatureEntryPointProtocol {
	static let shared: FeatureEntryPointProtocol = RetainCycleEntryPoint()

	private(set) var identifier: String = Bundle(for: RetainCycleEntryPoint.self).bundleIdentifier ?? ""
	private(set) var processName: String = "RetainCycle"
	private(set) var description: String = "Graphs, charts, etc.."
	private(set) var imageName: String = ImageSource.gradient.rawValue
	
	private init() {}
	
	func enter() {
		let navigationController = UINavigationController.upper()
		navigationController?.pushViewController(GraphicsCanvasViewController(), animated: true)
	}
}
