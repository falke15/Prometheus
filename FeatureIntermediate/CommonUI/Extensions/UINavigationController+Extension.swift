//
//  UINavigationController+Extension.swift
//  FeatureIntermediate
//
//  Created by Pyretttt on 31.10.2021.
//

import UIKit

public extension UINavigationController {
	static func upper() -> UINavigationController? {
		let rootWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
		var topNavigationController: UINavigationController?
		var presentedViewController = rootWindow?.rootViewController
		
		while presentedViewController != nil {
			if presentedViewController is UINavigationController {
				topNavigationController = presentedViewController as? UINavigationController
			}
			presentedViewController = presentedViewController?.presentedViewController
		}
		
		return topNavigationController
	}
}
