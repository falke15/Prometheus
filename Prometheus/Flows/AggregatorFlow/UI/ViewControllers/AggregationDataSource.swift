//
//  AggregationDataSource.swift
//  Prometheus
//
//  Created by Pyretttt on 01.11.2021.
//

import FeatureIntermediate

final class AggregationDataSource: UICollectionViewDiffableDataSource<Section<AggregationItemModel>, AggregationItemModel> {
	
	func update(_ items: [Section<AggregationItemModel>]) {
		var snapshot = snapshot()
		snapshot.appendSections(items)
		for section in items {
			let items = !section.isClosed ? section.items : []
			snapshot.appendItems(items, toSection: section)
		}
		apply(snapshot)
	}
	
}
