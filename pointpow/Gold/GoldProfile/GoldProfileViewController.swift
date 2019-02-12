//
//  GoldProfileViewController.swift
//  pointpow
//
//  Created by thanawat on 4/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class GoldProfileViewController: GoldBaseViewController {

  
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-profile", comment: "")
        self.setUp()
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
       
    }

    
   

}
