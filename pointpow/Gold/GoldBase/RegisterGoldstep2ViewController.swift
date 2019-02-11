//
//  RegisterGoldstep2ViewController.swift
//  pointpow
//
//  Created by thanawat on 11/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class RegisterGoldstep2ViewController: BaseViewController {
    @IBOutlet weak var step1Label: UILabel!
    @IBOutlet weak var step2Label: UILabel!
    @IBOutlet weak var step3Label: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()
    }
    func setUp(){
        self.backgroundImage?.image = nil
        //self.checkBok.isChecked = true
    }

    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        
        self.nextButton.borderClearProperties(borderWidth: 1 , radius : 5)
        self.nextButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        self.step1Label.ovalColorClearProperties()
        self.step2Label.ovalColorClearProperties()
        self.step3Label.ovalColorClearProperties()
        
    }
    
    @IBAction func nextStepTapped(_ sender: Any) {
        
        self.showRegisterGoldStep3Saving(true)
    }
}
