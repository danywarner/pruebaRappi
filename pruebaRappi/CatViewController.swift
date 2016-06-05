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
import SwiftOverlays


class CatViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var _apps = [Application]()
    private var _categoriesArray = [Category]()
    private var _categoriesTextArray = [String]()
    private var transitionManager = TransitionManager()
    private var reach: Reachability!
    
    var apps: [Application] {
        get {
            return _apps
        }
        set {
            _apps = newValue
        }
    }
    
    var categoriesArray: [Category] {
        get {
            return _categoriesArray
        }
        set {
            _categoriesArray = newValue
        }
    }
    
    var categoriesTextArray: [String] {
        get {
            return _categoriesTextArray
        }
        set {
            _categoriesTextArray = newValue
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchAndSetResults()
        
        reach = Reachability.reachabilityForInternetConnection()
        if reach.isReachable() {
            apps = [Application]()
            categoriesArray = [Category]()
            categoriesTextArray = [String]()
            self.showWaitOverlayWithText("cargando")
            NetworkTasksHelper.downloadData(self)
        }
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        reach = Reachability.reachabilityForInternetConnection()
        if !reach.isReachable() {
            let alert = UIAlertController(title: "Alerta!", message: "No hay conexión a Internet", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
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
            
            if let menuVC = segue.destinationViewController as? AppViewController {
                
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
}