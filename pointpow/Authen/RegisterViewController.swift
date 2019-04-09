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
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
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
        self.registerButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    
    func setUp(){
        self.registerButton.borderClearProperties(borderWidth: 1)
        
        
    
        
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
        
        if isValidNumber(username){
            print("number")
            
            guard validateMobile(username) else { return }
            guard validatePassword(password, confirmPassword) else { return }
            print("pass")
            
            
            let fcmToken = Messaging.messaging().fcmToken ?? ""
            let params:Parameters = ["mobile" : username,
                                     "password": password,
                                     "device_token": fcmToken,
                                     "app_os": "ios"]
            
            modelCtrl.registerWithMobile(params: params, succeeded: { (result) in
                if let mResult = result as? [String:AnyObject]{
                    print(mResult)
                    let ref_id = mResult["ref_id"] as? String ?? ""
                    let member_id = mResult["member_id"] as? NSNumber ?? 0
                    self.showVerify(username, ref_id, member_id.stringValue, true)
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
            
            
            return
        }
        
        if isValidEmail(username) {
            print("email")
            guard validatePassword(password, confirmPassword) else { return }
            print("pass")
            
            let fcmToken = Messaging.messaging().fcmToken ?? ""
            let params:Parameters = ["email" : username,
                                     "password": password,
                                     "device_token": fcmToken,
                                     "app_os": "ios"]
            modelCtrl.registerWithEmail(params: params, succeeded: { (result) in
                if let mResult = result as? [String:AnyObject]{
                    print(mResult)
                    
                    let message = NSLocalizedString("string-verify-password-send-email", comment: "")
                    let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                    let ok = UIAlertAction(title: NSLocalizedString("string-button-ok", comment: ""), style: .cancel, handler: { (action) in
                        
                        self.showLogin(true)
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)

                    
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
