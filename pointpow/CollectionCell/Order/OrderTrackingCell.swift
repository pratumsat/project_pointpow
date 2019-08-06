//
//  OrderTrackingCell.swift
//  pointpow
//
//  Created by thanawat on 6/8/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class OrderTrackingCell: UICollectionViewCell {

    @IBOutlet weak var trackingView: UIView!
    @IBOutlet weak var betweenStep2View: UIView!
    @IBOutlet weak var dashLabel: UILabel!
    
    @IBOutlet weak var betweenStep3View: UIView!
    @IBOutlet weak var step3Label: UILabel!
    @IBOutlet weak var step2Label: UILabel!
    @IBOutlet weak var step1Label: UILabel!
    @IBOutlet weak var trackingNumberLabel: UILabel!
    @IBOutlet weak var logoProviderImageView: UIImageView!
    @IBOutlet weak var providerNameLabel: UILabel!
    
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    
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
    
    func selectPosition(_ position:Int) {
        switch position {
        case 0:
            self.trackingView.isUserInteractionEnabled = false
            self.logoProviderImageView.isHidden = true
            self.providerNameLabel.isHidden = true
            self.dashLabel.isHidden = false
            self.trackingNumberLabel.text = "-"
            self.trackingNumberLabel.textColor = UIColor.lightGray
            self.step1Label.backgroundColor = Constant.Colors.GREEN
            self.step2Label.backgroundColor = UIColor.lightGray
            self.step3Label.backgroundColor = UIColor.lightGray
            self.betweenStep2View.backgroundColor = UIColor.lightGray
            self.betweenStep3View.backgroundColor = UIColor.lightGray
            break
        case 1:
            self.trackingView.isUserInteractionEnabled = true
            self.logoProviderImageView.isHidden = false
            self.providerNameLabel.isHidden = false
            self.dashLabel.isHidden = true
            self.trackingNumberLabel.textColor = Constant.Colors.PRIMARY_COLOR
            self.step1Label.backgroundColor = Constant.Colors.GREEN
            self.step2Label.backgroundColor = Constant.Colors.GREEN
            self.step3Label.backgroundColor = UIColor.lightGray
            self.betweenStep2View.backgroundColor = Constant.Colors.GREEN
            self.betweenStep3View.backgroundColor = UIColor.lightGray
            break
        case 2:
            self.trackingView.isUserInteractionEnabled = true
            self.logoProviderImageView.isHidden = false
            self.providerNameLabel.isHidden = false
            self.dashLabel.isHidden = true
            self.trackingNumberLabel.textColor = Constant.Colors.PRIMARY_COLOR
            self.step1Label.backgroundColor = Constant.Colors.GREEN
            self.step2Label.backgroundColor = Constant.Colors.GREEN
            self.step3Label.backgroundColor = Constant.Colors.GREEN
            self.betweenStep2View.backgroundColor = Constant.Colors.GREEN
            self.betweenStep3View.backgroundColor = Constant.Colors.GREEN
            break
        default:
            break
        }
    }
    
    var tackingCallback: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tacking  = UITapGestureRecognizer(target: self, action: #selector(tackingTapped))
        self.trackingView.isUserInteractionEnabled = true
        self.trackingView.addGestureRecognizer(tacking)
    }

    @objc func tackingTapped(){
        self.tackingCallback?()
    }
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.step1Label.ovalColorClearProperties()
        self.step2Label.ovalColorClearProperties()
        self.step3Label.ovalColorClearProperties()
        
    }
}
