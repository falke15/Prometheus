//
//  AuthCoordinator.swift
//  rxLearn
//
//  Created by Pyretttt on 27.08.2021.
//

import UIKit

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
	private weak var eventListener: FlowEventListener?
	
	// MARK: - Lifecycle
	
	init(navigationController: UINavigationController?,
		 eventListener: FlowEventListener) {
		self.navigationController = navigationController
		self.eventListener = eventListener
	}
	
	// MARK: - Coordinator
	
	func start() {
		let viewModel = AuthViewModel(authorizationService: AuthorizationService())
		let vc = AuthViewController(viewModel: viewModel)
		navigationController?.pushViewController(vc, animated: true)
	}
	
	func finish() {
		
	}
	
	// MARK: - AuthCoordinating
	
	func completeAuthorization() {
		eventListener?.eventOccured(event: .loginSucceed)
	}
}
