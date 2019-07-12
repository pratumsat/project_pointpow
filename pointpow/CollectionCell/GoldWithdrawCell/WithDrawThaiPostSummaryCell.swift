//
//  WithDrawThaiPostSummaryCell.swift
//  pointpow
//
//  Created by thanawat on 17/3/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class WithDrawThaiPostSummaryCell: UICollectionViewCell {
    
    @IBOutlet weak var formatGoldReceiveLabel: UILabel!
    
    @IBOutlet weak var goldAmountLabel: UILabel!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var unitLabel: UILabel!
    
    @IBOutlet weak var expandImageView: UIImageView!
    @IBOutlet weak var amountBoxLabel: UILabel!
    @IBOutlet weak var heightContainerConstraints: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var goldBalanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var premiumLabel: UILabel!
    
    var expandableCallback:((_ height:CGFloat)->Void)?
    
    var arrayBox:[[String:AnyObject]]?{
        didSet{
            updateView()
        }
    }
    
    var on = true
    
    var heightView = CGFloat(0.0)
    var hideView = CGFloat(0.0)
    
    let active = UIImage(named: "ic-more-btn")
    let inactive = UIImage(named: "ic-more-btn2")
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.updateLayerCornerRadiusProperties()
        self.contentView.updateLayerCornerRadiusProperties()
        self.shadowCellProperties()
        
        let expand = UITapGestureRecognizer(target: self, action: #selector(expandableTapped))
        self.expandImageView.isUserInteractionEnabled = true
        self.expandImageView.addGestureRecognizer(expand)
        
        self.updateView()
    }
    
    
    func updateView(){
        self.heightContainerConstraints.constant = 0
        self.containerView.isHidden = true
        self.expandImageView.image = active
        
        
        
        if let array = arrayBox {
            for item in array {
                addView(item)
            }
        }
        
    }
    
    func addView(_ item:[String:AnyObject]) {
        let order = item["order"] as? NSNumber ?? 0
        let price = item["price"] as? NSNumber ?? 0
        let word = NSLocalizedString("string-thaipost-delivery-value", comment: "")
        let unitBaht = NSLocalizedString("unit-baht", comment: "")
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        let valuelabel = UILabel()
        valuelabel.translatesAutoresizingMaskIntoConstraints = false
        valuelabel.lineBreakMode = .byWordWrapping
        valuelabel.font = UIFont(name: Constant.Fonts.THAI_SANS_REGULAR, size: Constant.Fonts.Size.VALUE_EXPEND)!
        valuelabel.text = "\(word) \(order)"
        valuelabel.textColor = UIColor.darkGray
        valuelabel.sizeToFit()
        view.addSubview(valuelabel)
        
        valuelabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        valuelabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let pricelabel = UILabel()
        pricelabel.translatesAutoresizingMaskIntoConstraints = false
        pricelabel.lineBreakMode = .byWordWrapping
        pricelabel.font = UIFont(name: Constant.Fonts.THAI_SANS_REGULAR, size: Constant.Fonts.Size.VALUE_EXPEND2)!
        pricelabel.text = "\(price) \(unitBaht)"
        pricelabel.textColor = UIColor.darkGray
        pricelabel.sizeToFit()
        view.addSubview(pricelabel)
        
        pricelabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        pricelabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        if let lastView = self.containerView.subviews.last {
            self.containerView.addSubview(view)
            view.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 0).isActive = true
            view.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: 0).isActive = true
            view.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 0).isActive = true
            view.heightAnchor.constraint(equalTo: pricelabel.heightAnchor, constant: 0).isActive = true
        }else{
            self.containerView.addSubview(view)
            view.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 0).isActive = true
            view.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: 0).isActive = true
            view.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0).isActive = true
            view.heightAnchor.constraint(equalTo: pricelabel.heightAnchor, constant: 0).isActive = true
        }
        
        self.heightView += 30
    }
    
    
    
    @objc func expandableTapped(){
        self.expandableCallback?(on ? heightView : hideView)
        self.containerView.isHidden = on ? false : true
        self.heightContainerConstraints.constant = on ? heightView : hideView
        self.expandImageView.image = on ? inactive : active
        
        
        self.setNeedsUpdateConstraints()
       
        UIView.animate(withDuration: 0.2,  delay: 0, options:.beginFromCurrentState,animations: {
            self.layoutIfNeeded()
        }) { (completed) in
            self.on = self.on ? false : true
        }
        
    }
    
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.headView.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
       
    }
}
