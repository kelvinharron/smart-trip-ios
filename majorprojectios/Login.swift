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
            let alert = UIAlertController(title: "Oops!", message:"Please enter a valid email and password", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        } else {
            checkRequest()
        }
        
    }
    
    func checkRequest(){
        let manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Content-Type":"application/x-www-form-urlencoded" ]
        
        let parameters = ["email": emailField.text as! AnyObject,
                          "password": passwordField.text as! AnyObject ]
        
        Alamofire.request(
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
}