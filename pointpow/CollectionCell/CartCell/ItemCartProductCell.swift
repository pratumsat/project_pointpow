//
//  ItemCartProductCell.swift
//  pointpow
//
//  Created by thanawat on 3/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ItemCartProductCell: UICollectionViewCell ,UITextFieldDelegate{

    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var checkBox: CheckBoxRed!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var moreImageView: UIImageView!
    @IBOutlet weak var lessImageView: UIImageView!
    @IBOutlet weak var checkSpaceView: UIView!
    
    var checkCallback:((_ isCheck:Bool)->Void)?
    var callBackTotalPrice:((_ amount:Int, _ totalPrice:Double)->Void)?
    var priceOfProduct:Double?
    
    var maxAmount = 1 {
        didSet{
            if maxAmount == 1 {
                disableImageView(lessImageView)
                disableImageView(moreImageView)
            }
        }
    }
    var amount:Int = 1 {
        didSet{
            self.amountTextField.text = "\(Int(amount))"
            
            if amount > 1 {
                enableImageView(lessImageView)
            }
            
            if amount >= maxAmount {
                disableImageView(moreImageView)
            }else{
                enableImageView(moreImageView)
            }
        }
    }
    var isCheck = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        
        let less = UITapGestureRecognizer(target: self, action: #selector(lessPointTapped))
        self.lessImageView.isUserInteractionEnabled = true
        self.lessImageView.addGestureRecognizer(less)
        
        
        let more = UITapGestureRecognizer(target: self, action: #selector(morePointTapped))
        self.moreImageView.isUserInteractionEnabled = true
        self.moreImageView.addGestureRecognizer(more)
        
        self.amountTextField.delegate = self
        self.amountTextField.autocorrectionType = .no
        self.amountTextField.text = "1"
        
        let check = UITapGestureRecognizer(target: self, action: #selector(checkTapped))
        self.checkSpaceView.isUserInteractionEnabled = true
        self.checkSpaceView.addGestureRecognizer(check)
        
    }
    @objc func checkTapped(){
        //checkBox.isChecked = !checkBox.isChecked
        
        self.checkCallback?(!isCheck)
        checkBox.isChecked = !isCheck
        self.isCheck = !isCheck
        
    }
    
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.amountTextField.borderRedColorProperties(borderWidth: 1)
        self.lessImageView.ovalColorClearProperties()
        self.moreImageView.ovalColorClearProperties()
    }

    @objc func lessPointTapped() {
        let updatedText = self.amountTextField.text!
        
        var amount = 0.0
        if let iPoint = Int(updatedText.replace(target: ",", withString: "")){
            amount = Double(iPoint)
        }
        amount -= 1
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.minimumFractionDigits = 0
        
        self.amountTextField.text = numberFormatter.string(from: NSNumber(value: amount))
        if let price  = self.priceOfProduct {
            if amount < 1 {
                //self.callBackTotalPrice?(Int(0), price)
            }else{
                self.callBackTotalPrice?(Int(amount), Double(amount * price))
            }
            
        }
        
        if amount <= 1 {
            self.amountTextField.text = "1"
            disableImageView(self.lessImageView)
            
        }else{
            enableImageView(self.lessImageView)
        }
        if Int(amount) < maxAmount {
            enableImageView(self.moreImageView)
        }
        
    }
    @objc func morePointTapped() {
        let updatedText = self.amountTextField.text!
        
        var amount = 0.0
        if let iPoint = Int(updatedText.replace(target: ",", withString: "")){
            amount = Double(iPoint)
        }
        
        amount += 1
        
        
        if Int(amount) > maxAmount {
            //amount -= 1
            disableImageView(self.moreImageView)
        }else if Int(amount) == maxAmount {
            disableImageView(self.moreImageView)
        }else{
            enableImageView(self.lessImageView)
        }
       
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.minimumFractionDigits = 0
        
        self.amountTextField.text = numberFormatter.string(from: NSNumber(value: amount))
       
        if let price = self.priceOfProduct {
            
            self.callBackTotalPrice?(Int(amount), Double(amount * price))
        }
        
    }
    
    func disableImageView(_ image:UIImageView){
        //image.ovalColorClearProperties()
        image.backgroundColor = UIColor.groupTableViewBackground
        image.isUserInteractionEnabled = false
    }
    func enableImageView(_ image:UIImageView){
        //image.ovalColorClearProperties()
        image.backgroundColor = Constant.Colors.PRIMARY_COLOR
        image.isUserInteractionEnabled = true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == self.amountTextField {
            if let amount = Int(textField.text!.replace(target: ",", withString: "")){
                if amount == 0 {
                    textField.text = "1"
                    if let price  = self.priceOfProduct {
                        self.callBackTotalPrice?(1, price)
                        self.disableImageView(self.lessImageView)
                    }
                }
            }else{
                textField.text = "1"
                if let price  = self.priceOfProduct {
                    self.callBackTotalPrice?(1, price)
                    self.disableImageView(self.lessImageView)
                }
            }
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.amountTextField {
            guard let textRange = Range(range, in: textField.text!) else { return true}
            let updatedText = textField.text!.replacingCharacters(in: textRange, with: string)
            
            if updatedText.hasPrefix("0"){
                return false
            }
            
            if let iPoint = Int(updatedText.replace(target: ",", withString: "")){
                let amount = Double(iPoint)
                if iPoint > self.maxAmount {
                    return false
                }
                
                if amount <= 1 {
                    disableImageView(self.lessImageView)
                }else{
                    enableImageView(self.lessImageView)
                }
                
                if iPoint > self.maxAmount {
                    if maxAmount == 1 {
                        disableImageView(self.moreImageView)
                        disableImageView(self.lessImageView)
                    }
                    return false
                }else if iPoint == self.maxAmount {
                    if let price = self.priceOfProduct {
                        self.callBackTotalPrice?(maxAmount, Double(maxAmount) * price)
                    }
                    disableImageView(self.moreImageView)
                    
                    if maxAmount == 1 {
                        disableImageView(self.moreImageView)
                        disableImageView(self.lessImageView)
                    }
                }else{
                    if let price  = self.priceOfProduct {
                        self.callBackTotalPrice?(Int(amount), Double(amount * price))
                    }
                    enableImageView(self.moreImageView)
                    
                    if maxAmount == 1 {
                        disableImageView(self.moreImageView)
                        disableImageView(self.lessImageView)
                    }
                }
            }
        }
        return true
    }
}
