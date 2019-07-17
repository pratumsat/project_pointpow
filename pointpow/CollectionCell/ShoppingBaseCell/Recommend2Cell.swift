//
//  Recommend2Cell.swift
//  pointpow
//
//  Created by thanawat on 8/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class Recommend2Cell: RecommendCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setUp(){
        self.recommendCollectionView.delegate = self
        self.recommendCollectionView.dataSource = self
        self.recommendCollectionView.showsHorizontalScrollIndicator = false
        
        let nibName = "ShoppingRectProductCell"
        let nib = UINib(nibName: nibName, bundle: nil)
        self.recommendCollectionView.register(nib, forCellWithReuseIdentifier: nibName)
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
        if let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingRectProductCell", for: indexPath) as? ShoppingRectProductCell {
            cell = productCell
            
            if let item = self.recomendItems?[indexPath.row] {
                let title = item["title"] as? String ?? ""
                let brand = item["brand"] as? [String:AnyObject] ?? [:]
                let special_deal = item["special_deal"] as? [[String:AnyObject]] ?? [[:]]
                
                
                if special_deal.count == 0{
                    //check discount price
                    let regular_price = item["regular_price"] as? NSNumber ?? 0
                    let discount_price = item["discount_price"]  as? NSNumber ?? 0
                    
                    
                    if discount_price.intValue > 0 {
                        let numberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = .decimal
                        
                        let text = numberFormatter.string(from: regular_price) ?? "0"
                        let trail = NSLocalizedString("string-symbol-point-baht", comment: "")
                        
                        productCell.discountLabel.isHidden = false
                        productCell.discountLabel?.stuckCharacters( "\(text) \(trail)")
                        productCell.amountLabel.text = numberFormatter.string(from: discount_price)
                    }else{
                        let numberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = .decimal
                        
                        productCell.discountLabel.isHidden = true
                        productCell.amountLabel.text = numberFormatter.string(from: regular_price)
                    }
                    
                    
                }else{
                    //show special deal
                    let deal_price = special_deal.first?["deal_price"] as? NSNumber ?? 0
                    let price = special_deal.first?["price"]  as? NSNumber ?? 0
                    
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    
                    let text = numberFormatter.string(from: price) ?? "0"
                    let trail = NSLocalizedString("string-symbol-point-baht", comment: "")
                    
                    productCell.discountLabel.isHidden = false
                    productCell.discountLabel?.stuckCharacters( "\(text) \(trail)")
                    productCell.amountLabel.text = numberFormatter.string(from: deal_price)
                }
                
                productCell.desLabel.text = title
                
                if let url = URL(string: getFullPathImageView(brand)) {
                    productCell.brandImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                }
                if let url = URL(string: getFullPathImageView(item)) {
                    productCell.productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                }
            }
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.height - 20
        let width = collectionView.frame.width*0.8
        
        return CGSize(width: width, height: height)
    }
}
