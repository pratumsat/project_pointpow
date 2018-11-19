//
//  ItemConfirmSummaryCell.swift
//  pointpow
//
//  Created by thanawat on 19/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class ItemConfirmSummaryCell: UICollectionViewCell {
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    
    var backCallback:(()->Void)?
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
        
        self.backButton.borderRedColorProperties()
        self.confirmButton.borderClearProperties(borderWidth: 1)
        self.confirmButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.backCallback?()
    }
    @IBAction func confirmTapped(_ sender: Any) {
        self.confirmCallback?()
    }
}
