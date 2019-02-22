//
//  WithDrawResultPointPowCell.swift
//  pointpow
//
//  Created by thanawat on 20/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class WithDrawResultPointPowCell: UICollectionViewCell {

    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var shippingStatusLabel: UILabel!
    @IBOutlet weak var bgSuccessImageView: UIImageView!
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
    var cancelCallback:(()->Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateLayerCornerRadiusProperties()
        self.contentView.updateLayerCornerRadiusProperties()
        self.shadowCellProperties()
        
        
        
        let saveslip = UITapGestureRecognizer(target: self, action: #selector(saveSlipTapped))
        self.saveSlipView?.isUserInteractionEnabled = true
        self.saveSlipView?.addGestureRecognizer(saveslip)
        
        let viewMap = UITapGestureRecognizer(target: self, action: #selector(viewMapTapped))
        self.viewMapView?.isUserInteractionEnabled = true
        self.viewMapView?.addGestureRecognizer(viewMap)
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
        
        self.cancelButton?.borderClearProperties(borderWidth: 1)
        self.cancelButton?.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
        
        self.qrCodeImageView?.updateLayerCornerRadiusProperties()
        self.qrCodeImageView?.shadowCellProperties()
        self.viewMapView?.borderBlackolorProperties(borderWidth: 0.5)
        self.saveSlipView?.borderBlackolorProperties(borderWidth: 0.5)
    }

    @IBAction func cancelTapped(_ sender: Any) {
        self.cancelCallback?()
    }
}
