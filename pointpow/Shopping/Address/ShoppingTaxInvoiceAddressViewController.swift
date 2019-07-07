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
    @objc func addAddressTaxInvoiceTapped(){
        print("addAddressTaxInvoiceTapped")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
        if indexPath.section == 0 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "AddressViewCell", for: indexPath) as? AddressViewCell {
                
                let newText = String(("1489900090467").filter({ $0 != "-" }).prefix(13))
                var rawAddress = "\(newText)\n"
                rawAddress += "thanwat pratumsat 0836732572 45/33 หมู่บ้านสวนหลวง เฉลิมพระเกียรติ9 ดอกไม้ ประเวศ กรุงเทพมหานคร 10250"
                item.addressLabel.text = rawAddress
                
                item.editCallback = {
                    print("edit address")
                }
                item.deleteCallback = {
                    let alert = UIAlertController(title: NSLocalizedString("string-dailog-title-delete-address", comment: ""),
                                                  message: "", preferredStyle: .alert)
                    
                    let okButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-ok", comment: ""), style: .default, handler: {
                        (alert) in
                        
                    })
                    let cancelButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-cancel", comment: ""), style: .default, handler: nil)
                    
                    
                    alert.addAction(cancelButton)
                    alert.addAction(okButton)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                
                cell = item
            }
        }
        
        return cell!
    }
        


    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if indexPath.section == 0 {
            
            let width = collectionView.frame.width
            
            let newText = String(("1489900090467").filter({ $0 != "-" }).prefix(13))
            var rawAddress = "\(newText)\n"
            rawAddress += "thanwat pratumsat 0836732572 45/33 หมู่บ้านสวนหลวง เฉลิมพระเกียรติ9 ดอกไม้ ประเวศ กรุงเทพมหานคร 10250"
            
            
            let height = heightForView(text: rawAddress, font: UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: 16)!, width: width) +  60
            
            return CGSize(width: width, height: height)
            
        }
        
        return CGSize.zero
        
    }
    
}
