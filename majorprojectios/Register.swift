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
            encoding: .JSON).validate().responseJSON { [weak self] response in
              
                switch response.response!.statusCode {
                case 200:
                    self!.alertMessage("Registered " + self!.emailField.text!, alertMessage: "Tap OK to continue.")
                    break
                case 401:
                    self!.alertMessage("Email already in use", alertMessage: "Please choose a new email or contact the admin.")
                default: break
                }
        }
    }
    
    func alertMessage(alertTitle: String, alertMessage: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        self.presentViewController(alert, animated: true){}
    }
}