//
//  AppCoordinator.swift
//  rxLearn
//
//  Created by Pyretttt on 27.08.2021.
//

import UIKit

final class AppCoordinator: Coordinator {
	
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
		
		let coordinator = AuthCoordinator(navigationController: navigationController)
		coordinator.start()
	}
	
	private func startMainFlow() {
		let navigationController = UINavigationController()
		appDelegate?.window?.rootViewController = navigationController
	}
	
	func finish() {}
}

extension AppCoordinator {
	enum AppFlow {
		case main
		case auth
		case undefined
	}
}
