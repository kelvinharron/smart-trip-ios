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
        moveToMainView()
        
        let alamoManager = Manager.sharedInstance
        alamoManager.session.configuration.HTTPAdditionalHeaders = [
            "Content-Type":"application/json" ]
        
        let parameters = ["email": emailField.text as! AnyObject,
                          "password": passwordField.text as! AnyObject ]
        
        alamoManager.request(
            .POST,
            loginURL,
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
    
    func moveToMainView(){
        var storyboard = UIStoryboard(name: "Itinerary", bundle: nil)
        var controller = storyboard.instantiateViewControllerWithIdentifier("InitialController") as UIViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func alertMessage(alertTitle: String, alertMessage: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        self.presentViewController(alert, animated: true){}
    }
}