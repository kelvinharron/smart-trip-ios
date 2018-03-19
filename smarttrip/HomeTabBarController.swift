//
//  HomeTabBarController.swift
//  smarttrip
//
//  Created by Kelvin Harron on 18/03/2018.
//  Copyright © 2018 Kelvin Harron. All rights reserved.
//
import UIKit

class HomeTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let welcomeView = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Trips"
        setControllers()
    }
    
    private func setControllers() {
        let favoritesVC = UIViewController()
        favoritesVC.title = "Trips"
        favoritesVC.tabBarItem = UITabBarItem(title: "Trips", image: nil, tag: 0)
        let downloadsVC = MapViewController()
        downloadsVC.title = "Map"
        downloadsVC.tabBarItem = UITabBarItem(title: "Map", image: nil, tag: 1)
        
        let historyVC = UIViewController()
        historyVC.title = "Settings"
        historyVC.tabBarItem = UITabBarItem(title: "Settings", image: nil, tag: 2)
        let controllers = [favoritesVC, downloadsVC, historyVC]
        self.viewControllers = controllers
    }
}
