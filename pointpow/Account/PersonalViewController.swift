//
//  PersonalViewController.swift
//  pointpow
//
//  Created by thanawat on 12/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class PersonalViewController: BaseViewController {

    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var parsonalTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    var clearImageView:UIImageView?
    var clearImageView2:UIImageView?
    var clearImageView3:UIImageView?
    
    
    var nextStep:(()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
        
    }
   
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.nextButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        
        self.nextButton.borderClearProperties(borderWidth: 1)
        
        if #available(iOS 10.0, *) {
            self.firstNameTextField.textContentType = UITextContentType(rawValue: "")
            self.lastNameTextField.textContentType = UITextContentType(rawValue: "")
            self.parsonalTextField.textContentType = UITextContentType(rawValue: "")
            self.birthdayTextField.textContentType = UITextContentType(rawValue: "")
            self.mobileTextField.textContentType = UITextContentType(rawValue: "")
            self.emailTextField.textContentType = UITextContentType(rawValue: "")
        }
        if #available(iOS 12.0, *) {
            self.firstNameTextField.textContentType = .oneTimeCode
            self.lastNameTextField.textContentType = .oneTimeCode
            self.parsonalTextField.textContentType = .oneTimeCode
            self.birthdayTextField.textContentType = .oneTimeCode
            self.mobileTextField.textContentType = .oneTimeCode
            self.emailTextField.textContentType = .oneTimeCode
        }
        
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.parsonalTextField.delegate = self
        self.birthdayTextField.delegate = self
        self.mobileTextField.delegate = self
        self.emailTextField.delegate = self
        
        self.firstNameTextField.autocorrectionType = .no
        self.lastNameTextField.autocorrectionType = .no
        self.parsonalTextField.autocorrectionType = .no
        self.birthdayTextField.autocorrectionType = .no
        self.mobileTextField.autocorrectionType = .no
        self.emailTextField.autocorrectionType = .no
        
        
        self.clearImageView = self.firstNameTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearFirstNameTapped))
        self.clearImageView?.isUserInteractionEnabled = true
        self.clearImageView?.addGestureRecognizer(tap)
        self.clearImageView?.isHidden = true
        
        self.clearImageView2 = self.lastNameTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(clearLastNameTapped))
        self.clearImageView2?.isUserInteractionEnabled = true
        self.clearImageView2?.addGestureRecognizer(tap2)
        self.clearImageView2?.isHidden = true
        
        self.clearImageView3 = self.parsonalTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(clearPersanalTapped))
        self.clearImageView3?.isUserInteractionEnabled = true
        self.clearImageView3?.addGestureRecognizer(tap3)
        self.clearImageView3?.isHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField  == self.firstNameTextField {
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
        if textField  == self.lastNameTextField {
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //return newLength <= 20
            
            if newLength == 0 {
                self.clearImageView2?.isHidden = true
            }else{
                self.clearImageView2?.isHidden = false
            }
        }
        if textField  == self.parsonalTextField {
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //return newLength <= 20
            
            if newLength == 0 {
                self.clearImageView3?.isHidden = true
            }else{
                self.clearImageView3?.isHidden = false
            }
        }
        return true
        
    }
    @objc func clearPersanalTapped(){
        self.clearImageView3?.alpha = 0
        UIView.animate(withDuration: 0.1) {
            self.clearImageView3?.alpha = 1
            self.parsonalTextField.text = ""
            self.clearImageView3?.isHidden = true
        }
    }
    @objc func clearFirstNameTapped(){
        self.clearImageView?.alpha = 0
        UIView.animate(withDuration: 0.1) {
            self.clearImageView?.alpha = 1
            self.firstNameTextField.text = ""
            self.clearImageView?.isHidden = true
        }
        
    }
    @objc func clearLastNameTapped(){
        self.clearImageView2?.alpha = 0
        UIView.animate(withDuration: 0.1) {
            self.clearImageView2?.alpha = 1
            self.lastNameTextField.text = ""
            self.clearImageView2?.isHidden = true
        }
        
    }
    

}
