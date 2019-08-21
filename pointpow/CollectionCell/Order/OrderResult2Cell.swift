//
//  OrderResult2Cell.swift
//  pointpow
//
//  Created by thanawat on 1/8/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class OrderResult2Cell: UICollectionViewCell {
    @IBOutlet weak var amountPriceLabel: UILabel!
    @IBOutlet weak var shippingPriceLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var marginTopAddress: NSLayoutConstraint!

    @IBOutlet weak var bgsuccessImageView: UIImageView!
    @IBOutlet weak var mView: UIView!
    
    @IBOutlet weak var invoiceLineView: UIView!
    @IBOutlet weak var invoiceTitleLabel: UILabel!
    @IBOutlet weak var invoiceAddressLabel: UILabel!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var bLabel: UILabel!
    @IBOutlet weak var tacdLabel: UILabel!
    @IBOutlet weak var tcdLabel: UILabel!
    @IBOutlet weak var cdLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.updateLayerCornerRadiusProperties()
        //self.contentView.updateLayerCornerRadiusProperties()
        //self.shadowCellProperties()
    }

    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    func hideCreditCardLabel(){
        bLabel.isHidden = true
        tacdLabel.isHidden = true
        tcdLabel.isHidden = true
        cdLabel.isHidden = true
    }
    func showCreditCardLabel(){
        bLabel.isHidden = false
        tacdLabel.isHidden = false
        tcdLabel.isHidden = false
        cdLabel.isHidden = false
    }
}
