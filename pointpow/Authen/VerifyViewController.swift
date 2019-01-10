//
//  VerifyViewController.swift
//  pointpow
//
//  Created by thanawat on 5/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class VerifyViewController: BaseViewController {
    @IBOutlet weak var verifyButton: UIButton!
   
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var clearImageView:UIImageView?
    
     var errorOTPlLabel:UILabel?
    var countDown:Int = 60
    var timer:Timer?
    
    var ref_id:String?
    var member_id:String?
    var mobilePhone:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("string-title-verify", comment: "")
        self.setUp()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.verifyButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeCountDownLable()
    }
    func setUp(){
        self.sendButton.borderRedColorProperties(borderWidth: 1)  
        self.verifyButton.borderClearProperties(borderWidth: 1)
        
        
        if #available(iOS 10.0, *) {
            self.usernameTextField.textContentType = UITextContentType(rawValue: "")
            self.otpTextField.textContentType = UITextContentType(rawValue: "")
        }
        if #available(iOS 12.0, *) {
            self.usernameTextField.textContentType = .oneTimeCode
            self.otpTextField.textContentType = .oneTimeCode
        }
        self.usernameTextField.setLeftPaddingPoints(40)
        self.otpTextField.setLeftPaddingPoints(40)
        
        self.usernameTextField.delegate = self
        self.otpTextField.delegate = self
        
        self.otpTextField.autocorrectionType = .no
        self.usernameTextField.autocorrectionType = .no
        
        if let mobile = self.mobilePhone {
            let newText = String(mobile.filter({ $0 != "-" }).prefix(10))
            self.usernameTextField.text = newText.chunkFormatted()
        }
        self.usernameTextField.isEnabled = false
        self.otpTextField.keyboardType = .numberPad
        

        self.clearImageView = self.usernameTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearUserNameTapped))
        self.clearImageView?.isUserInteractionEnabled = true
        self.clearImageView?.addGestureRecognizer(tap)
        self.clearImageView?.isHidden = true
        
        
        self.sendButton.isEnabled = false
        self.countDown(1.0)
        
    }
    func updateButton(){
        self.sendButton.borderLightGrayColorProperties(borderWidth: 1)
        self.sendButton.addSpacingCharacters(0,  title: "\(countDown)", color: UIColor.lightGray)
        
    }
    func resetButton(){
        self.sendButton.borderRedColorProperties(borderWidth: 1)
        self.sendButton.addSpacingCharacters(0,  title: NSLocalizedString("string-button-re-send", comment: ""),
                                             color: Constant.Colors.PRIMARY_COLOR)
        self.sendButton.isEnabled = true
    }
    func countDown(_ time: Double){
        timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountDown() {
        if(countDown > 0) {
            countDown -= 1
            self.updateButton()
        } else {
            self.resetButton()
            self.removeCountDownLable()
        }
    }
    func removeCountDownLable() {
        //finish
        countDown = 60
        timer?.invalidate()
        timer = nil
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField  == self.usernameTextField {
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
            
            let text = textField.text ?? ""
            
            if string.count == 0 {
                textField.text = String(text.dropLast()).chunkFormatted()
            }  else {
                let newText = String((text + string).filter({ $0 != "-" }).prefix(10))
                textField.text = newText.chunkFormatted()
            }
            return false
            
        }
        return true
        
    }
    
    @objc func clearUserNameTapped(){
        self.clearImageView?.animationTapped({
            self.usernameTextField.text = ""
            self.clearImageView?.isHidden = true
        })
        
    }
    
   
    @IBAction func sendTapped(_ sender: Any) {
        self.sendButton.isEnabled = false
        self.countDown(1.0)
    }
    @IBAction func verifyTapped(_ sender: Any) {
        let otp = self.otpTextField.text!
        
        self.errorOTPlLabel?.removeFromSuperview()

        let params:Parameters = ["ref_id" : self.ref_id ?? "",
                                 "otp" : otp,
                                 "member_id" : self.member_id ?? ""]
        
        modelCtrl.verifyOTP(params: params, succeeded: { (result) in
            if let mResult = result as? [String:AnyObject]{
                print(mResult)
                
                
                self.showRegisterSuccessPopup(true , nextStepCallback: {
                    self.showLogin(true)
                })
            }
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                print(mError)
                let message = mError["message"] as? String ?? ""
                self.errorOTPlLabel = self.otpTextField.addBottomLabelErrorMessage(message, marginLeft: 15)
                self.showMessagePrompt(message)
            }
        }, failure: { (messageError) in
            self.handlerMessageError(messageError , title: "")
        })
        
//        let errorMessage = NSLocalizedString("string-error-otp", comment: "")
//        self.errorOTPlLabel = self.otpTextField.addBottomLabelErrorMessage(errorMessage, marginLeft: 15)
//        self.showMessagePrompt(errorMessage)
    }
    
   

}
