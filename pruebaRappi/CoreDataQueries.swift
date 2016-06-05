//
//  CoreDataQueries.swift
//  pruebaRappi
//
//  Created by Daniel Warner on 6/5/16.
//  Copyright © 2016 Daniel Warner. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataQueries {
    
    class func createCategory(name: String) -> Category {
        
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let entity = NSEntityDescription.entityForName("Category", inManagedObjectContext: context)!
        let category = Category(entity: entity, insertIntoManagedObjectContext: context)
        category.categoryName = name
        context.insertObject(category)
        
        do {
            try context.save()
        } catch {
            print("Could not save Category in context")
        }
        return category
    }
    
    class func createApplication(name: String, url: String, summary: String,amount: String,currency: String, rights: String,author: String,category: String, releaseDate: String) -> Application {
        
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
        context.insertObject(application)
        
        do {
            try context.save()
        } catch {
            print("Could not save Application in context")
        }
        return application
    }
    
    class func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
}