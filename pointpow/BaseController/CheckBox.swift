//
//  CheckBox.swift
//  pointpow
//
//  Created by thanawat on 16/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//


import UIKit

class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "ic_check_box")! as UIImage
    let uncheckedImage = UIImage(named: "ic_check_box_outline_blank")! as UIImage
    
    var toggle:((_ check:Bool)->Void)?
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                let original = checkedImage.withRenderingMode(.alwaysOriginal)
                self.setImage(original, for: UIControl.State.normal)
            } else {
                let original = uncheckedImage.withRenderingMode(.alwaysOriginal)
                self.setImage(original, for: UIControl.State.normal)
            }
            self.toggle?(isChecked)
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}

