//
//  PageViewFooterCollectionViewCell.swift
//  pointpow
//
//  Created by thanawat on 27/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PageViewFooterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var moreButton: UIButton!
    
    
    
    var moreCallback:(()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.moreButton.borderRedColorProperties()
        
    }
    @IBAction func moreTapped(_ sender: Any) {
        moreCallback?()
    }
}
