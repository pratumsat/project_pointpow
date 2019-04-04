//
//  LuckyDrawPrivacyCell.swift
//  pointpow
//
//  Created by thanawat on 2/4/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class LuckyDrawPrivacyCell: UICollectionViewCell {
    
    @IBOutlet weak var howToTitleLabel: UILabel!
    @IBOutlet weak var privacyTitleLabel: UILabel!
    @IBOutlet weak var requireTxtLabel: UILabel!
    @IBOutlet weak var required: UILabel!
    @IBOutlet weak var shadowHowToView: UIView!
    
    @IBOutlet weak var shadowPrivacyView: UIView!
    @IBOutlet weak var liveImageView: UIImageView!
    @IBOutlet weak var conditionView: UIView!
    @IBOutlet weak var winnerView: UIView!
    @IBOutlet weak var liveView: UIView!
    
    @IBOutlet weak var howtoLeftView: UIView!
    @IBOutlet weak var privacyLeftView: UIView!
    @IBOutlet weak var privacyView: UIView!
    @IBOutlet weak var howtoView: UIView!
    
    @IBOutlet weak var expandPrivacyImageView: UIImageView!
    
    @IBOutlet weak var expandHowtoImageView: UIImageView!
    
    @IBOutlet weak var heightPrivacyViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightHowtoViewConstraint: NSLayoutConstraint!
    func liveDisable(){
        liveImageView.image = liveImageView.image!.withRenderingMode(.alwaysTemplate)
        liveImageView.tintColor = UIColor.white
        liveView.borderClearProperties()
        liveView.backgroundColor = UIColor.lightGray
        liveView.isUserInteractionEnabled = false
    }
    func liveEnable(){
        liveImageView.image = liveImageView.image!.withRenderingMode(.alwaysTemplate)
        liveImageView.tintColor = UIColor.white
        liveView.borderRedColorProperties()
        liveView.backgroundColor = Constant.Colors.PRIMARY_COLOR
        liveView.isUserInteractionEnabled = true
    }
    
     var expandablePrivacyCallback:((_ height:CGFloat)->Void)?
     var expandableHowToCallback:((_ height:CGFloat)->Void)?
    
    var showWinnerCallback:(()->Void)?
    var showLinkFacebookCallback:(()->Void)?
    
    var onPrivacy = true
    
    var heightViewPrivacy = CGFloat(200.0)
    var hideViewPrivacy = CGFloat(35.0)
  
    var onHowto = true
    
    var heightViewHowto = CGFloat(150.0)
    var hideViewHowto = CGFloat(35.0)
    
    
    let active = UIImage(named: "ic-arrow-expand-down")
    let inactive = UIImage(named: "ic-arrow-expand")
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        self.liveDisable()
        
        //howtoView.shadowCellProperties()
        
        shadowHowToView.shadowCellProperties()
        shadowPrivacyView.shadowCellProperties()
        
        
        let expandPrivacy = UITapGestureRecognizer(target: self, action: #selector(expandablePrivacyTapped))
        self.privacyTitleLabel.isUserInteractionEnabled = true
        self.privacyTitleLabel.addGestureRecognizer(expandPrivacy)
        
        let expandHowto = UITapGestureRecognizer(target: self, action: #selector(expandableHowToTapped))
        self.howToTitleLabel.isUserInteractionEnabled = true
        self.howToTitleLabel.addGestureRecognizer(expandHowto)
      
        let winner = UITapGestureRecognizer(target: self, action: #selector(showWinnerLuckyDraw))
        self.winnerView.isUserInteractionEnabled = true
        self.winnerView.addGestureRecognizer(winner)
       
        let liveLink = UITapGestureRecognizer(target: self, action: #selector(showLive))
        self.liveView.isUserInteractionEnabled = true
        self.liveView.addGestureRecognizer(liveLink)
        
        updateView()
        
    }
    @objc func showLive(){
        self.showLinkFacebookCallback?()
    }
    @objc func showWinnerLuckyDraw(){
        self.showWinnerCallback?()
    }
    func updateView(){
        self.expandPrivacyImageView.image = active
        self.expandHowtoImageView.image = inactive
        
        self.heightPrivacyViewConstraint.constant = heightViewPrivacy
        self.onPrivacy = true
        
        self.heightHowtoViewConstraint.constant = hideViewPrivacy
        self.onPrivacy = false
    }
    
    @objc func expandablePrivacyTapped(){
        self.expandablePrivacyCallback?(onPrivacy ? heightViewPrivacy : hideViewPrivacy)
        self.heightPrivacyViewConstraint.constant = onPrivacy ? hideViewPrivacy : heightViewPrivacy
        self.expandPrivacyImageView.image = onPrivacy ? inactive : active
        
        
        self.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: 0.2,  delay: 0, options:.beginFromCurrentState,animations: {
            self.layoutIfNeeded()
        }) { (completed) in
            self.onPrivacy = self.onPrivacy ? false : true
        }
        
    }
    
    
    @objc func expandableHowToTapped(){
        self.expandableHowToCallback?(onHowto ? heightViewHowto : hideViewHowto)
        self.heightHowtoViewConstraint.constant = onHowto ? heightViewHowto : hideViewHowto
        self.expandHowtoImageView.image = onHowto ? active : inactive
        
        
        self.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: 0.2,  delay: 0, options:.beginFromCurrentState,animations: {
            self.layoutIfNeeded()
        }) { (completed) in
            self.onHowto = self.onHowto ? false : true
        }
    }
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        winnerView.borderRedColorProperties()
        
        conditionView.borderRedColorProperties(borderWidth: 1.0, radius: 10)
        
       
        howtoView.borderClearProperties(borderWidth: 1.0, radius: 10)
        privacyView.borderClearProperties(borderWidth: 1.0, radius: 10)
        
        
        
        
    }
    
}

