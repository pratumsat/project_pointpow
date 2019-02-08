//
//  RegisterGoldCell.swift
//  pointpow
//
//  Created by thanawat on 5/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class RegisterGoldCell: UICollectionViewCell {

    @IBOutlet weak var registerButton: UIButton!
    
    var registerCallback:(()->Void)?
    
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
        
        self.registerButton.borderClearProperties(borderWidth: 1)
        self.registerButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    @IBAction func registerTapped(_ sender: Any) {
        print("register")
        self.registerCallback?()
    }
}
