//
//  VerifyMobileNumberViewController.swift
//  pointpow
//
//  Created by thanawat on 10/5/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class VerifyMobileNumberViewController: BaseViewController {

    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var refIDLabel: UILabel!
    
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
        
        
        self.usernameTextField.setLeftPaddingPoints(40)
        self.otpTextField.setLeftPaddingPoints(40)
        
        self.usernameTextField.delegate = self
        self.otpTextField.delegate = self
        
        self.otpTextField.autocorrectionType = .no
        self.usernameTextField.autocorrectionType = .no
        
        if let mobile = self.mobilePhone {
            //let newText = String(mobile.filter({ $0 != "-" }).prefix(10))
            self.usernameTextField.text = mobile
        }
        self.usernameTextField.textColor = UIColor.lightGray
        self.usernameTextField.isEnabled = false
        self.otpTextField.keyboardType = .numberPad
        
        
        if self.ref_id != nil {
            self.refIDLabel?.text = "\(NSLocalizedString("title-forgot-passcode-confirm-ref-otp", comment: "")) \(self.ref_id!)"
            
        }
        
      
        
        self.sendButton.isEnabled = false
        self.updateButton()
        self.removeCountDownLable()
        self.countDown(1.0)
        
    }
    func updateButton(){
        self.sendButton.borderLightGrayColorProperties(borderWidth: 1)
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
        
        if otp.trimmingCharacters(in: .whitespaces).isEmpty{
            print("isEmpty")
            self.showMessagePrompt(NSLocalizedString("string-error-empty-otp", comment: ""))
            return
        }
        
        let params:Parameters = ["ref_id" : self.ref_id ?? "",
                                 "otp" : otp,
                                 "app_os": "ios",
                                 "new_mobile_number" : self.mobilePhone ?? ""]
        
        modelCtrl.verifyOTPNewMobileNumber(params: params, succeeded: { (result) in
            //success
            self.showMessagePrompt2(NSLocalizedString("string-message-success-change-mobile", comment: "")) {
                //ok callback
//                if let security = self.navigationController?.viewControllers[1] as? SecuritySettingViewController {
//                    self.navigationController?.popToViewController(security, animated: false)
//                }
                
                DataController.sharedInstance.clearNotificationArrayOfObjectData()
                DataController.sharedInstance.setToken("")
                Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.reNewApplicationLogin), userInfo: nil, repeats: false)
                
//                self.modelCtrl.logOut(succeeded: { (result) in
//                    Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.reNewApplicationLogin), userInfo: nil, repeats: false)
//                }, error: { (error) in
//                    if let mError = error as? [String:AnyObject]{
//                        let message = mError["message"] as? String ?? ""
//                        print(message)
//                        self.showMessagePrompt(message)
//                    }
//                    print(error)
//                }) { (messageError) in
//                    print("messageError")
//                    self.handlerMessageError(messageError)
//                }
                
            }
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                print(mError)
                let message = mError["message"] as? String ?? ""
                self.showMessagePrompt(message)
            }
        }, failure: { (messageError) in
            self.handlerMessageError(messageError , title: "")
        })
        
    }
    
}
