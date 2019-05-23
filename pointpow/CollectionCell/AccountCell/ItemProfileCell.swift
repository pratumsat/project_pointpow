//
//  ItemProfileCell.swift
//  pointpow
//
//  Created by thanawat on 9/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class ItemProfileCell: UICollectionViewCell {

    @IBOutlet weak var marginRight: NSLayoutConstraint!
    @IBOutlet weak var trailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    //default 20
    let defaultMarginRight = CGFloat(20)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
