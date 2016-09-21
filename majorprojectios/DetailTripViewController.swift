import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class DetailTripViewController: UITableViewController {
	
	@IBAction func unwindFromMap(segue: UIStoryboardSegue) {}
	@IBAction func unwindFromDetailMap(segue: UIStoryboardSegue) {}
	@IBOutlet var venueTable: UITableView!
	@IBOutlet weak var tripName: UILabel!
	@IBOutlet weak var tripCity: UILabel!
	@IBOutlet weak var startDate: UILabel!
	@IBOutlet weak var endDate: UILabel!
	
	var venueArray = [String]()
	var selectedTripName = ""
	var venueToDelete : NSIndexPath? = nil

	let SUCCESS_CODE = 200
	private let queue = NSOperationQueue()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		updateTripLabels()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewDidAppear(true)
		venueArray.removeAll()
		getVenueList()
		self.tableView.tableFooterView = UIView()
		
	}
	
	func updateTripLabels(){
		var appendedTripURL = API.getSingleTripURL+selectedTripName
		appendedTripURL = appendedTripURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
		Alamofire.request(.GET, appendedTripURL, parameters: nil, encoding: .JSON).validate().responseJSON { serverResponse in
			
			switch serverResponse.result {
			case .Success(let response):
				if let data = serverResponse.result.value {
					dispatch_async(dispatch_get_main_queue(), {
					let jsonResult = JSON(data)
					self.tripName.text = jsonResult["tripName"].stringValue
					self.setView(self.tripName, duration: 0.5, hidden: false)
					self.tripCity.text = jsonResult["tripCity"].stringValue
					self.setView(self.tripCity, duration: 0.8, hidden: false)
					self.startDate.text = jsonResult["startDate"].stringValue
					self.setView(self.startDate, duration: 1.2, hidden: false)
					self.endDate.text = jsonResult["endDate"].stringValue
					self.setView(self.endDate, duration: 1.2, hidden: false)
					})
				}
				break
			case .Failure(let error):
				self.alertMessage("No connection", alertMessage: "We can't reach the service at the moment. Please contact the admin.")
				break
			}
		}
	}
	
	func getVenueList(){
		var numberRows = 0
		
		Alamofire.request(.GET, API.getAllVenuesURL, parameters: nil, encoding: .JSON).validate().responseJSON { serverResponse in
			switch serverResponse.result {
			case .Success(let response):
				let jsonResult = JSON(serverResponse.result.value!)
				numberRows = jsonResult.count
				
				for (index, object) in jsonResult {
					var trip = object["venueName"].stringValue
					self.venueArray.append(trip)
				}
				self.venueTable.reloadData()
				break
			case .Failure(let error):
				if (numberRows != 0) {
					self.alertMessage("No connection", alertMessage: "We can't reach the service at the moment. Please contact the admin.")
				}
				break
			}
		}
	}
	
	/// Returns a count of the number of cells in our table view
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return venueArray.count
	}
	
	/// Returns an index path so we can configure a cell for display
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = venueTable.dequeueReusableCellWithIdentifier("venueCell")!
		cell.alpha = 0
		UIView.animateWithDuration(1, animations: { cell.alpha = 1.4})
		cell.textLabel?.text = venueArray[indexPath.row]
		return cell
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			venueToDelete = indexPath
			let selectedVenue = venueArray[indexPath.row]
			deleteVenue(selectedVenue)
			venueArray.removeAtIndex(indexPath.row)
			venueTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
		}
	}
	
	func deleteVenue(selectedVenue: String){
		let parameter = ["venueName": selectedVenue]
		
		Alamofire.request(.DELETE, API.deleteVenueURL, parameters: parameter, encoding: .JSON).validate().responseJSON { serverResponse in
			let data = serverResponse.data
			let responseData = String(data: data!, encoding: NSUTF8StringEncoding)
			
			if(serverResponse.response!.statusCode != self.SUCCESS_CODE) {
				self.alertMessage("Error", alertMessage: responseData!)
			} else {
				self.alertMessage("Success", alertMessage: responseData!)
			}
		}
		self.venueTable.reloadData()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "venueSender") {
			
			let nav = segue.destinationViewController as! UINavigationController
			let destinationViewController = nav.topViewController as! MapVenueViewController
			
			if let indexPath = self.tableView.indexPathForSelectedRow {
				let selectedRow = venueArray[indexPath.row]
				destinationViewController.selectedVenueName = selectedRow
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