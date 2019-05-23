//
//  LoginViewController.swift
//  pointpow
//
//  Created by thanawat on 2/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseMessaging

class LoginViewController: BaseViewController {

    
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
        self.hendleSetPasscodeSuccess = { (passcode, controller) in
            
            let message = NSLocalizedString("string-set-pincode-success", comment: "")
            let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: NSLocalizedString("string-button-ok", comment: ""), style: .cancel, handler: { (action) in
                
                controller.dismiss(animated: false, completion: { () in
                    //
                    self.dismiss(animated: false, completion: {
                        (self.navigationController as? IntroNav)?.callbackFinish?()
                    })
                })
            })
            alert.addAction(ok)
            alert.show()
        }
        
        self.loginButton.borderClearProperties(borderWidth: 1)
        
        let forgot = UITapGestureRecognizer(target: self, action: #selector(forgotTapped))
        self.forgotLabel.isUserInteractionEnabled = true
        self.forgotLabel.addGestureRecognizer(forgot)
        
       
        self.usernameTextField.setLeftPaddingPoints(40)
        self.passwordTextField.setLeftPaddingPoints(40)
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.usernameTextField.autocorrectionType = .no
        self.passwordTextField.autocorrectionType = .no
        self.passwordTextField.isSecureTextEntry = true
        
        self.usernameTextField.returnKeyType = .next
        self.passwordTextField.returnKeyType = .done
        
        self.clearImageView = self.usernameTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearUserNameTapped))
        self.clearImageView?.isUserInteractionEnabled = true
        self.clearImageView?.addGestureRecognizer(tap)
        self.clearImageView?.isHidden = true
        
        self.eyeImageView = self.passwordTextField.addRightButton(UIImage(named: "ic-eye-close")!)
        let eyeTap = UITapGestureRecognizer(target: self, action: #selector(eyeTapped))
        self.eyeImageView?.isUserInteractionEnabled = true
        self.eyeImageView?.addGestureRecognizer(eyeTap)
        
    }
    
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == self.usernameTextField {
            self.passwordTextField.becomeFirstResponder()
        }
        
        return true
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
      
        if password.trimmingCharacters(in: .whitespaces).isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-pwd", comment: "")
            self.errorPasswordLabel =  self.passwordTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 15 )
            errorEmpty += 1
        }
        
        if username.trimmingCharacters(in: .whitespaces).isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-username", comment: "")
            self.errorUsernamelLabel =  self.usernameTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 15 )
            errorEmpty += 1
            
        }
        if errorEmpty > 0 {
            self.showMessagePrompt(emptyMessage)
            return
        }

        guard validateMobile(username) else { return }
        
        let fcmToken = Messaging.messaging().fcmToken ?? ""
        let mobile = username.replace(target: "-", withString: "")
        let params:Parameters = ["mobile" : mobile,
                                 "password": password,
                                 "device_token": fcmToken,
                                 "app_os": "ios"]
        modelCtrl.loginWithEmailORMobile(params: params, succeeded: { (result) in
            if let mResult = result as? [String:AnyObject]{
                print(mResult)
                let status = mResult["status"] as? String ?? ""
                let ref_id = mResult["ref_id"] as? String ?? ""
                let is_pin = mResult["is_pin"] as? NSNumber ?? 0
                
                
                
                if status != "active" {
                    self.showVerify(mobile, ref_id, true)
                    return
                }
                
                if !is_pin.boolValue {
                    self.showSettingPassCodeModalView(NSLocalizedString("title-set-passcode", comment: ""), lockscreen: true)
                    return
                }
                
                
                self.dismiss(animated: true, completion: {
                    (self.navigationController as? IntroNav)?.callbackFinish?()
                })
                
                
                
            }
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                print(mError)
                let message = mError["message"] as? String ?? ""
                let field = mError["field"] as? String ?? ""
                if field == "username" {
                    self.errorUsernamelLabel = self.usernameTextField.addBottomLabelErrorMessage(message, marginLeft: 15)
                }else if field == "password"{
                    self.errorPasswordLabel =  self.passwordTextField.addBottomLabelErrorMessage(message, marginLeft: 15)
                }
                self.showMessagePrompt(message)
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
}
