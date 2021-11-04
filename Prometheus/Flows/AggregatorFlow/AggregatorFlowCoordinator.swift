//
//  AggregatorFlowCoordinator.swift
//  Prometheus
//
//  Created by Pyretttt on 30.09.2021.
//

import FeatureIntermediate

final class AggregatorFlowCoordinator: Coordinator {
	
	var childCoordinators: [Coordinator] = []
	weak var navigationController: UINavigationController?
	private let handleEvent: AppCoordinator.EventHandler
	private let serviceLocator: AggregationServiceLocatorType
	
	// MARK: - Lifecycle
	
	init(navigation: UINavigationController,
		 serviceLocator: AggregationServiceLocatorType,
		 handleEvent: @escaping AppCoordinator.EventHandler) {
		self.navigationController = navigation
		self.serviceLocator = serviceLocator
		self.handleEvent = handleEvent
	}
	
	// MARK: - Coordinator
	
	func start() {
		let viewModel = AggregationViewModel(featureLoader: serviceLocator.featureLoader)
		let view = AggregationViewController(viewModel: viewModel)
		navigationController?.pushViewController(view, animated: true)
	}
	
	func finish() {
		childCoordinators.forEach {
			$0.finish()
			removeFlow(coordinator: $0)
		}
		handleEvent(.logout, self)
	}
}
