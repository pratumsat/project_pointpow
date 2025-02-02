//
//  PopupShippingMyAddressViewController.swift
//  pointpow
//
//  Created by thanawat on 24/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire


class PopupShippingMyAddressViewController: BaseViewController  , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    
    var userData:AnyObject?
    var modelAddreses:[[String:AnyObject]]?
    var selectedAddressCallback:((_ selectedAddress:AnyObject)->Void)?
    var addAddressCallback:((_ modelAddress:AnyObject?)->Void)?
    var editAddressCallback:((_ modelAddress:AnyObject?)->Void)?
    var reloadDataCallback:(()->Void)?
    @IBOutlet weak var addressCollectionView: UICollectionView!
    
    var selectItem:Int?
    var selectedAddress:AnyObject?{
        didSet{
            print(self.selectedAddress)
        }
    }
    
    var name:String = ""
    var mobile:String = ""
    
    var countAddress = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()
        
        self.getUserInfo(){
            self.addressCollectionView.reloadData()
        }
        
    }
 
    
    func getUserInfo(_ avaliable:(()->Void)?  = nil){
        
        var isLoading:Bool = true
        if self.userData != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        
        modelCtrl.getUserData(params: nil , isLoading , succeeded: { (result) in
            self.userData = result
            
            if let data  = self.userData as? [String:AnyObject] {
                let first_name = data["goldsaving_member"]?["firstname"] as? String ?? ""
                let last_name = data["goldsaving_member"]?["lastname"]as? String ?? ""
                let mobile = data["goldsaving_member"]?["mobile"]as? String ?? ""
                
                self.name = "\(first_name) \(last_name)"
                self.mobile = mobile
                
                let member_addresses = data["member_addresses"] as? [[String:AnyObject]] ?? [[:]]
               
                self.modelAddreses = []
                self.selectedAddress = nil
                
                if member_addresses.count > 0 {
                    for address in member_addresses {
                        let type = address["type"] as? String ?? ""
                        let latest_shipping = address["latest_shipping"] as? NSNumber ?? 0
                        
                        if type.lowercased() == "gold" {
                            if latest_shipping.boolValue {
                                self.selectedAddress = address as AnyObject
                            }
                            self.modelAddreses?.append(address)
                        }
                    }
                }
                self.modelAddreses = self.modelAddreses?.sorted(by: { (a1, a2) -> Bool in
                    let v1 = a1["latest_shipping"] as? NSNumber ?? 0
                    let v2 = a2["latest_shipping"] as? NSNumber ?? 0
                    return v1.boolValue
                })
                
                self.countAddress = self.modelAddreses?.count ?? 0
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
    
    
    override func dismissPoPup() {
        super.dismissPoPup()
        
        self.dismiss(animated: true, completion: {
            if self.countAddress == 0 {
                self.reloadDataCallback?()
            }
            
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCloseBlackView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.submitButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    func setUp(){
        self.backgroundImage?.image = nil
        
        self.submitButton.borderClearProperties(borderWidth: 1)
        
        
        self.addressCollectionView.dataSource = self
        self.addressCollectionView.delegate = self
        self.addressCollectionView.showsVerticalScrollIndicator = false
        
        self.registerNib(self.addressCollectionView, "AddressViewCell")
        
        //add
        let add = UITapGestureRecognizer(target: self, action: #selector(addTapped))
        self.addView.isUserInteractionEnabled = true
        self.addView.addGestureRecognizer(add)
        

    }
    
    @IBAction func submitTapped(_ sender: Any) {
        if let model = self.selectedAddress {
            self.dismiss(animated: true) {
                self.windowSubview?.removeFromSuperview()
                self.windowSubview = nil
                
                self.selectedAddressCallback?(model)
            }
        }else{
            self.showMessagePrompt(NSLocalizedString("string-dailog-title-please-choose-address", comment: ""))
        }
        
    }
    
    @objc func addTapped(){
        self.dismiss(animated: false) {
            self.windowSubview?.removeFromSuperview()
            self.windowSubview = nil
            self.addAddressCallback?(nil)
        }
        
    }
    
    func deleteAddress(_ id:Int){
        let alert = UIAlertController(title: NSLocalizedString("string-dailog-title-delete-address", comment: ""),
                                      message: "", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-ok", comment: ""), style: .default, handler: {
            (alert) in
            
            self.modelCtrl.deleteMemberAddress(id: id, true, succeeded: { (result) in
                
                self.getUserInfo(){
                    self.addressCollectionView.reloadData()
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
            
        })
        let cancelButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-cancel", comment: ""), style: .default, handler: nil)
        
        
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    var isCall = false
    
    func updateLatestShippingAddress(_ id:Int, m_type: String){
        
        if isCall {
            return
        }
        isCall = true
        
        let params:Parameters = ["id":id,
                                 "type":m_type]
        
        self.modelCtrl.updateMemberLatestAddress(params: params, true, succeeded: { (result) in
            //update success
            self.isCall = false
            self.addressCollectionView.reloadData()
            
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                self.showMessagePrompt(message)
            }
            self.isCall = false
            print(error)
            
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
            self.isCall = false
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return modelAddreses?.count ?? 0
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
        if indexPath.section == 0 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "AddressViewCell", for: indexPath) as? AddressViewCell {
                
                if let data = modelAddreses?[indexPath.row] {
                   // let id = data["id"] as? NSNumber ?? 0
                    let address = data["address"] as? String ?? ""
                    let districtName = data["district"]?["name_in_thai"] as? String ?? ""
                    let subdistrictName = data["subdistrict"]?["name_in_thai"] as? String ?? ""
                    let provinceName = data["province"]?["name_in_thai"] as? String ?? ""
                    let zip_code = data["subdistrict"]?["zip_code"] as? NSNumber ?? 0
                    let latest_shipping = data["latest_shipping"] as? NSNumber ?? 0
                    
                    
                    let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
                    
                    var rawAddress = "\(self.name) \(newMText.chunkFormatted())"
                    rawAddress += "\n\(address) \(subdistrictName) \(districtName) \(provinceName) \(zip_code)"

                    item.addressLabel.text = rawAddress
                    
                    
                    
                    if let select = selectItem {
                        if indexPath.row == select {
                            item.selectedAddress = true
                        }else{
                            item.selectedAddress = false
                        }
                        
                    }else{
                        if latest_shipping.boolValue  {
                            item.selectedAddress = true
                        }else{
                            item.selectedAddress = false
                        }
                    }
                }
                
               
                
                
                item.editCallback = {
                    print("edit address")
                    self.dismiss(animated: false) {
                        self.windowSubview?.removeFromSuperview()
                        self.windowSubview = nil
                        self.editAddressCallback?(self.modelAddreses?[indexPath.row] as AnyObject)
                    }
                }
                item.deleteCallback = {
                    if let data = self.modelAddreses?[indexPath.row] {
                        let latest_shipping = data["latest_shipping"] as? NSNumber ?? 0
                        let id = data["id"] as? NSNumber ?? 0
                        if latest_shipping.boolValue  {

                            self.showMessagePrompt2(NSLocalizedString("string-item-shopping-cart-delete-address", comment: ""))
                        }else{
                            self.deleteAddress(id.intValue)
                        }
                    }
                }
                
                
                cell = item
            }
            
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let select = self.modelAddreses?[indexPath.row] as AnyObject
        let idSelect = select["id"] as? NSNumber ?? 0
        
        let defaultSelect = selectedAddress?["id"] as? NSNumber ?? 0
        if defaultSelect.intValue == idSelect.intValue {
            return
        }
        
        
        self.selectItem = indexPath.row
        self.selectedAddress = self.modelAddreses?[indexPath.row] as AnyObject
        
        if let data = self.modelAddreses?[indexPath.row]{
            let id = data["id"] as? NSNumber ?? 0
            let type = data["type"] as? String ?? ""
            self.updateLatestShippingAddress(id.intValue, m_type: type)
        }
        
        
        
        self.addressCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.zero
        //return CGSize(width: collectionView.frame.width, height: 20)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if indexPath.section == 0 {
            
            let width = collectionView.frame.width
            if let data = modelAddreses?[indexPath.row] {
                let address = data["address"] as? String ?? ""
                let districtName = data["district"]?["name_in_thai"] as? String ?? ""
                let subdistrictName = data["subdistrict"]?["name_in_thai"] as? String ?? ""
                let provinceName = data["province"]?["name_in_thai"] as? String ?? ""
                let zip_code = data["subdistrict"]?["zip_code"] as? NSNumber ?? 0
                
               
                let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
                var rawAddress = "\(self.name) \(newMText.chunkFormatted())"
                rawAddress += "\n\(address) \(subdistrictName) \(districtName) \(provinceName) \(zip_code)"
                
                
                var height = CGFloat(30)
                height += heightForView(text: rawAddress, font: UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: 16)!, width: width - 120)
                
                
                return CGSize(width: width, height: height)
            }
            
        }
        
        return CGSize.zero
        
    }
}
