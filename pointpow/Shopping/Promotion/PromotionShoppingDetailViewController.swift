//
//  PromotionShoppingDetailViewController.swift
//  pointpow
//
//  Created by thanawat on 5/8/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PromotionShoppingDetailViewController: PromotionDetailViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
   override func updateView(){
        if let itemData = self.promotionModel {
            let title = itemData["title"] as? String ?? ""
            let description = itemData["description"] as? String ?? ""
            let image_detail_mobile = itemData["image_detail_mobile"] as? String ?? ""
            
            
            self.title = title
            self.titleLabel.text = title
            self.detailLabel.text = description
            
            if let url = URL(string: image_detail_mobile) {
                self.bannerLImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.BANNER_PROMO_DETAIL_PLACEHOLDER))
            }else{
                self.bannerLImageView.image = UIImage(named: Constant.DefaultConstansts.DefaultImaege.BANNER_PROMO_DETAIL_PLACEHOLDER)
            }
            
        }
        
    }
    
   override func getPromotion(_ avaliable:(()->Void)?  = nil){
        
        var isLoading:Bool = true
        if self.promotionModel != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        
        modelCtrl.shoppingPromotionById(id: self.id! , isLoading , succeeded: { (result) in
            if let mResult = result as? [String:AnyObject] {
                self.promotionModel = mResult
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
}
