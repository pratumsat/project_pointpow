//
//  CartPointBalanceCell.swift
//  pointpow
//
//  Created by thanawat on 3/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class CartPointBalanceCell: UICollectionViewCell {

    @IBOutlet weak var redeemView: UIView!
    @IBOutlet weak var pointBalanceLabel: UILabel!
    
    var redeemCallback:(()->Void)?
    
    var disableRedeemView = false {
        didSet{
            if disableRedeemView {
                //hide
                self.redeemView.isHidden = true
            }else{
                //show
                self.redeemView.isHidden = false
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
      
        
        let redeem = UITapGestureRecognizer(target: self, action: #selector(redeemTeapped));
        self.redeemView.isUserInteractionEnabled = true
        self.redeemView.addGestureRecognizer(redeem)
    } 

    @objc func redeemTeapped(){
        self.redeemCallback?()
    }
    
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.redeemView.borderBlackolorProperties()
        
    }

}
