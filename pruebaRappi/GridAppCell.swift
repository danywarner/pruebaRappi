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
        
        if let imageUrl = app.imageUrl {
            Alamofire.request(.GET, imageUrl).response(completionHandler: {
                request, response, data, err in
                
                if err == nil {
                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            self.appImgGrid.image = img
                            app.image = data
                        }
                    }
                }
            })
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}