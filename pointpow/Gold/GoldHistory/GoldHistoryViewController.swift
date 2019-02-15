//
//  GoldHistoryViewController.swift
//  pointpow
//
//  Created by thanawat on 7/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class GoldHistoryViewController: GoldBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func bViewTapped(_ sender: Any) {
        if let saving = self.storyboard?.instantiateViewController(withIdentifier: "GoldPageNav") as? UINavigationController {
            self.revealViewController()?.pushFrontViewController(saving, animated: true)
            
        }
    }


}
