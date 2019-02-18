//
//  SavingResultCell.swift
//  pointpow
//
//  Created by thanawat on 15/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class SavingResultCell: UICollectionViewCell {

    @IBOutlet weak var goldReceiveLabel: UILabel!
    @IBOutlet weak var pointpowLabel: UILabel!
    @IBOutlet weak var goldPriceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var transactionNumberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateLayerCornerRadiusProperties()
        self.contentView.updateLayerCornerRadiusProperties()
        self.shadowCellProperties()
    }

}
