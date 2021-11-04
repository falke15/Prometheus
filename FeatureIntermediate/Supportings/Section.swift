//
//  Section.swift
//  Prometheus
//
//  Created by Pyretttt on 10.10.2021.
//

import Foundation

public struct Section<Item: Hashable>: Hashable {
	public let id = UUID()
	public var name: String
	public var isClosed: Bool
	
	public var items: [Item] {
		isClosed ? [] : _items
	}
	private var _items: [Item]
	
	// MARK: - Lifecycle
	
	public init(name: String,
				isClosed: Bool,
				items: [Item]) {
		self.name = name
		self.isClosed = isClosed
		self._items = items
	}
	
	// MARK: - Hashable
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	public static func == (lhs: Section<Item>, rhs: Section<Item>) -> Bool {
		   return lhs.id == rhs.id
	}
}
