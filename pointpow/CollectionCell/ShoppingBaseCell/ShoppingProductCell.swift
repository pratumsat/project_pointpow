//
//  ShoppingProductCell.swift
//  pointpow
//
//  Created by thanawat on 26/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ShoppingProductCell: UICollectionViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var brandImageView: UIImageView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        self.updateLayerCornerRadiusProperties(5.0)
        self.contentView.updateLayerCornerRadiusProperties(5.0)
        self.shadowCellProperties()
    }

}
