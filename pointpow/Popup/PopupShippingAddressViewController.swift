//
//  PopupShippingAddressViewController.swift
//  pointpow
//
//  Created by thanawat on 19/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PopupShippingAddressViewController: BaseViewController ,UIPickerViewDelegate , UIPickerViewDataSource {
    var nextStep:((_ address:String)->Void)?
    
    @IBOutlet weak var postCodeTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var subDistrictTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var numberPhoneTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    
    var clearImageView:UIImageView?
    var clearImageView2:UIImageView?
    var clearImageView3:UIImageView?
    
    var errorNamelLabel:UILabel?
    var errorAddressLabel:UILabel?
    var errorMobileLabel:UILabel?
    var errorDistrictLabel:UILabel?
    var errorSubDistrictLabel:UILabel?
    var errorProvinceLabel:UILabel?
    var errorPostCodeLabel:UILabel?
    
    var provincePickerView:UIPickerView?
    var districtPickerView:UIPickerView?
    var subDistrictPickerView:UIPickerView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.setUp()
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        
        self.nextButton.borderClearProperties(borderWidth: 1)
        
        
        if #available(iOS 10.0, *) {
            self.nameTextField.textContentType = UITextContentType(rawValue: "")
            self.numberPhoneTextField.textContentType = UITextContentType(rawValue: "")
            self.addressTextField.textContentType = UITextContentType(rawValue: "")
            
            
        }
        if #available(iOS 12.0, *) {
            self.nameTextField.textContentType = .oneTimeCode
            self.numberPhoneTextField.textContentType = .oneTimeCode
            self.addressTextField.textContentType = .oneTimeCode
            
        }
        
        self.nameTextField.delegate = self
        self.numberPhoneTextField.delegate = self
        self.addressTextField.delegate = self
        
        self.nameTextField.autocorrectionType = .no
        self.numberPhoneTextField.autocorrectionType = .no
        self.addressTextField.autocorrectionType = .no
       
        self.clearImageView = self.nameTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearNameTapped))
        self.clearImageView?.isUserInteractionEnabled = true
        self.clearImageView?.addGestureRecognizer(tap)
        self.clearImageView?.isHidden = true
        
        self.clearImageView2 = self.numberPhoneTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(clearNumberTapped))
        self.clearImageView2?.isUserInteractionEnabled = true
        self.clearImageView2?.addGestureRecognizer(tap2)
        self.clearImageView2?.isHidden = true
        
        self.clearImageView3 = self.addressTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(clearAddressTapped))
        self.clearImageView3?.isUserInteractionEnabled = true
        self.clearImageView3?.addGestureRecognizer(tap3)
        self.clearImageView3?.isHidden = true
        
        self.setPicker()
    }
    
    
    func setPicker(){
        provincePickerView = UIPickerView()
        provincePickerView!.delegate = self
        provincePickerView!.dataSource = self
        
        self.provinceTextField.tintColor = UIColor.clear
        self.provinceTextField.isUserInteractionEnabled = true
        self.provinceTextField.inputView = provincePickerView
        
        districtPickerView = UIPickerView()
        districtPickerView!.delegate = self
        districtPickerView!.dataSource = self
        
        self.districtTextField.tintColor = UIColor.clear
        self.districtTextField.isUserInteractionEnabled = true
        self.districtTextField.inputView = districtPickerView
        
        
        subDistrictPickerView = UIPickerView()
        subDistrictPickerView!.delegate = self
        subDistrictPickerView!.dataSource = self
        
        self.subDistrictTextField.tintColor = UIColor.clear
        self.subDistrictTextField.isUserInteractionEnabled = true
        self.subDistrictTextField.inputView = subDistrictPickerView
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.provincePickerView{
            return 1
        }
        if pickerView == self.districtPickerView{
            return 1
        }
        if pickerView == self.subDistrictPickerView{
            return 1
        }
        return 1
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.provincePickerView{
            return "province"
        }
        if pickerView == self.districtPickerView{
            return "district"
        }
        if pickerView == self.subDistrictPickerView{
            return "sub_district"
        }
        
        return ""
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        errorNamelLabel?.removeFromSuperview()
        errorMobileLabel?.removeFromSuperview()
        errorAddressLabel?.removeFromSuperview()
         errorProvinceLabel?.removeFromSuperview()
        errorDistrictLabel?.removeFromSuperview()
        errorSubDistrictLabel?.removeFromSuperview()
        errorPostCodeLabel?.removeFromSuperview()
        
       
        
        
        let name = self.nameTextField.text!
        let mobile = self.numberPhoneTextField.text!
        let address  = self.addressTextField.text!
        let district = self.districtTextField.text!
        let subDistrict = self.subDistrictTextField.text!
        let province = self.provinceTextField.text!
        let postcode = self.postCodeTextField.text!
        
        var errorEmpty = 0
        var emptyMessage = ""
        
        
        if postcode.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-postcode", comment: "")
            self.errorPostCodeLabel =  self.postCodeTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
             errorEmpty += 1
        }
        
        if district.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-district", comment: "")
            self.errorDistrictLabel =  self.districtTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            errorEmpty += 1
            
        }
        if subDistrict.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-sub-district", comment: "")
            self.errorSubDistrictLabel =  self.subDistrictTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            errorEmpty += 1
            
        }
        if province.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-province", comment: "")
            self.errorProvinceLabel =  self.provinceTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            errorEmpty += 1
        }
        if address.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-address", comment: "")
            self.errorAddressLabel =  self.addressTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            errorEmpty += 1
        }
        if mobile.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-mobile", comment: "")
            self.errorMobileLabel =  self.numberPhoneTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            errorEmpty += 1
        }
        if name.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-firstname", comment: "")
            self.errorNamelLabel =  self.nameTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            errorEmpty += 1
        }
        
        
        if errorEmpty > 0 {
            self.showMessagePrompt(emptyMessage)
            return
        }
        
        
        guard validateMobile(mobile) else { return }
        print("pass pass pass")
//
//        self.dismiss(animated: true) {
//            self.windowSubview?.removeFromSuperview()
//            self.windowSubview = nil
//            self.nextStep?()
//        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
        if textField  == self.nameTextField {
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
        if textField  == self.numberPhoneTextField {
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
            let text = textField.text ?? ""
            
            if string.count == 0 {
                textField.text = String(text.dropLast()).chunkFormatted()
            }  else {
                let newText = String((text + string).filter({ $0 != "-" }).prefix(10))
                textField.text = newText.chunkFormatted()
            }
            return false
            
        }
        
        if textField  == self.addressTextField {
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
    
    @objc func clearNameTapped(){
        self.clearImageView?.animationTapped({
            self.nameTextField.text = ""
            self.clearImageView?.isHidden = true
        })
    }
    @objc func clearNumberTapped(){
        self.clearImageView2?.animationTapped({
            self.numberPhoneTextField.text = ""
            self.clearImageView2?.isHidden = true
        })
        
    }
    @objc func clearAddressTapped(){
        self.clearImageView3?.animationTapped({
            self.addressTextField.text = ""
            self.clearImageView3?.isHidden = true
        })
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
            self.errorMobileLabel =  self.numberPhoneTextField.addBottomLabelErrorMessage(errorMessage , marginLeft: 0)
            return false
        }
        return true
    }
}
