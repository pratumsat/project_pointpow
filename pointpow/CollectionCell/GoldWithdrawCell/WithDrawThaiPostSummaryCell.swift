//
//  WithDrawThaiPostSummaryCell.swift
//  pointpow
//
//  Created by thanawat on 17/3/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class WithDrawThaiPostSummaryCell: UICollectionViewCell {
    @IBOutlet weak var goldAmountLabel: UILabel!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var unitLabel: UILabel!
    
    @IBOutlet weak var expandImageView: UIImageView!
    @IBOutlet weak var amountBoxLabel: UILabel!
    @IBOutlet weak var heightContainerConstraints: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var goldBalanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var premiumLabel: UILabel!
    
    var expandableCallback:((_ height:CGFloat)->Void)?
    
    var on = true
    
    var heightView = CGFloat(100.0)
    var hideView = CGFloat(0.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.updateLayerCornerRadiusProperties()
        self.contentView.updateLayerCornerRadiusProperties()
        self.shadowCellProperties()
        
        let expand = UITapGestureRecognizer(target: self, action: #selector(expandableTapped))
        self.expandImageView.isUserInteractionEnabled = true
        self.expandImageView.addGestureRecognizer(expand)
        
        self.updateView()
    }
    
    
    func updateView(){
        self.heightContainerConstraints.constant = 0
        
        let unitBaht = NSLocalizedString("unit-baht", comment: "")
        
    }
    
    
    
    @objc func expandableTapped(){
        self.expandableCallback?(on ? heightView : hideView)
        self.heightContainerConstraints.constant = on ? heightView : hideView
        
        self.setNeedsUpdateConstraints()
       
        UIView.animate(withDuration: 0.2,  delay: 0, options:.beginFromCurrentState,animations: {
            self.layoutIfNeeded()
        }) { (completed) in
            self.on = self.on ? false : true
        }
        
    }
    
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.headView.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
}
