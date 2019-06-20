//
//  FavorPopupViewController.swift
//  pointpow
//
//  Created by thanawat on 17/12/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class FavorPopupViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    var clearImageView:UIImageView?
    
    var didSave:(()->Void)?
    var favName:String?
    var mType:String = ""
    var amount:String = ""
    var transaction_ref_id:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.setUp()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        self.windowSubview?.removeFromSuperview()
        self.windowSubview = nil
        
        let params:Parameters = [  "type": self.mType,
                                   "transaction_ref_id": self.transaction_ref_id,
                                   "amount" : self.amount,
                                   "alias": self.nameTextField.text!]
        
        self.modelCtrl.favoriteTransferPoint(params: params , true , succeeded: { (result) in
         
            self.showMessagePrompt2(NSLocalizedString("string-message-success-save-favourite-transfer", comment: ""), okCallback: {
                
                self.dismiss(animated: true) {
                    self.didSave?()
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
