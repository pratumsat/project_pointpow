//
//  ConfirmButtonCell.swift
//  pointpow
//
//  Created by thanawat on 15/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ConfirmButtonCell: UICollectionViewCell {

    @IBOutlet weak var confirmButton: UIButton!
    
    
    var confirmCallback:(()->Void)?
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
        
        self.confirmButton.borderClearProperties(borderWidth: 1)
        self.confirmButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    @IBAction func confirmTapped(_ sender: Any) {
        self.confirmCallback?()
    }
}
