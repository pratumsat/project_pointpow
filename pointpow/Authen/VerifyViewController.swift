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
    
    @IBOutlet weak var refIDLabel: UILabel!
    var clearImageView:UIImageView?
    
    var countDown:Int = 60
    var timer:Timer?
    
    var ref_id:String?{
        didSet{
            if self.ref_id != nil {
                self.refIDLabel?.text = "\(NSLocalizedString("title-forgot-passcode-confirm-ref-otp", comment: "")) \(self.ref_id!)"
                
            }
            
        }
    }
   
    var mobilePhone:String?
    var register:Bool = false
    
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
        self.hendleSetPasscodeSuccess = { (passcode, controller) in
            
            let message = NSLocalizedString("string-register-pincode-success", comment: "")
            let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: NSLocalizedString("string-button-ok", comment: ""), style: .cancel, handler: { (action) in
                
                controller.dismiss(animated: false, completion: { () in
                    self.dismiss(animated: false, completion: {
                        (self.navigationController as? IntroNav)?.callbackFinish?()
                    })
                })
            })
            alert.addAction(ok)
            alert.show()
        }
        
        self.sendButton.borderRedColorProperties(borderWidth: 1)  
        self.verifyButton.borderClearProperties(borderWidth: 1)
        
  
        self.usernameTextField.setLeftPaddingPoints(40)
        self.otpTextField.setLeftPaddingPoints(40)
        
        self.usernameTextField.delegate = self
        self.otpTextField.delegate = self
        
        self.otpTextField.autocorrectionType = .no
        self.usernameTextField.autocorrectionType = .no
        
        if let mobile = self.mobilePhone {
            //let newText = String(mobile.filter({ $0 != "-" }).prefix(10))
            //self.usernameTextField.text = newText.chunkFormatted()
            self.usernameTextField.text = mobile
        }
        self.usernameTextField.textColor = UIColor.lightGray
        self.usernameTextField.isEnabled = false
        self.otpTextField.keyboardType = .numberPad
        

        if self.ref_id != nil {
            self.refIDLabel?.text = "\(NSLocalizedString("title-forgot-passcode-confirm-ref-otp", comment: "")) \(self.ref_id!)"
            
        }
        
        self.clearImageView = self.usernameTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearUserNameTapped))
        self.clearImageView?.isUserInteractionEnabled = true
        self.clearImageView?.addGestureRecognizer(tap)
        self.clearImageView?.isHidden = true
        
        
        self.sendButton.isEnabled = false
        self.updateButton()
        self.removeCountDownLable()
        self.countDown(1.0)
        
    }
    func updateButton(){
        self.sendButton.borderLightGrayColorProperties(borderWidth: 1)
     
//        if forgotPassword {
//            self.sendButton.setTitle("\(prodTimeString(time: TimeInterval(countDown)) )", for: .normal)
//        }else{
//            self.sendButton.setTitle("\(countDown)", for: .normal)
//        }
        self.sendButton.setTitle("\(countDown)", for: .normal)
        self.sendButton.setTitleColor(UIColor.lightGray, for: .normal)
        
    }
    private func prodTimeString(time: TimeInterval) -> String {
        let prodMinutes = Int(time) / 60 % 60
        let prodSeconds = Int(time) % 60
        
        return String(format: "%02d:%02d", prodMinutes, prodSeconds)
    }
    func resetButton(){
        self.sendButton.borderGreen2ColorProperties(borderWidth: 1)
        self.sendButton.setTitle(NSLocalizedString("string-button-re-send", comment: ""), for: .normal)
        self.sendButton.setTitleColor(Constant.Colors.GREEN2, for: .normal)
        self.sendButton.isEnabled = true
    }
    func countDown(_ time: Double){
        timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
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
            return newLength <= 10
            
            
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
        
        let params:Parameters = ["mobile" : mobilePhone ?? "",
                                 "request_id": DataController.sharedInstance.getRequestId()]
        
        modelCtrl.resendOTP(params: params, succeeded: { (result) in
            if let mResult = result as? [String:AnyObject]{
                print(mResult)
                
                if let mResult = result as? [String:AnyObject]{
                    print(mResult)
                    let ref_id = mResult["ref_id"] as? String ?? ""
                    self.ref_id = ref_id
                   
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
        
        
    }
    @IBAction func verifyTapped(_ sender: Any) {
        let otp = self.otpTextField.text!
        //self.errorOTPlLabel?.removeFromSuperview()

        if otp.trimmingCharacters(in: .whitespaces).isEmpty{
            print("isEmpty")
            self.showMessagePrompt(NSLocalizedString("string-error-empty-otp", comment: ""))
            return
        }
        
        
        
       let params:Parameters = [ "ref_id" : self.ref_id ?? "",
                                 "otp" : otp,
                                 "app_os" : "ios"]

        modelCtrl.verifyOTP(params: params, succeeded: { (result) in
            if let mResult = result as? [String:AnyObject]{
                print(mResult)
                
                let access_token  = mResult["access_token"] as? String ?? ""
                //let reset_token  = mResult["reset_token"] as? String ?? ""
                let member = mResult["member"] as? [String:AnyObject] ?? [:]
                let is_profile = member["is_profile"] as? NSNumber ?? 0
                let is_pin = member["is_pin"] as? NSNumber ?? 0
                
                /* Forgotpassword
                 DataController.sharedInstance.setResetPasswordToken(reset_token)
                 self.showResetPasswordView(true, forgotPassword: true)
                 */
                
                DataController.sharedInstance.setToken(access_token)
                
                if self.register {
                    if !is_profile.boolValue && !is_pin.boolValue {
                        self.showPersonalData(true){
                            self.dismiss(animated: false, completion: {
                                (self.navigationController as? IntroNav)?.callbackFinish?()
                            })
                        }
                    }else{
                        if !is_pin.boolValue {
                            self.showSettingPassCodeModalView(NSLocalizedString("title-set-passcode", comment: ""), lockscreen: true)

                        }else{
                            self.dismiss(animated: false, completion: {
                                (self.navigationController as? IntroNav)?.callbackFinish?()
                            })
                        }
                    }
                }else{
                    if !is_pin.boolValue {
                        self.showSettingPassCodeModalView(NSLocalizedString("title-set-passcode", comment: ""), lockscreen: true)

                    }else{
                        self.dismiss(animated: false, completion: {
                            (self.navigationController as? IntroNav)?.callbackFinish?()
                        })
                    }
                    
                    
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
 
        
    }
    
   

}
