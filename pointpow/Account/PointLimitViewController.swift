//
//  PointLimitViewController.swift
//  pointpow
//
//  Created by thanawat on 10/5/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PointLimitViewController: BaseViewController {

    @IBOutlet weak var pointlimitTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var pointlimit:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-point-limit", comment: "")
        self.setUp()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.saveButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    
    func setUp(){
        self.saveButton.borderRedColorProperties(borderWidth: 1)
        
        self.pointlimitTextField.delegate = self
        self.pointlimitTextField.autocorrectionType = .no
        
        if let point = self.pointlimit {
            self.pointlimitTextField.text = point
        }
      
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let point = self.pointlimitTextField.text!
        
        self.showMessagePrompt2(NSLocalizedString("string-message-success-change-point-limit", comment: "")) {
            //ok callback
            
            if let security = self.navigationController?.viewControllers[1] as? SecuritySettingViewController {
                self.navigationController?.popToViewController(security, animated: false)
            }
            
        }
        /*
         let params:Parameters = ["ref_id" : self.ref_id ?? "",
         "otp" : otp,
         "mobile" : self.mobilePhone ?? ""]
         
         modelCtrl.verifyOTP(params: params, succeeded: { (result) in
         if let mResult = result as? [String:AnyObject]{
         print(mResult)
         let access_token  = result["access_token"] as? String ?? ""
         DataController.sharedInstance.setToken(access_token)
         //success
         
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
         */
    }

}
