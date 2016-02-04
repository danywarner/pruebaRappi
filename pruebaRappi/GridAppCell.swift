//
//  GridAppCell.swift
//  pruebaRappi
//
//  Created by Daniel Warner on 2/3/16.
//  Copyright © 2016 Daniel Warner. All rights reserved.
//

import UIKit
import Alamofire

class GridAppCell: UICollectionViewCell {
    
    @IBOutlet weak var appNameGrid: UILabel!
    @IBOutlet weak var appImgGrid: UIImageView!
    
    func configureCell(app: Application) {
        appNameGrid.text = app.name
        
        Alamofire.request(.GET, app.imageUrl!).response(completionHandler: {
            request, response, data, err in
            
            if err == nil {
                let img = UIImage(data: data!)!
                self.appImgGrid.image = img
                app.image = data
            }
        })
    }
    
   
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
}
