//
//  SpacerView.swift
//  FeatureIntermediate
//
//  Created by Pyretttt on 16.11.2021.
//

import UIKit

/// Филлер для заполнения простратсва. Дефолтный размер 100x40
public final class SpacerView: UIView {

	private static let defaultPriority: Float = 125
	
	// MARK: - Lifecycle
	
	init() {
		super.init(frame: .zero)
		setContentHuggingPriority(UILayoutPriority(Self.defaultPriority), for: .vertical)
		setContentHuggingPriority(UILayoutPriority(Self.defaultPriority), for: .horizontal)
		setContentCompressionResistancePriority(UILayoutPriority(Self.defaultPriority), for: .vertical)
		setContentCompressionResistancePriority(UILayoutPriority(Self.defaultPriority), for: .horizontal)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UIView
	
	public override var intrinsicContentSize: CGSize {
		CGSize(width: 100, height: 40)
	}
}
