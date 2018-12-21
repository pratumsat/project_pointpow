//
//  LoginViewController.swift
//  pointpow
//
//  Created by thanawat on 2/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var forgotLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    var clearImageView:UIImageView?
    var eyeImageView:UIImageView?
    var isClose:Bool = false
    
    var errorUsernamelLabel:UILabel?
    var errorPasswordLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-login", comment: "")
        self.setUp()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.loginButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
   
    func setUp(){
        self.loginButton.borderClearProperties(borderWidth: 1)
        
        let forgot = UITapGestureRecognizer(target: self, action: #selector(forgotTapped))
        self.forgotLabel.isUserInteractionEnabled = true
        self.forgotLabel.addGestureRecognizer(forgot)
        
        
        if #available(iOS 10.0, *) {
            self.usernameTextField.textContentType = UITextContentType(rawValue: "")
            self.passwordTextField.textContentType = UITextContentType(rawValue: "")
        }
        if #available(iOS 12.0, *) {
            self.usernameTextField.textContentType = .oneTimeCode
            self.passwordTextField.textContentType = .oneTimeCode
        }
        self.usernameTextField.setLeftPaddingPoints(40)
        self.passwordTextField.setLeftPaddingPoints(40)
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.usernameTextField.autocorrectionType = .no
        self.passwordTextField.autocorrectionType = .no
        self.passwordTextField.isSecureTextEntry = true
        
        self.clearImageView = self.usernameTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearUserNameTapped))
        self.clearImageView?.isUserInteractionEnabled = true
        self.clearImageView?.addGestureRecognizer(tap)
        self.clearImageView?.isHidden = true
        
        self.eyeImageView = self.passwordTextField.addRightButton(UIImage(named: "ic-eye-close")!)
        let eyeTap = UITapGestureRecognizer(target: self, action: #selector(eyeTapped))
        self.eyeImageView?.isUserInteractionEnabled = true
        self.eyeImageView?.addGestureRecognizer(eyeTap)
        
        
        let gTap = UITapGestureRecognizer(target: self, action: #selector(googleTapped))
        self.googleView.isUserInteractionEnabled = true
        self.googleView.addGestureRecognizer(gTap)
        let fTap = UITapGestureRecognizer(target: self, action: #selector(facebookTapped))
        self.facebookView.isUserInteractionEnabled = true
        self.facebookView.addGestureRecognizer(fTap)
    }
    
    
    @objc func googleTapped(){
        self.loginGoogle()
    }
    
    @objc func facebookTapped(){
        self.loginFacebook()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField  == self.usernameTextField {
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
    @objc func clearUserNameTapped(){
        self.clearImageView?.animationTapped({
            self.usernameTextField.text = ""
            self.clearImageView?.isHidden = true
        })
        
    }
    @objc func eyeTapped(){
        self.eyeImageView?.animationTapped({
            if self.isClose {
                self.isClose = false
                self.eyeImageView?.image = UIImage(named: "ic-eye-close")
                self.passwordTextField.isSecureTextEntry = true
            }else{
                self.isClose = true
                self.eyeImageView?.image = UIImage(named: "ic-eye")
                self.passwordTextField.isSecureTextEntry = false
                
            }
        })
    }
    
    @objc func forgotTapped(){
        self.showForgot(true)
    }

    
    @IBAction func loginTapped(_ sender: Any) {
    
        let username = self.usernameTextField.text!
        let password = self.passwordTextField.text!
        
        var errorEmpty = 0
        var emptyMessage = ""
        
        self.errorUsernamelLabel?.removeFromSuperview()
        self.errorPasswordLabel?.removeFromSuperview()
      
        if password.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-pwd", comment: "")
            self.errorPasswordLabel =  self.passwordTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 15 )
            errorEmpty += 1
        }
        
        if username.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-username", comment: "")
            self.errorUsernamelLabel =  self.usernameTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 15 )
            errorEmpty += 1
            
        }
        if errorEmpty > 0 {
            self.showMessagePrompt(emptyMessage)
            return
        }

       
        if isValidNumber(username){
            print("number")
            
            guard validateMobile(username) else { return }
            
            if password == "123456A" {
                self.dismiss(animated: true, completion: nil)
            }else{
                self.showMessagePrompt("ใส่รหัสผ่านไม่ถูกต้อง")
                self.errorPasswordLabel =  self.passwordTextField.addBottomLabelErrorMessage("ใส่รหัสผ่านไม่ถูกต้อง" , marginLeft: 15)
            }
            
            return
        }
        
        if isValidEmail(username) {
            print("email")
            
            if password == "123456A" {
                self.dismiss(animated: true, completion: nil)
            }else{
                self.showMessagePrompt("ใส่รหัสผ่านไม่ถูกต้อง")
                self.errorPasswordLabel =  self.passwordTextField.addBottomLabelErrorMessage("ใส่รหัสผ่านไม่ถูกต้อง" , marginLeft: 15)
            }
            
        }else{
           
            print("not email")
            
            let emailNotValid = NSLocalizedString("string-error-invalid-email", comment: "")
            self.showMessagePrompt(emailNotValid)
            self.errorUsernamelLabel =  self.usernameTextField.addBottomLabelErrorMessage(emailNotValid, marginLeft: 15 )

            
        }
    }
   
    func validateMobile(_ mobile:String)-> Bool{
        var errorMobile = 0
        if mobile.count != 10 {
            errorMobile += 1
        }
        if !checkPrefixcellPhone(mobile) {
            errorMobile += 1
        }
        if errorMobile > 0 {
            let errorMessage = NSLocalizedString("string-error-invalid-mobile", comment: "")
            self.showMessagePrompt(errorMessage)
            self.errorUsernamelLabel =  self.usernameTextField.addBottomLabelErrorMessage(errorMessage , marginLeft: 15)
            return false
        }
        return true
    }
}
