//
//  SavingConfirmCell.swift
//  pointpow
//
//  Created by thanawat on 15/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class SavingConfirmCell: UICollectionViewCell {

    @IBOutlet weak var goldReceiveLabel: UILabel!
    @IBOutlet weak var pointPowSpanLabel: UILabel!
    @IBOutlet weak var goldPriceLabel: UILabel!
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
