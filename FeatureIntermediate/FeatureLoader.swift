//
//  FrameworkLoader.swift
//  Prometheus
//
//  Created by Pyretttt on 07.10.2021.
//

import Foundation
import UIKit

public protocol FeatureProtocol {
	static var shared: FeatureProtocol { get }
	
	var isAvailable: Bool { get }
	var name: String { get }
	var image: UIImage? { get }
	
	func start(params: [String: String]?)
}

public final class FeatureLoader {
	private let loadQueue = DispatchQueue(label: "dylibLoadQueue", attributes: [.concurrent])
	private let lock = NSLock()
	
	private let features: [String] = {
		let bundle = Bundle.main
		let path = bundle.path(forResource: "Features", ofType: "plist")
		let plist = NSDictionary(contentsOfFile: path ?? "") as? [String: Any]
		let features = plist?["Features"] as? [String]
		return features ?? []
	}()
	
	public init() {
		
	}
	
	public func loadDylibs() -> [FeatureProtocol] {
		var result: [FeatureProtocol] = []
		
		let frameworkPath = Bundle.main.privateFrameworksPath
		DispatchQueue.concurrentPerform(iterations: features.count) { idx in
			if let path = frameworkPath?.appending("/\(features[idx]).framework"),
			   let bundle = Bundle(path: path) {
				if let metaType = bundle.principalClass as? FeatureProtocol.Type {
					
					self.lock.unlock()
					result.append(metaType.shared)
					self.lock.unlock()
				}
			}
		}
		
		return result
	}
}
