//
//  PersonalViewController.swift
//  pointpow
//
//  Created by thanawat on 12/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class PersonalViewController: BaseViewController  {

    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var parsonalTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    
    var clearImageView:UIImageView?
    var clearImageView2:UIImageView?
    var clearImageView3:UIImageView?
    
    
    var pickerView:UIDatePicker?
    
     var errorPersonalIDLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("string-title-profile-edit", comment: "")
        self.setUp()
        
    }
   
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.nextButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
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
        pickerView = UIDatePicker()
        pickerView!.datePickerMode = .date
        pickerView!.calendar = Calendar(identifier: .buddhist)

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
        
            self.birthdayTextField.addDoneButtonToKeyboard(myAction:
                #selector(self.birthdayTextField.resignFirstResponder))
        
        self.backgroundImage?.image = nil
        self.nextButton.borderClearProperties(borderWidth: 1)
        
        if #available(iOS 10.0, *) {
            self.firstNameTextField.textContentType = UITextContentType(rawValue: "")
            self.lastNameTextField.textContentType = UITextContentType(rawValue: "")
            self.parsonalTextField.textContentType = UITextContentType(rawValue: "")
            self.birthdayTextField.textContentType = UITextContentType(rawValue: "")
        }
        if #available(iOS 12.0, *) {
            self.firstNameTextField.textContentType = .oneTimeCode
            self.lastNameTextField.textContentType = .oneTimeCode
            self.parsonalTextField.textContentType = .oneTimeCode
            self.birthdayTextField.textContentType = .oneTimeCode
        }
        
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.parsonalTextField.delegate = self
        self.birthdayTextField.delegate = self
        
        self.firstNameTextField.autocorrectionType = .no
        self.lastNameTextField.autocorrectionType = .no
        self.parsonalTextField.autocorrectionType = .no
        self.birthdayTextField.autocorrectionType = .no
        
        
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
        
        errorPersonalIDLabel?.removeFromSuperview()
        
        let firstName = self.firstNameTextField.text!
        let lastName = self.lastNameTextField.text!
        let personalID  = self.parsonalTextField.text!
        
        
        var errorEmpty = 0
        var emptyMessage = ""
        
        
      
        if personalID.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-personal-id", comment: "")
            self.errorPersonalIDLabel =  self.parsonalTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            errorEmpty += 1
            
        }
        
        
        if errorEmpty > 0 {
            self.showMessagePrompt(NSLocalizedString("string-error-empty-fill", comment: ""))
            return
        }
        
        
        guard validateIDcard(personalID) else { return }
       
        //pass
       
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
