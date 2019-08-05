//
//  OrderShippingPageCell.swift
//  pointpow
//
//  Created by thanawat on 5/8/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class OrderShippingPageCell: UICollectionViewCell {
    @IBOutlet weak var amountCate3Label: UILabel!
    @IBOutlet weak var amountCate2Label: UILabel!
    @IBOutlet weak var amountCate1Label: UILabel!
    
    @IBOutlet weak var underlineView: UIView!
    
    @IBOutlet weak var cate3Label: UILabel!
    @IBOutlet weak var cate3ImageView: UIImageView!
    @IBOutlet weak var cate3View: UIView!
    
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
    var selectType:String = "waiting" {
        didSet{
            switch selectType {
            case "waiting":
                selectPosition(0)
                break
            case "shipping":
                selectPosition(1)
                break
            case "complete":
                selectPosition(2)
                break
            default:
                break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        let cate1 = UITapGestureRecognizer(target: self, action: #selector(cate1Tapped))
        self.caet1View.isUserInteractionEnabled = true
        self.caet1View.addGestureRecognizer(cate1)
        
        let cate2 = UITapGestureRecognizer(target: self, action: #selector(cate2Tapped))
        self.cate2View.isUserInteractionEnabled = true
        self.cate2View.addGestureRecognizer(cate2)
        
        let cate3 = UITapGestureRecognizer(target: self, action: #selector(cate3Tapped))
        self.cate3View.isUserInteractionEnabled = true
        self.cate3View.addGestureRecognizer(cate3)
        
        
      

    }

    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    func updateUnderLineView2(_ position:Int , cateView:UIView){
        if selectUnderLine == nil {
            selectUnderLine = UIView()
            selectUnderLine!.translatesAutoresizingMaskIntoConstraints = false
            addSubview(selectUnderLine!)
            
            selectUnderLine?.centerYAnchor.constraint(equalTo: underlineView.centerYAnchor, constant: 0).isActive = true
            selectUnderLine?.heightAnchor.constraint(equalToConstant: 2).isActive = true
            
            selectUnderLine?.backgroundColor = cate1Items[0]["color"]
            selectUnderLine?.leadingAnchor.constraint(equalTo: cateView.leadingAnchor, constant: 0).isActive = true
            selectUnderLine?.trailingAnchor.constraint(equalTo: cateView.trailingAnchor, constant: 0).isActive = true
            
            return
        }
        
        var widthForView = CGFloat(0)
        switch position {
        case 0:
            widthForView = caet1View.frame.origin.x
            
            break
        case 1:
            widthForView = cate2View.frame.origin.x
            break
            
        case 2:
            widthForView = cate3View.frame.origin.x
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
            print("init view")
        }
        
        
        
    }
    
    func selectPosition(_ position:Int ){
        switch position {
        case 0:
            selectedCallback?(0)
            updateUnderLineView2(0 , cateView: caet1View)
            self.cate1Label.textColor = cate1Items[0]["color"]
            self.caet2Label.textColor = cate1Items[1]["color"]
            self.cate3Label.textColor = cate1Items[1]["color"]
            
            self.amountCate1Label.textColor = cate1Items[0]["color"]
            self.amountCate2Label.textColor = cate1Items[1]["color"]
            self.amountCate3Label.textColor = cate1Items[1]["color"]
            
            self.cate1ImageView.image = UIImage(named: "ic-address-shopping-cate3-active")
            self.cate2ImageView.image = UIImage(named: "ic-address-setting-cate1")
            self.cate3ImageView.image = UIImage(named: "ic-shopping-filter-success")
            break
        case 1:
            selectedCallback?(1)
            updateUnderLineView2(1, cateView: cate2View)
            self.cate1Label.textColor = cate1Items[1]["color"]
            self.caet2Label.textColor = cate1Items[0]["color"]
            self.cate3Label.textColor = cate1Items[1]["color"]
            
            self.amountCate1Label.textColor = cate1Items[1]["color"]
            self.amountCate2Label.textColor = cate1Items[0]["color"]
            self.amountCate3Label.textColor = cate1Items[1]["color"]
            
            self.cate1ImageView.image = UIImage(named: "ic-address-shopping-cate3")
            self.cate2ImageView.image = UIImage(named: "ic-address-setting-cate1-active")
            self.cate3ImageView.image = UIImage(named: "ic-shopping-filter-success")
            break
        case 2:
            selectedCallback?(2)
            updateUnderLineView2(2, cateView: cate3View)
            self.cate1Label.textColor = cate1Items[1]["color"]
            self.caet2Label.textColor = cate1Items[1]["color"]
            self.cate3Label.textColor = cate1Items[0]["color"]
            
            self.amountCate1Label.textColor = cate1Items[1]["color"]
            self.amountCate2Label.textColor = cate1Items[1]["color"]
            self.amountCate3Label.textColor = cate1Items[0]["color"]
            
            self.cate1ImageView.image = UIImage(named: "ic-address-shopping-cate3")
            self.cate2ImageView.image = UIImage(named: "ic-address-setting-cate1")
            self.cate3ImageView.image = UIImage(named: "ic-shopping-filter-success-active")
            break
        default:
            break
        }
    }
    
    @objc func cate1Tapped(){
        selectPosition(0)
      
    }
    
    @objc func cate2Tapped(){
       selectPosition(1)
    }
    
    @objc func cate3Tapped(){
        selectPosition(2)
    }
}
