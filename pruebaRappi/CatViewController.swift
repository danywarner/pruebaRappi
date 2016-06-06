//
//  CatViewController.swift
//  pruebaRappi
//
//  Created by Daniel Warner on 2/3/16.
//  Copyright © 2016 Daniel Warner. All rights reserved.
//

import UIKit
import SwiftOverlays


class CatViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var _apps = [Application]()
    private var _categoriesArray = [Category]()
    private var _categoriesTextArray = [String]()
    private var reach: Reachability!
    
    var transition = ElasticTransition()
    
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
        
        CoreDataQueries.fetchAndSetResults(self)
        
        reach = Reachability.reachabilityForInternetConnection()
        
        if reach.isReachable() {
            apps = [Application]()
            categoriesArray = [Category]()
            categoriesTextArray = [String]()
            CoreDataQueries.deleteAllData("Application")
            CoreDataQueries.deleteAllData("Category")
            self.showWaitOverlayWithText("cargando")
            NetworkTasksHelper.downloadData(self)
        }
        tableView.reloadData()
        
        transition.sticky = true
        transition.showShadow = true
        transition.panThreshold = 0.3
        transition.transformType = .TranslateMid
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
        var cat: Category
        cat = categoriesArray[indexPath.row]
        transition.edge = .Right
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
                    
                    if let catName = category.categoryName {
                        let filteredApps = filterApps(catName)
                        menuVC.category = category
                        menuVC.apps = filteredApps
                    }
                }
            }
        }
    }
}