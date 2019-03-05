//
//  ConfirmSavingViewController.swift
//  pointpow
//
//  Created by thanawat on 6/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class ConfirmSavingViewController: BaseViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var summaryCollectionView: UICollectionView!
    
    var modelSaving:(pointBalance:Double?, pointSpend:Double?, goldReceive:Double?, currentGoldprice:Double?){
        didSet{
            print(modelSaving)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title =  NSLocalizedString("title-gold-pendding-confirm-saving", comment: "")
        self.setUp()
    }
    
    func setUp(){
        
        self.handlerEnterSuccess = {
            
            let params:Parameters = ["current_gold_price": self.modelSaving.currentGoldprice ?? "0",
                                     "pointpow_spend": self.modelSaving.pointSpend ?? "0",
                                     "gold_received": self.modelSaving.goldReceive ?? "0.0000"]
            
            self.modelCtrl.savingGold(params: params, true , succeeded: { (result) in
                if let data = result as? [String:AnyObject]{
                    let transactionId = data["saving"]?["transaction_no"] as? String ?? ""
                    
                    self.showGoldSavingResult(true , transactionId:  transactionId) {
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
        
        self.registerNib(self.summaryCollectionView, "SavingConfirmCell")
        self.registerNib(self.summaryCollectionView, "SavingSummaryCell")
        self.registerNib(self.summaryCollectionView, "ConfirmButtonCell")
        self.registerNib(self.summaryCollectionView, "LogoGoldCell")
        
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
       
        if indexPath.section == 0 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "SavingConfirmCell", for: indexPath) as? SavingConfirmCell{
                cell = item
                
                
                var numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                item.goldPriceLabel.text = numberFormatter.string(from: NSNumber(value: self.modelSaving.currentGoldprice!))
               
                numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 2
                
                item.pointPowSpanLabel.text = numberFormatter.string(from: NSNumber(value: self.modelSaving.pointSpend!))
                
                
                numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 4
                
                item.goldReceiveLabel.text = numberFormatter.string(from: NSNumber(value: self.modelSaving.goldReceive!))
                
                
            }
        }else if indexPath.section == 1 {
            
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "SavingSummaryCell", for: indexPath) as? SavingSummaryCell{
                cell = item
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 2
            
                item.pointPowSpanLabel.text  =  numberFormatter.string(from: NSNumber(value: self.modelSaving.pointSpend!))
                
                let pointbalance = self.modelSaving.pointBalance!
                let pointspend = self.modelSaving.pointSpend!
                let result = pointbalance - pointspend
                item.pointpowBalance.text = numberFormatter.string(from: NSNumber(value: result))
                
            }
        } else if indexPath.section == 2 {
       
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "ConfirmButtonCell", for: indexPath) as? ConfirmButtonCell {
                cell = item
                
                item.confirmCallback = {
                    self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
                }
            }
            
        } else if indexPath.section == 3 {
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
            let height = width/375*240
            return CGSize(width: width, height: height)
        }else if indexPath.section == 1 {
         
            let width = collectionView.frame.width - 40
            let height = width/375*220
            return CGSize(width: width, height: height)
        }else if indexPath.section == 2 {
          
            let height = CGFloat(40.0)
            let width = collectionView.frame.width - 40
            return CGSize(width: width, height: height)
            
        }else {
            let width = collectionView.frame.width
            let cheight = collectionView.frame.height
            let height = abs((cheight) - (((width/375*240))+((width/375*220))+100))
            
            return CGSize(width: width, height: height)
        }
        
    
        
    }


}
