//
//  DotProgressView.swift
//  exKeeper
//
//  Created by Pyretttt on 06.09.2021.
//

import UIKit

public final class DotProgressView: UIView {
	
	private enum Values {
		static let dotSize: CGFloat = 16
	}
	
	private var counter: Int = 0
	private(set) var dotsCount: Int
	
	private let successColor: UIColor = Pallete.Green.green3
	private let secondaryColor: UIColor = Pallete.Gray.gray4
	
	// MARK: - Views
	
	private let statusLabel: UILabel = {
		let view = UILabel()
		view.textColor = Pallete.Black.black2
		view.font = view.font.withSize(NumericValues.large)
		view.numberOfLines = 2
		view.textAlignment = .center
		view.setContentHuggingPriority(.defaultLow, for: .vertical)
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	private let dotStack: UIStackView = {
		let view = UIStackView()
		view.spacing = 8
		view.axis = .horizontal
		view.distribution = .fill
		view.alignment = .center
		view.setContentHuggingPriority(.required, for: .vertical)
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	private var dots: [UIView] = []
	
	// MARK: - Lifecycle
	
	public init(dotsCount: Int) {
		self.dotsCount = dotsCount
		super.init(frame: .zero)
		
		dots = createDots()
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Interface
	
	public func setStatusText(text: String, animated: Bool = false) {
		if animated {
			let animation = CATransition()
			animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
			animation.type = CATransitionType.fade
			animation.duration = 0.3
			statusLabel.layer.add(animation, forKey: CATransitionType.fade.rawValue)
		}
		
		statusLabel.text = text
	}
	
	public func fillProgrees() {
		counter = 4
		dots.forEach {
			changeViewColor(view: $0, color: successColor)
		}
	}
	
	public func resetProgress() {
		counter = 0
		dots.forEach {
			changeViewColor(view: $0, color: secondaryColor)
		}
	}
	
	public func increment() {
		if counter < dotsCount {
			let currentDot = dots[counter]
			changeViewColor(view: currentDot, color: successColor)
			counter += 1
		}
	}
	
	public func decrement() {
		if counter > 0 {
			let prevDot = dots[counter - 1]
			changeViewColor(view: prevDot, color: secondaryColor)
			counter -= 1
		}
	}
	
	// MARK: - Setup UI
	
	private func setupUI() {
		let views = [statusLabel, dotStack]
		views.forEach { addSubview($0) }
		dots.forEach { dotStack.addArrangedSubview($0) }
		
		setupConstraints()
	}
	
	private func createDots() -> [UIView] {
		var dots: [UIView] = []
		for _ in 0..<dotsCount {
			let view = UIView()
			view.translatesAutoresizingMaskIntoConstraints = false
			view.backgroundColor = Pallete.Gray.gray4
			view.layer.cornerRadius = Values.dotSize / 2
			NSLayoutConstraint.activate([
				view.heightAnchor.constraint(equalToConstant: Values.dotSize),
				view.widthAnchor.constraint(equalTo: view.heightAnchor)
			])
			
			dots.append(view)
		}
		return dots
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			statusLabel.topAnchor.constraint(equalTo: topAnchor),
			statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
			
			dotStack.topAnchor.constraint(equalTo: statusLabel.bottomAnchor,
										  constant: NumericValues.default),
			dotStack.bottomAnchor.constraint(equalTo: bottomAnchor),
			dotStack.centerXAnchor.constraint(equalTo: centerXAnchor)
		])
	}
	
	// MARK: - Animations
	
	private func changeViewColor(view: UIView, color: UIColor) {
		UIView.animate(withDuration: 0.1) {
			view.backgroundColor = color
		}
	}
}
