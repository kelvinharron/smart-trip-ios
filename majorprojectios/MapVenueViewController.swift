import Alamofire
import SwiftyJSON
import UIKit
import MapKit

class MapVenueViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
	
	@IBOutlet weak var mapView: MKMapView!
	let SUCCESS_CODE = 200
	let	getVenueListURL = "http://192.168.1.65:54321/api/venue/"
	var selectedVenueName = ""
	let locationManager = CLLocationManager()
	var venueArray = [String]()
	var annotation = MKPointAnnotation()
	var annotationArray: [MKPointAnnotation] = []
	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
		establishLocationManager()
		let lat = locationManager.location?.coordinate.latitude
		let lng = locationManager.location?.coordinate.longitude
		let center = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
		let span = MKCoordinateSpanMake(0.05, 0.05)
		let region = MKCoordinateRegion(center: center, span: span)
		mapView.setRegion(region, animated: true)
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
	
	func showRouteOnMap() {
		let destination = annotationArray[0]
		let request = MKDirectionsRequest()
		request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!), addressDictionary: nil))
		request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destination.coordinate.latitude, longitude: destination.coordinate.longitude), addressDictionary: nil))
		request.requestsAlternateRoutes = true
		request.transportType = .Walking
		
		let directions = MKDirections(request: request)
		
		directions.calculateDirectionsWithCompletionHandler({ [unowned self] Response, error in
			guard let unwrappedResponse = Response else { return }
			
	
			for route in unwrappedResponse.routes {
				self.mapView.addOverlay(route.polyline)
				self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
			}
		
		})
	}
	
	func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {

		let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
		renderer.strokeColor = UIColor.redColor()
		renderer.lineWidth = 3
		renderer.lineDashPhase = 5
		
		return renderer
	}
	
	/// MARK: Location delegate methods
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let location = locations.last
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		print("Failed to find user's location: \(error.localizedDescription)")
	}
	
	func drawMarker(){
		var appendedVenueURL = getVenueListURL+selectedVenueName
		print(appendedVenueURL)
		appendedVenueURL = appendedVenueURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
		
		Alamofire.request(.GET, appendedVenueURL, parameters: nil, encoding: .JSON).validate().responseJSON { [weak self] serverResponse in
			
			if serverResponse.response!.statusCode != self!.SUCCESS_CODE {
				self!.alertMessage("Error", alertMessage: "We can't reach the service at the moment. Please contact the admin.")
			}
			if let data = serverResponse.result.value {
			  let jsonResult = JSON(data)
					let venueName = jsonResult["venueName"].stringValue
					let venueAddress = jsonResult["venueAddress"].stringValue
					var venueLatitude = jsonResult["venueLatitude"].doubleValue as Double
					var venueLongitude = jsonResult["venueLongitude"].doubleValue as Double
				
					var points:CLLocationCoordinate2D = CLLocationCoordinate2DMake(venueLatitude, venueLongitude);
					self!.annotation.title = jsonResult["venueName"].stringValue
					self!.annotation.subtitle = jsonResult["venueAddress"].stringValue
					self!.annotation.coordinate = points
					self!.annotationArray.append(self!.annotation)
					self!.mapView.addAnnotation(self!.annotation)
				}
			
			self!.centerMapOnResult(self!.annotationArray[0], regionRadius: 2000.0)
			self!.showRouteOnMap()
		}
		
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
			showRouteOnMap()
		}
		return resultPin
	}
	
	func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		if control == view.rightCalloutAccessoryView {
			let name = view.annotation!.title! as String!
			let address = view.annotation!.subtitle! as String!
			let lat = view.annotation!.coordinate.latitude
			let lng = view.annotation!.coordinate.longitude
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
