//
//  FavorPopupViewController.swift
//  pointpow
//
//  Created by thanawat on 17/12/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class FavorPopupViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    var clearImageView:UIImageView?
    
    var didSave:(()->Void)?
    var favName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.setUp()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        self.windowSubview?.removeFromSuperview()
        self.windowSubview = nil
        
        self.dismiss(animated: true) {
            self.didSave?()
        }
    }
    
    override func dismissPoPup() {
        super.dismissPoPup()
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCloseBlackView()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.saveButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    
    func setUp(){
        if let _ = self.favName {
            titleLabel.text = NSLocalizedString("string-dailog-title-edit-favorite", comment: "")
        }else{
            titleLabel.text = NSLocalizedString("string-dailog-title-add-favorite", comment: "")
        }
        self.nameTextField.text = self.favName
        
        self.backgroundImage?.image = nil
        
        self.saveButton.borderClearProperties(borderWidth: 1)
        
        if #available(iOS 10.0, *) {
            self.nameTextField.textContentType = UITextContentType(rawValue: "")
           
        }
        if #available(iOS 12.0, *) {
            self.nameTextField.textContentType = .oneTimeCode
           
        }
        
        
        self.nameTextField.delegate = self
        
        self.nameTextField.autocorrectionType = .no
       
        
        self.clearImageView = self.nameTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearNameTapped))
        self.clearImageView?.isUserInteractionEnabled = true
        self.clearImageView?.addGestureRecognizer(tap)
        self.clearImageView?.isHidden = true
     
        
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
        }
     
        return true
        
    }
    @objc func clearNameTapped(){
        self.clearImageView?.animationTapped({
            self.nameTextField.text = ""
            self.clearImageView?.isHidden = true
        })
    }
   
}
