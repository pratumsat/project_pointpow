//
//  ForgotPasswordViewController.swift
//  pointpow
//
//  Created by thanawat on 2/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    var clearImageView:UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-forgotpassword", comment: "")
        
        self.setUp()
    }
   
    func setUp(){
        self.resetButton.borderClearProperties(borderWidth: 1)
        self.resetButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
        if #available(iOS 10.0, *) {
            self.usernameTextField.textContentType = UITextContentType(rawValue: "")
        }
        if #available(iOS 12.0, *) {
            self.usernameTextField.textContentType = .oneTimeCode
        }
        self.usernameTextField.setLeftPaddingPoints(40)
        
        self.usernameTextField.delegate = self
        self.usernameTextField.autocorrectionType = .no
        
        self.clearImageView = self.usernameTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearUserNameTapped))
        self.clearImageView?.isUserInteractionEnabled = true
        self.clearImageView?.addGestureRecognizer(tap)
        self.clearImageView?.isHidden = true
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
        }
        return true
        
    }
    @objc func clearUserNameTapped(){
        self.clearImageView?.alpha = 0
        UIView.animate(withDuration: 0.1) {
            self.clearImageView?.alpha = 1
            self.usernameTextField.text = ""
            self.clearImageView?.isHidden = true
        }
        
    }
    
    @IBAction func resetTapped(_ sender: Any) {
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
