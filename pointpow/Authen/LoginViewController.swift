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
        
        
        let gTap = UITapGestureRecognizer(target: self, action: #selector(googleTapped))
        self.googleView.isUserInteractionEnabled = true
        self.googleView.addGestureRecognizer(gTap)
        let fTap = UITapGestureRecognizer(target: self, action: #selector(facebookTapped))
        self.facebookView.isUserInteractionEnabled = true
        self.facebookView.addGestureRecognizer(fTap)
    }
    
    override func GoogleSigInSuccess(notification: NSNotification) {
        if let userInfo = notification.userInfo as? [String:AnyObject]{
            
            print(userInfo)
            
            let ggtoken = userInfo["idToken"] as? String ?? ""
            let email = userInfo["email"] as? String ?? ""
            let first_name = userInfo["givenName"] as? String ?? ""
            let last_name = userInfo["familyName"] as? String ?? ""
            let fcmToken = Messaging.messaging().fcmToken ?? ""
            
            let params:Parameters = ["email" : email,
                                     "firstname": first_name,
                                     "lastname" : last_name,
                                     "social_token" : ggtoken,
                                     "device_token": fcmToken,
                                     "app_os": "ios"]
            
            self.modelCtrl.loginWithSocial(params: params, succeeded: { (result) in
                if let mResult = result as? [String:AnyObject]{
                    print(mResult)
                    let dupicate = mResult["exist_email"] as? NSNumber ?? 0
                    if dupicate.boolValue {
                        self.isExist = true
                    }else{
                        self.isExist = false
                    }
                    self.socialLoginSucces = true
                }
            }, error: { (error) in
                if let mError = error as? [String:AnyObject]{
                    print(mError)
                }
            }, failure: { (messageError) in
                self.handlerMessageError(messageError , title: "")
            })
            
        }
    }
    override var socialLoginSucces: Bool?{
        didSet{
            print("success")
            if isExist {
                self.dismiss(animated: true, completion: nil)
            }else{
                self.showRegisterSuccessPopup(true) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            
        }
    }
    @objc func googleTapped(){
        self.loginGoogle()
    }
    
    @objc func facebookTapped(){
        self.loginFacebook()
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
            
            let fcmToken = Messaging.messaging().fcmToken ?? ""
            let params:Parameters = ["mobile" : username,
                                     "password": password,
                                     "device_token": fcmToken,
                                     "app_os": "ios"]
            modelCtrl.loginWithEmailORMobile(params: params, succeeded: { (result) in
                if let mResult = result as? [String:AnyObject]{
                    print(mResult)
                    
                    self.dismiss(animated: true, completion: nil)
                    
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
            
            return
        }
        
        if isValidEmail(username) {
            print("email")
         
            let fcmToken = Messaging.messaging().fcmToken ?? ""
            let params:Parameters = ["email" : username,
                                     "password": password,
                                     "device_token": fcmToken,
                                     "app_os": "ios"]
            modelCtrl.loginWithEmailORMobile(params: params, succeeded: { (result) in
                if let mResult = result as? [String:AnyObject]{
                    print(mResult)
                    
                    self.dismiss(animated: true, completion: nil)
                    
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
            
            
        }else{
           
            print("not email")
            
            let emailNotValid = NSLocalizedString("string-error-invalid-email", comment: "")
            self.showMessagePrompt(emailNotValid)
            self.errorUsernamelLabel =  self.usernameTextField.addBottomLabelErrorMessage(emailNotValid, marginLeft: 15 )

            
        }
    }
   
    func validateMobile(_ mobile:String)-> Bool{
        var errorMobile = 0
        var errorMessage = ""
        
        if !checkPrefixcellPhone(mobile) {
            errorMessage = NSLocalizedString("string-error-invalid-mobile", comment: "")
            errorMobile += 1
        }
        if mobile.count < 10 {
            errorMessage = NSLocalizedString("string-error-invalid-mobile1", comment: "")
            errorMobile += 1
        }
        if mobile.count > 10 {
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
