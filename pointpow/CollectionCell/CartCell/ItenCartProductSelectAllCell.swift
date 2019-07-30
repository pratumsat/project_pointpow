//
//  ItenCartProductCell.swift
//  pointpow
//
//  Created by thanawat on 3/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ItenCartProductSelectAllCell: UICollectionViewCell {
    
    @IBOutlet weak var checkSpaceView: UIView!
    @IBOutlet weak var checkBox: CheckBoxRed!
    
    @IBOutlet weak var deleteImageView: UIImageView!
    @IBOutlet weak var deleteView: UIView!
    
    @IBOutlet weak var allLabel: UILabel!
    var deleteCallback:(()->Void)?
    var checkCallback:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let delete = UITapGestureRecognizer(target: self, action: #selector(deleteTapped))
        self.deleteView.isUserInteractionEnabled = true
        self.deleteView.addGestureRecognizer(delete)
        
        let check = UITapGestureRecognizer(target: self, action: #selector(checkTapped))
        self.checkSpaceView.isUserInteractionEnabled = true
        self.checkSpaceView.addGestureRecognizer(check)
    }
    
    @objc func deleteTapped(){
        self.deleteCallback?()
    }
    @objc func checkTapped(){
        checkBox.isChecked = !checkBox.isChecked
        self.checkCallback?()
    }

}
