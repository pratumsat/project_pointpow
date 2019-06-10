//
//  DisplayNameViewController.swift
//  pointpow
//
//  Created by thanawat on 16/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class DisplayNameViewController: BaseViewController {
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    
    var displayName:String?{
        didSet{
            print("displayName \(displayName)")
        }
    }
    
    var clearImageView:UIImageView?
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-profile-change-displayname", comment: "")
        self.setUp()
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.confirmButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    
    
    func setUp(){
        self.displayNameTextField.text = displayName
        
        self.backgroundImage?.image = nil
        
        self.confirmButton.borderClearProperties(borderWidth: 1)
        
      
        
        self.displayNameTextField.delegate = self
        
        self.displayNameTextField.autocorrectionType = .no
        
        self.clearImageView = self.displayNameTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearNameTapped))
        self.clearImageView?.isUserInteractionEnabled = true
        self.clearImageView?.addGestureRecognizer(tap)
        self.clearImageView?.isHidden = true
       
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == self.displayNameTextField {
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
           
            if newLength == 0 {
                self.clearImageView?.isHidden = true
            }else{
                self.clearImageView?.isHidden = false
            }
            return newLength <= 20
            
        }
      
        return true
        
    }
    @objc func clearNameTapped(){
        self.clearImageView?.animationTapped({
            self.displayNameTextField.text = ""
            self.clearImageView?.isHidden = true
        })
    }
   

    @IBAction func confirmTapped(_ sender: Any) {
        let displayName = self.displayNameTextField.text!
        
        var errorEmpty = 0
        var emptyMessage = ""
        
        
        
        if displayName.trimmingCharacters(in: .whitespaces).isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-display-name", comment: "")
            errorEmpty += 1
        }
        
        if errorEmpty > 0 {
            self.showMessagePrompt(emptyMessage)
            return
        }
        
        //post displayname
        let params:Parameters = ["display_name"  : displayName]
        
        self.modelCtrl.memberSetting(params: params, true, succeeded: { (result) in
            print(result)
            self.showMessagePrompt2(NSLocalizedString("string-message-success-change-displayname", comment: ""), okCallback: {
                if let profile = self.navigationController?.viewControllers[1] as? ProfileViewController {
                    self.navigationController?.popToViewController(profile, animated: false)
                }
            })
            
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
