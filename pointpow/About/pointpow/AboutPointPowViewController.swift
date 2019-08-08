//
//  AboutPointPowViewController.swift
//  pointpow
//
//  Created by thanawat on 14/5/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class AboutPointPowViewController: BaseViewController {
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-item-about-pointpow", comment: "")
        self.backgroundImage?.image = nil
        
        let appVersion = DataController.sharedInstance.getVersion()
        self.versionLabel.text = "App version \(appVersion)"
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
