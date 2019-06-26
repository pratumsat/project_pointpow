//
//  HomeShoppingViewController.swift
//  pointpow
//
//  Created by thanawat on 25/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class HomeShoppingViewController: ShoppingBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchView = self.addSearchView()
        self.addCategoryView(searchView)
        
        self.searchCallback = { (keyword) in
            print("ketyword: \(keyword)")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = NSLocalizedString("string-item-shopping", comment: "")
    }
    
    override func categoryTapped(sender: UITapGestureRecognizer) {
        //let tag = sender.view?.tag
        //print(tag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}
