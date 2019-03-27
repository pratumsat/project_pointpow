//
//  GoldWithDrawViewController.swift
//  pointpow
//
//  Created by thanawat on 4/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class GoldWithDrawViewController: GoldBaseViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var withDrawCollectionView: UICollectionView!
    
    var premiumLabel:UILabel?
    var amountTextField:UITextField?
    //var goldBalanceLabel:UILabel?
    var gold_balance:NSNumber = NSNumber(value: 0.0)
    var gold_price_average:NSNumber = NSNumber(value: 0.0)
    
    var drawCount = 0
    var amountToUnit:(amount:Int, unit:Int , price:Double , goldPrice:Int)?
    var withdrawData:(premium:Int, goldbalance:Double,goldAmountToUnit:(amount:Int, unit:Int , price:Double, goldPrice:Int))?
    
    var sumWeight:Double = 0.00
    
   
    var withDrawCell:WithdrawCell?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem?.action = #selector(SWRevealViewController.rightRevealToggle(_:))
        
        
        self.title  = NSLocalizedString("string-title-gold-page-withdraw", comment: "")
        
        setUp()
     
        getDataMember() {
            self.updateView()
        }
        
    }
    
   
    
    func updateView(){
        if let data  = self.userData as? [String:AnyObject] {
            let gold_balance = data["goldsaving_member"]?["gold_balance"] as? NSNumber ?? 0
            let gold_price_average = data["goldsaving_member"]?["gold_price_average"] as? NSNumber ?? 0
            
            self.gold_balance = gold_balance
            self.gold_price_average = gold_price_average
        }
        self.withDrawCollectionView.reloadData()
    }
    
    func setUp(){
        //self.dummyview = UITextField(frame: CGRect.zero)
        //self.view.addSubview(dummyview!)
        
        
        self.backgroundImage?.image = nil
        self.withDrawCollectionView.delegate = self
        self.withDrawCollectionView.dataSource = self
        self.withDrawCollectionView.showsVerticalScrollIndicator = false
        
        self.registerNib(self.withDrawCollectionView, "WithDrawMyGoldCell")
        self.registerNib(self.withDrawCollectionView, "WithdrawCell")
        self.registerNib(self.withDrawCollectionView, "NextButtonCell")
        self.registerNib(self.withDrawCollectionView, "LogoGoldCell")
    }
    
    @IBAction func bViewTapped(_ sender: Any) {
        if let saving = self.storyboard?.instantiateViewController(withIdentifier: "GoldPageNav") as? UINavigationController {
            self.revealViewController()?.pushFrontViewController(saving, animated: true)
            
        }
    }
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        //let y = textField.frame.origin.y + (textField.superview?.frame.origin.y)!;
        let pointInTable = textField.superview?.convert(textField.frame.origin, to: self.withDrawCollectionView)
        let y =  pointInTable?.y ?? 600
        self.positionYTextField = y + 50
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.amountTextField {
            let textRange = Range(range, in: textField.text!)!
            let updatedText = textField.text!.replacingCharacters(in: textRange, with: string)
            
            if updatedText.isEmpty {
                self.withDrawCell?.amountTextField.text = "0"
                self.withDrawCell?.premiumLabel.text = "0"
                
                self.withDrawCell?.withDrawData = (premium : "\(0)" , goldReceive: [])
                //self.goldSpendCallback?(0 , self.selectedUnits)
                
                return true
            }
            
            if  isValidNumber(updatedText) {
                
                let amount = Double(updatedText)!
                
                if self.withDrawCell?.selectedUnits == 0 {
                    if amount > 200 {
                        self.withDrawCell?.amountTextField?.text = "200"
                        self.withDrawCell?.calSalueng("200")
                        return false
                    }else{
                        self.withDrawCell?.calSalueng(updatedText)
                    }
                    
                }else{
                    if amount > 50 {
                        self.withDrawCell?.amountTextField?.text = "50"
                        self.withDrawCell?.calBaht("50")
                        return false
                    }else{
                        self.withDrawCell?.calBaht(updatedText)
                    }
                    
                }
            }else{
                return false
            }
            
        }
        
        return true
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
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "WithDrawMyGoldCell", for: indexPath) as? WithDrawMyGoldCell {
                cell = item
                
                
                var numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 4
                
                item.goldBalanceLabel.text = numberFormatter.string(from: self.gold_balance)
                
                numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 2
                
                
                item.goldAverageLabel.text = numberFormatter.string(from: self.gold_price_average)
                
                
                //self.goldBalanceLabel = item.goldBalanceLabel
            }
            
        } else if indexPath.section == 1 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "WithdrawCell", for: indexPath) as? WithdrawCell {
                cell = item
                
             
                item.amountTextField.delegate = self
                item.amountTextField.addDoneButtonToKeyboard()
                
                
                item.withDrawCollectionView = collectionView
                item.gold_balance = 2000000//self.gold_balance
                
                self.amountTextField = item.amountTextField
                self.premiumLabel = item.premiumLabel
              
                
                item.infoCallback = {
                    self.showInfoGoldPremiumPopup(true) 
                }
                
                item.drawCountCallback = { (count) in
                    self.drawCount = count
                
                    self.withDrawCollectionView.performBatchUpdates({
                        collectionView.reloadInputViews()
                    }, completion: { (true) in
                        //item.amountTextField.becomeFirstResponder()
                    })
                }
                
                item.goldSpendCallback = { (amount, unit) in
                    
                    self.amountToUnit = (amount: amount, unit: unit, price: 0.0 , goldPrice: 0)
                    if unit == 0 {
                       //salueng
                        let weightToSalueng = 15.244/4
                        let stg = weightToSalueng*Double(amount)
                        
                        
                        self.sumWeight = self.gold_balance.doubleValue - stg
                        //self.goldBalanceLabel?.text = String(format: "%.04f", sumWeight)
                        
                        if let data  = self.goldPrice as? [String:AnyObject] {
                            
                            let goldprice = data["open_buy_price"] as? NSNumber ?? 0
                            let gramToBaht = Double(goldprice.intValue)/15.244
                            
                            
                            
                            self.amountToUnit?.price = Double(stg)*gramToBaht
                            self.amountToUnit?.goldPrice = goldprice.intValue
                        }
                        
                       
                    }else{
                       //baht
                        let btg = Double(amount)*15.244
                        
                        self.sumWeight = self.gold_balance.doubleValue - btg
                        //self.goldBalanceLabel?.text = String(format: "%.04f", sumWeight)
                        
                        if let data = self.goldPrice as? [String:AnyObject] {
                            
                            let goldprice = data["open_buy_price"] as? NSNumber ?? 0
                            let gramToBaht = Double(goldprice.intValue)/15.244
                            
                            
                           
                            self.amountToUnit?.price = Double(btg)*gramToBaht
                            self.amountToUnit?.goldPrice = goldprice.intValue
                        }
                    }
                }
                   self.withDrawCell = item
                
            }
        } else if indexPath.section == 2 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "NextButtonCell", for: indexPath) as? NextButtonCell {
                cell = item
                
                item.nextCallback = {
                    let amount = self.amountTextField?.text ?? ""
                    let goldbalance = self.sumWeight
                    let premium = Int(self.premiumLabel?.text ?? "") ?? 0
                   
                    
                        if amount.isEmpty {
                            
                          self.showMessagePrompt(NSLocalizedString("string-dailog-saving-gold-amount-empty", comment: ""))
                        
                        }else{
                         
                            //if goldbalance < 0 {
                           //     self.showMessagePrompt(NSLocalizedString("string-dailog-saving-gold-pointspend-not-enogh", comment: ""))
                            //}else{
                            
                                if let amountunit = self.amountToUnit {
                                
                                    self.withdrawData = (premium: premium, goldbalance: goldbalance,  goldAmountToUnit: amountunit)
                                    
                                   
                                    self.chooseShippingPage(true ,withdrawData:  self.withdrawData!)
                                    
                                }
                                
                            
                           // }
                            
                            
                        }
                        
                        
                    
                    
                    
                }
                
            }
        } else  {
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
            let height = width/360*190
            return CGSize(width: width, height: height)
        } else if indexPath.section == 1 {
           
            let width = collectionView.frame.width - 40
            var h2 = CGFloat(0)
            if self.drawCount > 0 {
                h2 = heightForViewWithDraw(self.drawCount, width: width , height: 250)
            }else{
                h2 = heightForViewWithDraw(self.drawCount, width: width , height: 130)
            }
            
            return CGSize(width: width, height: h2)
        } else if indexPath.section == 2 {
            
            let width = collectionView.frame.width - 40
            let height = CGFloat(40)
            return CGSize(width: width, height: height)
        } else {
            let width = collectionView.frame.width
            return CGSize(width: width, height: CGFloat(60))
        }
        
    }
    
}
