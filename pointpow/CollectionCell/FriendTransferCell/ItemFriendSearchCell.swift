//
//  ItemFriendSearchCell.swift
//  pointpow
//
//  Created by thanawat on 17/5/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ItemFriendSearchCell: UICollectionViewCell {
   
    @IBOutlet weak var transferButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    var tappedCallback:(()->Void)?
    var didSelectImageView:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        let tap  = UITapGestureRecognizer(target: self, action: #selector(didSelect))
        self.coverImageView.isUserInteractionEnabled = true
        self.coverImageView.addGestureRecognizer(tap)
    }
    @objc func didSelect(){
        self.didSelectImageView?()
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
    
    @IBAction func transferTapped(_ sender: Any) {
        self.tappedCallback?()
    }
}
