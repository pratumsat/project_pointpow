//
//  ChangePasswordViewController.swift
//  pointpow
//
//  Created by thanawat on 13/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

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
    
    var errorOldPasswordLabel:UILabel?
    var errorNewPasswordLabel:UILabel?
    var errorConfirmNewPasswordLabel:UILabel?
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == self.passwordTextField {
            self.newPasswordTextField.becomeFirstResponder()
        }
        if textField == self.newPasswordTextField {
            self.confirmNewPasswordTextField.becomeFirstResponder()
        }
      
        
        return true
    }
    
    @IBAction func confirmTapped(_ sender: Any) {
        let old_password = self.passwordTextField.text!
        let new_password = self.newPasswordTextField.text!
        let confirm_new_password = self.confirmNewPasswordTextField.text!
        
        var errorEmpty = 0
        var emptyMessage = ""
        
        self.errorOldPasswordLabel?.removeFromSuperview()
        self.errorNewPasswordLabel?.removeFromSuperview()
        self.errorConfirmNewPasswordLabel?.removeFromSuperview()
        
        if confirm_new_password.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-confirm-pwd", comment: "")
            self.errorConfirmNewPasswordLabel =  self.confirmNewPasswordTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            errorEmpty += 1
            
        }
        if new_password.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-pwd", comment: "")
            self.errorNewPasswordLabel =  self.newPasswordTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            errorEmpty += 1
            
        }
        if old_password.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-old-pwd", comment: "")
            self.errorOldPasswordLabel =  self.passwordTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            errorEmpty += 1
            
        }
        
       
        if errorEmpty > 0 {
            self.showMessagePrompt(NSLocalizedString("string-error-empty-fill", comment: ""))
            return
        }
        
        if !validPassword(old_password) {
            self.errorOldPasswordLabel =  self.passwordTextField.addBottomLabelErrorMessage(NSLocalizedString("string-error-invalid-pwd", comment: ""), marginLeft: 0 )
            
            return
            
        }
        
        guard validatePassword(new_password, confirm_new_password) else { return }
        print(" matching password  ")
        
        
        let params:Parameters = ["old_password": old_password,
                                 "new_password" : new_password]

        self.modelCtrl.changePassword(params: params, succeeded: { (result) in
            print(result)
            
            self.showMessagePrompt2(NSLocalizedString("string-change-password-success", comment: ""), okCallback: {
                if let security = self.navigationController?.viewControllers[1] as? SecuritySettingViewController {
                    self.navigationController?.popToViewController(security, animated: false)
                }
            })

        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                print(mError)
                let message = mError["message"] as? String ?? ""

                self.handlerMessageError(message , title: "")
            }
        }, failure: { (messageError) in
            self.handlerMessageError(messageError , title: "")
        })
       
        
    }
    
    func validatePassword(_ password:String, _ confirmPassword:String) ->Bool{
        var errorPassowrd = 0
        var errorMessagePassword = ""
        if !validPassword(confirmPassword){
            errorMessagePassword = NSLocalizedString("string-error-invalid-confirm-pwd", comment: "")
            self.errorConfirmNewPasswordLabel =  self.confirmNewPasswordTextField.addBottomLabelErrorMessage(errorMessagePassword, marginLeft: 0 )
            errorPassowrd += 1
        }
        if !validPassword(password) {
            errorMessagePassword = NSLocalizedString("string-error-invalid-pwd", comment: "")
            self.errorNewPasswordLabel =  self.newPasswordTextField.addBottomLabelErrorMessage(errorMessagePassword, marginLeft: 0 )
            errorPassowrd += 1
        }
        if errorPassowrd > 0 {
            self.showMessagePrompt(errorMessagePassword)
            return false
        }
        
        if password != confirmPassword {
            let errorMissmatch = NSLocalizedString("string-error-mismatch-pwd", comment: "")
            self.showMessagePrompt(errorMissmatch)
            self.errorConfirmNewPasswordLabel =  self.confirmNewPasswordTextField.addBottomLabelErrorMessage(errorMissmatch, marginLeft: 0 )
            
            return false
        }
        
        
        return true
    }
}
