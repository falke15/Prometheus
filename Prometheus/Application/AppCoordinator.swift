//
//  AppCoordinator.swift
//  rxLearn
//
//  Created by Pyretttt on 27.08.2021.
//

import UIKit

final class AppCoordinator: Coordinator {
	
	typealias EventHandler = (Event, Coordinator) -> Void
	
	enum Event {
		case loginSucceed
		case logout
		case passwordChangeRequest
	}
	
	weak var navigationController: UINavigationController?
	var childCoordinators: [Coordinator] = []
	
	// MARK: - Private properties
	
	private weak var appDelegate: AppDelegate?
	private lazy var handleEvent: EventHandler = { [weak self] event, sender in
		guard let self = self else { return }
		sender.finish()
		self.removeFlow(coordinator: sender)
		self.eventOccured(event: event)
	}
	
	// MARK: - Lifecycle
	
	init(appDelegate: AppDelegate) {
		self.appDelegate = appDelegate
	}
	
	// MARK: - Methods
	
	func start() {
		startAuthFlow()
	}
	
	private func startAuthFlow() {
		let navigationController = UINavigationControllerSpy()
		appDelegate?.window?.rootViewController = navigationController
		self.navigationController = navigationController
		
		let coordinator = AuthCoordinator(navigationController: navigationController,
										  handleEvent: handleEvent)
		addFlow(coordinator: coordinator)
		coordinator.start()
	}
	
	private func startAggregatorFlow() {
		let navigationController = UINavigationControllerSpy()
		appDelegate?.window?.rootViewController = navigationController
		self.navigationController = navigationController
		
		let coordinator = AggregatorFlowCoordinator(navigation: navigationController,
													handleEvent: handleEvent)
		addFlow(coordinator: coordinator)
		coordinator.start()
	}
	
	func finish() {}
	
	// MARK: - FlowEventListener
	
	func eventOccured(event: Event) {
		switch event {
		case .loginSucceed:
			startAggregatorFlow()
		case .logout:
			break
		case .passwordChangeRequest:
			break
		}
	}
}
