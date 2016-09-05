//
//  Login.swift
//  majorprojectios
//
//  Created by Kelvin Harron on 29/08/2016.
//  Copyright © 2016 Kelvin Harron. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Login: UIViewController {
    
    let loginURL = "http://localhost:54321/api/user/login"
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginButton(sender: AnyObject) {
        checkLogin()
    }
    
    func checkLogin() {
        if (emailField.text!.isEmpty) || (passwordField.text!.isEmpty) {
            alertMessage("Empty Fields", alertMessage: "Please fill out your email and password.")
        } else {
            checkRequest()
        }
    }
    
    func checkRequest(){
        
        let alamoManager = Manager.sharedInstance
        alamoManager.session.configuration.HTTPAdditionalHeaders = [
            "Content-Type":"application/json" ]
        
        let parameters = ["email": emailField.text as! AnyObject,
                          "password": passwordField.text as! AnyObject ]
        
        alamoManager.request(
            .POST,
            loginURL,
            parameters: parameters,
            encoding: .JSON).validate().responseJSON { [weak self] serverResponse in
                
                switch serverResponse.response!.statusCode {
                case 200:
                    self!.successMessage("Login Success! ", alertMessage: "Welcome " + self!.emailField.text!)
                    break
                case 400:
                    self!.alertMessage("Invalid Details", alertMessage: "Please enter a valid email and password")
                    break
                default: break
                }
        }
    }
    
    func moveToMainView(){
        var storyboard = UIStoryboard(name: "Itinerary", bundle: nil)
        var controller = storyboard.instantiateViewControllerWithIdentifier("InitialController") as UIViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func successMessage(alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Proceed", style: .Default, handler: { action in
            self.moveToMainView()}))
        self.presentViewController(alert, animated: true){}
        
    }
    
    func alertMessage(alertTitle: String, alertMessage: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        self.presentViewController(alert, animated: true){}
    }
}