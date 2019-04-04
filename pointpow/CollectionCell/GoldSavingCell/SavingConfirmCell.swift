//
//  SavingConfirmCell.swift
//  pointpow
//
//  Created by thanawat on 15/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class SavingConfirmCell: UICollectionViewCell {

    @IBOutlet weak var pointPointBalanceLabel: UILabel!
    
    @IBOutlet weak var pointPowSpanLabel: UILabel!
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
        
        
    }
}
