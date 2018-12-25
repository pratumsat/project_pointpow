//
//  PersonalPopupViewController.swift
//  pointpow
//
//  Created by thanawat on 6/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class PersonalPopupViewController: BaseViewController {

    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var optionTextField: UITextField!
    
    @IBOutlet weak var parsonalTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    
    var clearImageView:UIImageView?
    var clearImageView2:UIImageView?
    var clearImageView3:UIImageView?
    var clearImageView4:UIImageView?
    
    var nextStep:(()->Void)?
    
    
    var errorLastnamelLabel:UILabel?
    var errorFirstNameLabel:UILabel?
    var errorPersonalIDLabel:UILabel?
    var errorEmailLabel:UILabel?
    var errorMobileLabel:UILabel?
    
    var isMobileField:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()
        
    }
    override func dismissPoPup() {
        super.dismissPoPup()
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCloseBlackView()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.nextButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    
    func setUp(){
        
        self.isMobileField = true
        
        self.backgroundImage?.image = nil
        
        self.nextButton.borderClearProperties(borderWidth: 1)
        
        if #available(iOS 10.0, *) {
            self.firstNameTextField.textContentType = UITextContentType(rawValue: "")
            self.lastNameTextField.textContentType = UITextContentType(rawValue: "")
            self.parsonalTextField.textContentType = UITextContentType(rawValue: "")
          
            self.optionTextField.textContentType = UITextContentType(rawValue: "")
        }
        if #available(iOS 12.0, *) {
            self.firstNameTextField.textContentType = .oneTimeCode
            self.lastNameTextField.textContentType = .oneTimeCode
            self.parsonalTextField.textContentType = .oneTimeCode
         
            self.optionTextField.textContentType = .oneTimeCode
        }
       
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.parsonalTextField.delegate = self
        self.optionTextField.delegate = self
        
        self.firstNameTextField.autocorrectionType = .no
        self.lastNameTextField.autocorrectionType = .no
        self.parsonalTextField.autocorrectionType = .no
        self.optionTextField.autocorrectionType = .no
      
        if self.isMobileField {
            self.optionTextField.keyboardType = .numberPad
            self.optionLabel.text = NSLocalizedString("string-item-popup-profile-mobile", comment: "")
        }else{
            self.optionTextField.keyboardType = .emailAddress
            self.optionLabel.text = NSLocalizedString("string-item-popup-profile-email", comment: "")
        }
        
        
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
        
        self.clearImageView4 = self.optionTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(clearOptionalTapped))
        self.clearImageView4?.isUserInteractionEnabled = true
        self.clearImageView4?.addGestureRecognizer(tap4)
        self.clearImageView4?.isHidden = true
        
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
            
            //Mobile
            let text = textField.text ?? ""
            
            if string.count == 0 {
                textField.text = String(text.dropLast()).chunkFormattedPersonalID()
            }  else {
                let newText = String((text + string).filter({ $0 != "-" }).prefix(13))
                textField.text = newText.chunkFormattedPersonalID()
            }
            return false
            
        }
        if textField  == self.optionTextField {
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //return newLength <= 20
            
            if newLength == 0 {
                self.clearImageView4?.isHidden = true
            }else{
                self.clearImageView4?.isHidden = false
            }
            if self.isMobileField {
                //Mobile
                let text = textField.text ?? ""
                
                if string.count == 0 {
                    textField.text = String(text.dropLast()).chunkFormatted()
                }  else {
                    let newText = String((text + string).filter({ $0 != "-" }).prefix(10))
                    textField.text = newText.chunkFormatted()
                }
                return false
            }else{
                //Email
            }
            
        }
        return true
        
    }
    @objc func clearPersanalTapped(){
        self.clearImageView3?.animationTapped({
            self.parsonalTextField.text = ""
            self.clearImageView3?.isHidden = true
        })
    }
    @objc func clearFirstNameTapped(){
        self.clearImageView?.animationTapped({
            self.firstNameTextField.text = ""
            self.clearImageView?.isHidden = true
        })
    }
    @objc func clearLastNameTapped(){
        self.clearImageView2?.animationTapped({
            self.lastNameTextField.text = ""
            self.clearImageView2?.isHidden = true
        })
        
    }
    @objc func clearOptionalTapped(){
        self.clearImageView4?.animationTapped({
            self.optionTextField.text = ""
            self.clearImageView4?.isHidden = true
        })
        
    }
    @IBAction func nextTapped(_ sender: Any) {
        
        errorLastnamelLabel?.removeFromSuperview()
        errorFirstNameLabel?.removeFromSuperview()
        errorPersonalIDLabel?.removeFromSuperview()
        errorEmailLabel?.removeFromSuperview()
        errorMobileLabel?.removeFromSuperview()
        
        
        let firstName = self.firstNameTextField.text!
        let lastName = self.lastNameTextField.text!
        let personalID  = self.parsonalTextField.text!
        let optional = self.optionTextField.text!
        
        var errorEmpty = 0
        var emptyMessage = ""
        
        
        
        if optional.isEmpty {
            if self.isMobileField {
                emptyMessage = NSLocalizedString("string-error-empty-mobile", comment: "")
                self.errorMobileLabel =  self.optionTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            }else{
                emptyMessage = NSLocalizedString("string-error-empty-email", comment: "")
                self.errorEmailLabel =  self.optionTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            }
            errorEmpty += 1
            
        }
        if personalID.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-personal-id", comment: "")
            self.errorPersonalIDLabel =  self.parsonalTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            errorEmpty += 1
            
        }
        if lastName.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-lastname", comment: "")
            self.errorLastnamelLabel =  self.lastNameTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            errorEmpty += 1
            
        }
        if firstName.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-firstname", comment: "")
            self.errorFirstNameLabel =  self.firstNameTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            errorEmpty += 1
        }
        
        
        if errorEmpty > 0 {
            self.showMessagePrompt(emptyMessage)
            return
        }

    
        guard validateIDcard(personalID) else { return }
        
        if self.isMobileField {
            guard validateMobile(optional) else { return }
            
            self.dismiss(animated: true) {
                self.windowSubview?.removeFromSuperview()
                self.windowSubview = nil
                self.nextStep?()
            }
        }else{
            if isValidEmail(optional) {
                self.dismiss(animated: true) {
                    self.windowSubview?.removeFromSuperview()
                    self.windowSubview = nil
                    self.nextStep?()
                }
            }else{
                let emailNotValid = NSLocalizedString("string-error-invalid-email", comment: "")
                self.showMessagePrompt(emailNotValid)
                self.errorEmailLabel =  self.optionTextField.addBottomLabelErrorMessage(emailNotValid, marginLeft: 0 )
            }
        }
    }
    
    func validateIDcard(_ id:String)-> Bool{
        var errorMobile = 0
        var errorMessage = ""
        let nID = id.replace(target: "-", withString: "")
        if !isValidIDCard(nID) {
            errorMessage = NSLocalizedString("string-error-invalid-personal-id", comment: "")
            errorMobile += 1
        }
        if nID.count < 13 {
            errorMessage = NSLocalizedString("string-error-invalid-personal-id1", comment: "")
            errorMobile += 1
        }

        if errorMobile > 0 {
            
            self.showMessagePrompt(errorMessage)
            self.errorPersonalIDLabel =  self.parsonalTextField.addBottomLabelErrorMessage(errorMessage , marginLeft: 0)
            return false
        }
        return true
    }
    func validateMobile(_ mobile:String)-> Bool{
        var errorMobile = 0
        var errorMessage = ""
        let nMobile = mobile.replace(target: "-", withString: "")
        if nMobile.count != 10 {
            errorMobile += 1
        }
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
            self.errorMobileLabel =  self.optionTextField.addBottomLabelErrorMessage(errorMessage , marginLeft: 0)
            return false
        }
        return true
    }

}
