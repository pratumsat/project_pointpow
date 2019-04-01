//
//  CountDownCell.swift
//  pointpow
//
//  Created by thanawat on 1/4/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class CountDownCell: UICollectionViewCell {


    @IBOutlet weak var secLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateLayerCornerRadiusProperties()
        self.contentView.updateLayerCornerRadiusProperties()
        self.shadowCellProperties()
        
        
    }
    
 

}
