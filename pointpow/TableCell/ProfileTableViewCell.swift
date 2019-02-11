//
//  ProfileTableViewCell.swift
//  pointpow
//
//  Created by thanawat on 8/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var goldIdLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.profileImageView.ovalColorClearProperties()
      
      
      
    }
    
    
}
