//
//  WithDrawShippingThaiPostCell.swift
//  pointpow
//
//  Created by thanawat on 19/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class WithDrawShippingThaiPostCell: UICollectionViewCell {
    @IBOutlet weak var editImageView: UIImageView!
    @IBOutlet weak var shippingAddressLabel: UILabel!
    
    @IBOutlet weak var titleShippingLabel: UILabel!
    @IBOutlet weak var heightAddressConstrainst: NSLayoutConstraint!
    
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var emsLabel: UILabel!
    @IBOutlet weak var premiumLabel: UILabel!
    
    @IBOutlet weak var addressView: UIView!
    
    
    var heightAddress:((_ height:CGFloat)->Void)?
    
    var editCallback:(()->Void)?
    var address:String?{
        didSet{
            if address == nil{
                self.initView()
                return
            }
            self.shippingAddressLabel.text = address
            self.titleShippingLabel.isHidden = false
            self.shippingAddressLabel.isHidden = false
            self.editImageView.isHidden = false
            
            
            
            let height = heightForView(text: address!, font: UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: 18)!, width: self.frame.width) + 100
            
            self.heightAddressConstrainst.constant = height
            
            self.heightAddress?(height)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.updateLayerCornerRadiusProperties()
        self.contentView.updateLayerCornerRadiusProperties()
        self.shadowCellProperties()
        
        
        let edit = UITapGestureRecognizer(target: self, action: #selector(editTapped))
        self.addressView.isUserInteractionEnabled  = true
        self.addressView.addGestureRecognizer(edit)
        
        self.initView()
    }
    func initView(){
        self.editImageView.isHidden = true
        self.titleShippingLabel.isHidden = true
        self.shippingAddressLabel.isHidden = true
        self.heightAddressConstrainst.constant = 0
    }
    
    @objc func editTapped(){
        self.editCallback?()
    
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
