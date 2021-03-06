//
//  ViewController.swift
//  pruebaRappi
//
//  Created by Daniel Warner on 2/3/16.
//  Copyright © 2016 Daniel Warner. All rights reserved.
//

import UIKit
import Alamofire

class AppViewController: ElasticModalViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var categoryLabeliPad: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collection: UICollectionView!
    private var _apps = [Application]()
    private var _category: Category?
    
    var apps: [Application] {
        get {
            return _apps
        }
        set {
            _apps = newValue
        }
    }
    
    var category: Category {
        get {
            return _category!
        }
        set {
            _category = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        collection.delegate = self
        collection.dataSource = self
        categoryLabeliPad.text = category.categoryName
        categoryLabel.text = category.categoryName
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apps.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105,105)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        let app = apps[indexPath.row]
        performSegueWithIdentifier("AppDetailVC", sender: app)
        
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
         let app = apps[indexPath.row]
        performSegueWithIdentifier("AppDetailVC", sender: app)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "AppDetailVC" {
            
            if let detailsVC = segue.destinationViewController as? AppDetailVC {
                
                if let app = sender as? Application {
                    
                    detailsVC.application = app
                }
            } 
        }
    }
    
    @IBAction func iPadBackBtnPressed(sender: AnyObject) {
        dismissFromLeft(sender as? UIView)
    }
    
    @IBAction func iPhoneBackButtonPressed(sender: AnyObject) {
        dismissFromLeft(sender as? UIView)
    }
}