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
	public private(set) lazy var appCoordinator: AppCoordinator = AppCoordinator(appDelegate: self)
	
    func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.backgroundColor = Pallete.Light.white1
		appCoordinator.start()
		window?.makeKeyAndVisible()
		
		return true
    }
}
