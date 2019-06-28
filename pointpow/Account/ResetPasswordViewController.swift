//
//  ResetPasswordViewController.swift
//  pointpow
//
//  Created by thanawat on 22/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class ResetPasswordViewController: BaseViewController {
    
    @IBOutlet weak var confirmButton: UIButton!
   
    
    @IBOutlet weak var infomationlabel: UILabel!
    
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
   

    var eyeConfirmImageView:UIImageView?
    var eyeNewPassImageView:UIImageView?
   
    var comfirmIsClose:Bool = false
    var newPsssIsClose:Bool = false
   
    var errorPasswordLabel:UILabel?
    var errorConfirmPasswordLabel:UILabel?
    
    var forgotPassword:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("string-title-resetpassword", comment: "")
       
        if !forgotPassword {
            let cancelButton = UIBarButtonItem(title: NSLocalizedString("string-title-cancel-reset-pwd", comment: ""), style: .plain, target: self, action: #selector(cancelTapped))
            cancelButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                                 NSAttributedString.Key.font :  UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.ITEM_TITLE )!]
                , for: .normal)
            
            
            self.navigationItem.leftBarButtonItem = cancelButton
        }
        
        
        
        self.setUp()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.confirmButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        self.confirmButton.borderClearProperties(borderWidth: 1)
        
      
        self.newPasswordTextField.autocorrectionType = .no
        self.confirmNewPasswordTextField.autocorrectionType = .no
        
       
        self.newPasswordTextField.delegate = self
        self.confirmNewPasswordTextField.delegate = self
        
        
        
        self.newPasswordTextField.isSecureTextEntry = true
        self.confirmNewPasswordTextField.isSecureTextEntry = true
        
        
       
        
        
        self.eyeNewPassImageView = self.newPasswordTextField.addRightButton(UIImage(named: "ic-eye-close")!)
        let eyeNewPassTap = UITapGestureRecognizer(target: self, action: #selector(eyeNewPassTapped))
        self.eyeNewPassImageView?.isUserInteractionEnabled = true
        self.eyeNewPassImageView?.addGestureRecognizer(eyeNewPassTap)
        
        self.eyeConfirmImageView = self.confirmNewPasswordTextField.addRightButton(UIImage(named: "ic-eye-close")!)
        let eyeConfirmTap = UITapGestureRecognizer(target: self, action: #selector(eyeConfirmTapped))
        self.eyeConfirmImageView?.isUserInteractionEnabled = true
        self.eyeConfirmImageView?.addGestureRecognizer(eyeConfirmTap)
        
        
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
        
        if textField == self.newPasswordTextField {
            self.confirmNewPasswordTextField.becomeFirstResponder()
        }
       
        
        return true
    }
    @IBAction func confirmTapped(_ sender: Any) {
        let password = self.newPasswordTextField.text!
        let confirmPassword = self.confirmNewPasswordTextField.text!
        
        var errorEmpty = 0
        var emptyMessage = ""
        
        self.errorPasswordLabel?.removeFromSuperview()
        self.errorConfirmPasswordLabel?.removeFromSuperview()
        self.infomationlabel.isHidden = false
        
        if confirmPassword.trimmingCharacters(in: .whitespaces).isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-confirm-pwd", comment: "")
            self.errorConfirmPasswordLabel =  self.confirmNewPasswordTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            errorEmpty += 1
        }
        
        if password.trimmingCharacters(in: .whitespaces).isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-pwd", comment: "")
            self.errorPasswordLabel =  self.newPasswordTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            self.infomationlabel.isHidden = true
            errorEmpty += 1
        }
        
        if errorEmpty > 0 {
            self.showMessagePrompt(emptyMessage)
            return
        }
        guard validatePassword(password, confirmPassword) else { return }
        
        let reset_token = DataController.sharedInstance.getResetPasswordToken()
        let params:Parameters = ["reset_token" : reset_token,
                                 "new_password" : password]
        
        modelCtrl.setPassword(params: params, succeeded: { (result) in
            DataController.sharedInstance.setResetPasswordToken("")
            
            let message = NSLocalizedString("string-reset-password-success", comment: "")
            let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: NSLocalizedString("string-button-ok", comment: ""), style: .cancel, handler: { (action) in
                
                if self.forgotPassword {
                    if let loginVC = self.navigationController?.viewControllers[1] as? LoginViewController {
                        self.navigationController?.popToViewController(loginVC, animated: false)
                    }
                    
                }else{
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)

            
        }, error: { (error) in
           if let mError = error as? [String:AnyObject]{
                print(mError)
                let message = mError["message"] as? String ?? ""
                self.AlertMessageDialogOK(message , title: "")
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
            self.infomationlabel.isHidden = true
            self.errorConfirmPasswordLabel =  self.confirmNewPasswordTextField.addBottomLabelErrorMessage(errorMessagePassword, marginLeft: 0 )
            errorPassowrd += 1
        }
        if !validPassword(password) {
            errorMessagePassword = NSLocalizedString("string-error-invalid-pwd", comment: "")
            self.errorPasswordLabel =  self.newPasswordTextField.addBottomLabelErrorMessage(errorMessagePassword, marginLeft: 0 )
            errorPassowrd += 1
        }
        if errorPassowrd > 0 {
            self.showMessagePrompt(errorMessagePassword)
            return false
        }
        
        if password != confirmPassword {
            let errorMissmatch = NSLocalizedString("string-error-mismatch-pwd", comment: "")
            self.showMessagePrompt(errorMissmatch)
            self.errorConfirmPasswordLabel =  self.confirmNewPasswordTextField.addBottomLabelErrorMessage(errorMissmatch, marginLeft: 0 )
            
            return false
        }
        
        
        return true
    }
    
}
