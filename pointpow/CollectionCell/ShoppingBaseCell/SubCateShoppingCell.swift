//
//  SubCateShoppingCell.swift
//  pointpow
//
//  Created by thanawat on 25/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class SubCateShoppingCell: UICollectionViewCell {

    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //self.mView.borderColorProperties(borderWidth: 1, color: Constant.Colors.CATE2.cgColor)
        
    }
}
