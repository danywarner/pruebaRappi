//
//  ViewController.swift
//  pruebaRappi
//
//  Created by Daniel Warner on 2/3/16.
//  Copyright © 2016 Daniel Warner. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var apps = [Application]()
    
    func fetchAndSetResults() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Application")
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            self.apps = results as! [Application]
            print(apps.count)
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    
        
        
        fetchAndSetResults()
        
        if apps.count == 0 {
            print("no data")
            downloadData()
            
        }
        
        tableView.reloadData()
    }
    
    func downloadData() {
        Alamofire.request(.GET, "https://itunes.apple.com/us/rss/topfreeapplications/limit=20/json")
            .responseJSON { response in
                
                
                
                if let dict = response.result.value as? Dictionary<String, AnyObject> {
                    
                    if let feed = dict["feed"] as? Dictionary<String, AnyObject> {
                        if let entries = feed["entry"] as? Array<AnyObject> {
                            for var x = 0 ; x < entries.count ; x++ {
                                if let entry = entries[x]["im:name"]  {
                                    if let name = entry!["label"] as? String{
                                        
                                        self.createApplication(name)
                                    }
                                }
                            }
                        }
                    }
                }
        self.tableView.reloadData()
        }
        
    }
    
    func createApplication(name: String) {
       
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let entity = NSEntityDescription.entityForName("Application", inManagedObjectContext: context)!
        let application = Application(entity: entity, insertIntoManagedObjectContext: context)
        application.name = name
        apps.append(application)
        context.insertObject(application)
        
        do {
            try context.save()
        } catch {
            print("could not save Application")
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("AppCell") as? AppCell {
            
            let app = apps[indexPath.row]
            cell.configureCell(app)
            return cell
        } else {
            return AppCell()
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return apps.count
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

