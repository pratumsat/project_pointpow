//
//  ShoppingAddTaxInvoiceAddressViewController.swift
//  pointpow
//
//  Created by thanawat on 20/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class ShoppingAddTaxInvoiceAddressViewController:BaseViewController ,UIPickerViewDelegate , UIPickerViewDataSource {
    
   
    @IBOutlet weak var personalTextField: UITextField!
    @IBOutlet weak var shippingProductImageView: UIImageView!
    @IBOutlet weak var shippingTaxImageView: UIImageView!
    @IBOutlet weak var postCodeTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var subDistrictTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var numberPhoneTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var shippingProductView: UIView!
    @IBOutlet weak var shippingTaxView: UIView!
    
    var clearImageView:UIImageView?
    var clearImageView2:UIImageView?
    var clearImageView3:UIImageView?
    var clearImageView4:UIImageView?
    
    var errorNamelLabel:UILabel?
    var errorAddressLabel:UILabel?
    var errorMobileLabel:UILabel?
    var errorDistrictLabel:UILabel?
    var errorSubDistrictLabel:UILabel?
    var errorProvinceLabel:UILabel?
    var errorPostCodeLabel:UILabel?
    var errorPersonalIDLabel:UILabel?
    
    var provincePickerView:UIPickerView?
    var districtPickerView:UIPickerView?
    var subDistrictPickerView:UIPickerView?
    
    var provinces:[[String:AnyObject]]?
    var districts:[[String:AnyObject]]?
    var subDistricts:[[String:AnyObject]]?
    var userData:AnyObject? {
        didSet{
            self.updateDataIdle()
        }
    }
    
    func updateDataWithShippingAddress(){
        if let data = self.modelDuplicateAddress as? [String: AnyObject] {
            let id = data["id"] as? NSNumber ?? 0
            let address = data["address"] as? String ?? ""
            let districtName = data["district"]?["name_in_thai"] as? String ?? ""
            let subdistrictName = data["subdistrict"]?["name_in_thai"] as? String ?? ""
            let provinceName = data["province"]?["name_in_thai"] as? String ?? ""
            let zip_code = data["subdistrict"]?["zip_code"] as? NSNumber ?? 0
            
            let idDistrict = data["district"]?["id"] as? NSNumber ?? 0
            let idSubdistrict = data["subdistrict"]?["id"] as? NSNumber ?? 0
            let idProvince = data["province"]?["id"] as? NSNumber ?? 0
            
            let name = data["name"] as? String ?? ""
            let mobile = data["mobile"]as? String ?? ""
            let tax_invoice = data["tax_invoice"]as? String ?? ""
            
            
            let newText = String((tax_invoice).filter({ $0 != "-" }).prefix(13))
            
            
            
            self.personalTextField.text = newText.chunkFormattedPersonalID()
            self.nameTextField.text = name
            self.numberPhoneTextField.text = mobile
            self.addressTextField.text = address
            self.districtTextField.text = districtName
            self.subDistrictTextField.text = subdistrictName
            self.provinceTextField.text = provinceName
            self.postCodeTextField.text = "\(zip_code)"
            
            self.provinceId = idProvince.intValue
            self.districtId = idDistrict.intValue
            self.subDistrictId = idSubdistrict.intValue
            
            self.id = id.intValue
            
            
            
            getDistrict(idProvince.intValue) {
                self.districtPickerView = UIPickerView()
                self.districtPickerView!.delegate = self
                self.districtPickerView!.dataSource = self
                
                self.districtTextField.isEnabled = true
                self.districtTextField.tintColor = UIColor.clear
                self.districtTextField.isUserInteractionEnabled = true
                self.districtTextField.inputView = self.districtPickerView
                
                
            }
            
            getSubDistrict(idDistrict.intValue) {
                self.subDistrictPickerView = UIPickerView()
                self.subDistrictPickerView!.delegate = self
                self.subDistrictPickerView!.dataSource = self
                
                self.subDistrictTextField.isEnabled = true
                self.subDistrictTextField.tintColor = UIColor.clear
                self.subDistrictTextField.isUserInteractionEnabled = true
                self.subDistrictTextField.inputView = self.subDistrictPickerView
                
            }
            
        }
    }
    func updateDataWithTaxAddress(){
        if let data = self.modelAddress as? [String: AnyObject] {
            let id = data["id"] as? NSNumber ?? 0
            let address = data["address"] as? String ?? ""
            let districtName = data["district"]?["name_in_thai"] as? String ?? ""
            let subdistrictName = data["subdistrict"]?["name_in_thai"] as? String ?? ""
            let provinceName = data["province"]?["name_in_thai"] as? String ?? ""
            let zip_code = data["subdistrict"]?["zip_code"] as? NSNumber ?? 0
            
            let idDistrict = data["district"]?["id"] as? NSNumber ?? 0
            let idSubdistrict = data["subdistrict"]?["id"] as? NSNumber ?? 0
            let idProvince = data["province"]?["id"] as? NSNumber ?? 0
            
            let name = data["name"] as? String ?? ""
            let mobile = data["mobile"]as? String ?? ""
            let tax_invoice = data["tax_invoice"]as? String ?? ""
            let invoice_shipping = data["invoice_shipping"]as? String ?? ""
            
            let newText = String((tax_invoice).filter({ $0 != "-" }).prefix(13))
            
            self.invoice_shipping = invoice_shipping
            
            self.personalTextField.text = newText.chunkFormattedPersonalID()
            self.nameTextField.text = name
            self.numberPhoneTextField.text = mobile
            self.addressTextField.text = address
            self.districtTextField.text = districtName
            self.subDistrictTextField.text = subdistrictName
            self.provinceTextField.text = provinceName
            self.postCodeTextField.text = "\(zip_code)"
            
            self.provinceId = idProvince.intValue
            self.districtId = idDistrict.intValue
            self.subDistrictId = idSubdistrict.intValue
            
            self.id = id.intValue
            
            
            getDistrict(idProvince.intValue) {
                self.districtPickerView = UIPickerView()
                self.districtPickerView!.delegate = self
                self.districtPickerView!.dataSource = self
                
                self.districtTextField.isEnabled = true
                self.districtTextField.tintColor = UIColor.clear
                self.districtTextField.isUserInteractionEnabled = true
                self.districtTextField.inputView = self.districtPickerView
                
                
            }
            
            getSubDistrict(idDistrict.intValue) {
                self.subDistrictPickerView = UIPickerView()
                self.subDistrictPickerView!.delegate = self
                self.subDistrictPickerView!.dataSource = self
                
                self.subDistrictTextField.isEnabled = true
                self.subDistrictTextField.tintColor = UIColor.clear
                self.subDistrictTextField.isUserInteractionEnabled = true
                self.subDistrictTextField.inputView = self.subDistrictPickerView
                
            }
            
        }
    }
    func updateDataIdle(){
        if let data  = self.userData as? [String:AnyObject] {
            let first_name = data["first_name"] as? String ?? ""
            let last_name = data["last_name"]as? String ?? ""
            let mobile = data["mobile"]as? String ?? ""
            let pid = data["pid"]as? String ?? ""
            
            if self.modelAddress != nil  {
                // is address
            }else if self.modelDuplicateAddress != nil {
                // is duplicate
            }else{
                // idle
                self.nameTextField.text = "\(first_name) \(last_name)"
                self.numberPhoneTextField.text = mobile
                let newText = String((pid).filter({ $0 != "-" }).prefix(13))
                self.personalTextField.text = newText.chunkFormattedPersonalID()
                
                
                self.addressTextField.text = ""
                self.districtTextField.text = ""
                self.subDistrictTextField.text = ""
                self.provinceTextField.text = ""
                self.postCodeTextField.text = ""
                
                self.provinceId = 0
                self.districtId = 0
                self.subDistrictId = 0
                self.selectedProvinceId = 0
                self.selectedDistrictId = 0
                self.selectedSubDistrictId = 0
            }
            
            
            
        }
    }
    
    
    var language = "th"
    
    var modelAddress:AnyObject?
    var modelDuplicateAddress:AnyObject?
    var fromPopup = false
    
    var id:Int = 0
    var provinceId:Int = 0
    var districtId:Int = 0
    var subDistrictId:Int = 0
    
    var selectedProvinceId:Int = 0 {
        didSet{
            //will nexstep load district
            getDistrict(selectedProvinceId) {
                self.districtPickerView = UIPickerView()
                self.districtPickerView!.delegate = self
                self.districtPickerView!.dataSource = self
                
                self.districtTextField.isEnabled = true
                self.districtTextField.tintColor = UIColor.clear
                self.districtTextField.isUserInteractionEnabled = true
                self.districtTextField.inputView = self.districtPickerView
                
                self.districtTextField.text = ""
                self.subDistrictTextField.text = ""
                self.postCodeTextField.text = ""
            }
        }
    }
    var selectedDistrictId:Int = 0 {
        didSet{
            
            getSubDistrict(selectedDistrictId) {
                self.subDistrictPickerView = UIPickerView()
                self.subDistrictPickerView!.delegate = self
                self.subDistrictPickerView!.dataSource = self
                
                
                self.subDistrictTextField.isEnabled = true
                self.subDistrictTextField.tintColor = UIColor.clear
                self.subDistrictTextField.isUserInteractionEnabled = true
                self.subDistrictTextField.inputView = self.subDistrictPickerView
                
                self.subDistrictTextField.text = ""
                self.postCodeTextField.text = ""
            }
            
        }
    }
    var selectedSubDistrictId:Int = 0 {
        didSet{
            
        }
    }
    
    var invoice_shipping = "no" {
        didSet{
            if invoice_shipping.lowercased() == "yes" {
                self.shippingProductImageView?.image = UIImage(named: "ic-choose-1")
                self.shippingTaxImageView?.image = UIImage(named: "ic-choose-2")
                
                if modelAddress == nil {
                    if let data  = self.userData as? [String:AnyObject] {
                        let first_name = data["first_name"] as? String ?? ""
                        let last_name = data["last_name"]as? String ?? ""
                        let mobile = data["mobile"]as? String ?? ""
                        let pid = data["pid"]as? String ?? ""
                        
                        self.nameTextField.text = "\(first_name) \(last_name)"
                        self.numberPhoneTextField.text = mobile
                        let newText = String((pid).filter({ $0 != "-" }).prefix(13))
                        self.personalTextField.text = newText.chunkFormattedPersonalID()
                        
                        
                        self.addressTextField.text = ""
                        self.districtTextField.text = ""
                        self.subDistrictTextField.text = ""
                        self.provinceTextField.text = ""
                        self.postCodeTextField.text = ""
                        
                        self.provinceId = 0
                        self.districtId = 0
                        self.subDistrictId = 0
                        self.selectedProvinceId = 0
                        self.selectedDistrictId = 0
                        self.selectedSubDistrictId = 0
                    }
                    
                }
                
                
            }else{
                self.shippingProductImageView?.image = UIImage(named: "ic-choose-2")
                self.shippingTaxImageView?.image = UIImage(named: "ic-choose-1")
                
                self.updateDataWithShippingAddress()
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("string-title-invoice-address", comment: "")
        
        self.language = L102Language.currentAppleLanguage()
        
        self.setUp()
        
        self.getProvinces(){
            self.provincePickerView = UIPickerView()
            self.provincePickerView!.delegate = self
            self.provincePickerView!.dataSource = self
            
            self.provinceTextField.tintColor = UIColor.clear
            self.provinceTextField.isUserInteractionEnabled = true
            self.provinceTextField.inputView = self.provincePickerView
        }
        
        
        
        if let _ = self.modelAddress as? [String: AnyObject] {
            self.updateDataWithTaxAddress()
           // self.showFormView()
           
        }else  if let _ = self.modelDuplicateAddress as? [String: AnyObject] {
            self.updateDataWithShippingAddress()
          //  self.hiddenFormView()
        }
        getUserInfo(){
            //success
        }
        
    }
   
    
    func setUp(){
        self.backgroundImage?.image = nil
        
        self.nextButton.borderClearProperties(borderWidth: 1)
        
        
        self.personalTextField.delegate = self
        self.personalTextField.autocorrectionType = .no
        
        self.nameTextField.delegate = self
        self.numberPhoneTextField.delegate = self
        self.addressTextField.delegate = self
        
        self.provinceTextField.delegate = self
        self.districtTextField.delegate = self
        self.subDistrictTextField.delegate = self
        
        self.provinceTextField.isEnabled = true
        self.districtTextField.isEnabled = false
        self.subDistrictTextField.isEnabled = false
        self.postCodeTextField.isEnabled = false
        
        self.provinceTextField.addDoneButtonToKeyboard()
        self.districtTextField.addDoneButtonToKeyboard()
        self.subDistrictTextField.addDoneButtonToKeyboard()
        
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
        
        self.clearImageView4 = self.personalTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(clearPersonalTapped))
        self.clearImageView4?.isUserInteractionEnabled = true
        self.clearImageView4?.addGestureRecognizer(tap4)
        self.clearImageView4?.isHidden = true
        
        
        let shippingProduct = UITapGestureRecognizer(target: self, action: #selector(productTapped))
        self.shippingProductView?.isUserInteractionEnabled = true
        self.shippingProductView?.addGestureRecognizer(shippingProduct)
        
        let shippingInvoice = UITapGestureRecognizer(target: self, action: #selector(invoiceTapped))
        self.shippingTaxView?.isUserInteractionEnabled = true
        self.shippingTaxView?.addGestureRecognizer(shippingInvoice)
        
    }
    
    
    @objc func invoiceTapped(){
        self.invoice_shipping = "yes"
    }
    @objc func productTapped(){
        self.invoice_shipping = "no"
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
    
    func getProvinces(_ avaliable:(()->Void)? = nil){
        modelCtrl.getProvince(params: nil , false , succeeded: { (result) in
            print("get premium success")
            
            if let data = result as? [[String:AnyObject]]{
                self.provinces = data
            }
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
    func getDistrict(_ id:Int, _ avaliable:(()->Void)? = nil){
        
        modelCtrl.getDistrict(params: nil ,id: id, false , succeeded: { (result) in
            print("get premium success")
            
            if let data = result as? [[String:AnyObject]]{
                self.districts = data
            }
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
    func getSubDistrict(_ id:Int, _ avaliable:(()->Void)? = nil){
        modelCtrl.getSubDistrict(params: nil ,id: id, false , succeeded: { (result) in
            print("get premium success")
            
            if let data = result as? [[String:AnyObject]]{
                self.subDistricts = data
            }
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.provincePickerView{
            return self.provinces?.count ?? 0
        }
        if pickerView == self.districtPickerView{
            return self.districts?.count ?? 0
        }
        if pickerView == self.subDistrictPickerView{
            return self.subDistricts?.count ?? 0
        }
        return 1
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.provincePickerView{
            return self.getValueFromLanguage(self.provinces?[row])
        }
        
        if pickerView == self.districtPickerView{
            return self.getValueFromLanguage(self.districts?[row])
        }
        if pickerView == self.subDistrictPickerView{
            return self.getValueFromLanguage(self.subDistricts?[row])
        }
        
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.provincePickerView{
            self.selectedProvinceId = self.getIdFromLanguage(self.provinces?[row])
            self.provinceId = self.getIdFromLanguage(self.provinces?[row])
            self.provinceTextField.text = self.getValueFromLanguage(self.provinces?[row])
        }
        if pickerView == self.districtPickerView{
            self.selectedDistrictId = self.getIdFromLanguage(self.districts?[row])
            self.districtId = self.getIdFromLanguage(self.districts?[row])
            self.districtTextField.text = self.getValueFromLanguage(self.districts?[row])
        }
        if pickerView == self.subDistrictPickerView{
            self.selectedSubDistrictId = self.getIdFromLanguage(self.subDistricts?[row])
            self.subDistrictId = self.getIdFromLanguage(self.subDistricts?[row])
            self.subDistrictTextField.text = self.getValueFromLanguage(self.subDistricts?[row])
            self.postCodeTextField.text = (self.subDistricts?[row]["zip_code"] as? NSNumber)?.stringValue ?? ""
        }
    }
    override func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        super.textFieldDidBeginEditing(textField)
        
        if textField  == self.provinceTextField {
            if textField.text!.isEmpty {
                if let first = self.provinces?.first {
                    self.selectedProvinceId = self.getIdFromLanguage(first)
                    self.provinceId = self.getIdFromLanguage(first)
                    self.provinceTextField.text = self.getValueFromLanguage(first)
                }
            }
        }
        if textField  == self.districtTextField {
            if textField.text!.isEmpty {
                if let first = self.districts?.first {
                    self.selectedDistrictId = self.getIdFromLanguage(first)
                    self.districtId = self.getIdFromLanguage(first)
                    self.districtTextField.text = self.getValueFromLanguage(first)
                }
            }
        }
        if textField  == self.subDistrictTextField {
            if textField.text!.isEmpty {
                if let first = self.subDistricts?.first {
                    self.selectedSubDistrictId = self.getIdFromLanguage(first)
                    self.subDistrictId = self.getIdFromLanguage(first)
                    self.subDistrictTextField.text = self.getValueFromLanguage(first)
                    self.postCodeTextField.text = (first["zip_code"] as? NSNumber)?.stringValue ?? ""
                }
            }
        }
    }
    
    func getIdFromLanguage(_ item:[String:AnyObject]?) -> Int {
        return (item?["id"] as? NSNumber)?.intValue ?? 0
    }
    func getValueFromLanguage(_ item:[String:AnyObject]?) -> String {
        
        var province = ""
        if language == "en"{
            province = item?["name_in_english"] as? String ?? ""
        }else{
            province =  item?["name_in_thai"] as? String ?? ""
        }
        return province
    }
    func PopToCartViewController(){
        if let vcs = self.navigationController?.viewControllers {
            var i = 0
            for item in vcs {
                if item is CartViewController {
                    self.navigationController?.popToViewController((self.navigationController?.viewControllers[i])!, animated: true)
                    
                    return
                }
                i += 1
            }
        }
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        errorPersonalIDLabel?.removeFromSuperview()
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
        let personalID = self.personalTextField.text!
        
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
        
        if personalID.trimmingCharacters(in: .whitespaces).isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-personal-id", comment: "")
            self.errorPersonalIDLabel =  self.personalTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0)
            errorEmpty += 1
            
        }
        if name.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-firstname-and-lastname", comment: "")
            self.errorNamelLabel =  self.nameTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            errorEmpty += 1
        }
        
        if errorEmpty > 0 {
            self.showMessagePrompt(NSLocalizedString("string-error-empty-fill", comment: ""))
            return
        }
        
        
        guard validateMobile(mobile) else { return }
        guard validateIDcard(personalID) else { return }
        self.confirmAddAddress {
            
            let params:Parameters = [
                "title" : "invoice",
                "name" : name,
                "address" : address,
                "province_id" : self.provinceId,
                "district_id" : self.districtId,
                "subdistrict_id" : self.subDistrictId,
                "postcode" : postcode,
                "tax_invoice": personalID.replace(target: "-", withString: ""),
                "company" : "",
                "mobile": mobile.replace(target: "-", withString: "-"),
                "type" : "invoice",
                "invoice_shipping" : self.invoice_shipping
            ]
            print(params)
            
            
            if self.modelAddress != nil {
                self.modelCtrl.editMemberAddress(params: params, id: self.id, true, succeeded: { (result) in
                    print(result)
                   
                    self.PopToCartViewController()
                    
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
            }else{
                self.modelCtrl.createMemberAddress(params: params, true, succeeded: { (result) in
                    print(result)
                    
                    self.PopToCartViewController()
                    
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

            
        }
        
       
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
            
            if string.trimmingCharacters(in: .whitespaces).isEmpty {
                return true
            }
            
            if isValidName(string) {
                return true
            }else{
                return false
            }
        }
        if textField  == self.personalTextField {
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
            return newLength <= 10
            
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
    @objc func clearPersonalTapped(){
        self.clearImageView4?.animationTapped({
            self.personalTextField.text = ""
            self.clearImageView4?.isHidden = true
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = self.modelDuplicateAddress {
            self.personalTextField.becomeFirstResponder()
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.nextButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    
    func confirmAddAddress(_ confirm:(()->Void)? = nil) {
        let dTitle = NSLocalizedString("string-item-shopping-confirm-add-address", comment: "")
        //let message = NSLocalizedString("string-item-shopping-cart-delete-message", comment: "")
        let alert = UIAlertController(title: dTitle,
                                      message: "", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-ok", comment: ""), style: .default, handler: {
            (alert) in
            
            confirm?()
            
        })
        let cancelButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-cancel", comment: ""), style: .default, handler: { (alert) in
            
            
        })
        
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion: nil)
        
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
        if nMobile == "0000000000" {
            errorMessage = NSLocalizedString("string-error-invalid-mobile", comment: "")
            errorMobile += 1
        }
        if errorMobile > 0 {
            
            self.showMessagePrompt(errorMessage)
            self.errorMobileLabel =  self.numberPhoneTextField.addBottomLabelErrorMessage(errorMessage , marginLeft: 0)
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
            self.errorPersonalIDLabel =  self.personalTextField.addBottomLabelErrorMessage(errorMessage , marginLeft: 0)
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == self.addressTextField {
            self.provinceTextField.becomeFirstResponder()
        }
        if textField == self.provinceTextField {
            self.districtTextField.becomeFirstResponder()
        }
        if textField == self.districtTextField {
            self.subDistrictTextField.becomeFirstResponder()
        }
        if textField == self.subDistrictTextField {
            self.postCodeTextField.becomeFirstResponder()
        }
        
        return true
    }
}
