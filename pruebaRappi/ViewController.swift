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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collection: UICollectionView!
    var apps = [Application]()
    var categoriesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        collection.delegate = self
        collection.dataSource = self
        
        
        fetchAndSetResults()
        
        if apps.count == 0 {
            downloadData()
        }
        collection.reloadData()
        tableView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GridAppCell", forIndexPath: indexPath) as? GridAppCell {
            
            let app = apps[indexPath.row]
            cell.configureCell(app)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apps.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105,105)
    }
    
    func fetchAndSetResults() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Application")
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            self.apps = results as! [Application]
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func uniq<S: SequenceType, E: Hashable where E==S.Generator.Element>(source: S) -> [E] {
        var seen: [E:Bool] = [:]
        return source.filter { seen.updateValue(true, forKey: $0) == nil }
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
                                
                                let entryRights = entries[x]["rights"]
                                    rights = (entryRights!!["label"] as? String)!
                                
                                let entryArtist = entries[x]["im:artist"]
                                author = (entryArtist!!["label"] as? String)!
                                
                                let entryCategory = entries[x]["category"]
                                let categoryAttributes = (entryCategory!!["attributes"])!
                                category = (categoryAttributes!["label"] as? String)!
                                self.categoriesArray.append(category)
                                
                                let entryDate = entries[x]["im:releaseDate"]
                                releaseDate = (entryDate!!["label"] as? String)!

                                self.createApplication(name,url: url, summary: summary, amount: amount, currency: currency, rights: rights, author: author,category: category,releaseDate: releaseDate)
                            }
                        }
                    }
                }
        //self.downloadImages()
        self.collection.reloadData()
        self.tableView.reloadData()
                
        }// response
        
    }
    
//    func downloadImages() {
//        
//        for var x = 0 ; x < apps.count ; x++ {
//            
//        }
//        
//    }
    
    func createApplication(name: String, url: String, summary: String,amount: String,currency: String, rights: String,author: String,category: String, releaseDate: String) {
        
        let number = Double(amount)
        
        let price = NSNumber(double: number!)
        print(price)
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

