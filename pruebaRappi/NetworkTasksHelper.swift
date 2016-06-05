//
//  NetworkTasksHelper.swift
//  pruebaRappi
//
//  Created by Daniel Warner on 6/5/16.
//  Copyright © 2016 Daniel Warner. All rights reserved.
//

import Foundation
import Alamofire
import SwiftOverlays
import SwiftyJSON

class NetworkTasksHelper {
    
    static var controller = CatViewController()
    
    class func downloadData(controller: UIViewController) {
        
        self.controller = controller as! CatViewController
        Alamofire.request(.GET, "https://itunes.apple.com/us/rss/topfreeapplications/limit=20/json")
            .responseJSON { response in
                self.updateModel(response)
                controller.removeAllOverlays()
        }
    }
    
    class func updateModel(response: Response<AnyObject, NSError>) {
        
        if let dict = response.result.value as? Dictionary<String, AnyObject> {
            
            let json = JSON(dict)
            let entries = json["feed"]["entry"]
            
            for entry in entries.arrayValue  {
                
                let name = entry["im:name"]["label"].stringValue
                
                let url = entry["im:image"][2]["label"].stringValue
                
                let summary = entry["summary"]["label"].stringValue
                
                let priceAttributes = entry["im:price"]["attributes"]
                let amount = (priceAttributes["amount"].stringValue)
                let currency = (priceAttributes["currency"].stringValue)
                
                let dateAttributes = entry["im:releaseDate"]["attributes"]
                let releaseDate = (dateAttributes["label"].stringValue)
                
                let rights = entry["rights"]["label"].stringValue
                
                let author = entry["im:artist"]["label"].stringValue
                
                let categoryAttributes = entry["category"]["attributes"]
                let category = (categoryAttributes["label"].stringValue)
                
                if !controller.categoriesTextArray.contains(category) {
                    controller.categoriesTextArray.append(category)
                    let newCategory = CoreDataQueries.createCategory(category)
                    controller.categoriesArray.append(newCategory)
                }
                
                let newApplication = CoreDataQueries.createApplication(name,url: url, summary: summary, amount: amount, currency: currency, rights: rights, author: author,category: category,releaseDate: releaseDate)
                controller.apps.append(newApplication)
            }
            controller.tableView.reloadData()
        }
    }
    
    
    
}
