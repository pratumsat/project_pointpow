//
//  ForgotPasswordViewController.swift
//  pointpow
//
//  Created by thanawat on 2/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    var clearImageView:UIImageView?
    

    var errorUsernamelLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-forgotpassword", comment: "")
        
        self.setUp()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.resetButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    func setUp(){
        self.resetButton.borderClearProperties(borderWidth: 1)
        
        
        self.usernameTextField.setLeftPaddingPoints(40)
        
        self.usernameTextField.delegate = self
        self.usernameTextField.autocorrectionType = .no
        
        self.clearImageView = self.usernameTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearUserNameTapped))
        self.clearImageView?.isUserInteractionEnabled = true
        self.clearImageView?.addGestureRecognizer(tap)
        self.clearImageView?.isHidden = true
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
    
    @IBAction func resetTapped(_ sender: Any) {
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
        
        
        if isValidNumber(username){
            print("number")
            
            guard validateMobile(username) else { return }
            
           
            let params:Parameters = ["mobile" : username  ]
            
            modelCtrl.forgotPasswordMobile(params: params, succeeded: { (result) in
                if let mResult = result as? [String:AnyObject] {
                    let ref_id = mResult["ref_id"] as? String ?? ""
                    self.showVerify(username, ref_id, forgotPassword: true, true)
                }
                
                
//                let message = NSLocalizedString("string-reset-password-send-mobile", comment: "")
//                let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
//                let ok = UIAlertAction(title: NSLocalizedString("string-button-ok", comment: ""), style: .cancel, handler: { (action) in
//
//                    self.navigationController?.popViewController(animated: true)
//                })
//                alert.addAction(ok)
//                self.present(alert, animated: true, completion: nil)
                
            }, error: { (error) in
                if let mError = error as? [String:AnyObject]{
                    print(mError)
                    let message = mError["message"] as? String ?? ""
                    self.errorUsernamelLabel = self.usernameTextField.addBottomLabelErrorMessage(message, marginLeft: 15)
                    self.showMessagePrompt(message)
                }
            }, failure: { (messageError) in
                self.handlerMessageError(messageError , title: "")
            })
 
            
            
            return
        }
        
        if isValidEmail(username) {
            print("email")
           
            let params:Parameters = ["email" : username  ]
            
            modelCtrl.forgotPassword(params: params, succeeded: { (result) in

                let message = NSLocalizedString("string-reset-password-send-email", comment: "")
                let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                let ok = UIAlertAction(title: NSLocalizedString("string-button-ok", comment: ""), style: .cancel, handler: { (action) in
                    
                    self.navigationController?.popViewController(animated: true)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }, error: { (error) in
                if let mError = error as? [String:AnyObject]{
                    print(mError)
                    let message = mError["message"] as? String ?? ""
                    self.errorUsernamelLabel = self.usernameTextField.addBottomLabelErrorMessage(message, marginLeft: 15)
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
