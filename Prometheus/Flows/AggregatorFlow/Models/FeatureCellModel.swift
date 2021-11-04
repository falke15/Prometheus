//
//  FeatureCellModel.swift
//  Prometheus
//
//  Created by Pyretttt on 03.11.2021.
//

import FeatureIntermediate

struct FeatureCellModel: CollectionCellModelType, Hashable {
	typealias Cell = PlainFeatureCell
	
	let id = UUID()
	let name: String
	let description: String
	let image: UIImage
	let actionBlock: () -> Void
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	static func == (lhs: FeatureCellModel, rhs: FeatureCellModel) -> Bool {
		lhs.id == rhs.id
	}
}

extension FeatureCellModel {
	init(name: String,
		 description: String,
		 imageName: String,
		 actionBlock: @escaping () -> Void) {
		self.name = name
		self.description = description
		self.image = ImageSource.init(rawValue: imageName)?.image ?? UIImage.grayGradient
//		self.image = UIImage.makeImage(color: .blue)
		self.actionBlock = actionBlock
	}
}
