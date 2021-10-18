//
//  SquareInfoFeatureCell.swift
//  Prometheus
//
//  Created by Pyretttt on 16.10.2021.
//

import UIKit

final class SquareInfoFeatureCell: UICollectionViewCell, CollectionCellType {
	
	public static var reuseID: String = "SquareInfoFeatureCellID"
	
	// MARK: - Visual elements
	
	private let backgrounderView: UIView = {
		let view = UIView(frame: .zero)
		view.backgroundColor = Pallete.Gray.gray2
		view.layer.applyShadows(style: .transparent)
		view.layer.cornerRadius = NumericValues.large
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	private let centerIcon: UIImageView = {
		let view = UIImageView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.clipsToBounds = true
		view.contentMode = .scaleAspectFill
		
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
	
	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		centerIcon.layer.cornerRadius = frame.height / 4
	}
	
	// MARK: - Setup Data
	
	func setup(model: CollectionCellModelAnyType) {
		guard let model = model as? SquareFeatureAdapterCellModel else { return }
		
		centerIcon.image = model.image
		titleLabel.text = model.name
	}
	
	// MARK: - Setup UI
	
	private func setupUI() {
		contentView.clipsToBounds = true
		contentView.backgroundColor = Pallete.Utility.transparent
		contentView.addSubview(backgrounderView)
		
		let views = [centerIcon, titleLabel]
		views.forEach { backgrounderView.addSubview($0) }

		setupConstraints()
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			backgrounderView.topAnchor.constraint(equalTo: contentView.topAnchor,
												  constant: NumericValues.extraSmall),
			backgrounderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
													  constant: NumericValues.extraSmall),
			backgrounderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
													   constant: -NumericValues.extraSmall),
			backgrounderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
													 constant: -NumericValues.extraSmall),
			
			centerIcon.centerXAnchor.constraint(equalTo: backgrounderView.centerXAnchor),
			centerIcon.centerYAnchor.constraint(equalTo: backgrounderView.centerYAnchor),
			centerIcon.widthAnchor.constraint(equalTo: backgrounderView.widthAnchor, multiplier: 0.5),
			centerIcon.heightAnchor.constraint(equalTo: backgrounderView.heightAnchor, multiplier: 0.5),
			
			titleLabel.leadingAnchor.constraint(equalTo: backgrounderView.leadingAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: backgrounderView.trailingAnchor),
			titleLabel.bottomAnchor.constraint(equalTo: backgrounderView.bottomAnchor,  constant: -NumericValues.default),
		])
	}
}

