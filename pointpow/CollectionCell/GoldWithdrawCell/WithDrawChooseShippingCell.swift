//
//  WithDrawChooseShippingCell.swift
//  pointpow
//
//  Created by thanawat on 19/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class WithDrawChooseShippingCell: UICollectionViewCell {

    @IBOutlet weak var infoThaiPostImageView: UIImageView!
    @IBOutlet weak var infoPointPowImageView: UIImageView!
    @IBOutlet weak var spThaipostImageView: UIImageView!
    @IBOutlet weak var spPointpowImageView: UIImageView!
    
    var shippingCallback:((_ type:Int)->Void)?
    var infoCallback:(()->Void)?
    var infoThaipostCallback:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let select = UITapGestureRecognizer(target: self, action: #selector(selectTapped))
        self.spPointpowImageView.isUserInteractionEnabled  = true
        self.spPointpowImageView.addGestureRecognizer(select)
        
        let select2 = UITapGestureRecognizer(target: self, action: #selector(selectTapped2))
        self.spThaipostImageView.isUserInteractionEnabled  = true
        self.spThaipostImageView.addGestureRecognizer(select2)
        
        let info = UITapGestureRecognizer(target: self, action: #selector(infoTapped))
        self.infoPointPowImageView.isUserInteractionEnabled  = true
        self.infoPointPowImageView.addGestureRecognizer(info)
        
        let infothaipost = UITapGestureRecognizer(target: self, action: #selector(infoThaiPostTapped))
        self.infoThaiPostImageView.isUserInteractionEnabled  = true
        self.infoThaiPostImageView.addGestureRecognizer(infothaipost)
        
        
        
    }
    @objc func infoThaiPostTapped(){
        self.infoThaipostCallback?()
    }

    @objc func infoTapped(){
        self.infoCallback?()
    }
    
    @objc func selectTapped(){
        self.shippingCallback?(0)
        self.spPointpowImageView.image = UIImage(named: "ic-choose-2")
        self.spThaipostImageView.image = UIImage(named: "ic-choose-1")
    }
    @objc func selectTapped2(){
        self.shippingCallback?(1)
        self.spThaipostImageView.image = UIImage(named: "ic-choose-2")
        self.spPointpowImageView.image = UIImage(named: "ic-choose-1")
    }

}
