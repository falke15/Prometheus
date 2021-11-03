//
//  Section.swift
//  Prometheus
//
//  Created by Pyretttt on 10.10.2021.
//

import Foundation

public struct Section<Item: Hashable>: Hashable {
	public var name: String
	public var isClosed: Bool
	public var items: [Item]
	
	public init(name: String,
				isClosed: Bool,
				items: [Item]) {
		self.name = name
		self.isClosed = isClosed
		self.items = items
	}
}
