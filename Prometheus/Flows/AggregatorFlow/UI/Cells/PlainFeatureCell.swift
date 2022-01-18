//
//  PlainFeatureCell.swift
//  FeatureIntermediate
//
//  Created by Pyretttt on 24.10.2021.
//

import FeatureIntermediate

final class PlainFeatureCell: AnimatedHighlightCell, CollectionCellType {
	
	private enum Constants {
		static let imageHeight: CGFloat = 240
        static let defaultOffset: CGFloat = NumericValues.default
        static let largeOffset: CGFloat = NumericValues.large
	}
	
	static var reuseID: String = "PlainFeatureCellReuseID"
	
	// MARK: - Visual elements
	
	private let backgrounderView: UIView = {
		let view = UIView(frame: .zero)
		view.backgroundColor = Pallete.Gray.gray2
		view.layer.applyShadows(style: .transparent)
		view.layer.cornerRadius = NumericValues.large
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	private let imageViewCanvas: UIView = {
		let view = UIView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Pallete.Gray.gray3
		view.layer.cornerRadius = NumericValues.default
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
		view.setContentHuggingPriority(.required, for: .horizontal)
		view.setContentCompressionResistancePriority(.required, for: .horizontal)
		
		return view
	}()
	
	private let backgroundIcon: UIImageView = {
		let view = UIImageView(frame: .zero)
        view.layer.cornerRadius = NumericValues.default
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.clipsToBounds = true
		view.translatesAutoresizingMaskIntoConstraints = false
		view.contentMode = .scaleToFill
		
		return view
	}()
	
	private let titleLabel: UILabel = {
		let view = UILabel()
		view.numberOfLines = 0
		view.translatesAutoresizingMaskIntoConstraints = false
		view.textColor = Pallete.Black.black2
		view.textAlignment = .left
		view.font = TextFont.base.withSize(NumericValues.xxLarge)
		view.setContentHuggingPriority(.required, for: .vertical)
		view.setContentCompressionResistancePriority(.required, for: .vertical)
		view.setContentHuggingPriority(.required, for: .horizontal)
		view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
		
		return view
	}()
	
	private let descriptionLabel: UILabel = {
		let view = UILabel()
		view.numberOfLines = 0
		view.translatesAutoresizingMaskIntoConstraints = false
		view.textColor = Pallete.Black.black1
		view.textAlignment = .left
		view.font = TextFont.base.withSize(NumericValues.xLarge)
		view.setContentHuggingPriority(.defaultHigh, for: .vertical)
		view.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
		view.setContentHuggingPriority(.required, for: .horizontal)
		view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
		
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
		guard let model = model as? FeatureCellModel else { return }
		
		backgroundIcon.image = model.image.withRenderingMode(.alwaysOriginal)
		titleLabel.text = model.name
		descriptionLabel.text = model.description
	}
	
	// MARK: - Setup UI
	
	private func setupUI() {
		contentView.clipsToBounds = true
		contentView.backgroundColor = Pallete.Utility.transparent
		contentView.addSubview(backgrounderView)
		
		let views = [imageViewCanvas, titleLabel, descriptionLabel]
		views.forEach { backgrounderView.addSubview($0) }
		imageViewCanvas.addSubview(backgroundIcon)
		
		setupConstraints()
	}
	
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgrounderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: NumericValues.medium),
            backgrounderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: NumericValues.large),
            backgrounderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -NumericValues.large),
            backgrounderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -NumericValues.medium),
            
            imageViewCanvas.topAnchor.constraint(equalTo: backgrounderView.topAnchor),
            imageViewCanvas.leadingAnchor.constraint(equalTo: backgrounderView.leadingAnchor),
            imageViewCanvas.trailingAnchor.constraint(equalTo: backgrounderView.trailingAnchor),
            imageViewCanvas.heightAnchor.constraint(equalToConstant: Constants.imageHeight + NumericValues.large),
            
            backgroundIcon.topAnchor.constraint(equalTo: imageViewCanvas.topAnchor, constant: Constants.defaultOffset),
            backgroundIcon.leadingAnchor.constraint(equalTo: imageViewCanvas.leadingAnchor, constant: Constants.defaultOffset),
            backgroundIcon.trailingAnchor.constraint(equalTo: imageViewCanvas.trailingAnchor, constant: -Constants.defaultOffset),
            backgroundIcon.bottomAnchor.constraint(equalTo: imageViewCanvas.bottomAnchor, constant: -Constants.defaultOffset),
            
            titleLabel.topAnchor.constraint(equalTo: imageViewCanvas.bottomAnchor, constant: Constants.largeOffset),
            titleLabel.leadingAnchor.constraint(equalTo: backgrounderView.leadingAnchor, constant: Constants.largeOffset),
            titleLabel.trailingAnchor.constraint(equalTo: backgrounderView.trailingAnchor, constant: -Constants.largeOffset),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.largeOffset),
            descriptionLabel.leadingAnchor.constraint(equalTo: backgrounderView.leadingAnchor, constant: Constants.largeOffset),
            descriptionLabel.trailingAnchor.constraint(equalTo: backgrounderView.trailingAnchor, constant: -Constants.largeOffset)
        ])
    }
}
