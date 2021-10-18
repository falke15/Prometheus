//
//  SquareFeatureAdapterCellModel.swift
//  Prometheus
//
//  Created by Pyretttt on 17.10.2021.
//

import UIKit

struct SquareFeatureAdapterCellModel: CollectionCellModelType, Hashable {
	typealias Cell = SquareInfoFeatureCell
	
	let name: String
	let image: UIImage
	let id: String
	let action: (() -> Void)?
	
	static func == (lhs: SquareFeatureAdapterCellModel, rhs: SquareFeatureAdapterCellModel) -> Bool {
		lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
