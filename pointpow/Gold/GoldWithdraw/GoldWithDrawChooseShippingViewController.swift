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
    
    var ems_price:Int = 0
    var fee_price:Int = 0
    var addressModel:[String:AnyObject]?
    
    var heightAddressView:CGFloat = CGFloat(0)
    
    var withdrawData:(pointBalance:Double, premium:Int, goldbalance:Double, goldAmountToUnit:(amount:Int, unit:Int , price:Double, goldPrice:Int), goldReceive:[(amount:Int,unit:String)]? )?{
        didSet{
            print(withdrawData!)
        }
    }
    
    func showShippinhAddress(){
        self.showShippingAddressPopup(true, selectCallback: { (address) in
            if !self.repeatView(address){
                print(address)
                
                self.updateUI(address)
                
            }
        }) {
            self.getUserInfo() {
                self.shippingCollectionView.reloadData()
            }
        }
    }
    func repeatView (_ address:AnyObject) -> Bool{
        if let message = address as? String {
            if message == "showViewAddress" {
                self.showShippingAddressPopup(true, selectCallback: { (address) in
                    if !self.repeatView(address){
                        print(address)
                        
                        self.updateUI(address)
                        
                    }
                }) {
                    self.getUserInfo(){
                        self.shippingCollectionView.reloadData()
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
            self.addressModel = nil
            if option == 1 {
                if let count = self.myAddress?.count {
                    if count > 0 {
                        self.showShippinhAddress()
                    }else{
                        self.showShippingPopup(true , editData: nil) { (address) in
                            //nextstep
                            self.myAddress?.append([:])
                            self.updateUI(address)
                        }
                    }
                   
                }
                
            }
            self.shippingCollectionView.reloadData()
        }
    }
    var shippingAddress:String?
    
    func updateUI(_ address:AnyObject){
        if let data = address as? [String:AnyObject] {
            self.addressModel = data
            
            let address = data["address"] as? String ?? ""
            let districtName = data["district"]?["name_in_thai"] as? String ?? ""
            let subdistrictName = data["subdistrict"]?["name_in_thai"] as? String ?? ""
            let provinceName = data["province"]?["name_in_thai"] as? String ?? ""
            let zip_code = data["subdistrict"]?["zip_code"] as? NSNumber ?? 0
            
            let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
            var rawAddress = "\(self.name) \(newMText.chunkFormatted())"
            rawAddress += "\n\(address) \(subdistrictName) \(districtName) \(provinceName) \(zip_code)"
            
            self.shippingAddress = rawAddress
            
            self.getPriceThaiPost(){
                print("ems_price = \(self.ems_price)")
                print("fee_price = \(self.fee_price)")
                
                self.shippingCollectionView.reloadData()
            }
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
            self.shippingCollectionView.reloadData()
        }
        self.getPriceThaiPost(){
            print("ems_price = \(self.ems_price)")
            print("fee_price = \(self.fee_price)")
        }
    }
    
    func getPriceThaiPost(_ avaliable:(()->Void)?  = nil){
        modelCtrl.getServicePriceThaiPost(params: nil , true , succeeded: { (result) in
            print("get price thaipost")
            if let data = result as? [String:AnyObject] {
                let shipping = data["shipping"] as? [[String:AnyObject]] ?? []
                if shipping.count > 0 {
                    for item in shipping {
                        let name = item["name"] as? String ?? ""
                        let ems_price = item["ems_price"] as? NSNumber ?? 0
                        let fee_price = item["fee_price"] as? NSNumber ?? 0
                        
                        if name.lowercased() == "thaipost"{
                            self.ems_price = ems_price.intValue
                            self.fee_price = fee_price.intValue
                        }
                    }
                    
                }
            }
            avaliable?()
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
    
    func getUserInfo(_ avaliable:(()->Void)?  = nil){
        
        self.shippingAddress = nil
        self.addressModel = nil
        
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
                self.myAddress = []
                if member_addresses.count > 0 {
                    for address in member_addresses {
                        let type = address["type"] as? String ?? ""
                        if type.lowercased() == "gold" {
                            self.myAddress?.append(address)
                        }
                    }
                }
               
                
            }
           
            avaliable?()
            
            
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
                    self.showInfoThaiPostPopup(true)
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
                    
                    item.heightAddress = { (height) in
                        self.heightAddressView = height
                        
                        self.shippingCollectionView.performBatchUpdates({
                            collectionView.reloadInputViews()
                        }, completion: { (true) in
                            //item.amountTextField.becomeFirstResponder()
                        })
                    }
                    
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    
                    item.premiumLabel.text = numberFormatter.string(from: NSNumber(value: self.withdrawData!.premium))
                    
                    let premium = self.withdrawData!.premium
                    let price = Int(self.withdrawData!.goldAmountToUnit.price)
                    let goldPrice = Int(self.withdrawData!.goldAmountToUnit.goldPrice)
                    let goldUnit = self.withdrawData!.goldAmountToUnit.unit
                    let emsfee = self.ems_price + self.fee_price
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
                        for _ in 1...amountBox {
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
                    }
                    
                    let totalPrice = premium + totalServicePrice
                    
                    item.emsLabel.text  = numberFormatter.string(from: NSNumber(value: totalServicePrice))
                    item.sumLabel.text = numberFormatter.string(from: NSNumber(value: totalPrice))
                    
                    item.editCallback = {
                        //choose address
                       self.showShippinhAddress()
                    }
                    
                    
                }
            }
           
            
        }else if indexPath.section == 2 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "NextButtonCell", for: indexPath) as? NextButtonCell {
                cell = item
                item.enableButton()
                item.nextCallback = {
                    if self.option == 0 {
                        //next
                        print("summary office")
                        self.showWithDrawSummaryOfficeView(true, withdrawData: self.withdrawData)
                        
                        
                    }else{
                        print("summary thaipost")
                        
                        if let  address = self.addressModel {
                            self.showWithDrawSummaryThaiPostView(true,
                                                                 withdrawData: self.withdrawData,
                                                                 addressModel: address,
                                                                 ems: self.ems_price, fee: self.fee_price, name: self.name, mobile: self.mobile)
                        }else{
                            
                            if let count = self.myAddress?.count {
                                if count > 0 {
                                    self.showShippinhAddress()
                                }else{
                                    self.showShippingPopup(true , editData: nil) { (address) in
                                        //nextstep
                                        self.myAddress?.append([:])
                                        self.updateUI(address)
                                    }
                                }
                                
                            }
                        }
                       
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
        
        if section == 2 {
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
            let height = CGFloat(105)
            return CGSize(width: width, height: height)
        }else if indexPath.section == 1 {
            
            if option == 0 {
                let width = collectionView.frame.width - 40
                let height = CGFloat(100)
                return CGSize(width: width, height: height)
            }else{
                if self.shippingAddress != nil{
                    let width = collectionView.frame.width - 40
                    let height = CGFloat(180) + self.heightAddressView
                    return CGSize(width: width, height: height)
                }else{
                    let width = collectionView.frame.width - 40
                    let height = CGFloat(180)
                    return CGSize(width: width, height: height)
                }
                
            }
            
        }else if indexPath.section == 2 {
            
            let width = collectionView.frame.width - 40
            let height = CGFloat(40)
            return CGSize(width: width, height: height)
        } else {
            let width = collectionView.frame.width
            return CGSize(width: width, height: CGFloat(60))
        }
        
    }
    
    
}
