//
//  ItemFavorCell.swift
//  pointpow
//
//  Created by thanawat on 21/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class ItemFavorCell: UICollectionViewCell {
    @IBOutlet weak var favoView: UIView!
    
    var favorCallback:(()->Void)?
    
  
    var shareCallback:(()->Void)?
    
    var disableFav  = false {
        didSet{
            self.favoView.isUserInteractionEnabled = false
            self.favoView.borderLightGrayColorProperties()
            self.favoImageView.image = UIImage(named: "ic-star-outline-gray")
            self.favoLabel.textColor = UIColor.lightGray
        }
    }
    @IBOutlet weak var favoLabel: UILabel!
    
    @IBOutlet weak var favoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let addFav  = UITapGestureRecognizer(target: self, action: #selector(addFavTapped))
        self.favoView.isUserInteractionEnabled = true
        self.favoView.addGestureRecognizer(addFav)
        
    }
    
    @objc func addFavTapped(){
        self.favorCallback?()
    }
    
    
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !disableFav {
            self.favoView.borderRedColorProperties()
        }
        
    }
}
