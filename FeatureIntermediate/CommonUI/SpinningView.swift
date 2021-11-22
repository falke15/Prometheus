//
//  SpinningView.swift
//  FeatureIntermediate
//
//  Created by Pyretttt on 09.11.2021.
//

import Foundation

public final class SpinningView: UIView {

	private enum Constants {
		static let sectorWidth: CGFloat = 0.15
		static let strokeWidth: CGFloat = NumericValues.default
	}
	
	// MARK: - Visual Elements
	
	private let strokeColor: UIColor
	private lazy var circleLayer: CAShapeLayer = {
		let layer = CAShapeLayer()
		layer.fillColor = Pallete.Utility.transparent.cgColor
		layer.lineWidth = Constants.strokeWidth
		layer.strokeColor = strokeColor.cgColor
		layer.strokeEnd = Constants.sectorWidth
		
		return layer
	}()
	
	// MARK: - UIView
	
	public override var intrinsicContentSize: CGSize {
		return CGSize(width: 56, height: 56)
	}
	
	// MARK: - Lifecycle
	
	public init(strokeColor: UIColor = Pallete.Gray.gray3) {
		self.strokeColor = strokeColor
		super.init(frame: .zero)
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		setupCircleLayer()
	}
	
	// MARK: - Setup UI
	
	private func setupUI() {
		layer.addSublayer(circleLayer)
		circleLayer.applyShadows(style: .dark)
	}
	
	private func setupCircleLayer() {
		circleLayer.bounds = frame
		let path = UIBezierPath(roundedRect: circleLayer.bounds.insetBy(dx: Constants.strokeWidth, dy: Constants.strokeWidth),
								cornerRadius: circleLayer.bounds.width)
		circleLayer.path = path.cgPath
		circleLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
	}
	
	// MARK: - Animation
	
	public func startAnimation() {
		stopAnimation()

		let group = CAAnimationGroup()
		group.duration = 1
		group.repeatCount = .infinity
		group.isRemovedOnCompletion = false
		group.fillMode = .forwards
		group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		group.animations = [createRotationAnimation(), createStrokeAnimation()]
		
		circleLayer.add(group, forKey: #function)
	}
	
	private func createRotationAnimation() -> CAAnimation {
		let animation = CABasicAnimation(keyPath: "transform.rotation")
		animation.fromValue = 0
		animation.toValue = 2 * Float.pi
		return animation
	}
	
	private func createStrokeAnimation() -> CAAnimation {
		let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
		animation.fromValue = Constants.sectorWidth
		animation.toValue = 0.5
		animation.speed = 2
		animation.autoreverses = true
	
		return animation
	}
	
	public func stopAnimation() {
		circleLayer.removeAllAnimations()
	}
}
