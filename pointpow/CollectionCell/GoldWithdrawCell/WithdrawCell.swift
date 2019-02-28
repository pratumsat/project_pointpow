//
//  WithdrawCell.swift
//  pointpow
//
//  Created by thanawat on 17/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class WithdrawCell: UICollectionViewCell ,UIPickerViewDelegate , UIPickerViewDataSource, UIGestureRecognizerDelegate ,UITextFieldDelegate {
    @IBOutlet weak var headView: UIView!
    
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var unitView: UIView!
    @IBOutlet weak var goldReceiveInfoLabel: UILabel!
    @IBOutlet weak var dropDownImageView: UIImageView!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var heightPremiumConstraint: NSLayoutConstraint!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var result2saluengLabel: UILabel!
    
    @IBOutlet weak var result1saluengLabel: UILabel!
    
    @IBOutlet weak var result10bahtLabel: UILabel!
    @IBOutlet weak var result5bahtLabel: UILabel!
    @IBOutlet weak var result2bahtLabel: UILabel!
    @IBOutlet weak var result1bahtLabel: UILabel!
    
    @IBOutlet weak var result2salueng1View: UIView!
    @IBOutlet weak var result2salueng2View: UIView!
    
    @IBOutlet weak var result1salueng1View: UIView!
    @IBOutlet weak var result1salueng2View: UIView!
    
    @IBOutlet weak var result10baht1View: UIView!
    @IBOutlet weak var result10baht2View: UIView!
    
    @IBOutlet weak var result5baht1View: UIView!
    @IBOutlet weak var result5baht2View: UIView!
    
    @IBOutlet weak var result2baht1View: UIView!
    @IBOutlet weak var result2baht2View: UIView!
    
    @IBOutlet weak var result1baht1View: UIView!
    @IBOutlet weak var result1baht2View: UIView!
    
    
    @IBOutlet weak var height2saluengConstraint: NSLayoutConstraint!
    @IBOutlet weak var height1saluengConstraint: NSLayoutConstraint!
    @IBOutlet weak var height10bahtConstraint: NSLayoutConstraint!
    @IBOutlet weak var height5bahtConstraint: NSLayoutConstraint!
    @IBOutlet weak var height2bahtConstraint: NSLayoutConstraint!
    @IBOutlet weak var height1bahtConstraint: NSLayoutConstraint!
    @IBOutlet weak var _2saluengView: UIView!
    @IBOutlet weak var _1saluengView: UIView!
    @IBOutlet weak var _10bahtView: UIView!
    @IBOutlet weak var _5bahtView: UIView!
    @IBOutlet weak var _2bahtView: UIView!
    @IBOutlet weak var _1bahtView: UIView!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    
    var gold_balance:NSNumber = NSNumber(value: 0.0){
        didSet{
            setUpPicker()
        }
    }
    
    var defaultHeight = CGFloat(40)
    
    var pickerView:UIPickerView?
    var units = [NSLocalizedString("unit-salueng", comment: ""),NSLocalizedString("unit-baht", comment: "")]
    var selectedUnits:Int = 0 {
        didSet{
            self.amountTextField.text = ""
            self.premiumLabel.text = ""
            self.withDrawData = (premium : "\(0)" , goldReceive: [])
            self.goldSpendCallback?(0 , self.selectedUnits)
            
//            if self.selectedUnits == 0 {
//                calSalueng(amountTextField?.text ?? "")
//            }else{
//                calBaht(amountTextField?.text ?? "")
//            }
            
        }
    }
    
    var drawCountCallback:((_ count:Int)->Void)?
    var goldSpendCallback:((_ amount:Int ,_ unit:Int)->Void)?
    var infoCallback:(()->Void)?
    
    var withDrawData : (premium:String , goldReceive:[(amount:Int,unit:String)] )?{
        didSet{
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateLayerCornerRadiusProperties()
        self.contentView.updateLayerCornerRadiusProperties()
        self.shadowCellProperties()
        
        
        premiumView.borderClearProperties(borderWidth: 1)
        
        result2salueng1View.borderClearProperties(borderWidth: 1)
        result2salueng2View.borderClearProperties(borderWidth: 1)
        
        result1salueng1View.borderClearProperties(borderWidth: 1)
        result1salueng2View.borderClearProperties(borderWidth: 1)
        
        result10baht1View.borderClearProperties(borderWidth: 1)
        result10baht2View.borderClearProperties(borderWidth: 1)
        
        result5baht1View.borderClearProperties(borderWidth: 1)
        result5baht2View.borderClearProperties(borderWidth: 1)
        
        result2baht1View.borderClearProperties(borderWidth: 1)
        result2baht2View.borderClearProperties(borderWidth: 1)
        
        result1baht1View.borderClearProperties(borderWidth: 1)
        result1baht2View.borderClearProperties(borderWidth: 1)
        
        
        self.amountTextField.delegate = self
        self.amountTextField.addDoneButtonToKeyboard(myAction:
                #selector(self.amountTextField.resignFirstResponder))
        
        
        self.updateView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(infoTapped))
        self.infoImageView.isUserInteractionEnabled = true
        self.infoImageView.addGestureRecognizer(tap)
        
        let dropdownTap = UITapGestureRecognizer(target: self, action: #selector(dropdownTapped))
        self.unitView.isUserInteractionEnabled = true
        self.unitView.addGestureRecognizer(dropdownTap)
        
    }
    
    @objc func dropdownTapped(){
        self.unitTextField.becomeFirstResponder()
    }
    @objc func infoTapped(){
        self.infoCallback?()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.amountTextField {
            let textRange = Range(range, in: textField.text!)!
            let updatedText = textField.text!.replacingCharacters(in: textRange, with: string)
        
            if updatedText.isEmpty {
                self.amountTextField.text = "0"
                self.premiumLabel.text = "0"
                
                self.withDrawData = (premium : "\(0)" , goldReceive: [])
                self.goldSpendCallback?(0 , self.selectedUnits)
                
                return true
            }
            
            if let amount = Int(updatedText) {
               
                if self.selectedUnits == 0 {
                    if amount > 200 {
                        self.amountTextField?.text = "200"
                        calSalueng("200")
                        return false
                    }else{
                        calSalueng(updatedText)
                    }
                   
                }else{
                    if amount > 50 {
                        self.amountTextField?.text = "50"
                        calBaht("50")
                        return false
                    }else{
                        calBaht(updatedText)
                    }
                    
                }
            }else{
                return false
            }
            
        }
        
        return true
    }

    
    func updateView(){
        
        self.drawCountCallback?(0)
        
        self.underLineView.isHidden = true
        self.weightLabel.isHidden = true
        self.goldReceiveInfoLabel.isHidden = true
        self.heightPremiumConstraint.constant = 0
        
        self.height10bahtConstraint.constant = 0
        self.height5bahtConstraint.constant = 0
        self.height2bahtConstraint.constant = 0
        self.height1bahtConstraint.constant = 0
        self.height2saluengConstraint.constant = 0
        self.height1saluengConstraint.constant = 0
        
        if selectedUnits == 0 {
            //salueng
            if let data = self.withDrawData {
                self.premiumLabel.text = data.premium
                
                if data.premium != "0" {
                    self.heightPremiumConstraint.constant = self.defaultHeight
                    self.weightLabel.isHidden = false
                    self.goldReceiveInfoLabel.isHidden = false
                    
                    self.underLineView.isHidden = false
                }
                
                if data.goldReceive.count == 0 {
                    self.result2saluengLabel.text = "0"
                    self.result1saluengLabel.text = "0"
                    return
                }
               
                var drawCount = 0
                for item in data.goldReceive {
                    if item.unit  == "2salueng" {
                        if item.amount > 0 {
                            drawCount += 1
                            self.height2saluengConstraint.constant = self.defaultHeight
                            self.result2saluengLabel.text = "\(item.amount)"
                        }else{
                            self.height2saluengConstraint.constant = 0
                        }
                    }
                    if item.unit  == "1salueng" {
                        if item.amount > 0 {
                            drawCount += 1
                            self.height1saluengConstraint.constant = self.defaultHeight
                            self.result1saluengLabel.text = "\(item.amount)"
                        }else{
                            self.height1saluengConstraint.constant = 0
                        }
                    }
                }
                self.drawCountCallback?(drawCount)
            }
        }else{
            
            if let data = self.withDrawData {
                self.premiumLabel.text = data.premium
                
                if data.premium != "0" {
                    self.heightPremiumConstraint.constant = self.defaultHeight
                    self.weightLabel.isHidden = false
                    self.goldReceiveInfoLabel.isHidden = false
                    
                    self.underLineView.isHidden = false
                }
                
                if data.goldReceive.count == 0 {
                    self.result10bahtLabel.text = "0"
                    self.result5bahtLabel.text = "0"
                    self.result2bahtLabel.text = "0"
                    self.result1bahtLabel.text = "0"
                    return
                }
                
                var drawCount = 0
                for item in data.goldReceive {
                    if item.unit  == "10baht" {
                        if item.amount > 0 {
                            drawCount += 1
                            self.height10bahtConstraint.constant = self.defaultHeight
                            self.result10bahtLabel.text = "\(item.amount)"
                        }else{
                            self.height10bahtConstraint.constant = 0
                        }
                    }
                    if item.unit  == "5baht" {
                        if item.amount > 0 {
                            drawCount += 1
                            self.height5bahtConstraint.constant = self.defaultHeight
                            self.result5bahtLabel.text = "\(item.amount)"
                        }else{
                            self.height5bahtConstraint.constant = 0
                        }
                    }
                    if item.unit  == "2baht" {
                        if item.amount > 0 {
                            drawCount += 1
                            self.height2bahtConstraint.constant = self.defaultHeight
                            self.result2bahtLabel.text = "\(item.amount)"
                        }else{
                            self.height2bahtConstraint.constant = 0
                        }
                    }
                    if item.unit  == "1baht" {
                        if item.amount > 0 {
                            drawCount += 1
                            self.height1bahtConstraint.constant = self.defaultHeight
                            self.result1bahtLabel.text = "\(item.amount)"
                        }else{
                            self.height1bahtConstraint.constant = 0
                        }
                    }
                }
                self.drawCountCallback?(drawCount)
            }
        }
       
       
    }
    func calSalueng(_ s:String){
        if let amount = Int(s) {
            self.goldSpendCallback?(amount , self.selectedUnits)
            
            var p2salueng = 0
            var p1salueng = 0
            if let premium = DataController.sharedInstance.getDataGoldPremium(){
                if let premiums = premium as? [[String:AnyObject]]{
                    for item in premiums {
                        let unit = item["unit"] as? String ?? ""
                        let weight = (item["weight"] as? NSNumber)?.intValue ?? 0
                        let price = (item["premium"] as? NSNumber)?.intValue ?? 0
                        if unit == "salueng"{
                            if weight == 2 {
                                p2salueng = price
                            }
                            if weight == 1 {
                                p1salueng = price
                            }
                        }
                    }
                }
            }
            let gold2salueng = amount/2
            let gold1salueng = amount%2
            let _premium = (((amount/2)*p2salueng)+(amount%2)*p1salueng)
            
            var _goldReceive:[(amount:Int,unit:String)] = []
            _goldReceive.append((amount: gold2salueng, unit: "2salueng"))
            _goldReceive.append((amount: gold1salueng, unit: "1salueng"))
            
            self.withDrawData = (premium : "\(_premium)" , goldReceive: _goldReceive)
        }else{
            updateView()
        }
    }
    
    func calBaht(_ s:String){
        if let amount = Int(s) {
            self.goldSpendCallback?(amount , self.selectedUnits)
            
            var p1baht = 0
            var p2baht = 0
            var p5baht = 0
            var p10baht = 0
            if let premium = DataController.sharedInstance.getDataGoldPremium(){
                if let premiums = premium as? [[String:AnyObject]]{
                    for item in premiums {
                        let unit = item["unit"] as? String ?? ""
                        let weight = (item["weight"] as? NSNumber)?.intValue ?? 0
                        let price = (item["premium"] as? NSNumber)?.intValue ?? 0
                        if unit != "salueng"{
                            if weight == 1 {
                                p1baht = price
                            }
                            if weight == 2 {
                                p2baht = price
                            }
                            if weight == 5 {
                                p5baht = price
                            }
                            if weight == 10 {
                                p10baht = price
                            }
                        }
                    }
                }
            }
            let difference10 = amount%10
            let difference5 = difference10%5
            let difference2 = difference5%2
            
            let gold10baht = amount/10
            let gold5baht = difference10/5
            let gold2baht = difference5/2
            let gold1baht = difference2%2
            let _premium = ( ((amount/10)*p10baht)+((difference10/5)*p5baht)+((difference5/2)*p2baht)+((difference2%2)*p1baht))
            
            var _goldReceive:[(amount:Int,unit:String)] = []
            
            _goldReceive.append((amount: gold10baht, unit: "10baht"))
            _goldReceive.append((amount: gold5baht, unit: "5baht"))
            _goldReceive.append((amount: gold2baht, unit: "2baht"))
            _goldReceive.append((amount: gold1baht, unit: "1baht"))
            
            self.withDrawData = (premium : "\(_premium)" , goldReceive: _goldReceive)
            
        }else{
            updateView()
        }
        
    }
    
    
    func setUpPicker(){
        
        if self.gold_balance.doubleValue >= 15.244 {
            pickerView = UIPickerView()
            pickerView!.delegate = self
            pickerView!.dataSource = self

            let tap = UITapGestureRecognizer(target: self, action: #selector(pickerTapped))
            tap.delegate = self
            pickerView!.addGestureRecognizer(tap)

            
            self.unitTextField.tintColor = UIColor.clear
            self.unitTextField.isUserInteractionEnabled = true
            self.unitTextField.inputView = pickerView

            self.unitTextField.borderRedColorProperties(borderWidth: 1)
            self.unitTextField.isEnabled = true
            self.unitTextField.text = self.units[0]
            self.unitTextField.textColor = UIColor.black
            self.selectedUnits = 0

            
            self.dropDownImageView.image = UIImage(named: "ic-dropdown-2")
        }else{
            self.unitTextField.borderLightGrayColorProperties()
            self.unitTextField.isEnabled = false
            self.unitTextField.text = self.units[0]
            self.unitTextField.textColor = UIColor.lightGray
            self.selectedUnits = 0
            
            self.dropDownImageView.image = UIImage(named: "ic-dropdown-1")
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func pickerTapped(_ tapRecognizer:UITapGestureRecognizer){
        if tapRecognizer.state == .ended {
            let rowHeight = self.pickerView!.rowSize(forComponent: 0).height
            let selectedRowFrame = self.pickerView!.bounds.insetBy(dx: 0, dy: (self.pickerView!.frame.height - rowHeight) / 2)
            let userTappedOnSelectedRow = selectedRowFrame.contains(tapRecognizer.location(in: self.pickerView))
            if userTappedOnSelectedRow {
                let selectedRow = self.pickerView!.selectedRow(inComponent: 0)
                
                self.selectedUnits = selectedRow
                self.unitTextField.text = "\(self.units[selectedRow])"
                self.unitTextField.resignFirstResponder()
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.units.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
      
        
        self.selectedUnits = row
        self.unitTextField.text = "\(self.units[row])"
        
        return "\(self.units[row])"
    }

    
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.headView.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])

        
        self.amountTextField.borderRedColorProperties(borderWidth: 1)
        self.amountTextField.setRightPaddingPoints(10)
        
        //self.unitTextField.borderRedColorProperties(borderWidth: 1)
        self.unitTextField.setRightPaddingPoints(40)
        
        
       

    }
}




//var text = ""
//            text += "จำนวนทองที่ได้รับ 10 บาท \(amount/40) แท่ง พรีเมียม:\((amount/40)*300)\n"
//            let difference10 = amount%40
//
//            text += "จำนวนทองที่ได้รับ 5 บาท \(difference10/20) แท่ง พรีเมียม:\((difference10/20)*250)\n"
//            let difference5 = difference10%20
//
//            text += "จำนวนทองที่ได้รับ 2 บาท \(difference5/8) แท่ง พรีเมียม:\((difference5/8)*200)\n"
//            let difference2 = difference5%8
//
//            text += "จำนวนทองที่ได้รับ 1 บาท \(difference2/4) แท่ง พรีเมียม:\((difference2/4)*150)\n"
//            let difference1 = difference2%4
//
//            text += "จำนวนทองที่ได้รับ 2 สลึง \(difference1/2) แท่ง พรีเมียม:\((difference1/2)*130)\n"
//            text += "จำนวนทองที่ได้รับ 1 สลึง \(difference1%2) แท่ง พรีเมียม:\((difference1%2)*100)\n"
//
//            let premium = ( ((amount/40)*300)+((difference10/20)*250)+((difference5/8)*200)+((difference2/4)*150)+((difference1/2)*130)+((difference1%2)*100))

//            text += "จำนวนทองที่ได้รับ 2 สลึง \(amount/2) เส้น พรีเมียม:\((amount/2)*130)\n"
//            text += "จำนวนทองที่ได้รับ 1 สลึง \(amount%2) เส้น พรีเมียม:\((amount%2)*100)\n"
//            text += "ค่าพรีเมียม: \((((amount/2)*130)+(amount%2)*100))"
//            print(text)
