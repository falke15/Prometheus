//
//  PlainAggregationCellModel.swift
//  Prometheus
//
//  Created by Pyretttt on 10.10.2021.
//

import UIKit

struct FeatureAdapterCellModel: CollectionCellModelType, Hashable {
	typealias Cell = PromoFeatureCell
	
	let name: String
	let image: UIImage
	let id: String
	let action: (() -> Void)?
	
	static func == (lhs: FeatureAdapterCellModel, rhs: FeatureAdapterCellModel) -> Bool {
		lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
