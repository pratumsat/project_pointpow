//
//  LoginMobileViewController.swift
//  pointpow
//
//  Created by thanawat on 2/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseMessaging

class LoginMobileViewController: LoginViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setUp(){
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
        
        
        self.usernameTextField.setLeftPaddingPoints(40)
        self.usernameTextField.delegate = self
        self.usernameTextField.autocorrectionType = .no
        self.usernameTextField.returnKeyType = .next
      
        
        self.clearImageView = self.usernameTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearUserNameTapped))
        self.clearImageView?.isUserInteractionEnabled = true
        self.clearImageView?.addGestureRecognizer(tap)
        self.clearImageView?.isHidden = true
        
        
    }
    
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
   
        
        
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
            return newLength <= 10
            
        }
        return true
        
    }
    @objc override func clearUserNameTapped(){
        self.clearImageView?.animationTapped({
            self.usernameTextField.text = ""
            self.clearImageView?.isHidden = true
        })
    }
    
    
    @IBAction override func loginTapped(_ sender: Any) {
        
        let username = self.usernameTextField.text!
        
        var errorEmpty = 0
        var emptyMessage = ""
        
        self.errorUsernamelLabel?.removeFromSuperview()
        
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
                                 "device_token": fcmToken,
                                 "app_os": "ios"]
        
        modelCtrl.loginWithEmailORMobile(params: params, succeeded: { (result) in
            if let mResult = result as? [String:AnyObject]{
                print(mResult)
                //let status = mResult["status"] as? String ?? ""
                let ref_id = mResult["ref_id"] as? String ?? ""
                //let is_pin = mResult["is_pin"] as? NSNumber ?? 0
                let request_id  = mResult["request_id"] as? String ?? ""
                
                
                DataController.sharedInstance.setRequestId(request_id)
                self.showVerify(mobile, ref_id,  true)
                
                
//                if status != "active" {
//                    DataController.sharedInstance.setRequestId(request_id)
//                    self.showVerify(mobile, ref_id, true)
//                    return
//                }
//
//                if !is_pin.boolValue {
//                    self.showSettingPassCodeModalView(NSLocalizedString("title-set-passcode", comment: ""), lockscreen: true)
//                    return
//                }
//
//                self.dismiss(animated: true, completion: {
//                    (self.navigationController as? IntroNav)?.callbackFinish?()
//                })
  
            }
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                print(mError)
                let message = mError["message"] as? String ?? ""
                let field = mError["field"] as? String ?? ""
                if field == "username" {
                    self.errorUsernamelLabel = self.usernameTextField.addBottomLabelErrorMessage(message, marginLeft: 15)
                }
                
                self.showMessagePrompt(message)
            }
        }, failure: { (messageError) in
            self.handlerMessageError(messageError , title: "")
        })
        
    }
    
    override func validateMobile(_ mobile:String)-> Bool{
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
        if nMobile == "0000000000" {
            errorMessage = NSLocalizedString("string-error-invalid-mobile", comment: "")
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
