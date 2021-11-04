//
//  SectionHeaderView.swift
//  Prometheus
//
//  Created by Pyretttt on 04.11.2021.
//

import FeatureIntermediate

final class SectionHeaderView: UICollectionReusableView {

	private enum Constants {
		static let imageSize: CGFloat = 24
		
		static let primaryColor: UIColor = Pallete.Black.black4.withAlphaComponent(0.7)
		static let secondaryColor: UIColor = Pallete.Gray.gray3
	}
	
	static let reuseID: String = "SectionHeaderViewReuseID"
	
	private var actionBlock: (() -> Void)?
	
	// MARK: - Visual Elements
	
	private let titleLabel: UILabel = {
		let view = UILabel()
		view.numberOfLines = 1
		view.font = TextFont.base.withSize(NumericValues.xLarge)
		view.textColor = Constants.primaryColor
		view.translatesAutoresizingMaskIntoConstraints = false
		view.textAlignment = .left
		view.setContentHuggingPriority(.defaultLow, for: .horizontal)
		
		return view
	}()
	
	private let actionImageView: UIImageView = {
		let view = UIImageView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.contentMode = .scaleAspectFit
		view.image = ImageSource.arrowDown.image.withTintColor(Constants.primaryColor, renderingMode: .alwaysTemplate)
		view.setContentHuggingPriority(.required, for: .horizontal)
		view.tintColor = Constants.primaryColor
		
		return view
	}()
	
	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Data
	
	func configure(title: String, actionBlock: @escaping () -> Void) {
		titleLabel.text = title
		self.actionBlock = actionBlock
	}

	// MARK: - Setup UI
	
	private func setupUI() {
		backgroundColor = Pallete.Utility.transparent
		
		let views = [titleLabel, actionImageView]
		views.forEach { addSubview($0) }
		setupConstraints()
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: NumericValues.default),
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: NumericValues.large),
			titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -NumericValues.default),
			titleLabel.trailingAnchor.constraint(equalTo: actionImageView.trailingAnchor, constant: -NumericValues.default),
			
			actionImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -NumericValues.large),
			actionImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
			actionImageView.widthAnchor.constraint(equalTo: actionImageView.heightAnchor),
			actionImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
		])
	}
	
	// MARK: - Actions
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		animateTouch(color: Constants.secondaryColor)
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		animateTouch(color: Pallete.Utility.transparent)
		rotateArrow()
		actionBlock?()
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		animateTouch(color: Pallete.Utility.transparent)
	}
	
	private func animateTouch(color: UIColor) {
		UIView.animate(withDuration: 0.25) { [weak self] in
			self?.backgroundColor = color
		}
	}
	
	private func rotateArrow() {
		let transform = actionImageView.transform == .identity ?
			CGAffineTransform(rotationAngle: .pi) :
			.identity
		
		UIView.animate(withDuration: 0.25) { [weak self] in
			self?.actionImageView.transform = transform
		}
	}
}
