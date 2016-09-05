//
//  Map.swift
//  majorprojectios
//
//  Created by Kelvin Harron on 30/08/2016.
//  Copyright © 2016 Kelvin Harron. All rights reserved.
//

import MapKit

class Map: UIViewController, CLLocationManagerDelegate {
    
    let getEvents = "http://localhost:54321/api/event/search"
    
    @IBAction func scanButton(sender: AnyObject) {
        
    }
    
    // link to map view object from storyboard
    @IBOutlet weak var mapView: MKMapView!
    // start all users in belfast
    let startLocation = CLLocationCoordinate2D(latitude: 54.599181, longitude: -5.931083)
    var locationManager:CLLocationManager?
    let distanceSpan:Double = 500
    
    override func viewDidLoad() {
        setupMap()
        getUserLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
       getUserLocation()
    }
    
    func getUserLocation() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager!.requestAlwaysAuthorization()
            locationManager!.distanceFilter = 50
            locationManager!.startUpdatingLocation()
        }
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
    
    func requestEvents(){
        
    }
}
