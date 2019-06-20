//
//  PersonalPopupViewController.swift
//  pointpow
//
//  Created by thanawat on 6/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

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
    var userData:AnyObject?
    
    var errorLastnamelLabel:UILabel?
    var errorFirstNameLabel:UILabel?
    var errorPersonalIDLabel:UILabel?
    var errorEmailLabel:UILabel?
    var errorMobileLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()
        self.getUserInfo(){
            self.updateView()
        }
    }
   
    func getUserInfo(_ avaliable:(()->Void)?  = nil){
        
        var isLoading:Bool = true
        if self.userData != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        modelCtrl.getUserData(params: nil , isLoading , succeeded: { (result) in
            self.userData = result
            avaliable?()
            
           
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                self.showMessagePrompt(message)
            }
            
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
            
        }
    }
    
    func updateView(){
        //Fill Data
        if let data  = self.userData as? [String:AnyObject] {
            let first_name = data["first_name"] as? String ?? ""
            let last_name = data["last_name"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let pid = data["pid"] as? String ?? ""
            
            self.firstNameTextField.text = first_name
            self.lastNameTextField.text = last_name
            self.optionTextField.text = email
            
            let newText = String((pid).filter({ $0 != "-" }).prefix(13))
            self.parsonalTextField.text = newText.chunkFormattedPersonalID()
            
        }
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
        
        
    }
    
    func enableButton(){
        if let count = self.nextButton.layer.sublayers?.count {
            if count > 1 {
                self.nextButton.layer.sublayers?.removeFirst()
            }
        }
        
        self.nextButton.borderClearProperties(borderWidth: 1)
        self.nextButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        self.nextButton.isEnabled = true
    }
    func disableButton(){
        if let count = self.nextButton.layer.sublayers?.count {
            if count > 1 {
                self.nextButton.layer.sublayers?.removeFirst()
            }
        }
        self.nextButton.borderClearProperties(borderWidth: 1)
        self.nextButton.applyGradient(colours: [UIColor.lightGray, UIColor.lightGray])
        
        self.nextButton.isEnabled = false
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        
        self.nextButton.borderClearProperties(borderWidth: 1)
        
        self.parsonalTextField.addDoneButtonToKeyboard()
      
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.parsonalTextField.delegate = self
        self.optionTextField.delegate = self
        
        self.firstNameTextField.autocorrectionType = .no
        self.lastNameTextField.autocorrectionType = .no
        self.parsonalTextField.autocorrectionType = .no
        self.optionTextField.autocorrectionType = .no
      
        self.optionTextField.keyboardType = .emailAddress
        self.optionLabel.text = NSLocalizedString("string-item-popup-profile-email", comment: "")
        
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
        
        //disable
        self.disableButton()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textRange = Range(range, in: textField.text!)!
        let updatedText = textField.text!.replacingCharacters(in: textRange, with: string)
        
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
            
            if hasChangeData(updatedText, typeValue: "first_name"){
                self.enableButton()
            }else{
                self.disableButton()
            }
            
            if isValidName(string) {
                return true
            }else{
                return false
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
            
            if hasChangeData(updatedText, typeValue: "last_name"){
                self.enableButton()
            }else{
                self.disableButton()
            }
            if isValidName(string) {
                return true
            }else{
                return false
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
            
            if newLength <= 17 {
                if hasChangeData(updatedText, typeValue: "pid"){
                    self.enableButton()
                }else{
                    self.disableButton()
                }
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
            
            if hasChangeData(updatedText, typeValue: "email"){
                self.enableButton()
            }else{
                self.disableButton()
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == self.firstNameTextField {
            self.lastNameTextField.becomeFirstResponder()
        }
        if textField == self.lastNameTextField {
            self.parsonalTextField.becomeFirstResponder()
        }
        if textField == self.parsonalTextField {
            self.optionTextField.becomeFirstResponder()
        }
      
        
        return true
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
        let email = self.optionTextField.text!
        
        var errorEmpty = 0
        var emptyMessage = ""
        
        
        
        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-email", comment: "")
            self.errorEmailLabel =  self.optionTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            
            errorEmpty += 1
            
        }
        if personalID.trimmingCharacters(in: .whitespaces).isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-personal-id", comment: "")
            self.errorPersonalIDLabel =  self.parsonalTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            errorEmpty += 1
            
        }
        if lastName.trimmingCharacters(in: .whitespaces).isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-lastname", comment: "")
            self.errorLastnamelLabel =  self.lastNameTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            errorEmpty += 1
            
        }
        if firstName.trimmingCharacters(in: .whitespaces).isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-firstname", comment: "")
            self.errorFirstNameLabel =  self.firstNameTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            errorEmpty += 1
        }
        
        
        if errorEmpty > 0 {
            self.showMessagePrompt(NSLocalizedString("string-error-empty-fill", comment: ""))
            return
        }

        guard validateFirstNameLastName(firstName, lname: lastName) else { return }
        guard validateIDcard(personalID) else { return }
        
        if isValidEmail(email) {
            
            //pass
            let params:Parameters = ["firstname" : firstName,
                                     "lastname" : lastName,
                                     "pid" : personalID.replace(target: "-", withString: ""),
                                     "email" : email]
            print(params)
            self.modelCtrl.updateMemberProfile(params: params, succeeded: { (result) in
                
                //self.disableButton()
                
                
                self.showMessagePrompt2(NSLocalizedString("string-message-success-change-profile-infomation", comment: "")) {
                    //ok callback
                    self.dismiss(animated: true) {
                        self.windowSubview?.removeFromSuperview()
                        self.windowSubview = nil
                        self.nextStep?()
                    }
                }
                
                
            }, error: { (error) in
                if let mError = error as? [String:AnyObject]{
                    print(mError)
                    let message = mError["message"] as? String ?? ""
                    //self.errorOTPlLabel = self.otpTextField.addBottomLabelErrorMessage(message, marginLeft: 15)
                    self.showMessagePrompt(message)
                }
            }, failure: { (messageError) in
                self.handlerMessageError(messageError , title: "")
            })
            
        }else{
            let emailNotValid = NSLocalizedString("string-error-invalid-email", comment: "")
            self.showMessagePrompt(emailNotValid)
            self.errorEmailLabel =  self.optionTextField.addBottomLabelErrorMessage(emailNotValid, marginLeft: 0 )
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
      
        
    }
    
    func hasChangeData(_ txt:String , typeValue:String) -> Bool {
        if let data  = self.userData as? [String:AnyObject] {
            let email = data["email"]as? String ?? ""
            let pid = data["pid"]as? String ?? ""
            let last_name = data["last_name"]as? String ?? ""
            let first_name = data["first_name"] as? String ?? ""
            
            if typeValue == "first_name" {
                if txt != first_name {
                    return true
                }
            }
            if typeValue == "last_name" {
                if txt != last_name {
                    return true
                }
            }
            if typeValue == "pid" {
                if txt.replace(target: "-", withString: "") != pid {
                    return true
                }
            }
            if typeValue == "email" {
                if txt != email {
                    return true
                }
            }
           
        }
        
        return false
    }
    
    func validateFirstNameLastName(_ fname:String, lname:String)->Bool {
        var error = 0
        var errorMessage = NSLocalizedString("string-error-invalid-fname", comment: "")
        
        if !isValidName2Digit(lname){
            error += 1
            errorMessage = NSLocalizedString("string-error-invalid-lname", comment: "")
            self.errorLastnamelLabel = self.lastNameTextField.addBottomLabelErrorMessage(errorMessage , marginLeft: 0)
        }
        if !isValidName2Digit(fname){
            error += 1
            errorMessage = NSLocalizedString("string-error-invalid-fname", comment: "")
            self.errorFirstNameLabel = self.firstNameTextField.addBottomLabelErrorMessage(errorMessage, marginLeft: 0)
        }
        if error > 0 {
            self.showMessagePrompt(errorMessage)
            return false
        }
        
        return true
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
   
}
