//
//  AddressViewCell.swift
//  pointpow
//
//  Created by thanawat on 24/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class AddressViewCell: UICollectionViewCell {

    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var deleteImageView: UIImageView!
    @IBOutlet weak var editImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    var selectedAddress:Bool = false {
        didSet{
            if selectedAddress {
                self.selectImageView.image = UIImage(named: "ic-choose-2")
                self.mView.backgroundColor = Constant.Colors.SELECTED_RED
            }else{
                self.selectImageView.image = UIImage(named: "ic-choose-1")
                self.mView.backgroundColor = UIColor.white
            }
            
        }
    }
    
    
    var editCallback:(()->Void)?
    var deleteCallback:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let edit = UITapGestureRecognizer(target: self, action: #selector(editTapped))
        self.editImageView.isUserInteractionEnabled  = true
        self.editImageView.addGestureRecognizer(edit)
        
        let delete = UITapGestureRecognizer(target: self, action: #selector(deleteTapped))
        self.deleteImageView.isUserInteractionEnabled  = true
        self.deleteImageView.addGestureRecognizer(delete)
        
    }
    
    @objc func editTapped(){
        self.editCallback?()
    }
    
    @objc func deleteTapped(){
        self.deleteCallback?()
    }
    
    
    @objc func selectTapped(){
//        if selectedAddress {
//            self.selectImageView.image = UIImage(named: "ic-choose-1")
//        }else{
//            self.selectImageView.image = UIImage(named: "ic-choose-2")
//        }
    }
    

}
