//
//  OrderResultCell.swift
//  pointpow
//
//  Created by thanawat on 26/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class OrderResultCell: UICollectionViewCell {
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var marginTopAddress: NSLayoutConstraint!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var transection_ref_Label: UILabel!
    @IBOutlet weak var bgsuccessImageView: UIImageView!
    @IBOutlet weak var mView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var bLabel: UILabel!
    @IBOutlet weak var tacdLabel: UILabel!
    @IBOutlet weak var tcdLabel: UILabel!
    @IBOutlet weak var cdLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.updateLayerCornerRadiusProperties()
        self.contentView.updateLayerCornerRadiusProperties()
        self.shadowCellProperties()
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
