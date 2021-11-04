//
//  AggregationCellPrototype.swift
//  Prometheus
//
//  Created by Pyretttt on 22.10.2021.
//

import UIKit

open class AnimatedHighlightCell: UICollectionViewCell {
	
	// MARK: - UICollectionViewCell
	
	open override var isHighlighted: Bool {
		didSet {
			guard isHighlighted != oldValue else { return }
			animateHighlighting(increase: isHighlighted)
		}
	}
	
	// MARK: - Animations
	
	private func animateHighlighting(increase: Bool) {
		let scale: CGFloat = 1.03
		let transform = increase ?
			CGAffineTransform(scaleX: scale, y: scale) :
			.identity

		UIView.animate(withDuration: 0.25) { [weak self] in
			self?.transform = transform
		}
	}
}
