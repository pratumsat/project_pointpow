//
//  SaveButtonProfileCell.swift
//  pointpow
//
//  Created by thanawat on 7/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class SaveButtonProfileCell: UICollectionViewCell {

    @IBOutlet weak var saveButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.saveButton.borderClearProperties(borderWidth: 1 , radius : 5)
        self.saveButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
}
