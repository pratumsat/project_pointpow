//
//  TaxInvoiceSelectCell.swift
//  pointpow
//
//  Created by thanawat on 20/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class TaxInvoiceSelectCell: UICollectionViewCell {

    @IBOutlet weak var checkSpaceView: UIView!
    @IBOutlet weak var checkBox: CheckBoxRed!
     var checkCallback:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let check = UITapGestureRecognizer(target: self, action: #selector(checkTapped))
        self.checkSpaceView.isUserInteractionEnabled = true
        self.checkSpaceView.addGestureRecognizer(check)
    }
    @objc func checkTapped(){
        checkBox.isChecked = !checkBox.isChecked
        self.checkCallback?()
    }
}
