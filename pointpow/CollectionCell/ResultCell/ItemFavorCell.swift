//
//  ItemFavorCell.swift
//  pointpow
//
//  Created by thanawat on 21/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class ItemFavorCell: UICollectionViewCell {
    @IBOutlet weak var favoView: UIView!
    
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
        
        self.favoView.borderRedColorProperties()
        
        
    }
}
