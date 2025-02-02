//
//  WithDrawMyGoldCell.swift
//  pointpow
//
//  Created by thanawat on 15/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class WithDrawMyGoldCell: UICollectionViewCell {

    @IBOutlet weak var pointTotalLabel: UILabel!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var goldPriceLabel: UILabel!
    @IBOutlet weak var goldBalanceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
     
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
