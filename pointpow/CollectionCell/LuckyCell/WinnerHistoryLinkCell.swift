//
//  WinnerHistoryLinkCell.swift
//  pointpow
//
//  Created by thanawat on 3/4/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class WinnerHistoryLinkCell: UICollectionViewCell {
    @IBOutlet weak var savingView: UIView!
    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var liveInmgeView: UIImageView!
    
    var showLinkFacebookCallback:(()->Void)?
    var showSavingHomeCallback:(()->Void)?
    
    @IBOutlet weak var savingButtonView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        liveInmgeView.image = liveInmgeView.image!.withRenderingMode(.alwaysTemplate)
        liveInmgeView.tintColor = Constant.Colors.PRIMARY_COLOR
        
        let liveLink = UITapGestureRecognizer(target: self, action: #selector(showLive))
        self.liveView.isUserInteractionEnabled = true
        self.liveView.addGestureRecognizer(liveLink)
        
        let savingTap = UITapGestureRecognizer(target: self, action: #selector(savingTapped))
        self.savingButtonView.isUserInteractionEnabled = true
        self.savingButtonView.addGestureRecognizer(savingTap)
        
    }
    @objc func showLive(){
        self.showLinkFacebookCallback?()
    }
    @objc func savingTapped(){
        self.showSavingHomeCallback?()
    }

    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        liveView.borderRedColorProperties()
        savingView.borderRedColorProperties(borderWidth: 1.0, radius: 10)
        savingButtonView.borderRedColorProperties()
        
    }
}
