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
            let alert = UIAlertController(title: "Invalid", message:"Please complete all fields", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        } else if (passwordField.text != confirmPasswordField.text) {
            let alert = UIAlertController(title:"Invalid", message:"Passwords must match", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        } else {
            checkRequest()
        }
    }
    
    func checkRequest() {
        let manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Content-Type":"application/x-www-form-urlencoded"
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
                
                switch response.result {
                case .Success(let response):
                    print(response)
                    break
                case .Failure(let error):
                    print(error)
                }
        }
    }
}