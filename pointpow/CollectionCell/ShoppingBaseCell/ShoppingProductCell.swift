//
//  ShoppingProductCell.swift
//  pointpow
//
//  Created by thanawat on 26/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ShoppingProductCell: UICollectionViewCell {
    @IBOutlet weak var soldOutView: UIView!
    
    @IBOutlet weak var mSoldOutView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var brandImageView: UIImageView!
   
    
    var soldOut = false {
        didSet{
            if self.soldOut {
                self.mSoldOutView?.isHidden = false
            }else{
                self.mSoldOutView?.isHidden = true
            }
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mSoldOutView?.alpha = 0.8
        self.updateLayerCornerRadiusProperties(5.0)
        self.contentView.updateLayerCornerRadiusProperties(5.0)
        self.shadowCellProperties()
    }
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.soldOutView?.ovalColorRedProperties(borderWidth: 1.0)
    }

}
