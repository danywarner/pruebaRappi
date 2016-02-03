//
//  ViewController.swift
//  pruebaRappi
//
//  Created by Daniel Warner on 2/3/16.
//  Copyright © 2016 Daniel Warner. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Alamofire.request(.GET, "https://itunes.apple.com/us/rss/topfreeapplications/limit=20/json")
            .responseJSON { response in
               
            
                
                if let dict = response.result.value as? Dictionary<String, AnyObject> {
                    
                    if let feed = dict["feed"] as? Dictionary<String, AnyObject> {
                        if let entries = feed["entry"] as? Array<AnyObject> {
                            for var x = 0 ; x < entries.count ; x++ {
                                if let entry = entries[x]["im:name"]  {
                                    if let name = entry!["label"] as? String{
                                        print(name)
                                    }
                                }
                            }
                        }
                    }
                }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

