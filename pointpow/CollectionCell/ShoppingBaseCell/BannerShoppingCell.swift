//
//  BannerShoppingCell.swift
//  pointpow
//
//  Created by thanawat on 27/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class BannerShoppingCell: PromotionCampainCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
        if let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell {
            cell = imageCell
            
            if let itemData = self.itemBanner?[indexPath.row] {
                let attachment = itemData["attachment"] as? [String:AnyObject] ?? [:]
                let full_location = attachment["full_location"] as? String ?? ""
                
              
                if let url = URL(string: full_location) {
                    imageCell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.BANNER_HOME_PLACEHOLDER))
                }
                
            }
            
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let item = self.itemBanner?[indexPath.row] {
//            let type = item["type"] as? String ?? ""
//            if type == "luckydraw" {
//                self.luckyDrawCallback?()
//            }
//        }
        
    }
}
