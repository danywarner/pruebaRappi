//
//  Application+CoreDataProperties.swift
//  
//
//  Created by Daniel Warner on 2/3/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Application {

    @NSManaged var image: NSData?
    @NSManaged var category: String?
    @NSManaged var artist: String?
    @NSManaged var name: String?
    @NSManaged var price: NSNumber?
    @NSManaged var releaseDate: String?
    @NSManaged var rights: String?
    @NSManaged var summary: String?

}
