//
//  GoldPriceCell.swift
//  pointpow
//
//  Created by thanawat on 4/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class GoldPriceCell: UICollectionViewCell {

    @IBOutlet weak var diffImageView: UIImageView!
    @IBOutlet weak var diffLabel: UILabel!
    @IBOutlet weak var sellPriceLabel: UILabel!
    @IBOutlet weak var buyPriceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var headView: UIView!
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
        
        
        self.headView.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
}
