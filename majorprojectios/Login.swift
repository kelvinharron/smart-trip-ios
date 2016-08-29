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
    
    let loginURL = "http://localhost:54321/api/user/"
    
    @IBOutlet weak var emailLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    
    @IBAction func loginButton(sender: AnyObject) {
        checkLogin()
    }
    
    func checkLogin(){
        handleError()
        
            }
    
    func checkRequest(){
        Alamofire.request(
            .POST,
            loginURL)
            .responseJSON { (response) -> Void in
            if ((response.result.value) != nil) {
                let email = JSON(response.result.value!)
            }
        }
    }
    
    func handleError() {
        if (emailLogin.text!.isEmpty) || (passwordLogin.text!.isEmpty) {
            let alert = UIAlertController(title: "Oops!", message:"Please enter a valid email and password", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        }

    }
}

