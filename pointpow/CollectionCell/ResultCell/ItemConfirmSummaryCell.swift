//
//  ItemConfirmSummaryCell.swift
//  pointpow
//
//  Created by thanawat on 19/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class ItemConfirmSummaryCell: UICollectionViewCell {

    
    var favorCallback:(()->Void)?
    var shareCallback:(()->Void)?
    
    @IBOutlet weak var favoView: UIView!
    @IBOutlet weak var saveView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let share  = UITapGestureRecognizer(target: self, action: #selector(shareTapped))
        self.saveView.isUserInteractionEnabled = true
        self.saveView.addGestureRecognizer(share)
        
        let addFav  = UITapGestureRecognizer(target: self, action: #selector(addFavTapped))
        self.favoView.isUserInteractionEnabled = true
        self.favoView.addGestureRecognizer(addFav)
    }
    @objc func shareTapped(){
        self.shareCallback?()
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
        
        self.favoView.borderRedColorProperties()
       
        self.saveView.borderRedColorProperties()
       
        
    }
     
}
