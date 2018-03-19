//
//  HomeTabBarController.swift
//  smarttrip
//
//  Created by Kelvin Harron on 18/03/2018.
//  Copyright © 2018 Kelvin Harron. All rights reserved.
//
import UIKit

class HomeTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let flowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: 0, action: nil)
    }
    
    private func setViewControllers() {
        let tripsVC = TripsCollectionViewController(collectionViewLayout: flowLayout)
        tripsVC.tabBarItem = UITabBarItem(title: "Trips", image: nil, tag: 0)
        let mapsVC = MapViewController()
        mapsVC.tabBarItem = UITabBarItem(title: "Map", image: nil, tag: 1)
        let settingsVC = UIViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: nil, tag: 2)
        
        let controllers = [tripsVC, mapsVC, settingsVC]
        self.viewControllers = controllers
    }
}
