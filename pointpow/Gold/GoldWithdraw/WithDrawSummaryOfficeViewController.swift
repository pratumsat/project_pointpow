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

    var withdrawData:(premium:Int, goldbalance:Double,goldAmountToUnit:(amount:Int, unit:Int , price:Double, goldPrice:Int))?{
        didSet{
            print(withdrawData!)
        }
    }
    
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
                var pick = "office" //"thaipost"
                if self.withdrawData!.goldAmountToUnit.unit == 0 {
                    unit = "salueng"
                }else{
                    unit = "baht"
                    
                }
                let params:Parameters = ["withdraw_amount": withdrawAmount,
                                         "unit": unit,
                                         "pick": pick]
                print(params)
                
                self.modelCtrl.withdrawGold(params: params, true , succeeded: { (result) in
                    if let data = result as? [String:AnyObject]{
                        let transactionId = data["withdraw"]?["transaction_no"] as? String ?? ""
                        
                        self.showGoldWithDrawResult(true , transactionId:  transactionId) {
                            if let saving = self.storyboard?.instantiateViewController(withIdentifier: "GoldPageNav") as? UINavigationController {
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
                
                var numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                item.premiumLabel.text = numberFormatter.string(from: NSNumber(value: self.withdrawData!.premium))

                numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 4
                
                item.goldBalanceLabel.text = numberFormatter.string(from: NSNumber(value: self.withdrawData!.goldbalance))
                
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
            let height = CGFloat(270)
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
