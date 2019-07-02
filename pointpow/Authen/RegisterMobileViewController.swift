//
//  RegisterMobileViewController.swift
//  pointpow
//
//  Created by thanawat on 2/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseMessaging

class RegisterMobileViewController: RegisterViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setUp(){
        //self.registerButton.borderClearProperties(borderWidth: 1)
        
        self.usernameTextField.setLeftPaddingPoints(40)
        self.usernameTextField.delegate = self
        
        self.usernameTextField.autocorrectionType = .no
        self.usernameTextField.returnKeyType = .next
        
        self.clearImageView = self.usernameTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearUserNameTapped))
        self.clearImageView?.isUserInteractionEnabled = true
        self.clearImageView?.addGestureRecognizer(tap)
        self.clearImageView?.isHidden = true
        
        
        let term = UITapGestureRecognizer(target: self, action: #selector(termTapped))
        self.termLabel.isUserInteractionEnabled =  true
        self.termLabel.addGestureRecognizer(term)
        
        
        self.checkBox.toggle  = { (isCheck) in
            self.validateData()
        }
        self.checkBox.isChecked = false
    }
    
    
    @objc override func termTapped(){
        print("term and conftion")
        self.showTermAndConPointPow(true)
    }
    
    override func validateData(){
        if self.checkBox.isChecked {
            self.enableButton()
        }else{
            self.disableButton()
        }
    }
    override func enableButton(){
        if let count = self.registerButton?.layer.sublayers?.count {
            if count > 1 {
                self.registerButton?.layer.sublayers?.removeFirst()
            }
        }
        
        
        self.registerButton?.borderClearProperties(borderWidth: 1)
        self.registerButton?.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        self.registerButton?.isEnabled = true
    }
    override func disableButton(){
        if let count = self.registerButton?.layer.sublayers?.count {
            if count > 1 {
                self.registerButton?.layer.sublayers?.removeFirst()
            }
        }
        
        
        self.registerButton?.borderClearProperties(borderWidth: 1)
        self.registerButton?.applyGradient(colours: [UIColor.lightGray, UIColor.lightGray])
        
        self.registerButton?.isEnabled = false
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
            
            //Mobile
            //let text = textField.text ?? ""
            
            //            if string.count == 0 {
            //                textField.text = String(text.dropLast()).chunkFormatted()
            //            }  else {
            //                let newText = String((text + string).filter({ $0 != "-" }).prefix(10))
            //                textField.text = newText.chunkFormatted()
            //            }
            //            return false
        }
        return true
        
    }
    @objc override func clearUserNameTapped(){
        self.clearImageView?.animationTapped({
            self.usernameTextField.text = ""
            self.clearImageView?.isHidden = true
        })
        
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       
        
        return true
    }
    
    @IBAction override func registerTapped(_ sender: Any) {
        guard  self.checkBox.isChecked  else {
            showMessagePrompt(NSLocalizedString("string-message-alert-please-check-box", comment: ""))
            return
        }
        
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
       
        print("pass")
        
        let mobile = username.replace(target: "-", withString: "")
        let fcmToken = Messaging.messaging().fcmToken ?? ""
        let params:Parameters = ["mobile" : mobile,
                                 "device_token": fcmToken,
                                 "app_os": "ios"]
        
        modelCtrl.registerWithMobile(params: params, succeeded: { (result) in
            if let mResult = result as? [String:AnyObject]{
                print(mResult)
                let ref_id = mResult["ref_id"] as? String ?? ""
                let request_id  = mResult["request_id"] as? String ?? ""
                DataController.sharedInstance.setRequestId(request_id)
                
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
        if errorMobile > 0 {
            self.showMessagePrompt(errorMessage)
            self.errorUsernamelLabel =  self.usernameTextField.addBottomLabelErrorMessage(errorMessage , marginLeft: 15)
            return false
        }
        return true
    }
   

}
