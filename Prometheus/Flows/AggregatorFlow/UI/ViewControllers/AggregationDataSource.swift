//
//  AggregationDataSource.swift
//  Prometheus
//
//  Created by Pyretttt on 10.10.2021.
//

import UIKit

final class AggregationDataSource<Item: Hashable & CollectionCellModelType>:
	UICollectionViewDiffableDataSource<Section<Item>, Item> {
	
	private var items: [Item] = []
	
	func update(with items: [Item], animated: Bool = true) {
		var snapshot = NSDiffableDataSourceSnapshot<Section<Item>, Item>()
		
		let section = Section(name: "Модули", items: items , isClosed: false)
		snapshot.appendSections([section])
		snapshot.appendItems(items, toSection: section)
		apply(snapshot, animatingDifferences: animated)
	}
	
}
