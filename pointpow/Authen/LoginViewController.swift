//
//  LoginViewController.swift
//  pointpow
//
//  Created by thanawat on 2/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

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
        
        
        if #available(iOS 10.0, *) {
            self.usernameTextField.textContentType = UITextContentType(rawValue: "")
            self.passwordTextField.textContentType = UITextContentType(rawValue: "")
        }
        if #available(iOS 12.0, *) {
            self.usernameTextField.textContentType = .oneTimeCode
            self.passwordTextField.textContentType = .oneTimeCode
        }
        self.usernameTextField.setLeftPaddingPoints(40)
        self.passwordTextField.setLeftPaddingPoints(40)
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.usernameTextField.autocorrectionType = .no
        self.passwordTextField.autocorrectionType = .no
        self.passwordTextField.isSecureTextEntry = true
        
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
        self.clearImageView?.alpha = 0
        UIView.animate(withDuration: 0.1) {
            self.clearImageView?.alpha = 1
            self.usernameTextField.text = ""
            self.clearImageView?.isHidden = true
        }
        
    }
    @objc func eyeTapped(){
        self.eyeImageView?.alpha = 0
        UIView.animate(withDuration: 0.1) {
            self.eyeImageView?.alpha = 1
            
            if self.isClose {
                self.isClose = false
                self.eyeImageView?.image = UIImage(named: "ic-eye-close")
                self.passwordTextField.isSecureTextEntry = true
            }else{
                self.isClose = true
                self.eyeImageView?.image = UIImage(named: "ic-eye")
                self.passwordTextField.isSecureTextEntry = false
                
            }
        }
    }
    
    @objc func forgotTapped(){
        self.showForgot(true)
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
