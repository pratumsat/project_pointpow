//
//  CartAddressShippingCell.swift
//  pointpow
//
//  Created by thanawat on 4/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class CartAddressShippingCell: UICollectionViewCell {

    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
      
        //self.shadowCellProperties()
        //self.addressView.shadowCellProperties()
    }
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addressView.borderClearProperties(borderWidth: 1, radius: 10)
        self.addressView.shadowCellProperties()
    }

}
