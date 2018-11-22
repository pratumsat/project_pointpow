//
//  ResetPasswordViewController.swift
//  pointpow
//
//  Created by thanawat on 22/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class ResetPasswordViewController: BaseViewController {
    
    @IBOutlet weak var confirmButton: UIButton!
   
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
   

    var eyeConfirmImageView:UIImageView?
    var eyeNewPassImageView:UIImageView?
   
    var comfirmIsClose:Bool = false
    var newPsssIsClose:Bool = false
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("string-title-resetpassword", comment: "")
        self.setUp()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.confirmButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        self.confirmButton.borderClearProperties(borderWidth: 1)
        
      
        self.newPasswordTextField.autocorrectionType = .no
        self.confirmNewPasswordTextField.autocorrectionType = .no
        
       
        self.newPasswordTextField.delegate = self
        self.confirmNewPasswordTextField.delegate = self
        
        
        
        self.newPasswordTextField.isSecureTextEntry = true
        self.confirmNewPasswordTextField.isSecureTextEntry = true
        
        
        if #available(iOS 10.0, *) {
            self.newPasswordTextField.textContentType = UITextContentType(rawValue: "")
            self.confirmNewPasswordTextField.textContentType = UITextContentType(rawValue:"")
        }
        if #available(iOS 12.0, *) {
            self.newPasswordTextField.textContentType = .oneTimeCode
            self.confirmNewPasswordTextField.textContentType = .oneTimeCode
        }
        
        
        self.eyeNewPassImageView = self.newPasswordTextField.addRightButton(UIImage(named: "ic-eye-close")!)
        let eyeNewPassTap = UITapGestureRecognizer(target: self, action: #selector(eyeNewPassTapped))
        self.eyeNewPassImageView?.isUserInteractionEnabled = true
        self.eyeNewPassImageView?.addGestureRecognizer(eyeNewPassTap)
        
        self.eyeConfirmImageView = self.confirmNewPasswordTextField.addRightButton(UIImage(named: "ic-eye-close")!)
        let eyeConfirmTap = UITapGestureRecognizer(target: self, action: #selector(eyeConfirmTapped))
        self.eyeConfirmImageView?.isUserInteractionEnabled = true
        self.eyeConfirmImageView?.addGestureRecognizer(eyeConfirmTap)
        
        
    }
    
    @objc func eyeNewPassTapped(){
        self.self.newPsssIsClose = toggleEye(self.eyeNewPassImageView!,
                                             textfield: self.newPasswordTextField,
                                             status: self.newPsssIsClose)
    }
    @objc func eyeConfirmTapped(){
        self.self.comfirmIsClose = toggleEye(self.eyeConfirmImageView!,
                                             textfield: self.confirmNewPasswordTextField,
                                             status: self.comfirmIsClose)
    }
    func toggleEye(_ imageView:UIImageView, textfield:UITextField, status:Bool) -> Bool{
        imageView.alpha = 0
        if status {
            UIView.animate(withDuration: 0.1) {
                imageView.alpha = 1
                imageView.image = UIImage(named: "ic-eye-close")
                textfield.isSecureTextEntry = true
            }
            
            return false
        }else{
            UIView.animate(withDuration: 0.1) {
                imageView.alpha = 1
                imageView.image = UIImage(named: "ic-eye")
                textfield.isSecureTextEntry = false
            }
            
            return true
        }
    }
    @IBAction func confirmTapped(_ sender: Any) {
        self.showMessagePrompt(NSLocalizedString("string-reset-password-success", comment: ""))
    }
}
