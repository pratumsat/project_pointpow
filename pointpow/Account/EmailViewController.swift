//
//  EmailViewController.swift
//  pointpow
//
//  Created by thanawat on 13/12/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class EmailViewController: BaseViewController {

    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    var clearImageView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-profile-change-email", comment: "")
        self.setUp()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.confirmButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    
    
    func setUp(){
        self.emailTextField.text = "Lazy@gmail.com"
        
        self.backgroundImage?.image = nil
        
        self.confirmButton.borderClearProperties(borderWidth: 1)
      
        
        self.emailTextField.delegate = self
        
        self.emailTextField.autocorrectionType = .no
        
        self.clearImageView = self.emailTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearNameTapped))
        self.clearImageView?.isUserInteractionEnabled = true
        self.clearImageView?.addGestureRecognizer(tap)
        self.clearImageView?.isHidden = true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
  
        
        if textField  == self.emailTextField {
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //return newLength <= 20
            
            if newLength == 0 {
                self.clearImageView?.isHidden = true
            }else{
                self.clearImageView?.isHidden = false
            }
        }
        
        return true
        
    }
    @objc func clearNameTapped(){
        self.clearImageView?.animationTapped({
            self.emailTextField.text = ""
            self.clearImageView?.isHidden = true
        })
    }
    
    
    @IBAction func confirmTapped(_ sender: Any) {
    }
}
