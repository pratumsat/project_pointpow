//
//  FilterShoppingViewController.swift
//  pointpow
//
//  Created by thanawat on 1/8/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class FilterShoppingViewController: BaseViewController {

    
    @IBOutlet weak var statusContainView: UIView!
    @IBOutlet weak var serviceContainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-filter-shopping-transection", comment: "")
        self.backgroundImage?.image = nil
        self.setUp()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.statusContainView.borderDarkGrayColorProperties(borderWidth: 1, radius: 10)
        self.serviceContainView.borderDarkGrayColorProperties(borderWidth: 1, radius: 10)
    }
    
    
    func setUp(){
        
    }
}
