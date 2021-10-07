//
//  AggregatorPlainCell.swift
//  Prometheus
//
//  Created by Pyretttt on 03.10.2021.
//

import UIKit

public final class AggregatorPlainCell: UICollectionViewCell, CollectionCellType {
	
	public static var reuseID: String = "AggregatorEntryPointCellID"
	
	// MARK: - Lifecycle
	
	override public init(frame: CGRect) {
		super.init(frame: .zero)
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Setup Data
	
	public func setup(model: CollectionCellModelAnyType) {
//		guard let model = model as? PlainEntryPoint else { return }
		
	}
	
	// MARK: - Setup UI
	
	private func setupUI() {
		
		setupConstraints()
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			
		])
	}
}
