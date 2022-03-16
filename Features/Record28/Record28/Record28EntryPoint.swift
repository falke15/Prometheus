//
//  Record28EntryPoint.swift
//  Record28
//
//  Created by pyretttt pyretttt on 14.03.2022.
//

import Foundation

import FeatureIntermediate

final class Record28EntryPoint: FeatureEntryPointProtocol {
    static let shared: FeatureEntryPointProtocol = Record28EntryPoint()
    
    private(set) var identifier: String = Bundle(for: Record28EntryPoint.self).bundleIdentifier ?? ""
    private(set) var processName: String = "Record28"
    private(set) var description: String = "Handwritten digit recognizer"
    private(set) var imageName: String = ImageSource.gradient.rawValue
    
    private init() {}
    
    func enter() {
        let navigationController = UINavigationController.upper()
        navigationController?.pushViewController(RecognizerViewController(), animated: true)
    }
}
