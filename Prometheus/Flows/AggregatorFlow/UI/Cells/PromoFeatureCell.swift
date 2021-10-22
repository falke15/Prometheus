//
//  AggregatorPlainCell.swift
//  Prometheus
//
//  Created by Pyretttt on 03.10.2021.
//

import UIKit
import FeatureIntermediate

final class PromoFeatureCell: UICollectionViewCell, CollectionCellType {
	
	public static var reuseID: String = "PromoFeatureCellID"
	
	// MARK: - Visual elements
	
	private let backgrounderView: UIView = {
		let view = UIView(frame: .zero)
		view.backgroundColor = Pallete.Gray.gray2
		view.layer.applyShadows(style: .transparent)
		view.layer.cornerRadius = NumericValues.large
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	private let backgroundIcon: UIImageView = {
		let view = UIImageView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.contentMode = .scaleAspectFit
		
		return view
	}()
	
	private let titleLabel: UILabel = {
		let view = UILabel()
		view.numberOfLines = 1
		view.translatesAutoresizingMaskIntoConstraints = false
		view.textColor = Pallete.Black.black2
		view.textAlignment = .center
		view.font = TextFont.base.withSize(NumericValues.xxLarge)
		
		return view
	}()
	
	private let descriptionLabel: UILabel = {
		let view = UILabel()
		view.numberOfLines = 2
		view.translatesAutoresizingMaskIntoConstraints = false
		view.textColor = Pallete.Gray.gray3
		view.textAlignment = .center
		view.font = TextFont.base.withSize(NumericValues.xLarge)
		
		return view
	}()
	
	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Setup Data
	
	func setup(model: CollectionCellModelAnyType) {
		guard let model = model as? FeatureAdapterCellModel else { return }
		
		backgroundIcon.image = model.image
		titleLabel.text = model.name
	}
	
	// MARK: - Setup UI
	
	private func setupUI() {
		contentView.clipsToBounds = true
		contentView.backgroundColor = Pallete.Utility.transparent
		contentView.addSubview(backgrounderView)
		
		let views = [backgroundIcon, titleLabel, descriptionLabel]
		views.forEach { backgrounderView.addSubview($0) }

		setupConstraints()
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			backgrounderView.topAnchor.constraint(equalTo: contentView.topAnchor,
												  constant: NumericValues.default),
			backgrounderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
													  constant: NumericValues.default),
			backgrounderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
													   constant: -NumericValues.default),
			backgrounderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
													 constant: -NumericValues.default),
			
			backgroundIcon.topAnchor.constraint(equalTo: backgrounderView.topAnchor),
			backgroundIcon.leadingAnchor.constraint(equalTo: backgrounderView.leadingAnchor),
			backgroundIcon.trailingAnchor.constraint(equalTo: backgrounderView.trailingAnchor),
			backgroundIcon.bottomAnchor.constraint(equalTo: backgrounderView.bottomAnchor),
			
			titleLabel.leadingAnchor.constraint(equalTo: backgrounderView.leadingAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: backgrounderView.trailingAnchor),
			titleLabel.bottomAnchor.constraint(equalTo: backgrounderView.bottomAnchor,
											   constant: -NumericValues.extraSmall),
		])
	}
}
