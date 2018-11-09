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
    
    @IBOutlet weak var settingImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
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
         self.profileImageView.ovalColorWhiteProperties()
        //  self.backgroundCoverImageView.addBlur(CGFloat(0.5))
    }
    
}
