//
//  WithDrawOfficeSummaryCell.swift
//  pointpow
//
//  Created by thanawat on 23/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class WithDrawOfficeSummaryCell: UICollectionViewCell {

    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var goldBalanceLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
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
