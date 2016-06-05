//
//  CatViewController.swift
//  pruebaRappi
//
//  Created by Daniel Warner on 2/3/16.
//  Copyright © 2016 Daniel Warner. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import SwiftyJSON

class CatViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var apps = [Application]()
    private var categoriesArray = [Category]()
    private var categoriesTextArray = [String]()
    private var transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchAndSetResults()
        
        if apps.count == 0 {
            downloadData()
        }
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("CatCell") as? CatCell {
            
            let cat = categoriesArray[indexPath.row]
            cell.configureCell(cat)
            return cell
            
        } else {
            return CatCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        var cat: Category!
        cat = categoriesArray[indexPath.row]
        performSegueWithIdentifier("MenuVC", sender: cat)
    }
    
    func filterApps(category: String) -> Array<Application> {
        
        var filteredAppsArray = [Application]()
        for i in 0  ..< apps.count  {
            
            let app = apps[i]
            if app.category == category {
                
                filteredAppsArray.append(app)
            }
        }
        return filteredAppsArray
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MenuVC" {
            
            if let menuVC = segue.destinationViewController as? ViewController {
                
                if let category = sender as? Category {
                    
                    let catName = category.categoryName
                    let filteredApps = filterApps(catName!)
                    menuVC.category = category
                    menuVC.apps = filteredApps
                }
                menuVC.transitioningDelegate = self.transitionManager
            }
        }
    }
    
    
    func fetchAndSetResults() {
        
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let fetchRequest1 = NSFetchRequest(entityName: "Application")
        let fetchRequest2 = NSFetchRequest(entityName: "Category")
        
        do {
            let results = try context.executeFetchRequest(fetchRequest1)
            self.apps = results as! [Application]
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        do {
            let results = try context.executeFetchRequest(fetchRequest2)
            self.categoriesArray = results as! [Category]
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func updateModel(response: Response<AnyObject, NSError>) {
        
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
                
                if !self.categoriesTextArray.contains(category) {
                    self.categoriesTextArray.append(category)
                    self.createCategory(category)
                }
                
                self.createApplication(name,url: url, summary: summary, amount: amount, currency: currency, rights: rights, author: author,category: category,releaseDate: releaseDate)
            }
        }
    }
    
    func downloadData() {
        
        Alamofire.request(.GET, "https://itunes.apple.com/us/rss/topfreeapplications/limit=20/json")
            .responseJSON { response in
                self.updateModel(response)
        }
    }
    
    func createCategory(name: String) {
        
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let entity = NSEntityDescription.entityForName("Category", inManagedObjectContext: context)!
        let category = Category(entity: entity, insertIntoManagedObjectContext: context)
        category.categoryName = name
        categoriesArray.append(category)
        context.insertObject(category)
        
        do {
            try context.save()
        } catch {
            print("Could not save Category in context")
        }
    }
    
    func createApplication(name: String, url: String, summary: String,amount: String,currency: String, rights: String,author: String,category: String, releaseDate: String) {
        
        let number = Double(amount)
        let price = NSNumber(double: number!)
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let entity = NSEntityDescription.entityForName("Application", inManagedObjectContext: context)!
        let application = Application(entity: entity, insertIntoManagedObjectContext: context)
        
        application.name = name
        application.imageUrl = url
        application.summary = summary
        application.price = price
        application.rights = rights
        application.artist = author
        application.category = category
        application.releaseDate = releaseDate
        apps.append(application)
        context.insertObject(application)
        
        do {
            try context.save()
        } catch {
            print("Could not save Application in context")
        }
    }
}