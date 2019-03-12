//
//  GoldWithDrawChooseShippingViewController.swift
//  pointpow
//
//  Created by thanawat on 19/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class GoldWithDrawChooseShippingViewController: BaseViewController  , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var name:String = ""
    var mobile:String = ""
    var myAddress:[[String:AnyObject]]?
    
    var withdrawData:(premium:Int, goldbalance:Double,goldAmountToUnit:(amount:Int, unit:Int , price:Double))?{
        didSet{
            print(withdrawData!)
        }
    }
    
    func showShippinhAddress(){
        self.showShippingAddressPopup(true) { (address) in
            if !self.repeatView(address){
                print(address)
                
                self.updateUI(address)
                
            }
        }
    }
    func repeatView (_ address:AnyObject) -> Bool{
        if let message = address as? String {
            if message == "showViewAddress" {
                
                self.showShippingAddressPopup(true) { (address) in
                    if !self.repeatView(address){
                        print(address)
                        
                        self.updateUI(address)
                        
                    }
                }
                
                return true
            }else{
                return false
            }
        }else{
          return false
        }
    }
    var option = 0 {
        didSet{
            self.shippingAddress = nil
            if option == 1 {
                if let _ = self.myAddress?.count {
                   self.showShippinhAddress()
                }else{
                    self.showShippingPopup(true , editData: nil) { (address) in
                        //nextstep
                        self.updateUI(address)
                    }
                }
                
            }
            self.shippingCollectionView.reloadData()
        }
    }
    var shippingAddress:String?{
        didSet{
            self.shippingCollectionView.reloadData()
        }
    }
    
    func updateUI(_ address:AnyObject){
        if let data = address as? [String:AnyObject] {
            
            let address = data["address"] as? String ?? ""
            let districtName = data["district"]?["name_in_thai"] as? String ?? ""
            let subdistrictName = data["subdistrict"]?["name_in_thai"] as? String ?? ""
            let provinceName = data["province"]?["name_in_thai"] as? String ?? ""
            let zip_code = data["subdistrict"]?["zip_code"] as? NSNumber ?? 0
            
            var rawAddress = "\(self.name)"
            rawAddress += " \(address) \(subdistrictName) \(districtName) \(provinceName) \(zip_code)"
            rawAddress += " \(self.mobile)"
            
            self.shippingAddress = rawAddress
        }
    }
    
    @IBOutlet weak var shippingCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-gold-page-withdraw", comment: "")
        
        self.setUp()
        
        self.getUserInfo(){
            print("get my address")
            print("get my data")
        }
    }
    func getUserInfo(_ avaliable:(()->Void)?  = nil){
        
        var isLoading:Bool = true
        if self.myAddress != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        
        modelCtrl.getUserData(params: nil , isLoading , succeeded: { (result) in
            if let data = result as? [String:AnyObject] {
                let first_name = data["goldsaving_member"]?["firstname"] as? String ?? ""
                let last_name = data["goldsaving_member"]?["lastname"]as? String ?? ""
                let mobile = data["goldsaving_member"]?["mobile"]as? String ?? ""
                
                self.name = "\(first_name) \(last_name)"
                self.mobile = mobile
                
                let member_addresses = data["member_addresses"] as? [[String:AnyObject]] ?? [[:]]
                
                self.myAddress = member_addresses
            }
           
            avaliable?()
            
            
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                //self.showMessagePrompt(message)
            }
            
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
        }
    }

    func setUp(){
        
        self.backgroundImage?.image = nil
        self.shippingCollectionView.dataSource = self
        self.shippingCollectionView.delegate = self
        
        self.shippingCollectionView.showsVerticalScrollIndicator = false
        
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
    
    
    func showMap(){
        self.showInfoMapOfficePopup(true) {
            self.showMapFullViewController(true){
                Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.showMapPopup), userInfo: nil, repeats: false)
                
                //self.showMap()
            }
        }
    }
    @objc func showMapPopup(){
        showMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
        if indexPath.section == 0 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "WithDrawChooseShippingCell", for: indexPath) as? WithDrawChooseShippingCell{
                cell = item
                
                item.infoCallback = {
                    //info show popup pointpow
                    self.showMap()
                }
                item.infoThaipostCallback = {
                    //info show popup thaipost
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
                    
                    item.editCallback = {
                        //choose address
                        
                       self.showShippinhAddress()
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
                        print("summary office")
                        self.showWithDrawSummaryOfficeView(true, withdrawData: self.withdrawData)
                        
                        
                    }else{
                        print("summary thaipost")
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
                    let addOnHeight = heightForView(text: self.shippingAddress!, font: UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: 18)!, width: width) + 100
                    
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
