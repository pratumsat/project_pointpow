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
   
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var pointBalanceLabel: UILabel!
    var profileTappedCallback:(()->Void)?
    var backgroundTappedCallback:(()->Void)?
    
    @IBOutlet weak var pointpowIdLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    
        
        let profile = UITapGestureRecognizer(target: self, action: #selector(changeProfileTapped))
        self.profileImageView.isUserInteractionEnabled = true
        self.profileImageView.addGestureRecognizer(profile)
        
        let profile2 = UITapGestureRecognizer(target: self, action: #selector(changeProfileTapped))
        self.cameraView.isUserInteractionEnabled = true
        self.cameraView.addGestureRecognizer(profile2)
        
        
        
        let background = UITapGestureRecognizer(target: self, action: #selector(changeBackgroundTapped))
        self.changeBackground2Button.isUserInteractionEnabled = true
        self.changeBackground2Button.addGestureRecognizer(background)
        
        
        self.backgroundImageView.blurImage()
        
    }
    
    @objc func changeProfileTapped(){
        print("tap profile")
        self.profileTappedCallback?()
        //self.profileImageView.image
    }
    
    @objc func changeBackgroundTapped(){
        print("tap background")
        self.backgroundTappedCallback?()
        //self.backgroundImageView.image
    }

    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.cameraView.ovalColorWhiteProperties(borderWidth: 2.0)
        self.profileImageView.ovalColorWhiteProperties(borderWidth: 2.0)
        self.changeBackground2Button.borderWhiteProperties()
    }
    
}
