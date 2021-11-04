//
//  AggregationDataSource.swift
//  Prometheus
//
//  Created by Pyretttt on 01.11.2021.
//

import FeatureIntermediate

final class AggregationDataSource: UICollectionViewDiffableDataSource<Section<AggregationItemModel>, AggregationItemModel> {
	
	private typealias Snapshot = NSDiffableDataSourceSnapshot<Section<AggregationItemModel>, AggregationItemModel>
	
	var items: [Section<AggregationItemModel>] = []
	
	func internalUpdate(animated: Bool = false) {
		var currentSnapshot = snapshot()
		currentSnapshot.deleteSections(currentSnapshot.sectionIdentifiers)
		currentSnapshot.appendSections(items)
		for section in items {
			currentSnapshot.appendItems(section.items, toSection: section)
		}
		apply(currentSnapshot, animatingDifferences: animated)
	}
	
	func add(_ items: [Section<AggregationItemModel>], animated: Bool = false) {
		self.items = items
		var snapshot = Snapshot()
		
		snapshot.appendSections(items)
		for section in items {
			let items = section.items
			snapshot.appendItems(items, toSection: section)
		}
		apply(snapshot, animatingDifferences: animated)
	}
	
	override func collectionView(_ collectionView: UICollectionView,
								 viewForSupplementaryElementOfKind kind: String,
								 at indexPath: IndexPath) -> UICollectionReusableView {
		switch kind {
		case UICollectionView.elementKindSectionHeader:
			guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
																			 withReuseIdentifier: SectionHeaderView.reuseID,
																			 for: indexPath) as? SectionHeaderView else {
				return UICollectionReusableView()
			}
			
			let snap = snapshot()
			let section = snap.sectionIdentifiers[indexPath.section]
			view.configure(title: section.name) { [weak self] in
				guard let self = self else { return }
				self.items[indexPath.section].isClosed.toggle()
				self.internalUpdate(animated: true)
			}
			
			return view
		default:
			return UICollectionReusableView()
		}
	}
}
