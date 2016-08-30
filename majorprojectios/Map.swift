//
//  Map.swift
//  majorprojectios
//
//  Created by Kelvin Harron on 30/08/2016.
//  Copyright © 2016 Kelvin Harron. All rights reserved.
//

import MapKit

class Map: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let startLocation = CLLocationCoordinate2D(latitude: 54.599181, longitude: -5.931083)
    
    override func viewDidLoad() {
        setupMap()
    }
    
    func setupMap(){
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: startLocation, span: span)
        mapView.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        annotation.coordinate = startLocation
        annotation.title = "Belfast City Hall"
        mapView.addAnnotation(annotation)
    
    }
}
