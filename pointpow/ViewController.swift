//
//  ViewController.swift
//  pointpow
//
//  Created by thanawat on 30/10/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    @IBOutlet weak var textfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        textfield.delegate = self
       
        self.showIntroduce(false)
    }
    @IBAction func facebookTapped(_ sender: Any) {
        
    }
    @IBAction func googleTapped(_ sender: Any) {
        
    }
    @IBAction func cameraTapped(_ sender: Any) {
        self.showScanBarcode { (resultCode, code) in
        }
    }
    @IBAction func passcodeTapped(_ sender: Any) {
    }
    @IBAction func passcode2Tapped(_ sender: Any) {
    }
}

