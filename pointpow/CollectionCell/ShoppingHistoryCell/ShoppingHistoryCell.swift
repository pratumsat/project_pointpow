//
//  ShoppingHistoryCell.swift
//  pointpow
//
//  Created by thanawat on 1/8/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ShoppingHistoryCell: UICollectionViewCell {

    @IBOutlet weak var followProductView: UIView!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var heightLogoConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var trackCallback:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let follow = UITapGestureRecognizer(target: self, action: #selector(followTapped))
        self.followProductView.isUserInteractionEnabled = true
        self.followProductView.addGestureRecognizer(follow)
    }
    @objc func followTapped(){
        trackCallback?()
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
