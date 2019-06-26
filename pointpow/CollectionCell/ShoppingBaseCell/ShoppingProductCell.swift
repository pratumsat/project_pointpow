//
//  ShoppingProductCell.swift
//  pointpow
//
//  Created by thanawat on 26/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ShoppingProductCell: UICollectionViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    var disCountValue:String? {
        didSet{
            if let text = disCountValue {
                self.discountLabel?.stuckCharacters(text)
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
     
    }

}
