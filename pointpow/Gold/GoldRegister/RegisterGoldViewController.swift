//
//  RegisterGoldViewController.swift
//  pointpow
//
//  Created by thanawat on 5/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class RegisterGoldViewController: BaseViewController {

    @IBOutlet weak var step1Label: UILabel!
    @IBOutlet weak var step2Label: UILabel!
    @IBOutlet weak var step3Label: UILabel!
    
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
    
     var tupleModel:(image : UIImage?, firstname : String,lastname: String , email: String,mobile: String,idcard: String)?
    
    
    var clearImageView:UIImageView?
    var clearImageView2:UIImageView?
    var clearImageView3:UIImageView?
    var clearImageView4:UIImageView?
    var clearImageView5:UIImageView?
    
    var errorLastnamelLabel:UILabel?
    var errorFirstNameLabel:UILabel?
    var errorPersonalIDLabel:UILabel?
    var errorEmailLabel:UILabel?
    var errorMobileLabel:UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("string-title-gold-register1", comment: "")

        self.setUp()
    }
    func setUp(){
        self.backgroundImage?.image = nil
        
        
        if #available(iOS 10.0, *) {
            self.firstNameTextField.textContentType = UITextContentType(rawValue: "")
            self.lastNameTextField.textContentType = UITextContentType(rawValue: "")
            self.emailTextField.textContentType = UITextContentType(rawValue: "")
            self.mobileTextField.textContentType = UITextContentType(rawValue: "")
            self.idcardTextField.textContentType = UITextContentType(rawValue: "")
        }
        if #available(iOS 12.0, *) {
            self.firstNameTextField.textContentType = .oneTimeCode
            self.lastNameTextField.textContentType = .oneTimeCode
            self.emailTextField.textContentType = .oneTimeCode
            self.mobileTextField.textContentType = .oneTimeCode
            self.idcardTextField.textContentType = .oneTimeCode
        }
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.mobileTextField.delegate = self
        self.idcardTextField.delegate = self
        
        self.firstNameTextField.autocorrectionType = .no
        self.lastNameTextField.autocorrectionType = .no
        self.emailTextField.autocorrectionType = .no
        self.mobileTextField.autocorrectionType = .no
        self.idcardTextField.autocorrectionType = .no
        
        self.firstNameTextField.setLeftPaddingPoints(40)
        self.lastNameTextField.setLeftPaddingPoints(10)
        self.emailTextField.setLeftPaddingPoints(40)
        self.mobileTextField.setLeftPaddingPoints(40)
        self.idcardTextField.setLeftPaddingPoints(40)
        
        
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
    
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        self.addColorLineView(textField)
        
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
            break
            case lastNameTextField:
                fview.backgroundColor = UIColor.groupTableViewBackground
                lview.backgroundColor = UIColor.darkGray
                eview.backgroundColor = UIColor.groupTableViewBackground
                mview.backgroundColor = UIColor.groupTableViewBackground
                idview.backgroundColor = UIColor.groupTableViewBackground
            break
                case emailTextField:
                    fview.backgroundColor = UIColor.groupTableViewBackground
                    lview.backgroundColor = UIColor.groupTableViewBackground
                    eview.backgroundColor = UIColor.darkText
                    mview.backgroundColor = UIColor.groupTableViewBackground
                    idview.backgroundColor = UIColor.groupTableViewBackground
                break
                    case mobileTextField:
                        fview.backgroundColor = UIColor.groupTableViewBackground
                        lview.backgroundColor = UIColor.groupTableViewBackground
                        eview.backgroundColor = UIColor.groupTableViewBackground
                        mview.backgroundColor = UIColor.darkText
                        idview.backgroundColor = UIColor.groupTableViewBackground
                    break
                        case idcardTextField:
                            fview.backgroundColor = UIColor.groupTableViewBackground
                            lview.backgroundColor = UIColor.groupTableViewBackground
                            eview.backgroundColor = UIColor.groupTableViewBackground
                            mview.backgroundColor = UIColor.groupTableViewBackground
                            idview.backgroundColor = UIColor.darkText
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
        self.clearImageView4?.animationTapped({
            self.emailTextField.text = ""
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
        
        
        let firstName = self.firstNameTextField.text!
        let lastName = self.lastNameTextField.text!
        let personalID  = self.idcardTextField.text!
        let mobile = self.mobileTextField.text!
        let email = self.emailTextField.text!
        
        var errorEmpty = 0
        var emptyMessage = ""
        
        
        
       
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
            self.showMessagePrompt(emptyMessage)
            return
        }
        
        
        guard validateIDcard(personalID) else { return }
        guard validateMobile(mobile) else { return }
        
        if isValidEmail(email) {
            //pass
            self.tupleModel = (image : nil,
                               firstname : self.firstNameTextField.text!,
                               lastname: self.lastNameTextField.text! ,
                               email: self.emailTextField.text!,
                               mobile: self.mobileTextField.text!,
                               idcard: self.idcardTextField.text!)
            self.showRegisterGoldStep2Saving(true, tupleModel: tupleModel)
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
