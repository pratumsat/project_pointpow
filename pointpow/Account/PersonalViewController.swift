//
//  PersonalViewController.swift
//  pointpow
//
//  Created by thanawat on 12/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class PersonalViewController: BaseViewController  {

    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var parsonalTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var mScrollView: UIScrollView!
    
    var clearImageView:UIImageView?
    var clearImageView2:UIImageView?
    var clearImageView3:UIImageView?
    var clearImageView4:UIImageView?
    var clearImageView5:UIImageView?
    
    var pickerView:UIDatePicker?
    
    var errorBirthdayLabel:UILabel?
    var errorPersonalIDLabel:UILabel?
    var errorLastnamelLabel:UILabel?
    var errorFirstNameLabel:UILabel?
    var errorEmailLabel:UILabel?
    var errorBirthdateLabel:UILabel?
    
    var userData:AnyObject?
     var currentBirthdate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("string-title-profile-edit", comment: "")
        self.setUp()
        
        self.getUserInfo(){
            self.updateView()
        }
    }
    
    override func reloadData() {
        self.getUserInfo(){
            self.updateView()
        }
    }
    @IBAction func bViewTapped(_ sender: Any) {
        if self.nextButton.isEnabled {
            let alert = UIAlertController(title:
                NSLocalizedString("string-dailog-back-view-profile", comment: ""),
                                          message: "", preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: NSLocalizedString("string-dailog-gold-button-confirm", comment: ""), style: .default, handler: {
                (alert) in
                
                 self.navigationController?.popViewController(animated: true)
                
                
                
            })
            let cancelButton = UIAlertAction(title: NSLocalizedString("string-dailog-gold-button-cancel", comment: ""), style: .default, handler: nil)
            
            
            alert.addAction(cancelButton)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
            
        }
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
            
            self.refreshControl?.endRefreshing()
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                self.showMessagePrompt(message)
            }
            self.refreshControl?.endRefreshing()
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
            self.refreshControl?.endRefreshing()
        }
    }
    
    func updateView(){
        self.currentBirthdate = ""
        //Fill Data
        if let data  = self.userData as? [String:AnyObject] {
            let first_name = data["first_name"] as? String ?? ""
            let last_name = data["last_name"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let pid = data["pid"] as? String ?? ""
            let birthdate = data["birthdate"] as? String ?? ""
            
            self.firstNameTextField.text = first_name
            self.lastNameTextField.text = last_name
            self.emailTextField.text = email
            
            let newText = String((pid).filter({ $0 != "-" }).prefix(13))
            self.parsonalTextField.text = newText.chunkFormattedPersonalID()
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "th")
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            if let d1 = dateFormatter.date(from: convertDateRegister(birthdate, format: "yyyy-MM-dd")) {
                self.pickerView?.date = d1
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "th")
                formatter.dateFormat = "dd MMMM yyyy"
                
                self.birthdayTextField.text = formatter.string(from: d1)
                self.currentBirthdate = self.birthdayTextField.text!
            }
            
            
            
        }
    }
   
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       // self.nextButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "th")
        formatter.dateFormat = "dd MMMM yyyy"
        self.birthdayTextField.text = formatter.string(from: pickerView!.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    func setUp(){
        self.addRefreshScrollViewController(self.mScrollView)
        
        pickerView = UIDatePicker()
        pickerView!.datePickerMode = .date
        pickerView!.calendar = Calendar(identifier: .buddhist)
        pickerView!.maximumDate = Date()

        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self,
                                         action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                          target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self,
                                           action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        
        
        self.birthdayTextField.tintColor = UIColor.clear
        self.birthdayTextField.isUserInteractionEnabled = true
        self.birthdayTextField.inputView = pickerView
        self.birthdayTextField.inputAccessoryView = toolbar
        
          
        self.backgroundImage?.image = nil
        self.nextButton.borderClearProperties(borderWidth: 1)
        
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.parsonalTextField.delegate = self
        self.birthdayTextField.delegate = self
        self.emailTextField.delegate = self
        
        
        
        self.firstNameTextField.autocorrectionType = .no
        self.lastNameTextField.autocorrectionType = .no
        self.parsonalTextField.autocorrectionType = .no
        self.birthdayTextField.autocorrectionType = .no
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
        
        self.clearImageView4 = self.emailTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(clearEmailTapped))
        self.clearImageView4?.isUserInteractionEnabled = true
        self.clearImageView4?.addGestureRecognizer(tap4)
        self.clearImageView4?.isHidden = true
        
        //disable
        self.disableButton()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        if hasChangeData(){
            self.enableButton()
        }else{
            self.disableButton()
        }
        
    }
    
    func hasChangeData() -> Bool {
        if let data  = self.userData as? [String:AnyObject] {
            let email = data["email"]as? String ?? ""
            let pid = data["pid"]as? String ?? ""
            let last_name = data["last_name"]as? String ?? ""
            let first_name = data["first_name"] as? String ?? ""
            
            if self.firstNameTextField.text != first_name {
                return true
            }
            if self.lastNameTextField.text != last_name {
                return true
            }
            if self.parsonalTextField.text?.replace(target: "-", withString: "") != pid {
                return true
            }
            if self.birthdayTextField.text != self.currentBirthdate {
                return true
            }
            if self.emailTextField.text != email {
                return true
            }
        }
        
        return false
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
            
            //PID
            let text = textField.text ?? ""
            
            if string.count == 0 {
                textField.text = String(text.dropLast()).chunkFormattedPersonalID()
            }  else {
                let newText = String((text + string).filter({ $0 != "-" }).prefix(13))
                textField.text = newText.chunkFormattedPersonalID()
            }
            return false
        }
        if textField  == self.emailTextField {
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
            
        }
        if textField == self.birthdayTextField {
            return false
        }
        
        return true
        
    }
    @objc func clearEmailTapped(){
        self.clearImageView4?.animationTapped({
            self.emailTextField.text = ""
            self.clearImageView4?.isHidden = true
        })
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == self.firstNameTextField {
            self.lastNameTextField.becomeFirstResponder()
        }
        if textField == self.lastNameTextField {
            self.parsonalTextField.becomeFirstResponder()
        }
        if textField == self.parsonalTextField {
            self.emailTextField.becomeFirstResponder()
        }
        if textField == self.emailTextField {
            self.birthdayTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "1"
    }
    
    
   
    
    
    @IBAction func saveTapped(_ sender: Any) {
        
        errorFirstNameLabel?.removeFromSuperview()
        errorLastnamelLabel?.removeFromSuperview()
        errorPersonalIDLabel?.removeFromSuperview()
        errorEmailLabel?.removeFromSuperview()
        errorBirthdateLabel?.removeFromSuperview()
        
        let firstName = self.firstNameTextField.text!
        let lastName = self.lastNameTextField.text!
        let personalID  = self.parsonalTextField.text!
        let email  = self.emailTextField.text!
        let birthdate = self.birthdayTextField.text!
        
        var errorEmpty = 0
        var emptyMessage = ""
        
        
        
        if birthdate.trimmingCharacters(in: .whitespaces).isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-birth-date", comment: "")
            self.errorBirthdateLabel =  self.birthdayTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            errorEmpty += 1

        }
        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-email", comment: "")
            self.errorEmailLabel =  self.emailTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
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
        
        
        guard validateIDcard(personalID) else { return }
        if isValidEmail(email) {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            
            let date = convertBuddhaToChris(formatter.string(from: pickerView!.date))
            //pass
            let params:Parameters = ["firstname" : firstName,
                                     "lastname" : lastName,
                                     "pid" : personalID.replace(target: "-", withString: ""),
                                     "email" : email,
                                     "birthdate": date]
            print(params)
           self.modelCtrl.updateMemberProfile(params: params, succeeded: { (result) in
            
            self.disableButton()
           
            self.showMessagePrompt2(NSLocalizedString("string-message-success-change-profile-infomation", comment: "")) {
                //ok callback
                self.getUserInfo(){
                    self.updateView()
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
            self.errorEmailLabel =  self.emailTextField.addBottomLabelErrorMessage(emailNotValid, marginLeft: 0 )
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

}
