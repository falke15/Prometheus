//
//  ModuleEntryPoint.swift
//  Prometheus
//
//  Created by Pyretttt on 26.09.2021.
//

import Foundation

public protocol ModuleEntryPoint: AnyObject {
	var moduleName: String { get }
	
	init()
}
