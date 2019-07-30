//
//  ShoppingTaxInvoiceAddressViewController.swift
//  pointpow
//
//  Created by thanawat on 7/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ShoppingTaxInvoiceAddressViewController: ShoppingAddressViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setUp(){
        self.title = NSLocalizedString("string-title-shopping-address-taxinvoice", comment: "")
        let addAddress = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAddressTaxInvoiceTapped))
        self.navigationItem.rightBarButtonItem = addAddress
        
        
        self.backgroundImage?.image = nil
        
        self.addressCollectionView.dataSource = self
        self.addressCollectionView.delegate = self
        self.addressCollectionView.showsVerticalScrollIndicator = false
        
        self.addRefreshViewController(self.addressCollectionView)
        self.registerNib(self.addressCollectionView, "AddressViewCell")
        
    }
    
    override func getUserInfo(_ avaliable:(()->Void)?  = nil){
        
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
                        
                        if type.lowercased() == "invoice" {
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
    
    @objc func addAddressTaxInvoiceTapped(){
        print("addAddressTaxInvoiceTapped")
        self.showTaxInvoiceAddAddressPage(true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
                    let tax_invoice = data["tax_invoice"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let mobile = data["mobile"] as? String ?? ""
                    
                    let newText = String((tax_invoice).filter({ $0 != "-" }).prefix(13))
                    let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
                    
                    var rawAddress = "\(name) \(newText.chunkFormattedPersonalID())"
                    rawAddress += "\n\(newMText.chunkFormatted()) \(address) \(subdistrictName) \(districtName) \(provinceName) \(zip_code)"
                    
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
                    self.showTaxInvoiceEditAddressPage(true, self.modelAddreses?[indexPath.row] as AnyObject)
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
        
        return cell!
    }
        


    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if indexPath.section == 0 {
            
            let width = collectionView.frame.width
            if let data = modelAddreses?[indexPath.row] {
                let address = data["address"] as? String ?? ""
                let districtName = data["district"]?["name_in_thai"] as? String ?? ""
                let subdistrictName = data["subdistrict"]?["name_in_thai"] as? String ?? ""
                let provinceName = data["province"]?["name_in_thai"] as? String ?? ""
                let zip_code = data["subdistrict"]?["zip_code"] as? NSNumber ?? 0
                let tax_invoice = data["name"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let mobile = data["mobile"] as? String ?? ""
                
                let newText = String((tax_invoice).filter({ $0 != "-" }).prefix(13))
                let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
                
                var rawAddress = "\(name) \(newText.chunkFormattedPersonalID())"
                rawAddress += "\n\(newMText.chunkFormatted()) \(address) \(subdistrictName) \(districtName) \(provinceName) \(zip_code)"
                
                var height = CGFloat(50)
                height += heightForView(text: rawAddress, font: UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: 16)!, width: width - 80)
                
                return CGSize(width: width, height: height)
                
            }
            
        }
        
        return CGSize.zero
        
    }
    
}
