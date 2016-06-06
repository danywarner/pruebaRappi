//
//  AppDetailVC.swift
//  pruebaRappi
//
//  Created by Daniel Warner on 2/4/16.
//  Copyright © 2016 Daniel Warner. All rights reserved.
//

import UIKit

class AppDetailVC: ElasticModalViewController {

    
    @IBOutlet weak var appNameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var sellerLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var copyrightLbl: UILabel!
    @IBOutlet weak var appImg: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    
    private var _application: Application?
    
    var application: Application {
        get {
            return _application!
        }
        set {
            _application = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appImg.layer.cornerRadius = appImg.frame.size.width / 2
        appImg.clipsToBounds = true
        appNameLbl.text = _application?.name
        descriptionLbl.text = _application?.summary
        categoryLbl.text = _application?.category
        sellerLbl.text = _application?.artist
        dateLbl.text = _application?.releaseDate
        copyrightLbl.text = _application?.rights
        
        if let priceData = (_application?.price?.doubleValue) {
            priceLbl.text = "$\(priceData) USD"
        }
        
        if let imgData = (_application?.image) {
            appImg.image = UIImage(data: imgData)
        }
        
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissFromLeft(sender as? UIView)
    }
}