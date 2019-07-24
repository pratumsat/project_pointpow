//
//  SectionFilterCell.swift
//  pointpow
//
//  Created by thanawat on 15/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class SectionFilterCell: UICollectionViewCell {

    @IBOutlet weak var filterTextField: UITextField!
    @IBOutlet weak var headerNameLabel: UILabel!
    @IBOutlet weak var arrowDownImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        filterTextField.setLeftPaddingPoints(CGFloat(5.0))
    }
    @objc func filterTapped(){
        print("filterTextField")
    }
    
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        filterTextField.borderRedColorProperties(borderWidth: 1)
    }
}
