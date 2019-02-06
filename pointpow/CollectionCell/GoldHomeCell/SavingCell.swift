//
//  SavingCell.swift
//  pointpow
//
//  Created by thanawat on 4/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class SavingCell: UICollectionViewCell {

    @IBOutlet weak var goldamountLabel: UILabel!
    @IBOutlet weak var goldamountView: UIView!
    @IBOutlet weak var pointpowTextField: UITextField!
   
    @IBOutlet weak var savingButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateLayerCornerRadiusProperties()
        self.contentView.updateLayerCornerRadiusProperties()
        self.shadowCellProperties()
    }

    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.savingButton.borderClearProperties(borderWidth: 1 , radius : 5)
        self.savingButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
        
        self.goldamountView.borderClearProperties(borderWidth: 1, radius : 5)
        self.pointpowTextField.borderRedColorProperties(borderWidth: 1, radius : 5)
        self.pointpowTextField.setRightPaddingPoints(10)
    }
    @IBAction func savingTapped(_ sender: Any) {
    }
}
