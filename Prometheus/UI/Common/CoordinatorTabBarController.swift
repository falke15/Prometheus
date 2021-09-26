//
//  CoordinatorTabBarController.swift
//  rxLearn
//
//  Created by Pyretttt on 28.08.2021.
//

import UIKit

final class CoordinatorTabBarController: UITabBarController {
	
	private var coordinators: [Coordinator]
	
	// MARK: - Lifecycle
	
	init(coordinators: [Coordinator]) {
		self.coordinators = coordinators
		super.init(nibName: nil, bundle: nil)
		
		setupCoordinators()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Setup
	
	private func setupCoordinators() {
		coordinators.forEach { $0.start() }
		viewControllers = coordinators.compactMap { $0.navigationController }
	}
}
