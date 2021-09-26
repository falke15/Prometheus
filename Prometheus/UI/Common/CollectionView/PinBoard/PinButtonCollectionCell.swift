//
//  PinButtonCollectionCell.swift
//  rxLearn
//
//  Created by Pyretttt on 29.08.2021.
//

import UIKit

final class PinButtonCollectionCell: UICollectionViewCell, CollectionCellType {
	
	static var reuseID: String = "PinButtonCollectionCellReuseID"
	
	private let numberLabel: UILabel = {
		let view = UILabel(frame: .zero)
		view.textColor = .black
		view.textAlignment = .center
		view.numberOfLines = 0
		
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	// MARK: - Appearance
	
	override var isHighlighted: Bool {
		didSet {
			if isHighlighted {
				animateSelection(with: Pallete.Gray.gray1)
			} else {
				animateSelection(with: .clear)
			}
		}
	}
	
	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		contentView.layer.cornerRadius = contentView.frame.width / 2
	}
	
	// MARK: - Setup data
	
	func setup(model: CollectionCellModelAnyType) {
		guard let model = model as? PinBoardView.PinInfo else { return }
		let isEnabled = model.isEnabled
		if let image = model.icon {
			return
		}
		if let number = model.number {
			numberLabel.text = String(number)
			return
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		numberLabel.text = nil
	}
	
	// MARK: - Setup UI
	
	private func setupUI() {
		contentView.backgroundColor = .clear
		
		contentView.addSubview(numberLabel)
		
		setupConstraints()
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			numberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
			numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			numberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			numberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
		])
	}
	
	// MARK: - Animations
	
	private func animateSelection(with color: UIColor) {
		UIView.animate(withDuration: 0.1) { [weak self] in
			self?.contentView.backgroundColor = color
		}
	}
}
