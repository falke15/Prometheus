//
//  AggregationItemModel.swift
//  Prometheus
//
//  Created by Pyretttt on 31.10.2021.
//

import FeatureIntermediate

enum AggregationItemModel: Hashable {
	case plainFeature(model: FeatureCellModel)
    case productFeature(model: ProductFeatureModel)
	
	var model: CollectionCellModelAnyType {
		
		switch self {
        case let .plainFeature(featureModel):
			return featureModel
        case let .productFeature(featureModel):
            return featureModel
		}
	}
}
