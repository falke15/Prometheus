//
//  FrameworkLoader.swift
//  Prometheus
//
//  Created by Pyretttt on 07.10.2021.
//

import Foundation

public protocol FeatureEntryPointProtocol: AnyObject {
	static var shared: FeatureEntryPointProtocol { get }
	
	var identifier: String { get }
	var processName: String { get }
	var description: String { get }
	var imageName: String { get }
	
	func enter()
}

public final class FeatureLoader {
	private let loadQueue = DispatchQueue(label: "dylibLoadQueue", attributes: [.concurrent])
	private let lock = NSLock()
	
	private let features: [String] = {
		let bundle = Bundle.main
		let featuresKey = "Features"
		let path = bundle.path(forResource: featuresKey, ofType: "plist")
		let plist = NSDictionary(contentsOfFile: path ?? "") as? [String: Any]
		let features = plist?[featuresKey] as? [String]
		return features ?? []
	}()
	
	public init() {
		
	}
	
	public func getFeatures() -> [FeatureEntryPointProtocol] {
		var result: [FeatureEntryPointProtocol] = []
		
		let frameworkPath = Bundle.main.privateFrameworksPath
		DispatchQueue.concurrentPerform(iterations: features.count) { [weak self] idx in
			if let path = frameworkPath?.appending("/\(features[idx]).framework"),
			   let bundle = Bundle(path: path) {
				if let metaType = bundle.principalClass as? FeatureEntryPointProtocol.Type {
					guard let self = self else { return }
					self.lock.lock()
					result.append(metaType.shared)
					self.lock.unlock()
				}
			}
		}
		
		print("\n⚙️⚙️⚙️⚙️⚙️⚙️\n")
		print("DYLIBS LOADED:", result)
		print("\n⚙️⚙️⚙️⚙️⚙️⚙️\n")
		return result
	}
}
