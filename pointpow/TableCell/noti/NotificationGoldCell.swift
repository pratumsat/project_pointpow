//
//  NotificationGoldCell.swift
//  pointpow
//
//  Created by thanawat on 16/5/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class NotificationGoldCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var goldAmountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var topMView: UIView!
    @IBOutlet weak var mView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.topMView.updateLayerCornerRadiusProperties(5)
        self.mView.updateLayerCornerRadiusProperties(5)
        
    }
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
