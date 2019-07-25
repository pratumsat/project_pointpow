//
//  ConfirmOrderViewController.swift
//  pointpow
//
//  Created by thanawat on 25/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ConfirmOrderViewController: BaseViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIWebViewDelegate {

   @IBOutlet weak var confirmCollectionView: UICollectionView!
    var currentPointBalance:String?
    var totalOrder:(amount:Int, totalPrice:Double)?
    
    var cart_id:String?
    var invoice_id:String?
    var shipping_id:String?
    var tupleProduct:AnyObject? {
        didSet{
            var total = 0.0
            var amount = 0
            var i = 0
            if let tuple = self.tupleProduct as? [(title:String, id:Int, amount:Int, price:Double, select:Bool, brand:String, cover:String, stock:Int)] {
                
                for item in tuple {
                    if item.select {
                        let sum = Double(item.amount) * item.price
                        total += sum
                        
                        amount += item.amount
                    }
                    i += 1
                }
            }
            self.totalOrder = (amount: amount, totalPrice: total)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("string-title-confirm-order", comment: "")
        self.setUp()
        
    }
    
    func setUp(){
        self.handlerEnterSuccess = { (pin) in
            //checkout
            
        }

        
        self.confirmCollectionView.delegate = self
        self.confirmCollectionView.dataSource = self
        
        self.confirmCollectionView.showsVerticalScrollIndicator = false
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        self.currentPointBalance = numberFormatter.string(from: DataController.sharedInstance.getCurrentPointBalance() )
        
        
        
        self.registerNib(self.confirmCollectionView, "ConfirmOrderCell")
        self.registerNib(self.confirmCollectionView, "CartNextButtonCell")
        self.registerHeaderNib(self.confirmCollectionView, "HeaderSectionCell")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if indexPath.section == 0 {
            if let confirmCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConfirmOrderCell", for: indexPath) as? ConfirmOrderCell {
                cell = confirmCell
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 2
                
                if let current = self.currentPointBalance {
                    confirmCell.pointBalanceLabel.text = "\(current)"
                }
                confirmCell.totalLabel.text = numberFormatter.string(from: NSNumber(value: self.totalOrder?.totalPrice ?? 0))
                
                let txtAmount = NSLocalizedString("string-item-shopping-cart-txt-total-amount", comment: "")
                
                confirmCell.totalAmountLabel.text = txtAmount.replace(target: "{{amount}}", withString: "\(self.totalOrder?.amount ?? 0)")
                
                let pointbalance = DataController.sharedInstance.getCurrentPointBalance()
                let total = self.totalOrder?.totalPrice ?? 0
                if pointbalance.doubleValue < total {
                    let sum  = total - pointbalance.doubleValue
                    confirmCell.howtoPayLabel.text = NSLocalizedString("string-item-shopping-cart-howto-pay-pc", comment: "")
                    confirmCell.cdLabel.text = numberFormatter.string(from: NSNumber(value: sum))
                    confirmCell.pointLabel.text = numberFormatter.string(from: pointbalance)
                    
                    confirmCell.showCreditCardLabel()
                }else{
                    
                    confirmCell.howtoPayLabel.text = NSLocalizedString("string-item-shopping-cart-howto-pay-pp", comment: "")
                    confirmCell.cdLabel.text = ""
                    confirmCell.pointLabel.text = numberFormatter.string(from: NSNumber(value: total))
                    
                    confirmCell.hideCreditCardLabel()
                }
            }
        }else{
            if let nextCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartNextButtonCell", for: indexPath) as? CartNextButtonCell {
                cell = nextCell
                
                nextCell.nextButton.setTitle(NSLocalizedString("string-item-shopping-button-confirm-order", comment: ""), for: .normal)
                nextCell.nextCallback = {
                    //next
                    self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
                }
            }
        }
        
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        }
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSectionCell", for: indexPath) as! HeaderSectionCell
        header.headerNameLabel.text = ""
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let height = CGFloat(20.0)
        return CGSize(width: collectionView.frame.width , height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0{
            let pointbalance = DataController.sharedInstance.getCurrentPointBalance()
            let total = self.totalOrder?.totalPrice ?? 0
            if pointbalance.doubleValue < total {
                let height = CGFloat(390.0)
                return CGSize(width: collectionView.frame.width - 40, height: height)
            }else{
                let height = CGFloat(340.0)
                return CGSize(width: collectionView.frame.width - 40, height: height)
            }
        }else{
            let height = CGFloat(50.0)
            return CGSize(width: collectionView.frame.width - 40, height: height)
        }
        
        
    }
}
