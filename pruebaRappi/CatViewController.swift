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

class CatViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var apps = [Application]()
    var categoriesArray = [Category]()
    var categoriesTextArray = [String]()
    let transitionManager = TransitionManager()
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
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//    }
    
   
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        var cat: Category!
        
        cat = categoriesArray[indexPath.row]
        
        
        performSegueWithIdentifier("MenuVC", sender: cat)
    }
    
    func filterApps(category: String) -> Array<Application> {
        
        var filteredAppsArray = [Application]()
        for var i = 0 ; i < apps.count ; i++ {
            
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
    
    
    func downloadData() {
        
        var name = ""
        var url = ""
        var summary = ""
        var amount = ""
        var currency = ""
        var rights = ""
        var author = ""
        var category = ""
        var releaseDate = ""
        
        Alamofire.request(.GET, "https://itunes.apple.com/us/rss/topfreeapplications/limit=20/json")
            .responseJSON { response in
                
                if let dict = response.result.value as? Dictionary<String, AnyObject> {
                    
                    if let feed = dict["feed"] as? Dictionary<String, AnyObject> {
                        if let entries = feed["entry"] as? Array<AnyObject> {
                            for var x = 0 ; x < entries.count ; x++ {
                                let entryName = entries[x]["im:name"]
                                name = (entryName!!["label"] as? String)!
                                
                                if let entryImageUrls = entries[x]["im:image"] {
                                    
                                    let image = entryImageUrls![2]
                                    url = (image["label"] as? String)!
                                }
                                let entrySummary = entries[x]["summary"]
                                summary = (entrySummary!!["label"] as? String)!
                                
                                let entryPrice = entries[x]["im:price"]
                                let priceAttributes = (entryPrice!!["attributes"])!
                                amount = (priceAttributes!["amount"] as? String)!
                                currency = (priceAttributes!["currency"] as? String)!
                                
                                let entryDate = entries[x]["im:releaseDate"]
                                let dateAttributes = (entryDate!!["attributes"])!
                                releaseDate = (dateAttributes!["label"] as? String)!
                                
                                let entryRights = entries[x]["rights"]
                                rights = (entryRights!!["label"] as? String)!
                                
                                let entryArtist = entries[x]["im:artist"]
                                author = (entryArtist!!["label"] as? String)!
                                
                                let entryCategory = entries[x]["category"]
                                let categoryAttributes = (entryCategory!!["attributes"])!
                                category = (categoryAttributes!["label"] as? String)!
                                if !self.categoriesTextArray.contains(category) {
                                    self.categoriesTextArray.append(category)
                                    self.createCategory(category)
                                }
                                
                                
                                
                                
                                self.createApplication(name,url: url, summary: summary, amount: amount, currency: currency, rights: rights, author: author,category: category,releaseDate: releaseDate)
                            }
                        }
                    }
                }
                //self.downloadImages()
                //self.collection.reloadData()
                self.tableView.reloadData()
                
        }// response
        
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
            print("could not save Category")
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
            print("could not save Application")
        }
    }
    
    

   
}
