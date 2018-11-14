//
//  ItemBankCell.swift
//  pointpow
//
//  Created by thanawat on 14/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class ItemBankCell: UICollectionViewCell {

    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
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
        self.coverImageView.ovalColorWhiteProperties(borderWidth: 2.0)
    }
}
