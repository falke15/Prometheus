//
//  AggregationEntryPoint.swift
//  Prometheus
//
//  Created by Pyretttt on 03.10.2021.
//

import Foundation

struct PlainEntryPointModel: CollectionCellModelType {
	typealias Cell = AggregatorPlainCell
	
	let title: String
}
