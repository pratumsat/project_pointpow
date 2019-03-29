//
//  WithDrawResultThaiPostCell.swift
//  pointpow
//
//  Created by thanawat on 20/3/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class WithDrawResultThaiPostCell: UICollectionViewCell {

    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var shippingStatusTitleLabel: UILabel!
    @IBOutlet weak var shippingStatusLabel: UILabel!
    @IBOutlet weak var shippingLineView: UIView!
    @IBOutlet weak var bgSuccessImageView: UIImageView!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var payByLabel: UILabel!
    @IBOutlet weak var pickByLabel: UILabel!
    @IBOutlet weak var formatGoldReceiveLabel: UILabel!
    @IBOutlet weak var withdrawAmountLabel: UILabel!
    @IBOutlet weak var withdrawUnitLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var transactionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
   
    @IBOutlet weak var expandImageView: UIImageView!
    @IBOutlet weak var amountBoxLabel: UILabel!
    @IBOutlet weak var heightContainerConstraints: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var premiumLabel: UILabel!
    
    @IBOutlet weak var saveSlipView: UIView!
    @IBOutlet weak var marginTopCancelButton: NSLayoutConstraint!
    
    var saveSlipCallback:(()->Void)?
    var expandableCallback:((_ height:CGFloat)->Void)?
    var cancelCallback:(()->Void)?
    
    var addCompleted:(()->Void)?
    
    var arrayBox:[[String:AnyObject]]?{
        didSet{
            updateView()
        }
    }
    var showViewExpand:Bool = false {
        didSet{
            if showViewExpand {
                self.containerView.isHidden = false
                self.heightContainerConstraints.constant = heightView
                self.expandImageView.isHidden = true
                
            }
            
        }
    }
    
    var on = true
    
    var heightView = CGFloat(0.0)
    var hideView = CGFloat(0.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cancelButton?.tag = 1
        self.cancelLabel?.tag = 1
        self.saveSlipView?.tag = 1
        
        self.updateLayerCornerRadiusProperties()
        self.contentView.updateLayerCornerRadiusProperties()
        self.shadowCellProperties()
        
        let expand = UITapGestureRecognizer(target: self, action: #selector(expandableTapped))
        self.expandImageView.isUserInteractionEnabled = true
        self.expandImageView.addGestureRecognizer(expand)
        
        let saveslip = UITapGestureRecognizer(target: self, action: #selector(saveSlipTapped))
        self.saveSlipView?.isUserInteractionEnabled = true
        self.saveSlipView?.addGestureRecognizer(saveslip)
        
        self.updateView()
        
    }

    @objc func saveSlipTapped(){
        self.saveSlipCallback?()
    }
    @IBAction func cancelTapped(_ sender: Any) {
        self.cancelCallback?()
    }
    
    func updateView(){
        self.heightContainerConstraints.constant = 0
        self.containerView.isHidden = true
        
        
        if let array = arrayBox {
            for item in array {
                addView(item)
            }
        }
        self.addCompleted?()
        
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
        pricelabel.font = UIFont(name: Constant.Fonts.THAI_SANS_REGULAR, size: Constant.Fonts.Size.VALUE_EXPEND)!
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
        
        self.cancelButton?.borderClearProperties(borderWidth: 1)
        self.cancelButton?.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
        
        self.saveSlipView?.borderBlackolorProperties(borderWidth: 0.5)
        
    }
}
