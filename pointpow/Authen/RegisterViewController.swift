//
//  RegisterViewController.swift
//  pointpow
//
//  Created by thanawat on 2/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {

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
        
        
        
        if #available(iOS 10.0, *) {
            self.usernameTextField.textContentType = UITextContentType(rawValue: "")
            self.passwordTextField.textContentType = UITextContentType(rawValue: "")
            self.confirmPasswordTextField.textContentType = UITextContentType(rawValue: "")
        }
        if #available(iOS 12.0, *) {
            self.usernameTextField.textContentType = .oneTimeCode
            self.passwordTextField.textContentType = .oneTimeCode
            self.confirmPasswordTextField.textContentType = .oneTimeCode
        }
        
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
    
    @IBAction func registerTapped(_ sender: Any) {
        self.showVerify(true)
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
