//
//  OrderResultCell.swift
//  pointpow
//
//  Created by thanawat on 26/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class OrderResultCell: UICollectionViewCell {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var transection_ref_Label: UILabel!
    @IBOutlet weak var bgsuccessImageView: UIImageView!
    @IBOutlet weak var mView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
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
}
