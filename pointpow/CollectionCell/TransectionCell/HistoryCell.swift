//
//  HistoryCell.swift
//  pointpow
//
//  Created by thanawat on 21/5/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class HistoryCell: UICollectionViewCell {

    @IBOutlet weak var unitLabel: UILabel!
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
