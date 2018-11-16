//
//  BankPointTransferViewController.swift
//  pointpow
//
//  Created by thanawat on 16/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class BankPointTransferViewController: BaseViewController , UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    @IBOutlet weak var checkBox: CheckBox!
    @IBOutlet weak var balancePointLabel: UILabel!
    
    @IBOutlet weak var addmoreAmountImageView: UIImageView!
    @IBOutlet weak var lessAmountImageView: UIImageView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var transferFromTextField: UITextField!
    @IBOutlet weak var exchangeRateLabel: UILabel!
    @IBOutlet weak var transferButton: UIButton!
    
    
    let providerList = ["A","B","C"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        self.title = NSLocalizedString("string-title-profile-bank-transfer", comment: "")
        self.setUp()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.transferButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        self.checkBox.isChecked = true
        
        self.transferButton.borderClearProperties(borderWidth: 1)
        
        if #available(iOS 10.0, *) {
            self.amountTextField.textContentType = UITextContentType(rawValue: "")
            self.transferFromTextField.textContentType = UITextContentType(rawValue: "")
        }
        if #available(iOS 12.0, *) {
            self.amountTextField.textContentType = .oneTimeCode
            self.transferFromTextField.textContentType = .oneTimeCode
        }
        
        self.transferFromTextField.isUserInteractionEnabled = true
        self.transferFromTextField.tintColor = UIColor.white
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        self.transferFromTextField.inputView = pickerView
        
        
        self.transferFromTextField.delegate = self
        self.amountTextField.delegate = self
        
        self.transferFromTextField.autocorrectionType = .no
        self.amountTextField.autocorrectionType = .no
        
        self.transferFromTextField.autocorrectionType = .no
        self.amountTextField.autocorrectionType = .no
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.providerList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(providerList[row])"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.transferFromTextField.text = "\(providerList[row])"
    }
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        super.textFieldDidBeginEditing(textField)
        
        if textField  == self.transferFromTextField {
            if let frist = self.providerList.first {
                self.transferFromTextField.text = "\(frist)"
                
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField  == self.transferFromTextField {
            return false
        }
        
        return true
    }
    @IBAction func transferTapped(_ sender: Any) {
        self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
    }
}
