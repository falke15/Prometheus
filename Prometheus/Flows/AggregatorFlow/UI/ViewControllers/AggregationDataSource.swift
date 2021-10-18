//
//  AggregationDataSource.swift
//  Prometheus
//
//  Created by Pyretttt on 10.10.2021.
//

import UIKit


final class AggregationDataSource: UICollectionViewDiffableDataSource<Section<AnyHashable>, AnyHashable> {
	
	private var items: [AnyHashable] = []
	
	func update(with items: [Section<AnyHashable>], animated: Bool = true) {
		var snapshot = snapshot()
		
		snapshot.appendSections(items)
		items.forEach {
			snapshot.appendItems($0.items, toSection: $0)
		}
		apply(snapshot, animatingDifferences: animated)
	}
	
}
