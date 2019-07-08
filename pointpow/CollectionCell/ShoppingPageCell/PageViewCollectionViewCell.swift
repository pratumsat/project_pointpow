//
//  PageViewCollectionViewCell.swift
//  pointpow
//
//  Created by thanawat on 27/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PageViewCollectionViewCell: UICollectionViewCell {

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
    
    var cate1Items = [["color" : Constant.Colors.CATE1,
                     "image": UIImage(named: "ic-shopping-cate-r-1-active")!],
                      ["color" : UIColor.lightGray,
                       "image": UIImage(named: "ic-shopping-cate-r-1")!]]
    var cate2Items = [["color" : Constant.Colors.CATE2,
                       "image": UIImage(named: "ic-shopping-cate-r-2-active")!],
                      ["color" : UIColor.lightGray,
                       "image": UIImage(named: "ic-shopping-cate-r-2")!]]
    var cate3Items = [["color" : Constant.Colors.CATE3,
                       "image": UIImage(named: "ic-shopping-cate-r-3-active")!],
                      ["color" : UIColor.lightGray,
                       "image": UIImage(named: "ic-shopping-cate-r-3")!]]
    var cate4Items = [["color" : Constant.Colors.CATE4,
                       "image": UIImage(named: "ic-shopping-cate-r-4-active")!],
                      ["color" : UIColor.lightGray,
                       "image": UIImage(named: "ic-shopping-cate-r-4")!]]
    var cate5Items = [["color" : Constant.Colors.CATE5,
                       "image": UIImage(named: "ic-shopping-cate-r-5-active")!],
                      ["color" : UIColor.lightGray,
                       "image": UIImage(named: "ic-shopping-cate-r-5")!]]
    var cate6Items = [["color" : Constant.Colors.CATE6,
                       "image": UIImage(named: "ic-shopping-cate-r-6-active")!],
                      ["color" : UIColor.lightGray,
                       "image": UIImage(named: "ic-shopping-cate-r-6")!]]
    
    
    var selectedCallback:((_ cateNumber:Int)->Void)?
    
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
        
        self.selectedCategory(1)
    }
    
    @objc func cate1Tapped(){
        self.selectedCategory(1)
    }
    @objc func cate2Tapped(){
        self.selectedCategory(2)
    }
    @objc func cate3Tapped(){
        self.selectedCategory(3)
    }
    @objc func cate4Tapped(){
        self.selectedCategory(4)
    }
    @objc func cate5Tapped(){
        self.selectedCategory(5)
    }
    @objc func cate6Tapped(){
        self.selectedCategory(6)
    }
    func selectedCategory(_ position:Int){
        selectedCallback?(position)
        
        switch position {
        case 1:
            
            self.cate1ImageView.image = cate1Items[0]["image"] as? UIImage ?? nil
            self.cate1Label.textColor = cate1Items[0]["color"] as? UIColor ?? nil
            
            self.cate2ImageView.image = cate2Items[1]["image"] as? UIImage ?? nil
            self.caet2Label.textColor = cate2Items[1]["color"] as? UIColor ?? nil
            
            self.cate3ImageView.image = cate3Items[1]["image"] as? UIImage ?? nil
            self.caet3Label.textColor = cate3Items[1]["color"] as? UIColor ?? nil
            
            self.cate4ImageView.image = cate4Items[1]["image"] as? UIImage ?? nil
            self.caet4Label.textColor = cate4Items[1]["color"] as? UIColor ?? nil
            
            self.cate5ImageView.image = cate5Items[1]["image"] as? UIImage ?? nil
            self.caet5Label.textColor = cate5Items[1]["color"] as? UIColor ?? nil
            
            self.cate6ImageView.image = cate6Items[1]["image"] as? UIImage ?? nil
            self.caet6Label.textColor = cate6Items[1]["color"] as? UIColor ?? nil
            break
        case 2:
            
            self.cate1ImageView.image = cate1Items[1]["image"] as? UIImage ?? nil
            self.cate1Label.textColor = cate1Items[1]["color"] as? UIColor ?? nil
            
            self.cate2ImageView.image = cate2Items[0]["image"] as? UIImage ?? nil
            self.caet2Label.textColor = cate2Items[0]["color"] as? UIColor ?? nil
            
            self.cate3ImageView.image = cate3Items[1]["image"] as? UIImage ?? nil
            self.caet3Label.textColor = cate3Items[1]["color"] as? UIColor ?? nil
            
            self.cate4ImageView.image = cate4Items[1]["image"] as? UIImage ?? nil
            self.caet4Label.textColor = cate4Items[1]["color"] as? UIColor ?? nil
            
            self.cate5ImageView.image = cate5Items[1]["image"] as? UIImage ?? nil
            self.caet5Label.textColor = cate5Items[1]["color"] as? UIColor ?? nil
            
            self.cate6ImageView.image = cate6Items[1]["image"] as? UIImage ?? nil
            self.caet6Label.textColor = cate6Items[1]["color"] as? UIColor ?? nil
            break
        case 3:
            
            self.cate1ImageView.image = cate1Items[1]["image"] as? UIImage ?? nil
            self.cate1Label.textColor = cate1Items[1]["color"] as? UIColor ?? nil
            
            self.cate2ImageView.image = cate2Items[1]["image"] as? UIImage ?? nil
            self.caet2Label.textColor = cate2Items[1]["color"] as? UIColor ?? nil
            
            self.cate3ImageView.image = cate3Items[0]["image"] as? UIImage ?? nil
            self.caet3Label.textColor = cate3Items[0]["color"] as? UIColor ?? nil
            
            self.cate4ImageView.image = cate4Items[1]["image"] as? UIImage ?? nil
            self.caet4Label.textColor = cate4Items[1]["color"] as? UIColor ?? nil
            
            self.cate5ImageView.image = cate5Items[1]["image"] as? UIImage ?? nil
            self.caet5Label.textColor = cate5Items[1]["color"] as? UIColor ?? nil
            
            self.cate6ImageView.image = cate6Items[1]["image"] as? UIImage ?? nil
            self.caet6Label.textColor = cate6Items[1]["color"] as? UIColor ?? nil
            break
        case 4:
            
            self.cate1ImageView.image = cate1Items[1]["image"] as? UIImage ?? nil
            self.cate1Label.textColor = cate1Items[1]["color"] as? UIColor ?? nil
            
            self.cate2ImageView.image = cate2Items[1]["image"] as? UIImage ?? nil
            self.caet2Label.textColor = cate2Items[1]["color"] as? UIColor ?? nil
            
            self.cate3ImageView.image = cate3Items[1]["image"] as? UIImage ?? nil
            self.caet3Label.textColor = cate3Items[1]["color"] as? UIColor ?? nil
            
            self.cate4ImageView.image = cate4Items[0]["image"] as? UIImage ?? nil
            self.caet4Label.textColor = cate4Items[0]["color"] as? UIColor ?? nil
            
            self.cate5ImageView.image = cate5Items[1]["image"] as? UIImage ?? nil
            self.caet5Label.textColor = cate5Items[1]["color"] as? UIColor ?? nil
            
            self.cate6ImageView.image = cate6Items[1]["image"] as? UIImage ?? nil
            self.caet6Label.textColor = cate6Items[1]["color"] as? UIColor ?? nil
            break
        case 5:
            
            self.cate1ImageView.image = cate1Items[1]["image"] as? UIImage ?? nil
            self.cate1Label.textColor = cate1Items[1]["color"] as? UIColor ?? nil
            
            self.cate2ImageView.image = cate2Items[1]["image"] as? UIImage ?? nil
            self.caet2Label.textColor = cate2Items[1]["color"] as? UIColor ?? nil
            
            self.cate3ImageView.image = cate3Items[1]["image"] as? UIImage ?? nil
            self.caet3Label.textColor = cate3Items[1]["color"] as? UIColor ?? nil
            
            self.cate4ImageView.image = cate4Items[1]["image"] as? UIImage ?? nil
            self.caet4Label.textColor = cate4Items[1]["color"] as? UIColor ?? nil
            
            self.cate5ImageView.image = cate5Items[0]["image"] as? UIImage ?? nil
            self.caet5Label.textColor = cate5Items[0]["color"] as? UIColor ?? nil
            
            self.cate6ImageView.image = cate6Items[1]["image"] as? UIImage ?? nil
            self.caet6Label.textColor = cate6Items[1]["color"] as? UIColor ?? nil
            
            break
        case 6:
        
            self.cate1ImageView.image = cate1Items[1]["image"] as? UIImage ?? nil
            self.cate1Label.textColor = cate1Items[1]["color"] as? UIColor ?? nil
            
            self.cate2ImageView.image = cate2Items[1]["image"] as? UIImage ?? nil
            self.caet2Label.textColor = cate2Items[1]["color"] as? UIColor ?? nil
            
            self.cate3ImageView.image = cate3Items[1]["image"] as? UIImage ?? nil
            self.caet3Label.textColor = cate3Items[1]["color"] as? UIColor ?? nil
            
            self.cate4ImageView.image = cate4Items[1]["image"] as? UIImage ?? nil
            self.caet4Label.textColor = cate4Items[1]["color"] as? UIColor ?? nil
            
            self.cate5ImageView.image = cate5Items[1]["image"] as? UIImage ?? nil
            self.caet5Label.textColor = cate5Items[1]["color"] as? UIColor ?? nil
            
            self.cate6ImageView.image = cate6Items[0]["image"] as? UIImage ?? nil
            self.caet6Label.textColor = cate6Items[0]["color"] as? UIColor ?? nil
            break
        default:
            break
        }
    }

}
