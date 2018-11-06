//
//  VerifyViewController.swift
//  pointpow
//
//  Created by thanawat on 5/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class VerifyViewController: BaseViewController {
    @IBOutlet weak var verifyButton: UIButton!
   
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var clearImageView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("string-title-verify", comment: "")
        self.setUp()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.verifyButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    func setUp(){
        self.sendButton.borderRedColorProperties(borderWidth: 1)  
        self.verifyButton.borderClearProperties(borderWidth: 1)
        
        
        if #available(iOS 10.0, *) {
            self.usernameTextField.textContentType = UITextContentType(rawValue: "")
            self.otpTextField.textContentType = UITextContentType(rawValue: "")
        }
        if #available(iOS 12.0, *) {
            self.usernameTextField.textContentType = .oneTimeCode
            self.otpTextField.textContentType = .oneTimeCode
        }
        self.usernameTextField.setLeftPaddingPoints(40)
        self.otpTextField.setLeftPaddingPoints(40)
        
        self.usernameTextField.delegate = self
        self.otpTextField.delegate = self
        
        self.otpTextField.autocorrectionType = .no
        self.usernameTextField.autocorrectionType = .no
        

        self.clearImageView = self.usernameTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearUserNameTapped))
        self.clearImageView?.isUserInteractionEnabled = true
        self.clearImageView?.addGestureRecognizer(tap)
        self.clearImageView?.isHidden = true
    }
    
    @objc func clearUserNameTapped(){
        self.clearImageView?.alpha = 0
        UIView.animate(withDuration: 0.1) {
            self.clearImageView?.alpha = 1
            self.usernameTextField.text = ""
            self.clearImageView?.isHidden = true
        }
        
    }
    
   
    @IBAction func sendTapped(_ sender: Any) {
    }
    @IBAction func verifyTapped(_ sender: Any) {
    }
    
   

}
