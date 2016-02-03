//
//  Application.swift
//  
//
//  Created by Daniel Warner on 2/3/16.
//
//

import Foundation
import CoreData
import UIKit


class Application: NSManagedObject {

    func setAppImage(img:UIImage) {
        let data = UIImagePNGRepresentation(img)
        self.image = data
    }
    
    func getAppImage() -> UIImage {
        let img = UIImage(data: self.image!)!
        return img
    }
}
