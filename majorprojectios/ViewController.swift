//
//  ViewController.swift
//  majorprojectios
//
//  Created by Kelvin Harron on 29/08/2016.
//  Copyright © 2016 Kelvin Harron. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController {
    
    @IBOutlet weak var serverStatus: UILabel!
    let statusURL = "http://localhost:54321/status"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkServerStatus()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkServerStatus(){
        Alamofire.request(
            .GET,
            statusURL).validate().responseJSON { response in
                
                switch response.result {
                case .Success(let response):
                    print(response)
                    self.serverStatus.text = "Online"
                    self.serverStatus.textColor = UIColor.greenColor()
                    break
                case .Failure(let error):
                    print(error)
                    self.serverStatus.text = "Offline"
                    self.serverStatus.textColor = UIColor.redColor()
                    break
                }
        }
    }
}
