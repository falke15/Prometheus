//
//  UINavigationControllerSpy.swift
//  Prometheus
//
//  Created by Pyretttt on 30.09.2021.
//

import UIKit

final class UINavigationControllerSpy: UINavigationController {
	deinit {
		print("deleted")
	}
}
