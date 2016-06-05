//
//  CatCell.swift
//  pruebaRappi
//
//  Created by Daniel Warner on 2/3/16.
//  Copyright © 2016 Daniel Warner. All rights reserved.
//

import UIKit

class CatCell: UITableViewCell {

    @IBOutlet weak var catLabel: UILabel!
    
    func configureCell(category: Category) {
        catLabel.text = category.categoryName
    }

    override func awakeFromNib() {
        super.awakeFromNib()   
    }
}