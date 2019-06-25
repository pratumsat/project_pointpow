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

        self.addSearchView()
        self.addCategoryView()
        
        self.searchCallback = { (keyword) in
            print("ketyword: \(keyword)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

   

}
