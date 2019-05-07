//
//  RegisterViewController.swift
//  pointpow
//
//  Created by thanawat on 2/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseMessaging

class RegisterViewController: BaseViewController {

    @IBOutlet weak var infomationlabel: UILabel!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var checkBox: CheckBox!
    var clearImageView:UIImageView?
    var eyeImageView:UIImageView?
    var confirmEyeImageView:UIImageView?
    var confirmPsssIsClose:Bool = false
    var psssIsClose:Bool = false
    
    var errorUsernamelLabel:UILabel?
    var errorPasswordLabel:UILabel?
    var errorConfirmPasswordLabel:UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-register", comment: "")
        self.setUp()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //self.registerButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    
    func setUp(){
        //self.registerButton.borderClearProperties(borderWidth: 1)
        
        
    
        
        self.usernameTextField.setLeftPaddingPoints(40)
        self.passwordTextField.setLeftPaddingPoints(40)
        self.confirmPasswordTextField.setLeftPaddingPoints(40)
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        
        self.usernameTextField.autocorrectionType = .no
        self.passwordTextField.autocorrectionType = .no
        self.confirmPasswordTextField.autocorrectionType = .no
        
        self.passwordTextField.isSecureTextEntry = true
        self.confirmPasswordTextField.isSecureTextEntry = true
        
        
        self.usernameTextField.returnKeyType = .next
        self.passwordTextField.returnKeyType = .next
        self.confirmPasswordTextField.returnKeyType = .done
        
        self.clearImageView = self.usernameTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearUserNameTapped))
        self.clearImageView?.isUserInteractionEnabled = true
        self.clearImageView?.addGestureRecognizer(tap)
        self.clearImageView?.isHidden = true
        
        self.eyeImageView = self.passwordTextField.addRightButton(UIImage(named: "ic-eye-close")!)
        let eyeTap = UITapGestureRecognizer(target: self, action: #selector(eyeTapped))
        self.eyeImageView?.isUserInteractionEnabled = true
        self.eyeImageView?.addGestureRecognizer(eyeTap)
        
        self.confirmEyeImageView = self.confirmPasswordTextField.addRightButton(UIImage(named: "ic-eye-close")!)
        let confirmEyeTap = UITapGestureRecognizer(target: self, action: #selector(confirmEyeTapped))
        self.confirmEyeImageView?.isUserInteractionEnabled = true
        self.confirmEyeImageView?.addGestureRecognizer(confirmEyeTap)
        
        
        let term = UITapGestureRecognizer(target: self, action: #selector(termTapped))
        self.termLabel.isUserInteractionEnabled =  true
        self.termLabel.addGestureRecognizer(term)
        
        
        self.checkBox.toggle  = { (isCheck) in
            self.validateData()
        }
        self.checkBox.isChecked = false
    }
    
    
    @objc func termTapped(){
        print("term and conftion")
    }
    
    func validateData(){
        if self.checkBox.isChecked {
            self.enableButton()
        }else{
            self.disableButton()
        }
    }
    func enableButton(){
        if let count = self.registerButton?.layer.sublayers?.count {
            if count > 1 {
                self.registerButton?.layer.sublayers?.removeFirst()
            }
        }
        
        
        self.registerButton?.borderClearProperties(borderWidth: 1)
        self.registerButton?.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        self.registerButton?.isEnabled = true
    }
    func disableButton(){
        if let count = self.registerButton?.layer.sublayers?.count {
            if count > 1 {
                self.registerButton?.layer.sublayers?.removeFirst()
            }
        }
        
        
        
        self.registerButton?.borderClearProperties(borderWidth: 1)
        self.registerButton?.applyGradient(colours: [UIColor.lightGray, UIColor.lightGray])
        
        self.registerButton?.isEnabled = false
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
            //Mobile
            let text = textField.text ?? ""
            
            if string.count == 0 {
                textField.text = String(text.dropLast()).chunkFormatted()
            }  else {
                let newText = String((text + string).filter({ $0 != "-" }).prefix(10))
                textField.text = newText.chunkFormatted()
            }
            return false
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
        self.psssIsClose = toggleEye(self.eyeImageView!,
                                                 textfield: self.passwordTextField,
                                                 status: self.psssIsClose)
    }
    @objc func confirmEyeTapped(){
        self.confirmPsssIsClose = toggleEye(self.confirmEyeImageView!,
                                     textfield: self.confirmPasswordTextField,
                                     status: self.confirmPsssIsClose)
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == self.usernameTextField {
            self.passwordTextField.becomeFirstResponder()
        }
        if textField == self.passwordTextField {
            self.confirmPasswordTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        guard  self.checkBox.isChecked  else {
            showMessagePrompt(NSLocalizedString("string-message-alert-please-check-box", comment: ""))
            return
        }
        
        let username = self.usernameTextField.text!
        let password = self.passwordTextField.text!
        let confirmPassword = self.confirmPasswordTextField.text!
        
        var errorEmpty = 0
        var emptyMessage = ""
        
        self.errorUsernamelLabel?.removeFromSuperview()
        self.errorPasswordLabel?.removeFromSuperview()
        self.errorConfirmPasswordLabel?.removeFromSuperview()
        self.infomationlabel.isHidden = false
       
        if confirmPassword.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-confirm-pwd", comment: "")
            self.errorConfirmPasswordLabel =  self.confirmPasswordTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 15 )
            errorEmpty += 1
        }
        
        if password.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-pwd", comment: "")
            self.infomationlabel.isHidden = true
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
        
        
        guard validateMobile(username) else { return }
        guard validatePassword(password, confirmPassword) else { return }
        print("pass")
        
        let mobile = username.replace(target: "-", withString: "")
        let fcmToken = Messaging.messaging().fcmToken ?? ""
        let params:Parameters = ["mobile" : mobile,
                                 "password": password,
                                 "device_token": fcmToken,
                                 "app_os": "ios"]
        
        modelCtrl.registerWithMobile(params: params, succeeded: { (result) in
            if let mResult = result as? [String:AnyObject]{
                print(mResult)
                let ref_id = mResult["ref_id"] as? String ?? ""
               
                self.showVerify(mobile, ref_id,  true)
            }
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                print(mError)
                if let mError = error as? [String:AnyObject]{
                    print(mError)
                    let message = mError["message"] as? String ?? ""
                    let _ = mError["field"] as? String ?? ""
                    
                    self.errorUsernamelLabel =  self.usernameTextField.addBottomLabelErrorMessage(message, marginLeft: 15 )
                    self.showMessagePrompt(message)
                }
            }
        }, failure: { (messageError) in
            self.handlerMessageError(messageError , title: "")
        })
        
    }
    
    func validateMobile(_ mobile:String)-> Bool{
        var errorMobile = 0
        var errorMessage = ""
       
        let nMobile = mobile.replace(target: "-", withString: "")
        if !checkPrefixcellPhone(nMobile) {
            errorMessage = NSLocalizedString("string-error-invalid-mobile", comment: "")
            errorMobile += 1
        }
        if nMobile.count < 10 {
            errorMessage = NSLocalizedString("string-error-invalid-mobile1", comment: "")
            errorMobile += 1
        }
        if nMobile.count > 10 {
            errorMessage = NSLocalizedString("string-error-invalid-mobile2", comment: "")
            errorMobile += 1
        }
        if errorMobile > 0 { 
            self.showMessagePrompt(errorMessage)
            self.errorUsernamelLabel =  self.usernameTextField.addBottomLabelErrorMessage(errorMessage , marginLeft: 15)
            return false
        }
        return true
    }
    func validatePassword(_ password:String, _ confirmPassword:String) ->Bool{
        var errorPassowrd = 0
        var errorMessagePassword = ""
        
        if !validPassword(password) {
            errorMessagePassword = NSLocalizedString("string-error-invalid-pwd", comment: "")
            self.infomationlabel.isHidden = true
            self.errorPasswordLabel =  self.passwordTextField.addBottomLabelErrorMessage(errorMessagePassword, marginLeft: 15 )
            errorPassowrd += 1
        }
        if errorPassowrd > 0 {
            self.showMessagePrompt(errorMessagePassword)
            return false
        }
        
        if password != confirmPassword {
            let errorMissmatch = NSLocalizedString("string-error-mismatch-pwd", comment: "")
            self.showMessagePrompt(errorMissmatch)
            self.errorConfirmPasswordLabel =  self.confirmPasswordTextField.addBottomLabelErrorMessage(errorMissmatch, marginLeft: 15 )
            
            return false
        }
        
        
        return true
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
