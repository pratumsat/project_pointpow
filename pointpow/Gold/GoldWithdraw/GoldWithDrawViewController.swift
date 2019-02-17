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
    
    var amountGoldWeight:Double?
    var goldBalanceLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title  = NSLocalizedString("string-title-gold-page-withdraw", comment: "")
        
        setUp()
     
    }
    func setUp(){
        self.backgroundImage?.image = nil
        self.withDrawCollectionView.delegate = self
        self.withDrawCollectionView.dataSource = self
        
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
                
                self.goldBalanceLabel = item.goldBalanceLabel
                
                item.goldBalanceLabel.text = "15.3323"
                item.goldAverageLabel.text = "23,000"
                
            }
        } else if indexPath.section == 1 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "WithdrawCell", for: indexPath) as? WithdrawCell {
                cell = item
                
                item.infoCallback = {
                    self.showInfoGoldPremiumPopup(true) 
                }
                item.goldSpendCallback = { (amount, unit) in
                    if unit == 0 {
                       //salueng
                        let weightToSalueng = 15.244/4
                        let stg = weightToSalueng*Double(amount)
                        
                        
                        
                        let sumWeight = 15.3323 - stg
                        self.goldBalanceLabel?.text = String(format: "%.04f", sumWeight)
                    }else{
                       //baht
                        let btg = Double(amount)*15.244
                        
                        let sumWeight = 15.3323 - btg
                        self.goldBalanceLabel?.text = String(format: "%.04f", sumWeight)
                    }
                }
                
                
            }
        } else if indexPath.section == 2 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "NextButtonCell", for: indexPath) as? NextButtonCell {
                cell = item
                
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
            let height = width/360*130
            return CGSize(width: width, height: height)
        } else if indexPath.section == 1 {
           
            let width = collectionView.frame.width - 40
            let height = width/360*430
            return CGSize(width: width, height: height)
        } else if indexPath.section == 2 {
            
            let width = collectionView.frame.width - 40
            let height = CGFloat(40)
            return CGSize(width: width, height: height)
        } else {
            let width = collectionView.frame.width
            let cheight = collectionView.frame.height
            let height = abs((cheight) - (((width/360*130))+(width/360*430)+80))
            
            return CGSize(width: width, height: height)
        }
        
    }
    
}
