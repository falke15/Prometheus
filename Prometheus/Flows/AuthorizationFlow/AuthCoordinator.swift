//
//  AuthCoordinator.swift
//  rxLearn
//
//  Created by Pyretttt on 27.08.2021.
//

import UIKit
import FeatureIntermediate

/// Управляющий флоу авторизации
protocol AuthCoordinating: AnyObject {
	
	/// Завершить авторизацию
	func completeAuthorization()
}

final class AuthCoordinator: Coordinator, AuthCoordinating {
	
	enum Scenario {
		case creation
		case change
		case signIn
	}
	
	var childCoordinators: [Coordinator] = []
	weak var navigationController: UINavigationController?
	private let handleEvent: AppCoordinator.EventHandler
	
	// MARK: - Lifecycle
	
	init(navigationController: UINavigationController?,
		 handleEvent: @escaping AppCoordinator.EventHandler) {
		self.navigationController = navigationController
		self.handleEvent = handleEvent
	}
	
	// MARK: - Coordinator
	
	func start() {
		let viewModel = AuthViewModel(authorizationService: AuthorizationService(),
									  localAuthorizationHelper: LocalAuthorizationHelper(),
									  flowCoordinating: self)
		let vc = AuthViewController(viewModel: viewModel)
		navigationController?.pushViewController(vc, animated: true)
	}
	
	func finish() {
		childCoordinators.forEach {
			$0.finish()
			removeFlow(coordinator: $0)
		}
	}
	
	// MARK: - AuthCoordinating
	
	func completeAuthorization() {
		handleEvent(.loginSucceed, self)
	}
}
