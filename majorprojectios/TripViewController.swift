import UIKit
import Alamofire
import SwiftyJSON

class TripViewController: UITableViewController {
    @IBOutlet var tripTable: UITableView!
    
    var tripArray = [String]()
    var valueToPass = ""
    
    let getTripsURL = "http://localhost:54321/api/trip/"
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        getTripList()
    }
    
    func getTripList(){
        var numberRows = 1
        Alamofire.request(.GET, getTripsURL, parameters: nil, encoding: .JSON).validate().responseJSON { serverResponse in
            
            switch serverResponse.result {
            case .Success(let response):
                let jsonResult = JSON(serverResponse.result.value!)
                numberRows = jsonResult.count
                
                for i in 0...numberRows {
                    var trip = jsonResult[i]["tripName"].stringValue as String!
                    print(trip)
                    self.tripArray.append(trip)
                }
                self.tripTable.reloadData()
                break
            case .Failure(let error):
                self.alertMessage("No connection", alertMessage: "We can't reach the service at the moment. Please contact the admin.")
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
        cell.textLabel?.text = tripArray[indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueSender") {
            
            let nav = segue.destinationViewController as! UINavigationController
            let destinationViewController = nav.topViewController as! DetailTripViewController
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedRow = tripArray[indexPath.row]
                destinationViewController.valueToPass = selectedRow
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