//
//  ItemListResultCell.swift
//  pointpow
//
//  Created by thanawat on 16/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class ItemListResultCell: UICollectionViewCell {

    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var from_pointLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var transection_ref_Label: UILabel!
    @IBOutlet weak var bgsuccessImageView: UIImageView!
    @IBOutlet weak var mView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.updateLayerCornerRadiusProperties()
        self.contentView.updateLayerCornerRadiusProperties()
        self.shadowCellProperties()
    }

}
