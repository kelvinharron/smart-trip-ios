import Alamofire
import SwiftyJSON
import UIKit
import MapKit

class MapVenueViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
	
	@IBOutlet weak var mapView: MKMapView!
	let	getVenueListURL = "http://192.168.1.65:54321/api/venue/marker/"
	var selectedVenueName = ""
	let locationManager = CLLocationManager()
	var venueArray = [String]()
	let annotation = MKPointAnnotation()
	var annotationArray: [MKPointAnnotation] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
		establishLocationManager()
		drawMarker()
	}
	
	func establishLocationManager(){
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.requestAlwaysAuthorization()
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.startUpdatingLocation()
		mapView.showsUserLocation = true
	}
	
	/// MARK: Location delegate methods
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let location = locations.last
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		print("Failed to find user's location: \(error.localizedDescription)")
	}
	
	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		
		if annotation.isMemberOfClass(MKUserLocation.self) {
			return nil
		}
		let pinIdentifier = "pin"
		var resultPin = mapView.dequeueReusableAnnotationViewWithIdentifier(pinIdentifier) as? MKPinAnnotationView
		if resultPin == nil {
			resultPin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier)
			resultPin!.pinTintColor = UIColor.redColor()
			resultPin!.animatesDrop = true
			resultPin!.canShowCallout = true
		} else {
			resultPin!.annotation = annotation
		}
		return resultPin
	}
	
	func drawMarker(){
		var appendedVenueURL = getVenueListURL+selectedVenueName
		appendedVenueURL = appendedVenueURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
		Alamofire.request(.GET, appendedVenueURL, parameters: nil, encoding: .JSON).validate().responseJSON { serverResponse in
			print(serverResponse)
			switch serverResponse.result {
				
			case .Success(let response):
				if let data = serverResponse.result.value {
					let jsonResult = JSON(data)
					for (index, object) in jsonResult {
						
						self.annotation.title = object["venueName"].stringValue
						self.annotation.subtitle = object["venueAddress"].stringValue
						self.annotation.coordinate.latitude = object["venueLatitude"].doubleValue
						self.annotation.coordinate.longitude = object["venueLongitude"].doubleValue
						self.mapView.addAnnotation(	self.annotation)
						print(self.annotation)
					}
					
				}
				self.centerMapOnResult(self.annotation, regionRadius: 1000.0)
				break
			case .Failure(let error):
				self.alertMessage("No connection", alertMessage: "We can't reach the service at the moment. Please contact the admin.")
				break
			}
		}
	}
	
	func centerMapOnResult(location: MKPointAnnotation, regionRadius: Double){
		let coordinatesRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
		mapView.setRegion(coordinatesRegion, animated: true)
	}
	
	/// Popup alert that can be dismissed. Used to inform/warn the user as a result of their action not being accepted.
	///
	/// - Parameter alertTitle: String used as title of the alert popup
	/// - Parameter alertMessage: String used as body of the alert popup
	func alertMessage(alertTitle: String, alertMessage: String){
		let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
}
