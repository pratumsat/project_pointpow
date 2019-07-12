//
//  SavingSummaryViewController.swift
//  pointpow
//
//  Created by thanawat on 23/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class WithDrawSummaryOfficeViewController: BaseViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var withdrawData:(pointBalance:Double, premium:Int, goldbalance:Double, goldAmountToUnit:(amount:Int, unit:Int , price:Double, goldPrice:Int), goldReceive:[(amount:Int,unit:String)]? )?{
        didSet{
            print(withdrawData!)
            
            
            for item in withdrawData!.goldReceive! {
                if item.amount != 0 {
                   self.rowBar += 1
                }

            }
            
        }
    }
    var rowBar = 0
    
    @IBOutlet weak var summaryCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("title-gold-pendding-confirm-withdraw", comment: "")
        
        self.setUp()
    }
    
    func setUp(){
        
        self.handlerEnterSuccess = {(pin) in
            
                //get at pointpow
                let withdrawAmount = self.withdrawData!.goldAmountToUnit.amount
                var unit = ""
                if self.withdrawData!.goldAmountToUnit.unit == 0 {
                    unit = "salueng"
                }else{
                    unit = "baht"
                    
                }
                let params:Parameters = ["withdraw_amount": withdrawAmount,
                                         "unit": unit,
                                         "pick": "office"]
                print(params)
            
            var v:UIView = self.view
            if let nav = self.navigationController{
                if let rootNav = nav.navigationController{
                    v = rootNav.view
                }else{
                    v = nav.view
                }
            }
            self.loadingView?.mRootView = v
            
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
        
        self.registerNib(self.summaryCollectionView, "WithDrawOfficeSummaryCell")
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
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "WithDrawOfficeSummaryCell", for: indexPath) as? WithDrawOfficeSummaryCell {
                
                item.amountLabel.text = "\(self.withdrawData!.goldAmountToUnit.amount)"
                
                let unit = self.withdrawData!.goldAmountToUnit.unit
                
                if unit == 0 {
                    item.unitLabel.text =  NSLocalizedString("unit-salueng", comment: "")
                }else{
                    item.unitLabel.text = NSLocalizedString("unit-baht", comment: "")
                }
                
            
                if let received = self.withdrawData?.goldReceive {
                    item.formatGoldReceiveLabel.attributedText = self.goldFormat(gold_received: received)
                }
                
                var numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                item.premiumLabel.text = numberFormatter.string(from: NSNumber(value: self.withdrawData!.premium))

                numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 2
                
                let pb = self.withdrawData!.pointBalance
                item.goldBalanceLabel.text = numberFormatter.string(from: NSNumber(value: pb))
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
    
    func goldFormat(gold_received:[(amount:Int,unit:String)]) -> NSAttributedString {
        var j = 0
        var gr:[(amount:Int,unit:String)] = []
        for item in gold_received {
            if item.amount != 0 {
                gr.append(item)
            }
            j += 1
        }
        let unitSalueng = NSLocalizedString("unit-salueng", comment: "")
        let unitBaht = NSLocalizedString("unit-baht", comment: "")
        let unitBar = NSLocalizedString("unit-bar", comment: "")
        
        let txtAttr = NSMutableAttributedString(string: "")
        let amountAttribute = [ NSAttributedString.Key.font: UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: 25.0)! ]
        
        let unitAttribute = [ NSAttributedString.Key.font: UIFont(name: Constant.Fonts.THAI_SANS_REGULAR, size: 16.0)! ]
        
        var i = 0
        for item in gr {
            let unit = item.unit
            let amount = item.amount
            
            if amount == 0 {
                
                continue
            }
            if unit.lowercased() == "1salueng"{
                
                txtAttr.append(NSMutableAttributedString(string: "1 ", attributes: amountAttribute ))
                txtAttr.append(NSMutableAttributedString(string: unitSalueng, attributes: unitAttribute ))
                
            }
            if unit.lowercased() == "2salueng"{
                
                txtAttr.append(NSMutableAttributedString(string: "2 ", attributes: amountAttribute ))
                txtAttr.append(NSMutableAttributedString(string: unitSalueng, attributes: unitAttribute ))
                
            }
            if unit.lowercased() == "1baht"{
                
                txtAttr.append(NSMutableAttributedString(string: "1 ", attributes: amountAttribute ))
                txtAttr.append(NSMutableAttributedString(string: unitBaht, attributes: unitAttribute ))
                
            }
            if unit.lowercased() == "2baht"{
                
                txtAttr.append(NSMutableAttributedString(string: "2 ", attributes: amountAttribute ))
                txtAttr.append(NSMutableAttributedString(string: unitBaht, attributes: unitAttribute ))
                
            }
            if unit.lowercased() == "5baht"{
                
                txtAttr.append(NSMutableAttributedString(string: "5 ", attributes: amountAttribute ))
                txtAttr.append(NSMutableAttributedString(string: unitBaht, attributes: unitAttribute ))
                
            }
            if unit.lowercased() == "10baht"{
                
                txtAttr.append(NSMutableAttributedString(string: "10 ", attributes: amountAttribute ))
                txtAttr.append(NSMutableAttributedString(string: unitBaht, attributes: unitAttribute ))
                
            }
            if i == (gr.count - 1)  {
                txtAttr.append(NSMutableAttributedString(string: " \(amount) ", attributes: amountAttribute ))
                txtAttr.append(NSMutableAttributedString(string: "\(unitBar)", attributes: unitAttribute ))
            }else{
                txtAttr.append(NSMutableAttributedString(string: " \(amount) ", attributes: amountAttribute ))
                txtAttr.append(NSMutableAttributedString(string: "\(unitBar)\n", attributes: unitAttribute ))
            }
            
            i += 1
        }
        return txtAttr
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 1 {
            return CGSize(width: collectionView.frame.width, height: 30)
        }
        
        return CGSize(width: collectionView.frame.width, height: 20)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if indexPath.section == 0 {
            
            let width = collectionView.frame.width - 40
            let height = heightForViewWithDraw(self.rowBar, width: width , height: CGFloat(330) , rowHeight: 30.0)
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
