//
//  PageViewCollectionViewCell.swift
//  pointpow
//
//  Created by thanawat on 27/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PageViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var cate6View: UIView!
    @IBOutlet weak var cate6ImageView: UIImageView!
    @IBOutlet weak var caet6Label: UILabel!
    
    @IBOutlet weak var cate5View: UIView!
    @IBOutlet weak var cate5ImageView: UIImageView!
    @IBOutlet weak var caet5Label: UILabel!
    
    @IBOutlet weak var cate4View: UIView!
    @IBOutlet weak var cate4ImageView: UIImageView!
    @IBOutlet weak var caet4Label: UILabel!
    
    @IBOutlet weak var cate3View: UIView!
    @IBOutlet weak var cate3ImageView: UIImageView!
    @IBOutlet weak var caet3Label: UILabel!
    
    @IBOutlet weak var cate2View: UIView!
    @IBOutlet weak var cate2ImageView: UIImageView!
    @IBOutlet weak var caet2Label: UILabel!
    
    @IBOutlet weak var cate1Label: UILabel!
    @IBOutlet weak var cate1ImageView: UIImageView!
    @IBOutlet weak var caet1View: UIView!
    
    var cate1Items = [["color" : Constant.Colors.CATE1],
                      ["color" : UIColor.darkGray]]
  
    
    
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
        
        let cate3 = UITapGestureRecognizer(target: self, action: #selector(cate3Tapped))
        self.cate3View.isUserInteractionEnabled = true
        self.cate3View.addGestureRecognizer(cate3)
        
        let cate4 = UITapGestureRecognizer(target: self, action: #selector(cate4Tapped))
        self.cate4View.isUserInteractionEnabled = true
        self.cate4View.addGestureRecognizer(cate4)
        
        let cate5 = UITapGestureRecognizer(target: self, action: #selector(cate5Tapped))
        self.cate5View.isUserInteractionEnabled = true
        self.cate5View.addGestureRecognizer(cate5)
        
        let cate6 = UITapGestureRecognizer(target: self, action: #selector(cate6Tapped))
        self.cate6View.isUserInteractionEnabled = true
        self.cate6View.addGestureRecognizer(cate6)
        
        self.selectedCategory(0)
       
        
        
        
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
            //selectUnderLine?.backgroundColor = cate1Items[0]["color"] as? UIColor ?? nil
           
            break
        case 1:
            widthForView = cate2View.frame.origin.x
            //selectUnderLine?.backgroundColor = cate2Items[0]["color"] as? UIColor ?? nil
            
            
            break
        case 2:
            widthForView = cate3View.frame.origin.x
            //selectUnderLine?.backgroundColor = cate3Items[0]["color"] as? UIColor ?? nil
            
            
            break
        case 3:
            widthForView = cate4View.frame.origin.x
            //selectUnderLine?.backgroundColor = cate4Items[0]["color"] as? UIColor ?? nil
          
            
            break
        case 4:
            widthForView = cate5View.frame.origin.x
            //selectUnderLine?.backgroundColor = cate5Items[0]["color"] as? UIColor ?? nil
           
            
            break
        case 5:
            widthForView = cate6View.frame.origin.x
            //selectUnderLine?.backgroundColor = cate6Items[0]["color"] as? UIColor ?? nil
           
            
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
        self.selectedCategory(0)
    }
    @objc func cate2Tapped(){
        self.selectedCategory(1)
    }
    @objc func cate3Tapped(){
        self.selectedCategory(2)
    }
    @objc func cate4Tapped(){
        self.selectedCategory(3)
    }
    @objc func cate5Tapped(){
        self.selectedCategory(4)
    }
    @objc func cate6Tapped(){
        self.selectedCategory(5)
    }
    
    func selectedCategory(_ position:Int){
        selectedCallback?(position)
        updateUnderLineView2(position)
       
        
        switch position {
        case 0:
            
            
            self.cate1Label.textColor = cate1Items[0]["color"]
            
            
            self.caet2Label.textColor = cate1Items[1]["color"]
            
            
            self.caet3Label.textColor = cate1Items[1]["color"]
            
            
            self.caet4Label.textColor = cate1Items[1]["color"]
            
            
            self.caet5Label.textColor = cate1Items[1]["color"]
            
            
            self.caet6Label.textColor = cate1Items[1]["color"]
            
            
            break
        case 1:
            
            
            self.cate1Label.textColor = cate1Items[1]["color"]
            
           
            self.caet2Label.textColor = cate1Items[0]["color"]
            
            
            self.caet3Label.textColor = cate1Items[1]["color"]
            
            
            self.caet4Label.textColor = cate1Items[1]["color"]
            
            
            self.caet5Label.textColor = cate1Items[1]["color"]
            
            
            self.caet6Label.textColor = cate1Items[1]["color"]
            break
        case 2:
            
            
            self.cate1Label.textColor = cate1Items[1]["color"]
            
            
            self.caet2Label.textColor = cate1Items[1]["color"]
            
            
            self.caet3Label.textColor = cate1Items[0]["color"]
            
            
            self.caet4Label.textColor = cate1Items[1]["color"]
            
            
            self.caet5Label.textColor = cate1Items[1]["color"]
            
            
            self.caet6Label.textColor = cate1Items[1]["color"]
            break
        case 3:
            
            
            
            self.cate1Label.textColor = cate1Items[1]["color"]
            
            
            self.caet2Label.textColor = cate1Items[1]["color"]
            
            
            self.caet3Label.textColor = cate1Items[1]["color"]
            
            
            self.caet4Label.textColor = cate1Items[0]["color"]
            
            
            self.caet5Label.textColor = cate1Items[1]["color"]
            
            
            self.caet6Label.textColor = cate1Items[1]["color"]
            break
        case 4:
         
            
            self.cate1Label.textColor = cate1Items[1]["color"]
            
            
            self.caet2Label.textColor = cate1Items[1]["color"]
            
            
            self.caet3Label.textColor = cate1Items[1]["color"]
            
            
            self.caet4Label.textColor = cate1Items[1]["color"]
            
            
            self.caet5Label.textColor = cate1Items[0]["color"]
            
            
            self.caet6Label.textColor = cate1Items[1]["color"]
            
            break
        case 5:
        
            
            self.cate1Label.textColor = cate1Items[1]["color"]
            
            
            self.caet2Label.textColor = cate1Items[1]["color"]
            
            
            self.caet3Label.textColor = cate1Items[1]["color"]
            
            
            self.caet4Label.textColor = cate1Items[1]["color"]
            
            
            self.caet5Label.textColor = cate1Items[1]["color"]
            
            
            self.caet6Label.textColor = cate1Items[0]["color"]
            break
        default:
            break
        }
    }

}
