//
//  FavorCell.swift
//  pointpow
//
//  Created by thanawat on 15/12/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class FavorCell: UICollectionViewCell {

    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var deleteImageView: UIImageView!
    @IBOutlet weak var editImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var editCallback:(()->Void)?
    var deleteCallback:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let edit = UITapGestureRecognizer(target: self, action: #selector(editTapped))
        self.editView.isUserInteractionEnabled = true
        self.editView.addGestureRecognizer(edit)
        
        let delete = UITapGestureRecognizer(target: self, action: #selector(deleteTapped))
        self.deleteView.isUserInteractionEnabled = true
        self.deleteView.addGestureRecognizer(delete)
        
    }
    
    @objc func deleteTapped(){
        self.deleteCallback?()
    }
    @objc func editTapped(){
        self.editCallback?()
    }

}
