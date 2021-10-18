//
//  PinButtonCollectionCell.swift
//  rxLearn
//
//  Created by Pyretttt on 29.08.2021.
//

import UIKit

public final class PinButtonCollectionCell: UICollectionViewCell, CollectionCellType {
	
	public static var reuseID: String = "PinButtonCollectionCellReuseID"
	
	private let numberLabel: UILabel = {
		let view = UILabel(frame: .zero)
		view.textColor = Pallete.Black.black1
		view.textAlignment = .center
		view.numberOfLines = 0
		view.font = TextFont.base.withSize(24)
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	private let icon: UIImageView = {
		let view = UIImageView(frame: .zero)
		view.tintColor = Pallete.Black.black1
		view.alpha = 0.8
		view.contentMode = .scaleAspectFit
		view.isHidden = true
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	// MARK: - Appearance
	
	public override var isHighlighted: Bool {
		didSet {
			if isHighlighted {
				animateSelection(with: Pallete.Gray.gray3, tintColor: Pallete.Lilac.lilac2)
			} else {
				animateSelection(with: .clear, tintColor: Pallete.Black.black1)
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
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		contentView.layer.cornerRadius = contentView.frame.width / 2
	}
	
	// MARK: - Setup data
	
	public func setup(model: CollectionCellModelAnyType) {
		guard let model = model as? PinBoardView.PinInfo else { return }
		if model.isEnabled, let image = model.icon {
			icon.image = image
			icon.isHidden = false
			return
		}
		if let number = model.number {
			numberLabel.text = String(number)
		}
	}
	
	public override func prepareForReuse() {
		super.prepareForReuse()
		numberLabel.text = nil
		icon.isHidden = true
	}
	
	// MARK: - Setup UI
	
	private func setupUI() {
		contentView.backgroundColor = .clear
		let views = [numberLabel, icon]
		views.forEach { contentView.addSubview($0) }
		
		setupConstraints()
	}
	
	private func setupConstraints() {
			NSLayoutConstraint.activate([
				numberLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
				numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
				numberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
				numberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
				
				icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
				icon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
				icon.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
				icon.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
			])
	}
	
	// MARK: - Animations
	
	private func animateSelection(with color: UIColor, tintColor: UIColor) {
		UIView.animate(withDuration: 0.1) { [weak self] in
			self?.icon.tintColor = tintColor
			self?.numberLabel.textColor = tintColor
			self?.contentView.backgroundColor = color
		}
	}
}
