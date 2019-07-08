//
//  ShoppingRectProductCell.swift
//  pointpow
//
//  Created by thanawat on 8/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ShoppingRectProductCell: ShoppingProductCell {

    
    @IBOutlet weak var bfView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.bfView.ovalColorClearProperties()
        
    }
}
