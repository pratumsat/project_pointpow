//
//  SavingCell.swift
//  pointpow
//
//  Created by thanawat on 4/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class SavingCell: UICollectionViewCell{

    @IBOutlet weak var pointBalanceLabel: UILabel!
    @IBOutlet weak var headView: UIView!
   
    @IBOutlet weak var pointpowTextField: UITextField!
    @IBOutlet weak var savingButton: UIButton!
    
    var savingCallback:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        self.updateLayerCornerRadiusProperties()
        self.contentView.updateLayerCornerRadiusProperties()
        self.shadowCellProperties()
        
        self.pointpowTextField.borderRedColorProperties(borderWidth: 1)
        self.pointpowTextField.setRightPaddingPoints(10)
        self.pointpowTextField.setLeftPaddingPoints(10)
    }

    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
       
        
       
    }
    
    
    
  
    
    @IBAction func savingTapped(_ sender: Any) {
        self.savingCallback?()
    }
}
