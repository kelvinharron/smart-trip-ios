//
//  MapViewController.swift
//  smarttrip
//
//  Created by Kelvin Harron on 19/03/2018.
//  Copyright © 2018 Kelvin Harron. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
   override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let mapView = MKMapView()
        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = view.frame.size.height
        
        mapView.frame = CGRect(x: 0, y: 0, width: mapWidth, height: mapHeight)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.center = view.center
        
        view.addSubview(mapView)
    }
    
}
