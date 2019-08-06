//
//  ProductShippingViewController.swift
//  pointpow
//
//  Created by thanawat on 5/8/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ProductShippingViewController: BaseViewController  , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var productShippingCollectionView: UICollectionView!
    
    var productItems:[[String:AnyObject]]?
    var aWaiting = 0
    var aShipping = 0
    var aComplete = 0
    
    
    var items:[[String:AnyObject]]?{
        didSet{
           self.updateItems()
        }
    }
    
    var selectType = "waiting" {
        didSet{
            self.updateItems()
        }
    }
    
    func updateView(){
        let index = IndexSet(integer: 1)
        self.productShippingCollectionView?.reloadSections(index)
    }
    
    
    func updateItems(){
        guard let mItems = items else {return}
        productItems = []
        aWaiting = 0
        aShipping = 0
        aComplete = 0
        
        for item in mItems {
            let shipping_status = item["shipping_status"] as? String ?? ""
            
            switch shipping_status.lowercased() {
            case "complete":
                aComplete += 1
                break
            case "waiting":
                aWaiting += 1
                break
            case "shipping":
                aShipping += 1
                break
            default:
                break
            }
            
                
            if selectType == shipping_status {
                productItems?.append(item)
            }
        }
        
        self.updateView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    var section = 0
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        section = 2
        self.productShippingCollectionView.reloadData()
    }
    func setUp(){
        self.title = NSLocalizedString("string-title-shopping-shipping", comment: "")
       
        self.backgroundImage?.image = nil
    
        self.productShippingCollectionView.dataSource = self
        self.productShippingCollectionView.delegate = self
        self.productShippingCollectionView.showsVerticalScrollIndicator = false
        
        self.registerHeaderNib(self.productShippingCollectionView, "HeaderSectionCell")
        self.registerHeaderNib(self.productShippingCollectionView, "ImageProductNotFoundCell")
        self.registerNib(self.productShippingCollectionView, "OrderShippingPageCell")
        self.registerNib(self.productShippingCollectionView, "OrderTrackingCell")
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return section
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return productItems?.count ?? 0
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if indexPath.section == 0 {
            if let selectCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderShippingPageCell", for: indexPath) as? OrderShippingPageCell {
                cell = selectCell

                let amountWaiting = NSLocalizedString("string-dailog-shopping-shipping-status-waiting-amount", comment: "")
                let amountShipping = NSLocalizedString("string-dailog-shopping-shipping-status-waiting-amount", comment: "")
                let amountComplete = NSLocalizedString("string-dailog-shopping-shipping-status-waiting-amount", comment: "")
                
                selectCell.amountCate1Label.text = amountWaiting.replace(target: "{amount}", withString: "\(self.aWaiting)")
                selectCell.amountCate2Label.text = amountShipping.replace(target: "{amount}", withString: "\(self.aShipping)")
                selectCell.amountCate3Label.text = amountComplete.replace(target: "{amount}", withString: "\(self.aComplete)")
                
               
                selectCell.selectType = self.selectType
                selectCell.selectedCallback  = { (index) in
                    switch index {
                    case 0:
                        self.selectType = "waiting"
                    case 1:
                        self.selectType = "shipping"
                    case 2:
                        self.selectType = "complete"
                    default: break
                        
                    }
                }
            }
        }else if indexPath.section == 1 {
            if let trackingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderTrackingCell", for: indexPath) as? OrderTrackingCell {
                cell = trackingCell
                
                if let item = self.productItems?[indexPath.row] {
                    let tracking_code = item["tracking_code"] as? String ?? ""
                    let shipping_status = item["shipping_status"] as? String ?? ""
                    let product_detail = item["product_detail"] as? [String:AnyObject] ?? [:]
                    let product_name = product_detail["product_name"] as? String ?? ""
                    let brand_image = product_detail["brand_image"] as? String ?? ""
                    let full_path_image = product_detail["full_path_image"] as? String ?? ""
                    let shipping_provider = item["shipping_provider"] as? [String:AnyObject] ?? [:]
                    let logo = shipping_provider["logo"] as? String ?? ""
                    let name = shipping_provider["name"] as? String ?? ""
                    let tracking_url = shipping_provider["tracking_url"] as? String ?? ""
                    
                    trackingCell.tackingCallback = {
                        if let url = URL(string: tracking_url) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url)
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                       
                    }
                    trackingCell.providerNameLabel.underlineCharacters(name)
                    trackingCell.trackingNumberLabel.text = tracking_code
                    trackingCell.productNameLabel.text = product_name
                    trackingCell.selectType = shipping_status.lowercased()
                    
                   
                    if let url = URL(string: logo) {
                        trackingCell.logoProviderImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                    }
                    if let url = URL(string: brand_image) {
                        trackingCell.brandImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                    }
                    if let url = URL(string: full_path_image) {
                        trackingCell.productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                    }
                    
                    
                }
            }
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 1 {
            guard let count = self.productItems?.count, count > 0 else {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ImageProductNotFoundCell", for: indexPath) as! ImageProductNotFoundCell
                header.nameLabel.text = NSLocalizedString("string-string-sesarch-not-found-product-shipping", comment: "")
                return header
            }
        }
       
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSectionCell", for: indexPath) as! HeaderSectionCell
        header.headerNameLabel.text = ""
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width = collectionView.frame.width
        
        
        if section == 1 {
            guard let count = self.productItems?.count, count > 0 else {
                let height = width
                return CGSize(width: width, height: height)
            }
        }
        return CGSize.zero

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        if section == 1 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        }
        return UIEdgeInsets.zero
    }
    
   
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 1 {
            let width = collectionView.frame.width
            var height = CGFloat(165)
            
            if let item = self.productItems?[indexPath.row] {
                let product_detail = item["product_detail"] as? [String:AnyObject] ?? [:]
                let product_name = product_detail["product_name"] as? String ?? ""
                height += heightForView(text: product_name, font: UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: 16)!, width: width - 110)
                
                return CGSize(width: width, height: height)
                
            }else{
                return CGSize.zero
            }
            
            
        }
        
        
        return CGSize(width: collectionView.frame.width, height: CGFloat(115))
        
    }
}
