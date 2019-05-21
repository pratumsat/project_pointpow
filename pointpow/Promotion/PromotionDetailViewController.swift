//
//  PromotionDetailViewController.swift
//  pointpow
//
//  Created by thanawat on 8/5/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class PromotionDetailViewController: BaseViewController {

    var promotionModel:[String:AnyObject]?
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var bannerLImageView: UIImageView!
    
    var id:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.backgroundImage?.image = nil
        
        
        self.getPromotion(){
            self.updateView()
        }
    }
    
    func updateView(){
        if let itemData = self.promotionModel {
            let title = itemData["title"] as? String ?? ""
            let cover_detail = itemData["cover_detail"] as? String ?? ""
            let detail = itemData["detail"] as? String ?? ""
            
            self.title = title
            self.titleLabel.text = title
            self.detailLabel.text = detail
            
            if let url = URL(string: cover_detail) {
                self.bannerLImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.BANNER_PROMOTION_MOCK_DETAIL))
            }else{
                self.bannerLImageView.image = UIImage(named: Constant.DefaultConstansts.DefaultImaege.BANNER_PROMOTION_MOCK_DETAIL)
            }
            
        }
       
    }

    func getPromotion(_ avaliable:(()->Void)?  = nil){
        
        var isLoading:Bool = true
        if self.promotionModel != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        
        modelCtrl.promotionById(id: self.id! , isLoading , succeeded: { (result) in
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
