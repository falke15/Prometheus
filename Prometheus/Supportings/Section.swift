//
//  Section.swift
//  Prometheus
//
//  Created by Pyretttt on 10.10.2021.
//

import Foundation

struct Section<Item: Hashable>: Hashable {
	var name: String
	var items: [Item]
	var isClosed: Bool
}
