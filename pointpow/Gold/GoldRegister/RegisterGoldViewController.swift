//
//  RegisterGoldViewController.swift
//  pointpow
//
//  Created by thanawat on 5/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class RegisterGoldViewController: BaseViewController {

    
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var laserIdTextField: UITextField!
    @IBOutlet weak var step1Label: UILabel!
    @IBOutlet weak var step2Label: UILabel!
    @IBOutlet weak var step3Label: UILabel!
    
    @IBOutlet weak var birthdateView: UIView!
    @IBOutlet weak var lasetIdView: UIView!
    @IBOutlet weak var fview: UIView!
    @IBOutlet weak var lview: UIView!
    @IBOutlet weak var eview: UIView!
    @IBOutlet weak var mview: UIView!
    @IBOutlet weak var idview: UIView!
    
    @IBOutlet weak var idcardTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    var tupleModel:(image : UIImage?, firstname : String,lastname: String , email: String,mobile: String,idcard: String , birthdate:String, laserId:String)?
    
    
    var clearImageView:UIImageView?
    var clearImageView2:UIImageView?
    var clearImageView3:UIImageView?
    var clearImageView4:UIImageView?
    var clearImageView5:UIImageView?
    var clearImageView6:UIImageView?
    
    var errorLastnamelLabel:UILabel?
    var errorFirstNameLabel:UILabel?
    var errorPersonalIDLabel:UILabel?
    var errorEmailLabel:UILabel?
    var errorMobileLabel:UILabel?
    var errorLaserIdLabel:UILabel?
    var errorBirthdateLabel:UILabel?
    
    var userData:AnyObject?
    var pickerView:UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("string-title-gold-register1", comment: "")
        self.setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "th")
        formatter.dateFormat = "dd MMMM yyyy"
        self.birthdateTextField.text = formatter.string(from: pickerView!.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        
        self.mobileTextField.addDoneButtonToKeyboard()
        
        self.idcardTextField.addDoneButtonToKeyboard()
        
        self.birthdateTextField.addDoneButtonToKeyboard()
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.mobileTextField.delegate = self
        self.idcardTextField.delegate = self
        self.laserIdTextField.delegate = self
        self.birthdateTextField.delegate = self
        
        self.firstNameTextField.autocorrectionType = .no
        self.lastNameTextField.autocorrectionType = .no
        self.emailTextField.autocorrectionType = .no
        self.mobileTextField.autocorrectionType = .no
        self.idcardTextField.autocorrectionType = .no
        self.laserIdTextField.autocorrectionType = .no
        self.birthdateTextField.autocorrectionType = .no
        
        self.firstNameTextField.setLeftPaddingPoints(40)
        self.lastNameTextField.setLeftPaddingPoints(10)
        self.emailTextField.setLeftPaddingPoints(40)
        self.mobileTextField.setLeftPaddingPoints(40)
        self.idcardTextField.setLeftPaddingPoints(40)
        self.laserIdTextField.setLeftPaddingPoints(40)
        self.birthdateTextField.setLeftPaddingPoints(40)
        
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
        
        self.clearImageView3 = self.idcardTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(clearPersanalTapped))
        self.clearImageView3?.isUserInteractionEnabled = true
        self.clearImageView3?.addGestureRecognizer(tap3)
        self.clearImageView3?.isHidden = true
        
        self.clearImageView4 = self.mobileTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(clearMobileTapped))
        self.clearImageView4?.isUserInteractionEnabled = true
        self.clearImageView4?.addGestureRecognizer(tap4)
        self.clearImageView4?.isHidden = true
        
        self.clearImageView5 = self.emailTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(clearEmailTapped))
        self.clearImageView5?.isUserInteractionEnabled = true
        self.clearImageView5?.addGestureRecognizer(tap5)
        self.clearImageView5?.isHidden = true

//        self.clearImageView6 = self.laserIdTextField.addRightButton(UIImage(named: "ic-x")!)
//        let tap6 = UITapGestureRecognizer(target: self, action: #selector(clearLaserIdTapped))
//        self.clearImageView6?.isUserInteractionEnabled = true
//        self.clearImageView6?.addGestureRecognizer(tap6)
//        self.clearImageView6?.isHidden = true
        
        //Fill Data
        if let data  = self.userData as? [String:AnyObject] {
            //let pointBalance = data["member_point"]?["total"] as? String ?? "0.00"
            //let profileImage = data["picture_data"] as? String ?? ""
            let first_name = data["first_name"] as? String ?? ""
            let last_name = data["last_name"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let mobile = data["mobile"] as? String ?? ""
            let pid = data["pid"] as? String ?? ""
            let regis_by = data["regis_by"] as? String ?? ""
            let birthdate = data["birthdate"] as? String ?? ""
            
            if regis_by == "email" {
                
                self.emailTextField.textColor = UIColor.lightGray
                self.emailTextField.isEnabled = false
            }else{
                self.emailTextField.textColor = UIColor.black
                self.emailTextField.isEnabled = true
            }
            
            if regis_by == "mobile" {
                self.mobileTextField.textColor = UIColor.lightGray
                self.mobileTextField.isEnabled = false
            }else{
                self.mobileTextField.textColor = UIColor.black
                self.mobileTextField.isEnabled = true
            }
            
            self.firstNameTextField.text = first_name
            self.lastNameTextField.text = last_name
            self.emailTextField.text = email
            
            let newText = String((pid).filter({ $0 != "-" }).prefix(13))
            self.idcardTextField.text = newText.chunkFormattedPersonalID()
            
            let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
            self.mobileTextField.text =  newMText.chunkFormatted()
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "th")
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            if let d1 = dateFormatter.date(from: convertDateRegister(birthdate, format: "yyyy-MM-dd")) {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "th")
                formatter.dateFormat = "dd MMMM yyyy"
                
                self.birthdateTextField.text = formatter.string(from: d1)
            }
            
        }
        
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
        
        self.birthdateTextField.tintColor = UIColor.clear
        self.birthdateTextField.isUserInteractionEnabled = true
        self.birthdateTextField.inputView = pickerView
        self.birthdateTextField.inputAccessoryView = toolbar
        
        
        
        let info = UITapGestureRecognizer(target: self, action: #selector(infoLaserId))
        self.infoImageView.isUserInteractionEnabled = true
        self.infoImageView.addGestureRecognizer(info)
        
    }
    @objc func  infoLaserId(){
        self.showInfoLaserIdPopup(true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.addColorLineView(textField)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == self.firstNameTextField {
            self.lastNameTextField.becomeFirstResponder()
        }
        if textField == self.lastNameTextField {
            self.emailTextField.becomeFirstResponder()
        }
        if textField == self.emailTextField {
            self.mobileTextField.becomeFirstResponder()
        }
        if textField == self.mobileTextField {
            self.idcardTextField.becomeFirstResponder()
        }
        if textField == self.idcardTextField {
            self.laserIdTextField.becomeFirstResponder()
        }
        if textField == self.laserIdTextField {
            self.birthdateTextField.becomeFirstResponder()
        }
        
        return true
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
        if textField  == self.idcardTextField {
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
            
            let text = textField.text ?? ""
            
            if string.count == 0 {
                textField.text = String(text.dropLast()).chunkFormattedPersonalID()
            }  else {
                let newText = String((text + string).filter({ $0 != "-" }).prefix(13))
                textField.text = newText.chunkFormattedPersonalID()
            }
            return false
            
        }
        if textField  == self.mobileTextField {
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
            
            //Mobile
            let text = textField.text ?? ""
                
            if string.count == 0 {
                textField.text = String(text.dropLast()).chunkFormatted()
            }  else {
                let newText = String((text + string).filter({ $0 != "-" }).prefix(10))
                textField.text = newText.chunkFormatted()
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
                self.clearImageView5?.isHidden = true
            }else{
                self.clearImageView5?.isHidden = false
            }
            
        }
        if textField  == self.laserIdTextField {
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //return newLength <= 20
            
            if newLength == 0 {
                self.clearImageView6?.isHidden = true
            }else{
                self.clearImageView6?.isHidden = false
            }
            if newLength <= 2 {
                if !isValidName(string) {
                    return false
                }
            }else{
                if !isValidNumber(string) {
                    return false
                }
            }
            
            //validate laserId
            let text = textField.text ?? ""
            if string.count == 0 {
                textField.text = String(text.dropLast()).chunkFormattedLaserID()
            }  else {
                let newText = String((text + string).filter({ $0 != "-" }).prefix(12))
                textField.text = newText.chunkFormattedLaserID()
            }
            return false
        }
        
        
       
        
        return true
        
    }
    
    func addColorLineView(_ textField:UITextField){
        switch textField {
        case firstNameTextField:
            fview.backgroundColor = UIColor.darkGray
            lview.backgroundColor = UIColor.groupTableViewBackground
            eview.backgroundColor = UIColor.groupTableViewBackground
            mview.backgroundColor = UIColor.groupTableViewBackground
            idview.backgroundColor = UIColor.groupTableViewBackground
            lasetIdView.backgroundColor = UIColor.groupTableViewBackground
            birthdateView.backgroundColor = UIColor.groupTableViewBackground
            break
        case lastNameTextField:
            fview.backgroundColor = UIColor.groupTableViewBackground
            lview.backgroundColor = UIColor.darkGray
            eview.backgroundColor = UIColor.groupTableViewBackground
            mview.backgroundColor = UIColor.groupTableViewBackground
            idview.backgroundColor = UIColor.groupTableViewBackground
            lasetIdView.backgroundColor = UIColor.groupTableViewBackground
            birthdateView.backgroundColor = UIColor.groupTableViewBackground
            break
        case emailTextField:
            fview.backgroundColor = UIColor.groupTableViewBackground
            lview.backgroundColor = UIColor.groupTableViewBackground
            eview.backgroundColor = UIColor.darkText
            mview.backgroundColor = UIColor.groupTableViewBackground
            idview.backgroundColor = UIColor.groupTableViewBackground
            lasetIdView.backgroundColor = UIColor.groupTableViewBackground
            birthdateView.backgroundColor = UIColor.groupTableViewBackground
            break
        case mobileTextField:
            fview.backgroundColor = UIColor.groupTableViewBackground
            lview.backgroundColor = UIColor.groupTableViewBackground
            eview.backgroundColor = UIColor.groupTableViewBackground
            mview.backgroundColor = UIColor.darkText
            idview.backgroundColor = UIColor.groupTableViewBackground
            lasetIdView.backgroundColor = UIColor.groupTableViewBackground
            birthdateView.backgroundColor = UIColor.groupTableViewBackground
            break
        case idcardTextField:
            fview.backgroundColor = UIColor.groupTableViewBackground
            lview.backgroundColor = UIColor.groupTableViewBackground
            eview.backgroundColor = UIColor.groupTableViewBackground
            mview.backgroundColor = UIColor.groupTableViewBackground
            idview.backgroundColor = UIColor.darkText
            lasetIdView.backgroundColor = UIColor.groupTableViewBackground
            birthdateView.backgroundColor = UIColor.groupTableViewBackground
            break
        case laserIdTextField:
            fview.backgroundColor = UIColor.groupTableViewBackground
            lview.backgroundColor = UIColor.groupTableViewBackground
            eview.backgroundColor = UIColor.groupTableViewBackground
            mview.backgroundColor = UIColor.groupTableViewBackground
            idview.backgroundColor = UIColor.groupTableViewBackground
            lasetIdView.backgroundColor = UIColor.darkText
            birthdateView.backgroundColor = UIColor.groupTableViewBackground
            break
        case birthdateTextField:
            fview.backgroundColor = UIColor.groupTableViewBackground
            lview.backgroundColor = UIColor.groupTableViewBackground
            eview.backgroundColor = UIColor.groupTableViewBackground
            mview.backgroundColor = UIColor.groupTableViewBackground
            idview.backgroundColor = UIColor.groupTableViewBackground
            lasetIdView.backgroundColor = UIColor.groupTableViewBackground
            birthdateView.backgroundColor = UIColor.darkText
            break
            
        default:
            break
        }
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
    @objc func clearPersanalTapped(){
        self.clearImageView3?.animationTapped({
            self.idcardTextField.text = ""
            self.clearImageView3?.isHidden = true
        })
    }
    @objc func clearMobileTapped(){
        self.clearImageView4?.animationTapped({
            self.mobileTextField.text = ""
            self.clearImageView4?.isHidden = true
        })
        
    }
    @objc func clearEmailTapped(){
        self.clearImageView5?.animationTapped({
            self.emailTextField.text = ""
            self.clearImageView5?.isHidden = true
        })
        
    }
    @objc func clearLaserIdTapped(){
        self.clearImageView6?.animationTapped({
            self.laserIdTextField.text = ""
            self.clearImageView5?.isHidden = true
        })
        
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        
        self.nextButton.borderClearProperties(borderWidth: 1)
        self.nextButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        self.step1Label.ovalColorClearProperties()
        self.step2Label.ovalColorClearProperties()
        self.step3Label.ovalColorClearProperties()
        
        
    }
    @IBAction func nextStepTapped(_ sender: Any) {
        
        
        errorLastnamelLabel?.removeFromSuperview()
        errorFirstNameLabel?.removeFromSuperview()
        errorPersonalIDLabel?.removeFromSuperview()
        errorEmailLabel?.removeFromSuperview()
        errorMobileLabel?.removeFromSuperview()
        errorLaserIdLabel?.removeFromSuperview()
        errorBirthdateLabel?.removeFromSuperview()
        
        let firstName = self.firstNameTextField.text!
        let lastName = self.lastNameTextField.text!
        let personalID  = self.idcardTextField.text!
        let mobile = self.mobileTextField.text!
        let email = self.emailTextField.text!
        let laserId = self.laserIdTextField.text!
        let birthdate = self.birthdateTextField.text!
        
        var errorEmpty = 0
        var emptyMessage = ""
        
        
        
        if birthdate.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-birth-date", comment: "")
            self.errorBirthdateLabel =  self.birthdateTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 15 )
            errorEmpty += 1
            
        }
        if laserId.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-laser-id", comment: "")
            self.errorLaserIdLabel =  self.laserIdTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 15 )
            errorEmpty += 1
            
        }
        if personalID.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-personal-id", comment: "")
            self.errorPersonalIDLabel =  self.idcardTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 15 )
            errorEmpty += 1
            
        }
        if mobile.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-mobile", comment: "")
            self.errorMobileLabel =  self.mobileTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 15 )
            errorEmpty += 1
            
        }
        if email.isEmpty{
            emptyMessage = NSLocalizedString("string-error-empty-email", comment: "")
            self.errorEmailLabel =  self.emailTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 15 )
            errorEmpty += 1
        }
        if lastName.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-lastname", comment: "")
            self.errorLastnamelLabel =  self.lastNameTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 10 )
            errorEmpty += 1
            
        }
        if firstName.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-firstname", comment: "")
            self.errorFirstNameLabel =  self.firstNameTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 15 )
            errorEmpty += 1
        }
        
        
        if errorEmpty > 0 {
            self.showMessagePrompt(NSLocalizedString("string-error-empty-fill", comment: ""))
            return
        }
        
        
        guard validateLaserId(laserId) else { return }
        guard validateIDcard(personalID) else { return }
        guard validateMobile(mobile) else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        let date = convertBuddhaToChris(formatter.string(from: pickerView!.date))
        
        if isValidEmail(email) {
            //pass
            self.tupleModel = (image : nil,
                               firstname : firstName,
                               lastname: lastName ,
                               email: email,
                               mobile: mobile.replace(target: "-", withString: ""),
                               idcard: personalID.replace(target: "-", withString: ""),
                               birthdate: date,
                               laserId:laserId.replace(target: "-", withString: ""))
            
            self.showRegisterGoldStep2Saving(true, tupleModel: tupleModel)
        }else{
            let emailNotValid = NSLocalizedString("string-error-invalid-email", comment: "")
            self.showMessagePrompt(emailNotValid)
            self.errorEmailLabel =  self.emailTextField.addBottomLabelErrorMessage(emailNotValid, marginLeft: 0 )
        }
       
    }
    func validateLaserId(_ id:String)->Bool {
        var errorMobile = 0
        var errorMessage = ""
        let nID = id.replace(target: "-", withString: "")
        
        print("laserId = \(nID)")
        if !isValidLaserIdCard(nID) {
            errorMessage = NSLocalizedString("string-error-invalid-laser-id", comment: "")
            errorMobile += 1
        }
        if nID.count < 12 {
            errorMessage = NSLocalizedString("string-error-invalid-laser-id1", comment: "")
            errorMobile += 1
        }
    
        if errorMobile > 0 {
            self.showMessagePrompt(errorMessage)
            self.errorLaserIdLabel =  self.laserIdTextField.addBottomLabelErrorMessage(errorMessage , marginLeft: 15)
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
            self.errorPersonalIDLabel =  self.idcardTextField.addBottomLabelErrorMessage(errorMessage , marginLeft: 15)
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
            self.errorMobileLabel =  self.mobileTextField.addBottomLabelErrorMessage(errorMessage , marginLeft: 15)
            return false
        }
        return true
    }
}
