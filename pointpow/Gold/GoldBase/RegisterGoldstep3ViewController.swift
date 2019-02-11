//
//  RegisterGoldstep3ViewController.swift
//  pointpow
//
//  Created by thanawat on 11/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class RegisterGoldstep3ViewController: BaseViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var step1Label: UILabel!
    @IBOutlet weak var step2Label: UILabel!
    @IBOutlet weak var step3Label: UILabel!
    
    
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
        
        self.registerButton.borderClearProperties(borderWidth: 1 , radius : 5)
        self.registerButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        self.step1Label.ovalColorClearProperties()
        self.step2Label.ovalColorClearProperties()
        self.step3Label.ovalColorClearProperties()
        
    }
    
    @IBAction func registerTapped(_ sender: Any) {
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
