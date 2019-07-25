//
//  SettingAddressCell.swift
//  pointpow
//
//  Created by thanawat on 25/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class SettingAddressCell: UICollectionViewCell {

    @IBOutlet weak var underlineView: UIView!
    
    
    @IBOutlet weak var cate2View: UIView!
    @IBOutlet weak var cate2ImageView: UIImageView!
    @IBOutlet weak var caet2Label: UILabel!
    
    @IBOutlet weak var cate1Label: UILabel!
    @IBOutlet weak var cate1ImageView: UIImageView!
    @IBOutlet weak var caet1View: UIView!
    
    var cate1Items = [["color" : Constant.Colors.CATE1],
                      ["color" : UIColor.black]]
    
    var selectedCallback:((_ cateNumber:Int)->Void)?
    var selectUnderLine:UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cate1 = UITapGestureRecognizer(target: self, action: #selector(cate1Tapped))
        self.caet1View.isUserInteractionEnabled = true
        self.caet1View.addGestureRecognizer(cate1)
        
        let cate2 = UITapGestureRecognizer(target: self, action: #selector(cate2Tapped))
        self.cate2View.isUserInteractionEnabled = true
        self.cate2View.addGestureRecognizer(cate2)
        
        selectedCallback?(0)
        updateUnderLineView2(0)
        self.cate1Label.textColor = cate1Items[0]["color"]
        self.caet2Label.textColor = cate1Items[1]["color"]
        
        self.cate1ImageView.image = UIImage(named: "ic-address-setting-cate1-active")
        self.cate2ImageView.image = UIImage(named: "ic-address-setting-cate2")
    }
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    func updateUnderLineView2(_ position:Int){
        if selectUnderLine == nil {
            selectUnderLine = UIView()
            selectUnderLine!.translatesAutoresizingMaskIntoConstraints = false
            addSubview(selectUnderLine!)
            
            selectUnderLine?.centerYAnchor.constraint(equalTo: underlineView.centerYAnchor, constant: 0).isActive = true
            selectUnderLine?.heightAnchor.constraint(equalToConstant: 2).isActive = true
            
            selectUnderLine?.backgroundColor = cate1Items[0]["color"]
            selectUnderLine?.leadingAnchor.constraint(equalTo: caet1View.leadingAnchor, constant: 0).isActive = true
            selectUnderLine?.trailingAnchor.constraint(equalTo: caet1View.trailingAnchor, constant: 0).isActive = true
            
        }
        
        var widthForView = CGFloat(0)
        switch position {
        case 0:
            widthForView = caet1View.frame.origin.x
            
            break
        case 1:
            widthForView = cate2View.frame.origin.x
            break
       
        default:
            break
        }
        selectUnderLine?.backgroundColor =  cate1Items[0]["color"]
        
        UIView.animate(withDuration: 0.2,  delay: 0, options:.beginFromCurrentState,animations: {
            //start animation
            if let frame = self.selectUnderLine?.frame {
                var x = frame.origin.x
                let y = frame.origin.y
                if y > 0 {
                    x = CGFloat(widthForView)
                    
                    self.selectUnderLine?.frame.origin.x = x
                    self.layoutIfNeeded()
                }
            }
        }) { (completed) in
            //completed
        }
        
        
        
    }
    
    @objc func cate1Tapped(){
        selectedCallback?(0)
        updateUnderLineView2(0)
        self.cate1Label.textColor = cate1Items[0]["color"]
        self.caet2Label.textColor = cate1Items[1]["color"]
        
        self.cate1ImageView.image = UIImage(named: "ic-address-setting-cate1-active")
        self.cate2ImageView.image = UIImage(named: "ic-address-setting-cate2")
    }
    @objc func cate2Tapped(){
        selectedCallback?(1)
        updateUnderLineView2(1)
        self.cate1Label.textColor = cate1Items[1]["color"]
        self.caet2Label.textColor = cate1Items[0]["color"]
        
        self.cate1ImageView.image = UIImage(named: "ic-address-setting-cate1")
        self.cate2ImageView.image = UIImage(named: "ic-address-setting-cate2-active")
    }
    
}
