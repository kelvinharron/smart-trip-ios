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
    
    let registerURL = "http://localhost:54321/api/user/register"
    
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
            alertMessage("Error: Empty text fields", alertMessage: "Please fill out all text fields when registering.")
        } else if (passwordField.text != confirmPasswordField.text) {
            alertMessage("Error: Passwords do not match", alertMessage: "Please ensure your passwords match.")
        } else {
            checkRequest()
        }
    }
    
    func checkRequest() {
        let manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Content-Type":"application/json"
        ]
        let parameters = ["email": emailField.text as! AnyObject,
                          "password": passwordField.text as! AnyObject
        ]
        print(parameters)
        
        Alamofire.request(
            .POST,
            registerURL,
            parameters: parameters,
            encoding: .JSON).validate().responseJSON { [weak self] serverResponse in
              
                switch serverResponse.response!.statusCode {
                case 200:
                    self!.successMessage("Registered " + self!.emailField.text!, alertMessage: "Tap OK to continue.")
                    self!.moveToMainView()
                    break
                case 400:
                    self!.alertMessage("Bad Credentials", alertMessage: "Please enter a valid email address and a password that has at least 8 alphanumeric characters")
                    break
                case 409:
                    self!.alertMessage("Email already in use", alertMessage: "Please choose a new email or contact the admin.")
                    break
                default: break
                }
        }
    }
    
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
    
    func moveToMainView(){
        var storyboard = UIStoryboard(name: "Itinerary", bundle: nil)
        var controller = storyboard.instantiateViewControllerWithIdentifier("InitialController") as UIViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
}