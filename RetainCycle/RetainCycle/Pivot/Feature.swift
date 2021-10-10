//
//  EntryPoint.swift
//  RetainCycle
//
//  Created by Pyretttt on 07.10.2021.
//

import FeatureIntermediate
import UIKit

final class Feature: FeatureProtocol {
	static var shared: FeatureProtocol = Feature()
	
	var isAvailable: Bool = true
	
	var name: String = "Graphs"
	
	var image: UIImage? = nil
	
	func start(params: [String : String]?) {
		
	}
}
