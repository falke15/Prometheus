//
//  AggregationItemModel.swift
//  Prometheus
//
//  Created by Pyretttt on 31.10.2021.
//

import FeatureIntermediate

enum AggregationItemModel: Hashable {
	case plainFeature(model: FeatureCellModel)
	
	var model: CollectionCellModelAnyType {
		
		switch self {
		case let .plainFeature(featureModel):
			return featureModel
		}
	}
}
