//
//  WithDrawResultPointPowCell.swift
//  pointpow
//
//  Created by thanawat on 20/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class WithDrawResultPointPowCell: UICollectionViewCell {

    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var payByLabel: UILabel!
    @IBOutlet weak var pickByLabel: UILabel!
    @IBOutlet weak var formatGoldReceiveLabel: UILabel!
    @IBOutlet weak var withdrawAmountLabel: UILabel!
    @IBOutlet weak var withdrawUnitLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var transactionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var saveSlipView: UIView!
    @IBOutlet weak var viewMapView: UIView!
    
    
    var saveSlipCallback:(()->Void)?
    var viewMapCallback:(()->Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateLayerCornerRadiusProperties()
        self.contentView.updateLayerCornerRadiusProperties()
        self.shadowCellProperties()
        
        
        
        let saveslip = UITapGestureRecognizer(target: self, action: #selector(saveSlipTapped))
        self.saveSlipView.isUserInteractionEnabled = true
        self.saveSlipView.addGestureRecognizer(saveslip)
        
        let viewMap = UITapGestureRecognizer(target: self, action: #selector(viewMapTapped))
        self.viewMapView.isUserInteractionEnabled = true
        self.viewMapView.addGestureRecognizer(viewMap)
    }
    
    @objc func viewMapTapped(){
        self.viewMapCallback?()
    }
    @objc func saveSlipTapped(){
        self.saveSlipCallback?()
    }
    
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.qrCodeImageView.updateLayerCornerRadiusProperties()
        self.qrCodeImageView.shadowCellProperties()
        self.viewMapView.borderBlackolorProperties(borderWidth: 0.5)
        self.saveSlipView.borderBlackolorProperties(borderWidth: 0.5)
    }

}
