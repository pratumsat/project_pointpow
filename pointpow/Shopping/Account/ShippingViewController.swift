//
//  ShippingViewController.swift
//  pointpow
//
//  Created by thanawat on 31/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ShippingViewController: BaseViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var shippingCollectionView: UICollectionView!
    
    var shippingItem:[[String:AnyObject]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("string-item-shopping-track-shipping", comment: "")
        
        self.setUp()
    }
    
    override func reloadData() {
        self.getShippingList() {
            self.shippingCollectionView.reloadData()
        }
    }
    func setUp(){
        self.shippingCollectionView.delegate = self
        self.shippingCollectionView.dataSource = self
        
        self.shippingCollectionView.showsVerticalScrollIndicator = false
        self.addRefreshViewController(self.shippingCollectionView)
        
        
        self.registerHeaderNib(self.shippingCollectionView, "HeaderSectionCell")
        
        self.registerNib(self.shippingCollectionView, "ItemLogisticsCell")
        
        self.getShippingList() {
            self.shippingCollectionView.reloadData()
        }
    }
    
    func getShippingList(_ success:(()->Void)? = nil){
        
        modelCtrl.getShippingList(params: nil , true , succeeded: { (result) in
            if let mResult = result as? [[String:AnyObject]] {
                self.shippingItem = mResult
                success?()
                
            }
            self.refreshControl?.endRefreshing()
            
        }, error: { (error) in
            self.refreshControl?.endRefreshing()
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                
                self.showMessagePrompt(message)
            }
            
            print(error)
        }) { (messageError) in
            print("messageError")
            self.refreshControl?.endRefreshing()
            self.handlerMessageError(messageError)
            
        }
    }
}
extension ShippingViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let count = self.shippingItem?.count , count > 0 else { return 0 }
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return shippingItem?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        var cell:UICollectionViewCell?
     
        if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemLogisticsCell", for: indexPath) as? ItemLogisticsCell {
            cell = item
            
            if let data = self.shippingItem?[indexPath.row] {
                let name = data["name"] as? String ?? ""
                let logo = data["logo"] as? String ?? ""
                item.nameLabel.text = name
  
                if let url = URL(string: logo) {
                    item.logoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                }else{
                    item.logoImageView.image = UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER)
                }
            }
            
            
            //item.providerLabel.setLineSpacing(lineSpacing: 0, lineHeightMultiple: 0.9)   // for thai sans
            //item.providerLabel.textAlignment = .center
        }
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = self.shippingItem?[indexPath.row] {
            let tracking_url = data["tracking_url"] as? String ?? ""
            
            guard let url = URL(string: tracking_url) else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let width = collectionView.frame.width
        let height = CGFloat(70.0)
        return CGSize(width: width, height: height)
      
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSectionCell", for: indexPath) as! HeaderSectionCell
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
}
