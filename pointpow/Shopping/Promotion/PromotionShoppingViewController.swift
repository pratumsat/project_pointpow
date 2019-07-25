//
//  PromotionShoppingViewController.swift
//  pointpow
//
//  Created by thanawat on 25/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PromotionShoppingViewController: ShoppingBaseViewController {
    
    
    var promotionList:[[String:AnyObject]]?
    
    @IBOutlet weak var promotionCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = NSLocalizedString("string-title-promotion", comment: "")
        
    }
    
    func setUp(){
        
        self.backgroundImage?.image = nil
        
        self.promotionCollectionView.dataSource = self
        self.promotionCollectionView.delegate = self
        self.promotionCollectionView.showsVerticalScrollIndicator = false
        self.addRefreshViewController(self.promotionCollectionView)
        
        self.registerNib(promotionCollectionView, "PromoCell")
        self.registerHeaderNib(promotionCollectionView, "HeaderSectionCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getPromotion()
    }
    override func reloadData() {
        self.getPromotion()
    }
    
    func getPromotion(_ avaliable:(()->Void)?  = nil){
        
        var isLoading:Bool = true
        if self.promotionList != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        modelCtrl.promotionList(params: nil , isLoading , succeeded: { (result) in
            if let mResult = result as? [[String:AnyObject]] {
                
                
                if mResult.count <= 0 {
                    print("not found notification data")
                    self.addViewNotfoundData()
                }else{
                    self.promotionList = mResult
                    
                    self.promotionCollectionView.backgroundView = nil
                    self.promotionCollectionView.reloadData()
                }
            }
            
            
            
            avaliable?()
            
            
            self.refreshControl?.endRefreshing()
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                self.showMessagePrompt(message)
            }
            self.refreshControl?.endRefreshing()
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
            self.refreshControl?.endRefreshing()
        }
        
    }
    
    func addViewNotfoundData(){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        var centerpoint = view.center
        centerpoint.y -= self.view.frame.height*0.2
        
        let sorry = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        sorry.center = centerpoint
        sorry.textAlignment = .center
        sorry.font = UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.CONTENT )
        sorry.text = NSLocalizedString("string-not-found-item-pomotion", comment: "")
        sorry.textColor = UIColor.lightGray
        view.addSubview(sorry)
        
        self.promotionCollectionView.reloadData()
        self.promotionCollectionView.backgroundView = view
    }
    
    override  func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView != promotionCollectionView {
            return super.numberOfSections(in: collectionView)
        }
        
        return self.promotionList?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView != promotionCollectionView {
            return super.collectionView(collectionView, numberOfItemsInSection: section)
        }
        return 1
    }
    
    override  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView != promotionCollectionView {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
        
        var cell:UICollectionViewCell?
        
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromoCell", for: indexPath) as? PromoCell{
            cell = itemCell
            
            if let itemData = self.promotionList?[indexPath.section] {
                let title = itemData["title"] as? String ?? ""
                let path_mobile_thumbnail = itemData["path_mobile_thumbnail"] as? String ?? ""
                let shot_description = itemData["shot_description"] as? String ?? ""
                let created_at = itemData["created_at"] as? String ?? ""
                
                itemCell.dateLabel.text = convertDateOfDay(created_at)
                itemCell.titleLabel.text = title
                itemCell.detailLabel.text = shot_description
                
                if let url = URL(string: path_mobile_thumbnail) {
                    itemCell.bannerImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.BANNER_PROMO_PLACEHOLDER))
                }else{
                    itemCell.bannerImageView.image = UIImage(named: Constant.DefaultConstansts.DefaultImaege.BANNER_PROMO_PLACEHOLDER)
                }
                
            }
            
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    override  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != promotionCollectionView {
            super.collectionView(collectionView, didSelectItemAt: indexPath)
        }
        
        if let itemData = self.promotionList?[indexPath.section] {
            let id = itemData["id"] as? NSNumber ?? 0
            self.showPromotionDetail(id.stringValue, true)
        }
        
        
    }

    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView != promotionCollectionView {
            return super.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
        }
        
        return CGSize(width: collectionView.frame.width, height: 20)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let size = (self.promotionList?.count ?? 0) - 1
        if size == section {
            return UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        }
        return UIEdgeInsets.zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView != promotionCollectionView {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSectionCell", for: indexPath) as! HeaderSectionCell
        header.headerNameLabel.text = ""
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView != promotionCollectionView {
            return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        }
        
        let width = collectionView.frame.width - 20
        
        let heightImage = (width-20)/950*400
        
        let height = heightImage + 120
        return CGSize(width: width, height: height)
    }
    

}
