//
//  Register.swift
//  majorprojectios
//
//  Created by Kelvin Harron on 29/08/2016.
//  Copyright © 2016 Kelvin Harron. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class Register: UIViewController {
    
    let registerURL = "http://localhost:54321/api/user/signup"
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        definesPresentationContext = true
    }
    
    @IBAction func signupButton(sender: AnyObject) {
        checkLogin()
    }
    
    func checkLogin() {
        if (emailField.text!.isEmpty) || (passwordField.text!.isEmpty) || (confirmPasswordField.text!.isEmpty) {
            alertMessage("Empty text fields", alertMessage: "Please fill out all text fields when registering.")
        } else if (passwordField.text != confirmPasswordField.text) {
            alertMessage("Passwords do not match", alertMessage: "Please ensure your passwords match.")
        } else {
            checkRequest()
        }
    }
    
    func checkRequest() {
        
        let parameters = ["email": emailField.text as! AnyObject,
                          "password": passwordField.text as! AnyObject
        ]
        let manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Content-Type":"application/json"
        ]
        
        Alamofire.request(.POST,registerURL,parameters: parameters, encoding: .JSON).validate().responseJSON { [weak self] serverResponse in
            
            let data = serverResponse.data
            let responseData = String(data: data!, encoding: NSUTF8StringEncoding)
            
            print(responseData)
            
            switch serverResponse.response!.statusCode {
            case 200:
                self!.successMessage("Welcome!", alertMessage: responseData!)
                break
            case 400:
                self!.alertMessage("Bad Credentials", alertMessage: responseData!)
                break
            case 409:
                self!.alertMessage("Error", alertMessage: responseData!)
                break
            default: break
            }
        }
    }
    /// Popup alert that can be dismissed. Used to inform/warn the user as a result of their action not being accepted.
    /// - Parameter alertTitle: String used as title of the alert popup
    /// - Parameter alertMessage: String used as body of the alert popup
    func alertMessage(alertTitle: String, alertMessage: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        self.presentViewController(alert, animated: true){}
    }
    
    func successMessage(alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Proceed", style: .Default, handler: { action in
            self.moveToMainView()}))
        self.presentViewController(alert, animated: true){}
        
    }
    /**
     
     holy ceaip
     */
    func moveToMainView(){
        /// Gets or sets
        var storyboard = UIStoryboard(name: "Itinerary", bundle: nil)
        var controller = storyboard.instantiateViewControllerWithIdentifier("InitialController") as UIViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
}