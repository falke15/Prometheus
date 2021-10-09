//
//  AppDelegate.swift
//  rxLearn
//
//  Created by Pyretttt on 10.06.2021.
//

import UIKit
import RxSwift
import FeatureIntermediate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	private let featureLoader = FeatureLoader()
	public private(set) lazy var appCoordinator: AppCoordinator = AppCoordinator(appDelegate: self,
																				 featureLoader: featureLoader)
	
    func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		appCoordinator.start()
		window?.makeKeyAndVisible()
		
		return true
    }
}

