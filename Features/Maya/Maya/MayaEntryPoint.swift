//
//  MayaEntryPoint.swift
//  Maya
//
//  Created by pyretttt on 11.01.2022.
//

import Maya.Objective
import FeatureIntermediate

final class MayaEntryPoint: FeatureEntryPointProtocol {
    static let shared: FeatureEntryPointProtocol = MayaEntryPoint()
    
    private(set) var identifier: String = Bundle(for: MayaEntryPoint.self).bundleIdentifier ?? ""
    private(set) var processName: String = "Maya"
    private(set) var description: String = "Nice calendar for you ❤️"
    private(set) var imageName: String = ImageSource.gradient.rawValue
    
    private init() {}
    
    func enter() {
        let navigationController = UINavigationController.upper()
        navigationController?.pushViewController(MAYADemoViewController(), animated: true)
    }
}
