//
//  WithDrawResultNav.swift
//  pointpow
//
//  Created by thanawat on 20/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class WithDrawResultNav: BaseNavigationViewController {

    var callbackFinish:(()->Void)?
    
    var transactionId:String?

    var hideFinishButton:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
}
