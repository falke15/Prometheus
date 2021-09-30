//
//  AppCoordinator.swift
//  rxLearn
//
//  Created by Pyretttt on 27.08.2021.
//

import UIKit

protocol FlowEventListener: AnyObject {
	func eventOccured(event: AppCoordinator.Event)
}

final class AppCoordinator: Coordinator, FlowEventListener {
	
	enum Event {
		case loginSucceed
		case logout
		case passwordChangeRequest
	}
	
	weak var navigationController: UINavigationController?
	var childCoordinators: [Coordinator] = []
	
	// MARK: - Private properties
	
	private weak var appDelegate: AppDelegate?
	
	// MARK: - Lifecycle
	
	init(appDelegate: AppDelegate) {
		self.appDelegate = appDelegate
	}
	
	// MARK: - Methods
	
	func start() {
		startAuthFlow()
	}
	
	private func startAuthFlow() {
		let navigationController = UINavigationController()
		appDelegate?.window?.rootViewController = navigationController
		self.navigationController = navigationController
		
		let coordinator = AuthCoordinator(navigationController: navigationController,
										  eventListener: self)
		coordinator.start()
	}
	
	private func startMainFlow() {
		let navigationController = UINavigationController()
		appDelegate?.window?.rootViewController = navigationController
		self.navigationController = navigationController
	}
	
	func finish() {}
	
	// MARK: - FlowEventListener
	
	func eventOccured(event: Event) {
		switch event {
		case .loginSucceed:
			break
		case .logout:
			break
		case .passwordChangeRequest:
			break
		}
	}
}
