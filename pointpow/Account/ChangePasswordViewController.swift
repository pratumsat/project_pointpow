//
//  ChangePasswordViewController.swift
//  pointpow
//
//  Created by thanawat on 13/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    var eyeConfirmImageView:UIImageView?
    var eyeNewPassImageView:UIImageView?
    var currentPassImageView:UIImageView?
    var comfirmIsClose:Bool = false
    var newPsssIsClose:Bool = false
    var currentPsssIsClose:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-changepassword", comment: "")
        self.setUp()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.confirmButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        self.confirmButton.borderClearProperties(borderWidth: 1)
        
        self.passwordTextField.autocorrectionType = .no
        self.newPasswordTextField.autocorrectionType = .no
        self.confirmNewPasswordTextField.autocorrectionType = .no
        
        self.passwordTextField.delegate = self
        self.newPasswordTextField.delegate = self
        self.confirmNewPasswordTextField.delegate = self
        
        
        self.passwordTextField.isSecureTextEntry = true
        self.newPasswordTextField.isSecureTextEntry = true
        self.confirmNewPasswordTextField.isSecureTextEntry = true
        
        
        if #available(iOS 10.0, *) {
            self.passwordTextField.textContentType = UITextContentType(rawValue:"")
            self.newPasswordTextField.textContentType = UITextContentType(rawValue: "")
            self.confirmNewPasswordTextField.textContentType = UITextContentType(rawValue:"")
        }
        if #available(iOS 12.0, *) {
            self.passwordTextField.textContentType = .oneTimeCode
            self.newPasswordTextField.textContentType = .oneTimeCode
            self.confirmNewPasswordTextField.textContentType = .oneTimeCode
        }
        
        self.currentPassImageView = self.passwordTextField.addRightButton(UIImage(named: "ic-eye-close")!)
        let eyeCurrentTap = UITapGestureRecognizer(target: self, action: #selector(eyeCurrentPassTapped))
        self.currentPassImageView?.isUserInteractionEnabled = true
        self.currentPassImageView?.addGestureRecognizer(eyeCurrentTap)
        
        self.eyeNewPassImageView = self.newPasswordTextField.addRightButton(UIImage(named: "ic-eye-close")!)
        let eyeNewPassTap = UITapGestureRecognizer(target: self, action: #selector(eyeNewPassTapped))
        self.eyeNewPassImageView?.isUserInteractionEnabled = true
        self.eyeNewPassImageView?.addGestureRecognizer(eyeNewPassTap)
        
        self.eyeConfirmImageView = self.confirmNewPasswordTextField.addRightButton(UIImage(named: "ic-eye-close")!)
        let eyeConfirmTap = UITapGestureRecognizer(target: self, action: #selector(eyeConfirmTapped))
        self.eyeConfirmImageView?.isUserInteractionEnabled = true
        self.eyeConfirmImageView?.addGestureRecognizer(eyeConfirmTap)
        
        
    }
    @objc func eyeCurrentPassTapped(){
        
        self.self.currentPsssIsClose = toggleEye(self.currentPassImageView!,
                                                 textfield: self.passwordTextField,
                                                 status: self.currentPsssIsClose)
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
       
        if status {
            imageView.animationTapped {
                imageView.image = UIImage(named: "ic-eye-close")
                textfield.isSecureTextEntry = true
            }
            
            return false
        }else{
            imageView.animationTapped {
                imageView.image = UIImage(named: "ic-eye")
                textfield.isSecureTextEntry = false
            }
            return true
        }
    }
    @IBAction func confirmTapped(_ sender: Any) {
    }
}
