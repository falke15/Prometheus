//
//  AggregatorFlowCoordinator.swift
//  Prometheus
//
//  Created by Pyretttt on 30.09.2021.
//

import UIKit

final class AggregatorFlowCoordinator: Coordinator {
	
	var childCoordinators: [Coordinator] = []
	weak var navigationController: UINavigationController?
	private let handleEvent: AppCoordinator.EventHandler
	
	// MARK: - Lifecycle
	
	init(navigation: UINavigationController,
		 handleEvent: @escaping AppCoordinator.EventHandler) {
		self.navigationController = navigation
		self.handleEvent = handleEvent
	}
	
	// MARK: - Coordinator
	
	func start() {
		navigationController?.pushViewController(AggregatorViewController(), animated: true)
	}
	
	func finish() {
		childCoordinators.forEach {
			$0.finish()
			removeFlow(coordinator: $0)
		}
	}
}
