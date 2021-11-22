//
//  UIViewController+Upper.swift
//  FeatureIntermediate
//
//  Created by Pyretttt on 14.11.2021.
//

import UIKit

public extension UIViewController {
	func upperViewController(in window: UIWindow?) -> UIViewController {
		guard let window = window,
			  var rootView = window.rootViewController else {
			fatalError("Key window is unacceptable")
		}
		
		var pathFindingView: UIViewController? = rootView
		while pathFindingView != nil {
			pathFindingView = rootView.presentedViewController
			if let upperView = rootView.presentedViewController {
				rootView = upperView
			}
		}
		
		return rootView
	}
}

