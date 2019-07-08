//
//  ShoppingHeaderCell.swift
//  pointpow
//
//  Created by thanawat on 8/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ShoppingHeaderCell: UICollectionViewCell {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.borderView.borderClearProperties(borderWidth: 1.0, radius: 5.0)
       
    }
}
