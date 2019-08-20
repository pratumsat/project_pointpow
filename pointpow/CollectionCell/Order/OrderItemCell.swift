//
//  OrderItemCell.swift
//  pointpow
//
//  Created by thanawat on 2/8/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class OrderItemCell: UICollectionViewCell {

    @IBOutlet weak var productShippingStatusLabel: UILabel!
    @IBOutlet weak var followProductView: UIView!
    
    @IBOutlet weak var shippingPriceLabel: UILabel!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bgsuccessImageView: UIImageView!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    
    var trackingCallback:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tracking = UITapGestureRecognizer(target: self, action: #selector(trackTapped))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tracking)
        
    }
    @objc func trackTapped(){
        self.trackingCallback?()
    }

    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.followProductView.borderRedColorProperties(borderWidth: 1.0)
        
    }
}
