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
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(app: Application) {
        appName.text = app.name
        appPrice.text = "$\(app.price!) USD"
        
        Alamofire.request(.GET, app.imageUrl!).response(completionHandler: {
            request, response, data, err in
            
            if err == nil {
                let img = UIImage(data: data!)!
                self.appImg.image = img
                // app.image = img
            }
        })    }

}
