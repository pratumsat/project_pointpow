//
//  HeaderCollectionReusableView.swift
//  pointpow
//
//  Created by thanawat on 21/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    
    var disableLine:Bool = false {
        didSet{
            if !disableLine {
                if lineBottom != nil {
                    lineBottom!.removeFromSuperview()
                }
                lineBottom = UIView(frame: CGRect(x: 0, y: self.frame.height - 0.5 ,
                                                  width: self.frame.width,
                                                  height: 0.5 ))
                lineBottom!.backgroundColor = UIColor.lightGray
                self.addSubview(lineBottom!)
                
            }
            
        }
    }
    var disableLineTop:Bool = false {
        didSet{
            if !disableLineTop {
                if lineTop != nil {
                    lineTop!.removeFromSuperview()
                }
                lineTop = UIView(frame: CGRect(x: 0, y: 0 ,
                                               width: self.frame.width,
                                               height: 0.5 ))
                lineTop!.backgroundColor = UIColor.lightGray
                self.addSubview(lineTop!)
                
            }
            
        }
    }
    var lineTop:UIView?
    var lineBottom:UIView?
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
        
        
    }
    
}
