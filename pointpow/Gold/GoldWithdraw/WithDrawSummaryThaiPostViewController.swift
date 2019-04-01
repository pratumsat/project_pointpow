//
//  WithDrawSummaryThaiPostViewController.swift
//  pointpow
//
//  Created by thanawat on 17/3/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class WithDrawSummaryThaiPostViewController: BaseViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var withdrawData:(premium:Int, goldbalance:Double,goldAmountToUnit:(amount:Int, unit:Int , price:Double, goldPrice:Int))?{
        didSet{
            print(withdrawData!)
        }
    }
    var addressModel: [String:AnyObject]?
    var ems:Int?
    var fee:Int?
    var name:String?
    var mobile:String?
    var shippingAddress = ""
    var heightExpand = CGFloat(0)
    
    @IBOutlet weak var summaryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("title-gold-pendding-confirm-withdraw", comment: "")
        
        self.setUp()
    }
    
    func setUp(){
        
        if let data = self.addressModel {
            let address = data["address"] as? String ?? ""
            let districtName = data["district"]?["name_in_thai"] as? String ?? ""
            let subdistrictName = data["subdistrict"]?["name_in_thai"] as? String ?? ""
            let provinceName = data["province"]?["name_in_thai"] as? String ?? ""
            let zip_code = data["subdistrict"]?["zip_code"] as? NSNumber ?? 0
            
            var rawAddress = "\(self.name!)"
            rawAddress += " \(address) \(subdistrictName) \(districtName) \(provinceName) \(zip_code)"
            rawAddress += " \(self.mobile!)"
            
            self.shippingAddress = rawAddress
        }
        
        
        self.handlerEnterSuccess = {(pin) in
            
            //get at pointpow
            let withdrawAmount = self.withdrawData!.goldAmountToUnit.amount
            var unit = ""
            let pick = "thaipost" //
            if self.withdrawData!.goldAmountToUnit.unit == 0 {
                unit = "salueng"
            }else{
                unit = "baht"
                
            }
            let params:Parameters = ["withdraw_amount": withdrawAmount,
                                     "unit": unit,
                                     "pick": pick,
                                     "address_id": (self.addressModel?["id"] as? NSNumber)?.intValue ?? 0]
            print(params)
            
            
         
            self.modelCtrl.withdrawGold(params: params, true , succeeded: { (result) in
                if let data = result as? [String:AnyObject]{
                    let transactionId = data["withdraw"]?["transaction_no"] as? String ?? ""

                    self.showGoldWithDrawResult(true , transactionId:  transactionId) {
                        if let saving = self.storyboard?.instantiateViewController(withIdentifier: "NavGoldPage") as? NavGoldPage {
                            self.revealViewController()?.pushFrontViewController(saving, animated: true)

                        }
                    }

                }

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
        
        self.backgroundImage?.image = nil
        
        self.summaryCollectionView.delegate = self
        self.summaryCollectionView.dataSource = self
        
        self.summaryCollectionView.showsVerticalScrollIndicator = false
        
        self.registerNib(self.summaryCollectionView, "WithDrawThaiPostSummaryCell")
        self.registerNib(self.summaryCollectionView, "ConfirmButtonCell")
        self.registerNib(self.summaryCollectionView, "LogoGoldCell")
        
        
      
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
        if indexPath.section == 0 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "WithDrawThaiPostSummaryCell", for: indexPath) as? WithDrawThaiPostSummaryCell {

                item.goldAmountLabel.text = "\(self.withdrawData!.goldAmountToUnit.amount)"
                
                let unit = self.withdrawData!.goldAmountToUnit.unit

                if unit == 0 {
                    item.unitLabel.text =  NSLocalizedString("unit-salueng", comment: "")
                }else{
                    item.unitLabel.text = NSLocalizedString("unit-baht", comment: "")
                }

                var numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal

                item.premiumLabel.text = numberFormatter.string(from: NSNumber(value: self.withdrawData!.premium))

                numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 4

                item.goldBalanceLabel.text = numberFormatter.string(from: NSNumber(value: self.withdrawData!.goldbalance))

                item.addressLabel.text = shippingAddress
                
                item.expandableCallback = { (height) in
                    self.heightExpand = height
                    self.summaryCollectionView.performBatchUpdates({
                        collectionView.reloadInputViews()
                    }, completion: { (true) in
                        //item.amountTextField.becomeFirstResponder()
                    })

                }
                
                var arrayBox:[[String:AnyObject]] = []
                let premium = self.withdrawData!.premium
                let price = Int(self.withdrawData!.goldAmountToUnit.price)
                let goldPrice = Int(self.withdrawData!.goldAmountToUnit.goldPrice)
                let goldUnit = self.withdrawData!.goldAmountToUnit.unit
                let emsfee = self.ems! + self.fee!
                var totalServicePrice = 0
                
                var goldToBaht = 0
                if goldUnit == 0 {
                    goldToBaht = goldPrice/4  //salueng
                }else{
                    goldToBaht = goldPrice  //baht
                }
                var priceToBox = price
                
                while priceToBox > 50000 { // 50,000 max delivery to amount
                    priceToBox -= goldToBaht
                }
                
                var amountBox = price/priceToBox
                
                
                if amountBox > 0 {
                    for n in 1...amountBox {
                        var insurance = priceToBox/500
                        if priceToBox%500 > 0 {
                            insurance += 1
                        }
                        if priceToBox <= 20000 {
                            insurance = insurance*5
                        }else{
                            insurance = insurance*10
                        }
                        
                        
                        totalServicePrice += emsfee + insurance
                        arrayBox.append(["order" : n as AnyObject, "price": (emsfee + insurance) as AnyObject])
                    }
                }
                
                let diffAmountBox = price%priceToBox // diff
                if diffAmountBox > 0 {
                    amountBox += 1
                    
                    var insurance = diffAmountBox/500
                    if diffAmountBox%500 > 0 {
                        insurance += 1
                    }
                    if diffAmountBox <= 20000 {
                        insurance = insurance*5
                    }else{
                        insurance = insurance*10
                    }
                    totalServicePrice += emsfee + insurance
                    arrayBox.append(["order" : amountBox as AnyObject, "price": (emsfee + insurance) as AnyObject])
                }
                let totalPrice = premium + totalServicePrice
                
                print(arrayBox)
                print(totalServicePrice)
                print(totalPrice)
                
                
                numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                item.amountBoxLabel.text = "(\(arrayBox.count)\(NSLocalizedString("string-thaipost-delivery-box", comment: "")))"
                
                item.serviceLabel.text = numberFormatter.string(from: NSNumber(value: totalServicePrice))
                item.totalLabel.text = numberFormatter.string(from: NSNumber(value: totalPrice))
                
                
                item.arrayBox = arrayBox
                
                
                cell = item
            }
            
        }else if indexPath.section == 1 {
            
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "ConfirmButtonCell", for: indexPath) as? ConfirmButtonCell {
                cell = item
                
                item.confirmCallback = {
                    self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
                }
            }
            
        } else if indexPath.section == 2 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "LogoGoldCell", for: indexPath) as? LogoGoldCell {
                cell = item
                
            }
        }
        
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        
        return CGSize(width: collectionView.frame.width, height: 20)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if indexPath.section == 0 {
            
            let width = collectionView.frame.width - 40
            let height = heightForView(text: self.shippingAddress, font: UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: 18)!,
                                       width: width - 20) + 470 + self.heightExpand
            return CGSize(width: width, height: height)
            
        }else if indexPath.section == 1 {
            
            let height = CGFloat(40.0)
            let width = collectionView.frame.width - 40
            return CGSize(width: width, height: height)
            
        }else {
            let width = collectionView.frame.width
            return CGSize(width: width, height: CGFloat(60))
        }
        
        
        
    }
    
}
