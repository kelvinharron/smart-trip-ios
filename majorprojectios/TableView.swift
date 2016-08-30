//
//  TableView.swift
//  majorprojectios
//
//  Created by Kelvin Harron on 30/08/2016.
//  Copyright © 2016 Kelvin Harron. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TableView: UITableViewController {
    
    @IBOutlet var jsonTable: UITableView!
    let datas: [JSON] = []
    let itineraryURL = "http://localhost:54321/api/itinerary/"
    var tableCity = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromServer()
    }
    
   
    
    func getDataFromServer(){
        Alamofire.request(
            .GET,
            itineraryURL).validate().responseJSON { (response) -> Void in
                let myVar = JSON(response.result.value!)
                var varryJSON = myVar["tripName"].stringValue
                
                switch response.result {
                case .Success(let response):
                    print(response)
                    print(varryJSON)
                    break
                case .Failure(let error):
                    print(error)
                    break
                }
                
        }
    }
}