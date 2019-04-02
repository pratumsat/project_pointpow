//
//  GoldEditPenddingViewController.swift
//  pointpow
//
//  Created by thanawat on 2/4/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class GoldEditPenddingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("title-gold-pendding-verify", comment: "")
        self.backgroundImage?.image = nil
        
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            (self.navigationController as? GoldEditPenddingNav)?.dismissCallback?()
        })
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
