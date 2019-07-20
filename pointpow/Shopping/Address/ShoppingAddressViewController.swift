//
//  ShoppingAddressViewController.swift
//  pointpow
//
//  Created by thanawat on 5/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

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
                
                //self.name = "\(first_name) \(last_name)"
                //self.mobile = mobile
                
                let member_addresses = data["member_addresses"] as? [[String:AnyObject]] ?? [[:]]
                
                self.modelAddreses = []
                if member_addresses.count > 0 {
                    for address in member_addresses {
                        let type = address["type"] as? String ?? ""
                        if type.lowercased() == "shopping" {
                            self.modelAddreses?.append(address)
                        }
                    }
                }
                
                
               // self.selectedAddress = nil
                //self.countAddress = self.modelAddreses?.count ?? 0
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
    
    override func reloadData() {
        self.refreshControl?.endRefreshing()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
        if indexPath.section == 0 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "AddressViewCell", for: indexPath) as? AddressViewCell {
                
//                if let data = modelAddreses?[indexPath.row] {
//                    // let id = data["id"] as? NSNumber ?? 0
//                    let address = data["address"] as? String ?? ""
//                    let districtName = data["district"]?["name_in_thai"] as? String ?? ""
//                    let subdistrictName = data["subdistrict"]?["name_in_thai"] as? String ?? ""
//                    let provinceName = data["province"]?["name_in_thai"] as? String ?? ""
//                    let zip_code = data["subdistrict"]?["zip_code"] as? NSNumber ?? 0
//                    let latest_shipping = data["latest_shipping"] as? NSNumber ?? 0
//
//                    rawAddress += " \(address) \(subdistrictName) \(districtName) \(provinceName) \(zip_code)"
//                    rawAddress += " \(self.mobile)"
//
//                    item.addressLabel.text = rawAddress
//
//
//                    if let select = selectItem {
//                        if indexPath.row == select {
//                            item.selectedAddress = true
//                        }else{
//                            item.selectedAddress = false
//                        }
//
//                    }else{
//                        if latest_shipping.boolValue  {
//                            item.selectedAddress = true
//                            self.selectedAddress = data as AnyObject
//                        }else{
//                            item.selectedAddress = false
//                        }
//                    }
//                }
                var rawAddress = "thanwat pratumsat 0836732572 45/33 หมู่บ้านสวนหลวง เฉลิมพระเกียรติ9 ดอกไม้ ประเวศ กรุงเทพมหานคร 10250"
                item.addressLabel.text = rawAddress
                
                item.editCallback = {
                    print("edit address")
                    
                    self.showShoppingEditAddressPage(true)
                }
                item.deleteCallback = {
                    let alert = UIAlertController(title: NSLocalizedString("string-dailog-title-delete-address", comment: ""),
                                                  message: "", preferredStyle: .alert)
                    
                    let okButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-ok", comment: ""), style: .default, handler: {
                        (alert) in
                        
//                        if let data = self.modelAddreses?[indexPath.row] {
//                            let id = data["id"] as? NSNumber ?? 0
//
//                            self.modelCtrl.deleteMemberAddress(id: id.intValue, true, succeeded: { (result) in
//
//                                self.getUserInfo(){
//                                    self.addressCollectionView.reloadData()
//                                }
//
//                            }, error: { (error) in
//                                if let mError = error as? [String:AnyObject]{
//                                    let message = mError["message"] as? String ?? ""
//                                    print(message)
//                                    self.showMessagePrompt(message)
//                                }
//
//                                print(error)
//                            }) { (messageError) in
//                                print("messageError")
//                                self.handlerMessageError(messageError)
//
//                            }
//                        }
                        
                        
                        
                    })
                    let cancelButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-cancel", comment: ""), style: .default, handler: nil)
                    
                    
                    alert.addAction(cancelButton)
                    alert.addAction(okButton)
                    
                    self.present(alert, animated: true, completion: nil)
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
        
        self.selectItem = indexPath.row
        self.selectedAddress = self.modelAddreses?[indexPath.row] as AnyObject
        
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
//            if let data = modelAddreses?[indexPath.row] {
//                let address = data["address"] as? String ?? ""
//                let districtName = data["district"]?["name_in_thai"] as? String ?? ""
//                let subdistrictName = data["subdistrict"]?["name_in_thai"] as? String ?? ""
//                let provinceName = data["province"]?["name_in_thai"] as? String ?? ""
//                let zip_code = data["subdistrict"]?["zip_code"] as? NSNumber ?? 0
//
//
//            }
            var rawAddress = "thanwat pratumsat 0836732572 45/33 หมู่บ้านสวนหลวง เฉลิมพระเกียรติ9 ดอกไม้ ประเวศ กรุงเทพมหานคร 10250"
            let height = heightForView(text: rawAddress, font: UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: 16)!, width: width) +  60
            
            return CGSize(width: width, height: height)
            
        }
        
        return CGSize.zero
        
    }

}
