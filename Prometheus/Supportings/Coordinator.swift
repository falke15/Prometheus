//
//  Coordinator.swift
//  rxLearn
//
//  Created by Pyretttt on 27.08.2021.
//

import UIKit

protocol Coordinator: AnyObject {
	var childCoordinators: [Coordinator] { get set }
	var navigationController: UINavigationController? { get }
	
	func start()
	func finish()
}

extension Coordinator {
	func addFlow(coordinator: Coordinator) {
		childCoordinators.append(coordinator)
	}
	
	func removeFlow(coordinator: Coordinator) {
		childCoordinators = childCoordinators.filter { $0 !== coordinator }
		coordinator.finish()
	}
}
