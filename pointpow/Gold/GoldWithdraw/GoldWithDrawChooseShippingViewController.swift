//
//  GoldWithDrawChooseShippingViewController.swift
//  pointpow
//
//  Created by thanawat on 19/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class GoldWithDrawChooseShippingViewController: BaseViewController  , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var withdrawData:(premium:Int, goldbalance:Double,goldAmountToUnit:(amount:Int, unit:Int))?{
        didSet{
            print(withdrawData!)
        }
    }
    var option = 0 {
        didSet{
            self.shippingCollectionView.reloadData()
        }
    }
    var shippingAddress:String?{
        didSet{
            self.shippingCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var shippingCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-gold-page-withdraw", comment: "")
        
        self.setUp()
    }
    

    func setUp(){
        self.backgroundImage?.image = nil
        self.shippingCollectionView.dataSource = self
        self.shippingCollectionView.delegate = self
        
        self.registerNib(self.shippingCollectionView, "WithDrawChooseShippingCell")
        self.registerNib(self.shippingCollectionView, "WidthDrawShippingPointPowCell")
        self.registerNib(self.shippingCollectionView, "WithDrawShippingThaiPostCell")
        self.registerNib(self.shippingCollectionView, "NextButtonCell")
        self.registerNib(self.shippingCollectionView, "LogoGoldCell")
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
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "WithDrawChooseShippingCell", for: indexPath) as? WithDrawChooseShippingCell{
                cell = item
                
                item.infoCallback = {
                    //info pointpow
                }
                item.shippingCallback = {(option) in
                    self.option = option
                }
            }
        }else if indexPath.section == 1 {
            if self.option == 0 {
                if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "WidthDrawShippingPointPowCell", for: indexPath) as? WidthDrawShippingPointPowCell{
                    cell = item
                    
                    
                    
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    
                    item.premiunLabel.text = numberFormatter.string(from: NSNumber(value: self.withdrawData!.premium))
                }
            }else{
                if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "WithDrawShippingThaiPostCell", for: indexPath) as? WithDrawShippingThaiPostCell{
                    
                    cell = item
                    item.address = self.shippingAddress
                    item.infoThaipostCallback = {
                        //info thaipost
                    }
                    
                    
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    
                    item.premiumLabel.text = numberFormatter.string(from: NSNumber(value: self.withdrawData!.premium))
                }
            }
           
            
        }else if indexPath.section == 2 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "NextButtonCell", for: indexPath) as? NextButtonCell {
                cell = item
                
                item.nextCallback = {
                    if self.option == 0 {
                        //next
                    }else{
                        //choose address
                        self.showShippingPopup(true) { (address) in
                            //nextstep
                        }
                        //self.shippingAddress = "ธนัซมน์ ประทุมเศษ 112/88 สวนหลวงวิว ดอกไม้ ประเวศ กทม 10250 0817555989"
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
            let height = width/360*110
            return CGSize(width: width, height: height)
        }else if indexPath.section == 1 {
            
            if option == 0 {
                let width = collectionView.frame.width - 40
                let height = width/360*120
                return CGSize(width: width, height: height)
            }else{
                if self.shippingAddress != nil{
                    let width = collectionView.frame.width - 40
                    let height = width/360*230 + 150
                    return CGSize(width: width, height: height)
                }else{
                    let width = collectionView.frame.width - 40
                    let height = width/360*230
                    return CGSize(width: width, height: height)
                }
                
            }
            
        }else if indexPath.section == 2 {
            
            let width = collectionView.frame.width - 40
            let height = CGFloat(40)
            return CGSize(width: width, height: height)
        } else {
            let width = collectionView.frame.width
            let cheight = collectionView.frame.height
            
            if option == 0 {
                let height = abs((cheight) - (((width/360*110))+((width/360*120))+120))
                return CGSize(width: width, height: height)
            }else{
                if self.shippingAddress != nil{
                    let addOnHeight = heightForView(text: self.shippingAddress!, font: UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: 18)!, width: width) + 80
                    
                    let height = abs((cheight) - (((width/360*110))+((width/360*230 + addOnHeight))+120))
                    return CGSize(width: width, height: height)
                }else{
                    let height = abs((cheight) - (((width/360*110))+((width/360*230))+120))
                    return CGSize(width: width, height: height)
                }
                
            }
            
        }
        
    }
    
    
}
