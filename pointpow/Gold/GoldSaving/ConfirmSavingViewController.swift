//
//  ConfirmSavingViewController.swift
//  pointpow
//
//  Created by thanawat on 6/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ConfirmSavingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title =  "Confirm Saving Page"
        self.setUp()
    }
    func setUp(){
        self.backgroundImage?.image = nil
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
