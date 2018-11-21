//
//  ItemConfirmSummaryCell.swift
//  pointpow
//
//  Created by thanawat on 19/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class ItemConfirmSummaryCell: UICollectionViewCell {

    
    var backCallback:(()->Void)?
    var confirmCallback:(()->Void)?
    
    @IBOutlet weak var favoView: UIView!
    @IBOutlet weak var saveView: UIView!
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
        
        self.favoView.borderRedColorProperties()
       
        self.saveView.borderRedColorProperties()
       
        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.backCallback?()
    }
    @IBAction func confirmTapped(_ sender: Any) {
        self.confirmCallback?()
    }
}
