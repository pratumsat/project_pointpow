//
//  FavorCell.swift
//  pointpow
//
//  Created by thanawat on 15/12/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class FavorCell: UICollectionViewCell {

    @IBOutlet weak var deleteImageView: UIImageView!
    @IBOutlet weak var editImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var editCallback:(()->Void)?
    var deleteCallback:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let edit = UITapGestureRecognizer(target: self, action: #selector(editTapped))
        self.editImageView.isUserInteractionEnabled = true
        self.editImageView.addGestureRecognizer(edit)
        
        let delete = UITapGestureRecognizer(target: self, action: #selector(deleteTapped))
        self.deleteImageView.isUserInteractionEnabled = true
        self.deleteImageView.addGestureRecognizer(delete)
        
    }
    
    @objc func deleteTapped(){
        self.deleteCallback?()
    }
    @objc func editTapped(){
        self.editCallback?()
    }

}
