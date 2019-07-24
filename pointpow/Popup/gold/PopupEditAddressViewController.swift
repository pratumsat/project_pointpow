//
//  PopupEditAddressViewController.swift
//  pointpow
//
//  Created by thanawat on 12/3/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class PopupEditAddressViewController: PopupShippingAddressViewController {
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.cancelButton.borderRedColorProperties(borderWidth: 1)
        
    }
    @IBAction func cancelTapped(_ sender: Any) {
        super.dismissPoPup()
        self.dismiss(animated: true, completion: {
            if self.fromPopup {
                self.nextStep?("showViewAddress" as AnyObject)
            }
        })
    }
    
    @IBAction override func saveTapped(_ sender: Any) {
        
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
            emptyMessage = NSLocalizedString("string-error-empty-firstname-and-lastname", comment: "")
            self.errorNamelLabel =  self.nameTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 0 )
            errorEmpty += 1
        }
        
        
        if errorEmpty > 0 {
            self.showMessagePrompt(NSLocalizedString("string-error-empty-fill", comment: ""))
            return
        }
        
        
        guard validateMobile(mobile) else { return }
        
        
        
       
        let params:Parameters = [
            "title" : "gold",
            "name" : name,
            "address" : address,
            "province_id" : self.provinceId,
            "district_id" : self.districtId,
            "subdistrict_id" : self.subDistrictId,
            "postcode" : postcode
        ]
        print(params)
        
        
        self.modelCtrl.editMemberAddress(params: params, id: self.id, true, succeeded: { (result) in
            print(result)
            self.dismiss(animated: true) {
                self.windowSubview?.removeFromSuperview()
                self.windowSubview = nil
                //self.nextStep?([(address:"test addeess")] as AnyObject)
                self.nextStep?("showViewAddress" as AnyObject)
            }
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
