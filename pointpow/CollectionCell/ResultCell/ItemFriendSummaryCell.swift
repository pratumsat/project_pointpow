//
//  ItemFriendSummaryCell.swift
//  pointpow
//
//  Created by thanawat on 19/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class ItemFriendSummaryCell: UICollectionViewCell {
    
    @IBOutlet weak var mobileReceiverLabel: UILabel!
    @IBOutlet weak var mobileSenderLabel: UILabel!
    @IBOutlet weak var notelineView: UIView!
    @IBOutlet weak var titleNoteLabel: UILabel!
    @IBOutlet weak var bgSuccessImageView: UIImageView!
    @IBOutlet weak var transectionLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
   
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var receiverLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateLayerCornerRadiusProperties()
        self.contentView.updateLayerCornerRadiusProperties()
        self.shadowCellProperties()
    }

}
