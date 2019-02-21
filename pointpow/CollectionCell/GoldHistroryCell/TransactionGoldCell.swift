//
//  TransactionGoldCell.swift
//  pointpow
//
//  Created by thanawat on 21/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class TransactionGoldCell: UICollectionViewCell {

    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var statusShippingLabel: UILabel!
    @IBOutlet weak var heightLogoConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
