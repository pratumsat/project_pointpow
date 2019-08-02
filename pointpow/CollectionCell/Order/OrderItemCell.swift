//
//  OrderItemCell.swift
//  pointpow
//
//  Created by thanawat on 2/8/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class OrderItemCell: UICollectionViewCell {

    @IBOutlet weak var nameBrandLabel: UILabel!
    @IBOutlet weak var shippingPriceLabel: UILabel!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bgsuccessImageView: UIImageView!
    
    @IBOutlet weak var amountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
