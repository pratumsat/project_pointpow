//
//  ItemCartProductCell.swift
//  pointpow
//
//  Created by thanawat on 3/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ItemCartProductCell: UICollectionViewCell ,UITextFieldDelegate{

    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var checkBox: CheckBox!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var moreImageView: UIImageView!
    @IBOutlet weak var lessImageView: UIImageView!
    
    var callBackTotalPrice:((_ amount:Int, _ totalPrice:Double)->Void)?
    var priceOfProduct:Double?
    
    var amount:Int = 1 {
        didSet{
            self.amountTextField.text = "\(Int(amount))"
        }
    }
    
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
                self.callBackTotalPrice?(Int(0), price)
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
        
        
    }
    @objc func morePointTapped() {
        let updatedText = self.amountTextField.text!
        
        var amount = 0.0
        if let iPoint = Int(updatedText.replace(target: ",", withString: "")){
            amount = Double(iPoint)
        }
        
        amount += 1
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.minimumFractionDigits = 0
        
        self.amountTextField.text = numberFormatter.string(from: NSNumber(value: amount))
        if let price  = self.priceOfProduct {
            self.callBackTotalPrice?(Int(amount), Double(amount * price))
        }
        enableImageView(self.lessImageView)
        
        
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.amountTextField {
            guard let textRange = Range(range, in: textField.text!) else { return true}
            var updatedText = textField.text!.replacingCharacters(in: textRange, with: string)
            
            
            if updatedText.isEmpty {
                updatedText = "1"
            }
            if let iPoint = Int(updatedText.replace(target: ",", withString: "")){
                let amount = Double(iPoint)
                if amount <= 1 {
                    disableImageView(self.lessImageView)
                }else{
                    enableImageView(self.lessImageView)
                }
                
                
                if let iPoint = Int(updatedText.replace(target: ",", withString: "")){
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .none
                    
                    textField.text = numberFormatter.string(from: NSNumber(value: iPoint))
                    if let price  = self.priceOfProduct {
                        self.callBackTotalPrice?(Int(amount), Double(amount * price))
                    }
                    return false
                }
            }else{
                return false
            }
            
            
        }
        return true
    }
}
