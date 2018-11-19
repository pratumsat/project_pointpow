//
//  ItemFriendCell.swift
//  pointpow
//
//  Created by thanawat on 14/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class ItemFriendCell: UICollectionViewCell {

    @IBOutlet weak var widthConstraintButton: NSLayoutConstraint!
    @IBOutlet weak var marginTopConstraintButton: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintButton: NSLayoutConstraint!
    @IBOutlet weak var transferButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    var recentMode:Bool = false {
        didSet{
            self.nameLabel.font = UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.FREIND_RECENT)!
            self.heightConstraintButton.constant = 20
            self.marginTopConstraintButton.constant = 4
            
            let newConstaint = self.widthConstraintButton.constraintWithMultiplier(0.5)
            self.removeConstraint(self.widthConstraintButton)
            self.addConstraint(newConstaint)
            
            
            self.transferButton.titleLabel?.font = UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.FREIND_RECENT)!
     
            self.layoutIfNeeded()
        }
        
    }
    
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
        
        self.coverImageView.ovalColorClearProperties()
        self.transferButton.borderClearProperties(borderWidth: 1)
        self.transferButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    
}
