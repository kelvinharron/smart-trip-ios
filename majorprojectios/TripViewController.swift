import UIKit
import Alamofire
import SwiftyJSON

class TripViewController: UITableViewController {
    
    @IBOutlet var tripTable: UITableView!
	@IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {}
	let SUCCESS_CODE = 200
    var tripArray = [String]()
    var valueToPass = ""
    var tripToDelete : NSIndexPath? = nil
    var deleteTripURL = "http://143.117.187.228:7892/api/trip/"
    
    override func viewDidLoad() {
		super.viewDidLoad()
		self.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		self.tableView.tableFooterView = UIView()
    }
	
	func reloadData(){
		getTripList()
	}
	
    func getTripList(){
        var numberRows = 0
        Alamofire.request(.GET, API.getAllTripsURL, parameters: nil, encoding: .JSON).validate().responseJSON { serverResponse in
            
            switch serverResponse.result {
            case .Success(let response):
                let jsonResult = JSON(serverResponse.result.value!)
                numberRows = jsonResult.count
                
                for (index, object) in jsonResult {
                    var trip = object["tripName"].stringValue
                    self.tripArray.append(trip)
                }
                self.tripTable.reloadData()
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
        return tripArray.count
    }
    
    /// Returns an index path so we can configure a cell for display
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tripTable.dequeueReusableCellWithIdentifier("tripCell")!
		cell.alpha = 0
		UIView.animateWithDuration(1, animations: { cell.alpha = 1})
        cell.textLabel?.text = tripArray[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tripToDelete = indexPath
            let selectedTrip = tripArray[indexPath.row]
            deleteTrip(selectedTrip)
            tripArray.removeAtIndex(indexPath.row)
            tripTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
	
	func deleteTrip(selectedTrip: String){
		let parameter = ["tripName": selectedTrip]
		Alamofire.request(.DELETE, API.deleteTripURL, parameters: parameter, encoding: .JSON).validate().responseJSON { serverResponse in
			let data = serverResponse.data
			let responseData = String(data: data!, encoding: NSUTF8StringEncoding)
			
			if(serverResponse.response!.statusCode != self.SUCCESS_CODE) {
				self.alertMessage("Error", alertMessage: responseData!)
			} else {
				self.alertMessage("Success", alertMessage: responseData!)
			}
		}
		self.tripTable.reloadData()
	}
	
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueSender") {
			
			let nav = segue.destinationViewController as! UINavigationController
			let destinationViewController = nav.topViewController as! DetailTripViewController
			
			if let indexPath = self.tableView.indexPathForSelectedRow {
				let selectedRow = tripArray[indexPath.row]
				destinationViewController.selectedTripName = selectedRow
            }
        }
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
    
    @IBAction func logoutButton(sender: AnyObject) {
        moveToLogout()
    }
    
    /// Once called, moves to the welcome view
    func moveToLogout(){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("WelcomeViewController") as UIViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
}