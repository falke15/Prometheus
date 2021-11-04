//
//  Section.swift
//  rxLearn
//
//  Created by Pyretttt on 28.08.2021.
//

import UIKit

/// Общий протокол всех ячеек в коллекции
public protocol CollectionCellType: UICollectionViewCell {
	static var reuseID: String { get }
	
	func setup(model: CollectionCellModelAnyType)
}

/// Протокол со стертым типом ячейки
public protocol CollectionCellModelAnyType {
	var cellType: CollectionCellType.Type { get }
}

/// Протокол с выводимым типом ячейки
public protocol CollectionCellModelType: CollectionCellModelAnyType {
	associatedtype Cell: CollectionCellType
}

/// Дефолтная реализация протокола для выведения типа ячейки
public extension CollectionCellModelType {
	var cellType: CollectionCellType.Type {
		return Cell.self
	}
}

public extension UICollectionView {
	func dequeCell(cellModel: CollectionCellModelAnyType,
				   indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = dequeueReusableCell(withReuseIdentifier: cellModel.cellType.reuseID,
											 for: indexPath) as? CollectionCellType else {
			return UICollectionViewCell()
		}
		cell.setup(model: cellModel)
		
		return cell
	}
}
