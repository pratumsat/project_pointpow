//
//  ProfileCell.swift
//  pointpow
//
//  Created by thanawat on 9/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var changeBackground2Button: UIButton!
   
    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        self.profileImageView.ovalColorWhiteProperties(borderWidth: 2.0)
        self.changeBackground2Button.borderWhiteProperties()
    }
    
}
