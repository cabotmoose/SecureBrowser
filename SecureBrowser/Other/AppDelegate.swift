//
//  AppDelegate.swift
//  SecureBrowser
//
//  Created by Cameron Smith on 2/6/18.
//  Copyright © 2018 Flying Moose Development. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		//	Go to Login storyboard first
		let storyboard = UIStoryboard(name: "Login", bundle: .main)
		if let initialVC = storyboard.instantiateInitialViewController() {
			window?.rootViewController = initialVC
			window?.makeKeyAndVisible()
		}
		
		return true
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
		let storyboard = UIStoryboard(name: "Login", bundle: .main)
		if let initialVC = storyboard.instantiateInitialViewController() {
			window?.rootViewController = initialVC
			window?.makeKeyAndVisible()
		}
	}

	func applicationWillResignActive(_ application: UIApplication) {
		UIApplication.shared.ignoreSnapshotOnNextApplicationLaunch()
	}
	
	func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
		return false
	}
	
	func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
		return false
	}
}

