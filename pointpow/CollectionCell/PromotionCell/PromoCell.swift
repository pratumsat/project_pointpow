//
//  PromoCell.swift
//  pointpow
//
//  Created by thanawat on 8/5/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PromoCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
     
        self.updateLayerCornerRadiusProperties()
        self.contentView.updateLayerCornerRadiusProperties()
        self.shadowCellProperties()
    }

}