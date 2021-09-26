//
//  AppDelegate.swift
//  rxLearn
//
//  Created by Pyretttt on 10.06.2021.
//

import UIKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	public private(set) lazy var appCoordinator: AppCoordinator = AppCoordinator(appDelegate: self)
	
    func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		appCoordinator.start()
		window?.makeKeyAndVisible()
		
		return true
    }
}

