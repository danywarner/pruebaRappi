//
//  AppDetailVC.swift
//  pruebaRappi
//
//  Created by Daniel Warner on 2/4/16.
//  Copyright © 2016 Daniel Warner. All rights reserved.
//

import UIKit

class AppDetailVC: UIViewController {

    @IBOutlet weak var iPhoneAppNameLbl: UILabel!
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

        iPhoneAppNameLbl.text = _application?.name
    }


    @IBAction func iPhoneBackBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
