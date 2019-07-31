//
//  ShoppingAddressViewController.swift
//  pointpow
//
//  Created by thanawat on 5/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class ShoppingAddressViewController: BaseViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var addressCollectionView: UICollectionView!
    
    var userData:AnyObject?
    var modelAddreses:[[String:AnyObject]]?
    var selectedAddressCallback:((_ selectedAddress:AnyObject)->Void)?
    
    
    
    var selectItem:Int?
    var selectedAddress:AnyObject?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                let member_addresses = data["member_addresses"] as? [[String:AnyObject]] ?? [[:]]
                
                self.modelAddreses = []
                self.selectedAddress = nil
                if member_addresses.count > 0 {
                    for address in member_addresses {
                        let type = address["type"] as? String ?? ""
                        let latest_shipping = address["latest_shipping"] as? NSNumber ?? 0
                        
                        if type.lowercased() == "shopping" {
                            if latest_shipping.boolValue {
                                self.selectedAddress = address as AnyObject
                            }
                            self.modelAddreses?.append(address)
                        }
                    }
                }
                self.modelAddreses = self.modelAddreses?.sorted(by: { (a1, a2) -> Bool in
                    let v1 = a1["latest_shipping"] as? NSNumber ?? 0
                    return v1.boolValue
                })

                //self.modelAddreses?.reverse()
                self.selectItem = nil
                
                
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
    
    @objc func addAddressTapped(){
        print("add address")
        self.showShoppingAddAddressPage(true)
    }
    
    func setUp(){
        self.title = NSLocalizedString("string-title-shopping-address", comment: "")
        let addAddress = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAddressTapped))
        self.navigationItem.rightBarButtonItem = addAddress
        
        
        self.backgroundImage?.image = nil
        
        
        
        self.addressCollectionView.dataSource = self
        self.addressCollectionView.delegate = self
        self.addressCollectionView.showsVerticalScrollIndicator = false
        
        self.addRefreshViewController(self.addressCollectionView)
        self.registerNib(self.addressCollectionView, "AddressViewCell")
        
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
    
    override func reloadData() {
        self.getUserInfo(){
            self.addressCollectionView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modelAddreses?.count ?? 0
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
                    let name = data["name"] as? String ?? ""
                    let mobile = data["mobile"] as? String ?? ""

                    let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
                    var rawAddress = "\(name) \(newMText.chunkFormatted())"
                    rawAddress += "\n\(address) \(subdistrictName) \(districtName) \(provinceName) \(zip_code)"

                    item.addressLabel.text = rawAddress


                    if let select = selectItem {
                        if indexPath.row == select {
                            item.selectedAddressByShopping = true
                        }else{
                            item.selectedAddressByShopping = false
                        }

                    }else{
                        if latest_shipping.boolValue  {
                            item.selectedAddressByShopping = true
                        }else{
                            item.selectedAddressByShopping = false
                        }
                    }
                }
               
                
                
                item.editCallback = {
                    print("edit address")
                    self.showShoppingEditAddressPage(true, self.modelAddreses?[indexPath.row] as AnyObject)
                }
                
                item.deleteCallback = {
                    if let data = self.modelAddreses?[indexPath.row] {
                        let latest_shipping = data["latest_shipping"] as? NSNumber ?? 0
                        let id = data["id"] as? NSNumber ?? 0
                       
                        if let select = self.selectItem {
                            if indexPath.row == select {
                                self.showMessagePrompt2(NSLocalizedString("string-item-shopping-cart-delete-address", comment: ""))
                            }else{
                                self.deleteAddress(id.intValue)
                            }
                            
                        }else{
                            if latest_shipping.boolValue  {
                                self.showMessagePrompt2(NSLocalizedString("string-item-shopping-cart-delete-address", comment: ""))
                            }else{
                                self.deleteAddress(id.intValue)
                            }
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
                let name = data["name"] as? String ?? ""
                let mobile = data["mobile"] as? String ?? ""
                
                let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
                
                var rawAddress = "\(name) \(newMText.chunkFormatted())"
                rawAddress += "\n\(address) \(subdistrictName) \(districtName) \(provinceName) \(zip_code)"

                
                var height = CGFloat(50)
                height += heightForView(text: rawAddress, font: UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: 16)!, width: width - 80)
                
                return CGSize(width: width, height: height)

            }
            
            
        }
        
        return CGSize.zero
        
    }

}
