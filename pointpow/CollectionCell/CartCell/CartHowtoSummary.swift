//
//  CartHowtoSummary.swift
//  pointpow
//
//  Created by thanawat on 3/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class CartHowtoSummary: UICollectionViewCell {

    @IBOutlet weak var bLabel: UILabel!
    @IBOutlet weak var tacdLabel: UILabel!
    @IBOutlet weak var tcdLabel: UILabel!
    @IBOutlet weak var cdLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var howtoPayLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func hideCreditCardLabel(){
        bLabel.isHidden = true
        tacdLabel.isHidden = true
        tcdLabel.isHidden = true
        cdLabel.isHidden = true
    }
    func showCreditCardLabel(){
        bLabel.isHidden = false
        tacdLabel.isHidden = false
        tcdLabel.isHidden = false
        cdLabel.isHidden = false
    }

}
