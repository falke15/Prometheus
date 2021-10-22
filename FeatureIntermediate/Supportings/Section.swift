//
//  Section.swift
//  Prometheus
//
//  Created by Pyretttt on 10.10.2021.
//

import Foundation

public struct Section<Item: Hashable>: Hashable {
	public var name: String
	public var items: [Item]
	public var isClosed: Bool
	
	public init(name: String, items: [Item], isClosed: Bool) {
		self.name = name
		self.items = items
		self.isClosed = isClosed
	}
}
