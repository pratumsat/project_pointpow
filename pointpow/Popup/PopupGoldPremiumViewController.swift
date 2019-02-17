//
//  PopupGoldPremiumViewController.swift
//  pointpow
//
//  Created by thanawat on 17/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PopupGoldPremiumViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()
    }
    func setUp(){
        self.backgroundImage?.image = nil
    }
    override func dismissPoPup() {
        super.dismissPoPup()
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCloseBlackView()
    }

   

}
