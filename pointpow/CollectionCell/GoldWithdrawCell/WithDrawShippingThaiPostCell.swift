//
//  WithDrawShippingThaiPostCell.swift
//  pointpow
//
//  Created by thanawat on 19/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class WithDrawShippingThaiPostCell: UICollectionViewCell {
    @IBOutlet weak var shippingAddressLabel: UILabel!
    
    @IBOutlet weak var titleShippingLabel: UILabel!
    @IBOutlet weak var heightAddressConstrainst: NSLayoutConstraint!
    @IBOutlet weak var infoThaiPostImageView: UIImageView!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var emsLabel: UILabel!
    @IBOutlet weak var premiumLabel: UILabel!
    
    var infoThaipostCallback:(()->Void)?
    var address:String?{
        didSet{
            if address == nil{
                return
            }
            self.shippingAddressLabel.text = address
            self.titleShippingLabel.isHidden = false
            self.shippingAddressLabel.isHidden = false
            
            
            let height = heightForView(text: address!, font: UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: 18)!, width: self.frame.width) + 80
            
            self.heightAddressConstrainst.constant = height
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.updateLayerCornerRadiusProperties()
        self.contentView.updateLayerCornerRadiusProperties()
        self.shadowCellProperties()
        
        let info = UITapGestureRecognizer(target: self, action: #selector(infoTapped))
        self.infoThaiPostImageView.isUserInteractionEnabled  = true
        self.infoThaiPostImageView.addGestureRecognizer(info)
        
        self.initView()
    }
    func initView(){
        self.titleShippingLabel.isHidden = true
        self.shippingAddressLabel.isHidden = true
        self.heightAddressConstrainst.constant = 0
    }
    
    @objc func infoTapped(){
        self.infoThaipostCallback?()
    }
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

}
