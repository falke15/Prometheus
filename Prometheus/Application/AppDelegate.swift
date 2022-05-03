//
//  AppDelegate.swift
//  rxLearn
//
//  Created by Pyretttt on 10.06.2021.
//

import FeatureIntermediate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	public private(set) lazy var appCoordinator: AppCoordinator = AppCoordinator(appDelegate: self)
	
    func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.backgroundColor = Pallete.Light.white1
        let navigationController = UINavigationControllerSpy()
        window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
		
        SpashScreenViewController(nextLink: appCoordinator)
            .route(navigationController: navigationController)
        
		return true
    }
	
	func application(_ application: UIApplication,
					 supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		let defaultOrientation: UIInterfaceOrientationMask = .portrait
		guard let rootViewController = window?.rootViewController else {
			return defaultOrientation
		}
		
		let upperView = rootViewController.upperViewController(in: window)
		
		// TODO:  Add tabbar
		
		if let rotatableViewController = upperView as? UIRotatable {
			return rotatableViewController.supportedInterfaceOrientations
		} else if let rotatableViewController = (upperView as? UINavigationController)?.topViewController as? UIRotatable {
			return rotatableViewController.supportedInterfaceOrientations
		}
		
		return defaultOrientation
	}
}
