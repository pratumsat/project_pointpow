//
//  CustomBadge.swift
//  pointpow
//
//  Created by thanawat on 15/8/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class CustomBadgeView : UIView {
    var radius:CGFloat = CGFloat(15.0)
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
    init(frame:CGRect = CGRect(x: 0, y: 0, width: 100, height: 100), radius:CGFloat = 15.0) {
        super.init(frame: frame)
        self.radius = radius
        setup()
    }
    
    func setup(){
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = self.radius
        self.layer.borderColor =  Constant.Colors.PRIMARY_COLOR.cgColor
        self.layer.borderWidth = 1.0
        self.clipsToBounds = true;
        
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
