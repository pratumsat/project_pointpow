//
//  MobileViewController.swift
//  pointpow
//
//  Created by thanawat on 13/12/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class MobileViewController: BaseViewController {

    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var mobileTextField: UITextField!

    var clearImageView:UIImageView?
    
    var mobile:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-profile-change-mobile", comment: "")
        self.setUp()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.confirmButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    
    
    func setUp(){
        if let mobile = self.mobile {
            //let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
            self.mobileTextField.text = mobile
        
        }
       
        
        self.backgroundImage?.image = nil
        
        self.confirmButton.borderClearProperties(borderWidth: 1)
        
     
        
        self.mobileTextField.delegate = self
        
        self.mobileTextField.autocorrectionType = .no
        
        self.clearImageView = self.mobileTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearNameTapped))
        self.clearImageView?.isUserInteractionEnabled = true
        self.clearImageView?.addGestureRecognizer(tap)
        self.clearImageView?.isHidden = true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     
        if textField  == self.mobileTextField {
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
            return newLength <= 10
            
            //Mobile
//            let text = textField.text ?? ""
//            
//            if string.count == 0 {
//                textField.text = String(text.dropLast()).chunkFormatted()
//            }  else {
//                let newText = String((text + string).filter({ $0 != "-" }).prefix(10))
//                textField.text = newText.chunkFormatted()
//            }
//            return false
        }
        
        return true
        
    }
    @objc func clearNameTapped(){
        self.clearImageView?.animationTapped({
            self.mobileTextField.text = ""
            self.clearImageView?.isHidden = true
        })
    }
    
    
    @IBAction func confirmTapped(_ sender: Any) {
        let mobile = self.mobileTextField.text!
        var errorEmpty = 0
        var emptyMessage = ""
        
        if mobile.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-mobile", comment: "")
         
            errorEmpty += 1
        }
        
        if let myMobile = self.mobile {
            
            if mobile == myMobile {
                emptyMessage = NSLocalizedString("string-error-duplicate-mobile", comment: "")
                errorEmpty += 1
            }
        }
        
        
        if errorEmpty > 0 {
            self.showMessagePrompt(emptyMessage)
            return
        }
        
        guard validateMobile(mobile) else { return }
        
        let mobileNumber = mobile.replace(target: "-", withString: "")
        print("mobileNumber = \(mobileNumber)")
        
        let params:Parameters = ["new_mobile_number" : mobileNumber]
        
        self.modelCtrl.changeMobileNumber(params: params, succeeded: { (result) in
            if let mResult = result as? [String: AnyObject] {
                let ref_id = mResult["ref_id"] as? String ?? ""
                let request_id  = mResult["request_id"] as? String ?? ""
                DataController.sharedInstance.setRequestId(request_id)
                
                self.showMobileVerify(mobileNumber, ref_id, true)
                
            }
            
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                print(mError)
                let message = mError["message"] as? String ?? ""
                
                self.handlerMessageError(message , title: "")
            }
        }, failure: { (messageError) in
            self.handlerMessageError(messageError , title: "")
        })
        
        
    }

    func validateMobile(_ mobile:String)-> Bool{
        var errorMobile = 0
        var errorMessage = ""
        
        let nMobile = mobile.replace(target: "-", withString: "")
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
            return false
        }
        return true
    }
}
