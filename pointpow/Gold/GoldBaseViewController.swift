//
//  GoldMenuViewController.swift
//  pointpow
//
//  Created by thanawat on 4/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import SWRevealViewController
class GoldBaseViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if (self.revealViewController() != nil) {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.navigationItem.rightBarButtonItem?.target = revealViewController()
            self.navigationItem.rightBarButtonItem?.action = #selector(SWRevealViewController.rightRevealToggle(_:))
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
