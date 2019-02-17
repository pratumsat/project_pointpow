//
//  NextButtonCell.swift
//  pointpow
//
//  Created by thanawat on 17/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class NextButtonCell: UICollectionViewCell {
    @IBOutlet weak var nextButton: UIButton!
    var nextCallback:(()->Void)?
    
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
        
        self.nextButton.borderClearProperties(borderWidth: 1)
        self.nextButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    @IBAction func nextTapped(_ sender: Any) {
        self.nextCallback?()
    }
    
}
