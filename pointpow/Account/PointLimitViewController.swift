//
//  PointLimitViewController.swift
//  pointpow
//
//  Created by thanawat on 10/5/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

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
        self.backgroundImage?.image = nil
        self.saveButton.borderRedColorProperties(borderWidth: 1)
        
        self.pointlimitTextField.delegate = self
        self.pointlimitTextField.autocorrectionType = .no
        
        if let point = self.pointlimit {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            if let iPont = Int(point) {
                self.pointlimitTextField.text = numberFormatter.string(from: NSNumber(value: iPont))
            }
          
        }
    }
   
    
    @IBAction func saveTapped(_ sender: Any) {
        let point = self.pointlimitTextField.text!
        
        if isValidNumber(point) {
            let point = Double(point)!
            if point < 100 {
                self.showMessagePrompt(NSLocalizedString("string-dailog-limit-point-min", comment: ""))
                return
            }
            
        }
        let params:Parameters = ["limit_pay"  : point.replace(target: ",", withString: "")]
        
        self.modelCtrl.memberSetting(params: params, true, succeeded: { (result) in
            print(result)
            
            self.showMessagePrompt2(NSLocalizedString("string-message-success-change-point-limit", comment: "")) {
                //ok callback
                
                if let security = self.navigationController?.viewControllers[1] as? SecuritySettingViewController {
                    self.navigationController?.popToViewController(security, animated: false)
                }
                
            }
            
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                self.showMessagePrompt(message)
            }
            self.refreshControl?.endRefreshing()
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
            self.refreshControl?.endRefreshing()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
        
        if textField == self.pointlimitTextField{
            guard let textRange = Range(range, in: textField.text!) else { return true}
            let updatedText = textField.text!.replacingCharacters(in: textRange, with: string)
            
            if let iPoint = Int(updatedText.replace(target: ",", withString: "")){
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                textField.text = numberFormatter.string(from: NSNumber(value: iPoint))
                return false
            }
            
            
            
        }
        return true
    }

}
