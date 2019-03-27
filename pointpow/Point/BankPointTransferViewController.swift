//
//  BankPointTransferViewController.swift
//  pointpow
//
//  Created by thanawat on 16/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class BankPointTransferViewController: BaseViewController  {
    
    @IBOutlet weak var moreImageView: UIImageView!
    @IBOutlet weak var lessImageView: UIImageView!
    @IBOutlet weak var providerImageView: UIImageView!
    @IBOutlet weak var pointpowImageView: UIImageView!
    
    @IBOutlet weak var balancePointLabel: UILabel!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var exchangeRateView: UIView!
    @IBOutlet weak var exchangeRateLabel: UILabel!
    @IBOutlet weak var transferButton: UIButton!
    
    @IBOutlet weak var exchangeRate2Label: UILabel!
    @IBOutlet weak var exchange2View: UIView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        self.title = NSLocalizedString("string-title-profile-bank-transfer", comment: "")
        self.setUp()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.transferButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
        self.providerImageView.ovalColoLightGrayProperties()
        self.pointpowImageView.ovalColorClearProperties()
        
        self.lessImageView.ovalColorClearProperties()
        self.moreImageView.ovalColorClearProperties()
    }
    
    func setUp(){
        self.handlerEnterSuccess = { (pin) in
            self.showResultTransferView(true) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        
        
        self.backgroundImage?.image = nil
        
        self.exchangeRateView.borderClearProperties(borderWidth: 1, radius: 10)
        self.exchange2View.borderClearProperties(borderWidth: 1)
        self.transferButton.borderClearProperties(borderWidth: 1)
        
        self.amountTextField.borderRedColorProperties(borderWidth: 1)
        self.amountTextField.setRightPaddingPoints(20)
        
      
        
        self.amountTextField.delegate = self
        self.amountTextField.autocorrectionType = .no
        
        
    }

//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return self.providerList.count
//    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return "\(providerList[row])"
//    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        self.transferFromTextField.text = "\(providerList[row])"
//    }
//
//    override func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
//        super.textFieldDidBeginEditing(textField)
//
//        if textField  == self.transferFromTextField {
//            if let frist = self.providerList.first {
//                self.transferFromTextField.text = "\(frist)"
//
//            }
//        }
//    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if textField  == self.transferFromTextField {
//            return false
//        }
//
//        return true
//    }
    @IBAction func transferTapped(_ sender: Any) {
        self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
    }
}
