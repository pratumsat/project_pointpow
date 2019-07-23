//
//  ItenCartProductCell.swift
//  pointpow
//
//  Created by thanawat on 3/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ItenCartProductSelectAllCell: UICollectionViewCell {
    
    @IBOutlet weak var checkBox: CheckBoxRed!
    
    @IBOutlet weak var deleteImageView: UIImageView!
    
    var deleteCallback:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let delete = UITapGestureRecognizer(target: self, action: #selector(deleteTapped))
        self.deleteImageView.isUserInteractionEnabled = true
        self.deleteImageView.addGestureRecognizer(delete)
    }
    
    @objc func deleteTapped(){
        self.deleteCallback?()
    }

}
