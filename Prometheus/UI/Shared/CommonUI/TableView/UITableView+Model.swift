//
//  UITableView+Model.swift
//  rxLearn
//
//  Created by Pyretttt on 29.08.2021.
//

import UIKit

/// Общий протокол всех ячеек в коллекции
public protocol TableCellType: UITableViewCell {
	static var reuseID: String { get }
	
	func setup(model: TableCellModelAnyType)
}

/// Протокол со стертым типом ячейки
public protocol TableCellModelAnyType {
	var cellType: TableCellType.Type { get }
}

/// Протокол с выводимым типом ячейки
public protocol TableCellModelType: TableCellModelAnyType {
	associatedtype Cell: TableCellType
}


/// Дефолтная реализация протокола для выведения типа ячейки
public extension TableCellModelType {
	var cellType: TableCellType.Type {
		return Cell.self
	}
}

public extension UITableViewDataSource {
	func dequeCell(_ tableView: UITableView,
				   cellModel: TableCellModelAnyType,
				   indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellType.reuseID,
													   for: indexPath) as? TableCellType else {
			return UITableViewCell()
		}
		cell.setup(model: cellModel)
		
		return cell
	}
}
