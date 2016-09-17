import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class DetailTripViewController: UITableViewController {
	
	@IBAction func unwindFromMap(segue: UIStoryboardSegue) {}
	
	var valueToPass = ""
	let detailURL = "http://192.168.1.65:54321/api/trip/"
	
	@IBOutlet weak var tripName: UILabel!
	@IBOutlet weak var tripCity: UILabel!
	@IBOutlet weak var startDate: UILabel!
	@IBOutlet weak var endDate: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewDidAppear(true)
		self.reloadData()
	}
	
	func reloadData(){
		updateLabels()
	}
	
	func updateLabels(){
		var appendedURL = detailURL+valueToPass
		appendedURL = appendedURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
		Alamofire.request(.GET, appendedURL, parameters: nil, encoding: .JSON).validate().responseJSON { serverResponse in
			
			switch serverResponse.result {
			case .Success(let response):
				if let data = serverResponse.result.value {
					let jsonResult = JSON(data)
					self.tripName.text = jsonResult["tripName"].stringValue
					self.setView(self.tripName, duration: 0.5, hidden: false)
					self.tripCity.text = jsonResult["tripCity"].stringValue
					self.setView(self.tripCity, duration: 0.8, hidden: false)
					self.startDate.text = jsonResult["startDate"].stringValue
					self.setView(self.startDate, duration: 1.2, hidden: false)
					self.endDate.text = jsonResult["endDate"].stringValue
					self.setView(self.endDate, duration: 1.2, hidden: false)
				}
				break
			case .Failure(let error):
				self.alertMessage("No connection", alertMessage: "We can't reach the service at the moment. Please contact the admin.")
				break
			}
		}
	}

	
	/// Used to set the fade in animation once labels are loaded from the GET request
	func setView(view: UIView, duration: Double, hidden: Bool) {
		UIView.transitionWithView(view, duration: duration, options: .TransitionCrossDissolve, animations: {() -> Void in
			view.hidden = hidden
			}, completion: { _ in })
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