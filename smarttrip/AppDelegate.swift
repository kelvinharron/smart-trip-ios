//
//  AppDelegate.swift
//  majorprojectios
//
//  Created by Kelvin Harron on 29/08/2016.
//  Copyright © 2016 Kelvin Harron. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        setRootController()
    }
    
    private func setRootController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: HomeTabBarController())
    }
}
