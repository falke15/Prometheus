//
//  Section.swift
//  rxLearn
//
//  Created by Pyretttt on 28.08.2021.
//

import UIKit

/// Общий протокол всех ячеек в коллекции
protocol CollectionCellType: UICollectionViewCell {
	static var reuseID: String { get }
	
	func setup(model: CollectionCellModelAnyType)
}

/// Протокол со стертым типом ячейки
protocol CollectionCellModelAnyType {
	var cellType: CollectionCellType.Type { get }
}

/// Протокол с выводимым типом ячейки
protocol CollectionCellModelType: CollectionCellModelAnyType {
	associatedtype Cell: CollectionCellType
}

/// Дефолтная реализация протокола для выведения типа ячейки
extension CollectionCellModelType {
	var cellType: CollectionCellType.Type {
		return Cell.self
	}
}

extension UICollectionViewDataSource {
	func dequeCell(_ collectionView: UICollectionView,
				   cellModel: CollectionCellModelAnyType,
				   indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellModel.cellType.reuseID,
															for: indexPath) as? CollectionCellType else {
			return UICollectionViewCell()
		}
		cell.setup(model: cellModel)
		
		return cell
	}
}
