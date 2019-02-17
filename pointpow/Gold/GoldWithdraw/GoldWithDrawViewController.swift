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
    
    var goldamountTextField:UITextField?
    var goldUnit:Int = 0 {
        didSet{
            if self.goldUnit == 0 {
                calSalueng(goldamountTextField?.text ?? "")
            }else{
                calBaht(goldamountTextField?.text ?? "")
            }
        }
    }
    
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
        self.registerNib(self.withDrawCollectionView, "LogoGoldCell")
    }
    
    @IBAction func bViewTapped(_ sender: Any) {
        if let saving = self.storyboard?.instantiateViewController(withIdentifier: "GoldPageNav") as? UINavigationController {
            self.revealViewController()?.pushFrontViewController(saving, animated: true)
            
        }
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
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "WithDrawMyGoldCell", for: indexPath) as? WithDrawMyGoldCell {
                cell = item
                
                item.goldBalanceLabel.text = "15.3323"
                item.goldAverageLabel.text = "23,000"
                
            }
        } else if indexPath.section == 1 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "WithdrawCell", for: indexPath) as? WithdrawCell {
                cell = item
                self.goldamountTextField = item.amountTextField
                item.unitCallback = { (unit) in
                    self.goldUnit = unit
                }
                
                self.goldamountTextField?.delegate = self
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
            let height = width/360*140
            return CGSize(width: width, height: height)
        } else if indexPath.section == 1 {
           
            let width = collectionView.frame.width - 40
            let height = heightForViewWithDraw(6, width: width)
            return CGSize(width: width, height: height)
        } else {
            let width = collectionView.frame.width
            let cheight = collectionView.frame.height
            let height = abs((cheight) - (((width/360*140))+40))
            
            return CGSize(width: width, height: height)
        }
        
    }
    

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        if textField == self.goldamountTextField {
            let textRange = Range(range, in: textField.text!)!
            let updatedText = textField.text!.replacingCharacters(in: textRange, with: string)
            if self.goldUnit == 0 {
                calSalueng(updatedText)
            }else{
                calBaht(updatedText)
            }
            
        }
        
        return true
    }
   
    func calSalueng(_ s:String){
        if let amount = Int(s) {
            var text = ""
        
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
            
            
            text += "จำนวนทองที่ได้รับ 2 สลึง \(amount/2) เส้น พรีเมียม:\((amount/2)*130)\n"
            text += "จำนวนทองที่ได้รับ 1 สลึง \(amount%2) เส้น พรีเมียม:\((amount%2)*100)\n"
            let premium = (((amount/2)*130)+(amount%2)*100)
            
            text += "ค่าพรีเมียม: \(premium)"
            
            print(text)
        }
       
    }
    func calBaht(_ s:String){
        if let amount = Int(s) {
            var text = ""
            
            text += "จำนวนทองที่ได้รับ 10 บาท \(amount/10) แท่ง พรีเมียม:\((amount/10)*300)\n"
            let difference10 = amount%10
            
            text += "จำนวนทองที่ได้รับ 5 บาท \(difference10/5) แท่ง พรีเมียม:\((difference10/5)*250)\n"
            let difference5 = difference10%5

            text += "จำนวนทองที่ได้รับ 2 บาท \(difference5/2) แท่ง พรีเมียม:\((difference5/2)*200)\n"
            let difference2 = difference5%2

            text += "จำนวนทองที่ได้รับ 1 บาท \(difference2%2) แท่ง พรีเมียม:\((difference2%2)*150)\n"
          
            let premium = ( ((amount/10)*300)+((difference10/5)*250)+((difference5/2)*200)+((difference2%2)*150))
            text += "ค่าพรีเมียม: \(premium)"
            
            print(text)
        }
        
    }
    
}
