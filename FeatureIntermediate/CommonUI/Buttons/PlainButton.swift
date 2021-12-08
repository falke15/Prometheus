//
//  PlainButton.swift
//  FeatureIntermediate
//
//  Created by Pyretttt on 06.12.2021.
//

import UIKit

public final class PlainButton: UIButton {
	
	private enum Constants {
		static let primaryColor: UIColor = Pallete.Orange.orange1
		static let highlightedColor: UIColor = Pallete.Gray.gray1
	}
	
	public var action: (() -> Void)?
	
	// MARK: - Lifecycle
	
	public init() {
		super.init(frame: .zero)
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Setup UI
	
	private func setupUI() {
		backgroundColor = Constants.primaryColor
		layer.cornerRadius = NumericValues.large
		setTitleShadowColor(Pallete.Black.black2, for: .normal)
		setTitleColor(Constants.highlightedColor, for: .normal)
		titleLabel?.font = TextFont.base.withSize(NumericValues.xxLarge)
		contentEdgeInsets = UIEdgeInsets(top: NumericValues.default,
										 left: NumericValues.default,
										 bottom: NumericValues.default,
										 right: NumericValues.default)
		layer.masksToBounds = false
		
		addTarget(self, action: #selector(actionHandler), for: .touchUpInside)
	}
	
	// MARK: - Actions
	
	@objc
	func actionHandler() {
		action?()
	}
	
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		animateColorChange(Constants.highlightedColor)
	}
	
	public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		if !bounds.contains(touches.first?.location(in: self) ?? .zero) {
			cancelTracking(with: event)
			animateColorChange(Constants.primaryColor)
		}
	}
	
	public override func touchesCancelled(_ touches: Set<UITouch>,
										  with event: UIEvent?) {
		super.touchesCancelled(touches, with: event)
		animateColorChange(Constants.primaryColor)
	}
	
	public override func touchesEnded(_ touches: Set<UITouch>,
									  with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		animateColorChange(Constants.primaryColor)
	}
	
	private func animateColorChange(_ color: UIColor) {
		UIView.animate(withDuration: 0.1,
					   delay: 0,
					   options: .curveEaseInOut) { [weak self] in
			self?.backgroundColor = color
		}
		
		if color == Constants.highlightedColor {
			setTitleColor(Constants.primaryColor, for: [.normal, .highlighted])
			layer.applyShadows(style: .dark)
		} else {
			setTitleColor(Constants.highlightedColor, for: [.normal, .highlighted])
			layer.applyShadows(style: .transparent)
		}
	}
}
