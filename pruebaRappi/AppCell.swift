//
//  AppCell.swift
//  pruebaRappi
//
//  Created by Daniel Warner on 2/3/16.
//  Copyright © 2016 Daniel Warner. All rights reserved.
//

import UIKit
import Alamofire

class AppCell: UITableViewCell {

    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appImg: UIImageView!
    @IBOutlet weak var appPrice: UILabel!

    func configureCell(app: Application) {
        appName.text = app.name
        appPrice.text = "$\(app.price!) USD"
        
        Alamofire.request(.GET, app.imageUrl!).response(completionHandler: {
            request, response, data, err in
            
            if err == nil {
                if let img = UIImage(data: data!) {
                    self.appImg.image = img
                    self.appImg.layer.cornerRadius = self.appImg.frame.size.width / 2
                    self.appImg.clipsToBounds = true
                    app.image = data
                }
            }
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
