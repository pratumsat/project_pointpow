//
//  MyGoldCell.swift
//  pointpow
//
//  Created by thanawat on 4/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class MyGoldCell: UICollectionViewCell {
    @IBOutlet weak var headView: UIView!
    
    @IBOutlet weak var pointTotalLabel: UILabel!
    
    @IBOutlet weak var goldExchangeLabel: UILabel!
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
