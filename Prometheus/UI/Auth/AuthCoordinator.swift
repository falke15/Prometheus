//
//  AuthCoordinator.swift
//  rxLearn
//
//  Created by Pyretttt on 27.08.2021.
//

import UIKit

final class AuthCoordinator: Coordinator {
	
	var childCoordinators: [Coordinator] = []
	weak var navigationController: UINavigationController?
	
	// MARK: - Lifecycle
	
	init(navigationController: UINavigationController?) {
		self.navigationController = navigationController
	}
	
	// MARK: - Coordinator
	
	func start() {
		let vc = AuthViewController()
		navigationController?.pushViewController(vc, animated: true)
	}
	
	private func startPassCreation() {
		
	}
	
	func finish() {
		
	}
	
	// MARK: - Private methods
}

extension AuthCoordinator {
	enum Scenario {
		case creation
		case change
		case signIn
	}
}
