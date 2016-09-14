import UIKit
import Alamofire

/// Start point of our application. First view from the storyboard we see is the welcome screen which the following code handles
///
///
class WelcomeViewController: UIViewController {
    
    
    /// Label from view controller that is used to display server status
    @IBOutlet weak var serverStatus: UILabel!
    /// Status URL returns a 200 if operational, used to update status label
    let statusURL = "http://localhost:54321/status"
    
    /// Swift lifecycle function, called only once when the view is
    override func viewDidLoad() {
        super.viewDidLoad()
        checkServerStatus()
    }
    
    /// Function completes a GET request to the service using Alamofire to verify if the service is operational. 
    /// Using Alamofire built in validate function we can pull out a .Success and .Failure and switch on result
    ///Label colour updated depending on request result
    func checkServerStatus(){
        Alamofire.request(.GET, statusURL).validate().responseJSON { serverResponse in
            switch serverResponse.result {
            case .Success(let response):
                print("Server operational") // console print
                self.serverStatus.text = "Online"
                self.serverStatus.textColor = UIColor.greenColor()
                break
            case .Failure(let error):
                print("No response - server offline") // console print
                self.serverStatus.text = "Offline"
                self.serverStatus.textColor = UIColor.redColor()
                break
            }
        }
    }
}