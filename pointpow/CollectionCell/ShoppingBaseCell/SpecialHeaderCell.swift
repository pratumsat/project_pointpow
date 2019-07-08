//
//  SpecialHeaderCell.swift
//  pointpow
//
//  Created by thanawat on 27/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class SpecialHeaderCell: UICollectionViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var nameView: UIView!
    
    @IBOutlet weak var hourView: UIView!
    @IBOutlet weak var minView: UIView!
    @IBOutlet weak var secView: UIView!
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
        
        self.borderView.borderRedColorProperties(borderWidth: 1.0, radius: 5.0)
        self.hourView.borderRedColorProperties(borderWidth: 1.0, radius: 5.0)
        self.minView.borderRedColorProperties(borderWidth: 1.0, radius: 5.0)
        self.secView.borderRedColorProperties(borderWidth: 1.0, radius: 5.0)
        
        self.nameView.roundCorners(corners: [.bottomLeft, .topLeft], radius: 5.0)
    }
}
