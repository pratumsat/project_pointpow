//
//  WidthDrawShippingPointPowCell.swift
//  pointpow
//
//  Created by thanawat on 19/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class WidthDrawShippingPointPowCell: UICollectionViewCell {

    @IBOutlet weak var premiunLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  
        self.updateLayerCornerRadiusProperties()
        self.contentView.updateLayerCornerRadiusProperties()
        self.shadowCellProperties()
        
    }
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }


}
