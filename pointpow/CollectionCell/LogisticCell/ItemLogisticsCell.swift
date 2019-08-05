//
//  ItemLogisticsCell.swift
//  pointpow
//
//  Created by thanawat on 5/8/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ItemLogisticsCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
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
        
        self.logoImageView.ovalColoLightGrayProperties()
    }

}
