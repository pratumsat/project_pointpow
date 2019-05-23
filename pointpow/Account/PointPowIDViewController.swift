//
//  PointPowIDViewController.swift
//  pointpow
//
//  Created by thanawat on 23/5/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class PointPowIDViewController: BaseViewController {
    @IBOutlet weak var pointpowIdTextField: UITextField!
    
    @IBOutlet weak var countlimitLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    var clearImageView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-pointpow-id", comment: "")
        self.setUp()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.saveButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        self.saveButton.borderRedColorProperties(borderWidth: 1)
        
        self.pointpowIdTextField.delegate = self
        self.pointpowIdTextField.autocorrectionType = .no
        
        self.clearImageView = self.pointpowIdTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearNameTapped))
        self.clearImageView?.isUserInteractionEnabled = true
        self.clearImageView?.addGestureRecognizer(tap)
        self.clearImageView?.isHidden = true
        
    }
    @objc func clearNameTapped(){
        self.clearImageView?.animationTapped({
            self.pointpowIdTextField.text = ""
            self.clearImageView?.isHidden = true
        })
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func saveTapped(_ sender: Any) {
        let pointpowId = self.pointpowIdTextField.text!
        
        if pointpowId.trimmingCharacters(in: .whitespaces).isEmpty{
            print("isEmpty")
            self.showMessagePrompt(NSLocalizedString("string-error-empty-pointpow-id", comment: ""))
            return
        }
       
        
        self.confirmSavePointPowID() {
            let params:Parameters = ["pointpow_id"  : pointpowId]
            
            self.modelCtrl.memberSetting(params: params, true, succeeded: { (result) in
                print(result)
                
                self.showMessagePrompt2(NSLocalizedString("string-message-success-pointpow-id", comment: "")) {
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
        
        
        
    }
    func confirmSavePointPowID(_ confirmCallback:(()->Void)?){
        
        let alert = UIAlertController(title: NSLocalizedString("string-dailog-title-save-pointpow-id", comment: ""),
                                      message: "", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: NSLocalizedString("string-dailog-button-ok", comment: ""), style: .default, handler: {
            (alert) in
            
            confirmCallback?()
        })
        let cancel = UIAlertAction(title: NSLocalizedString("string-dailog-button-cancel", comment: ""), style: .default, handler: nil)
        
        
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.pointpowIdTextField {
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            if newLength <= 20 {
                self.countlimitLabel.text = "\(newLength)/20"
            }
            if newLength == 0 {
                self.clearImageView?.isHidden = true
            }else{
                self.clearImageView?.isHidden = false
            }
            return newLength <= 20
            
        }
        
        return true
    }

}
