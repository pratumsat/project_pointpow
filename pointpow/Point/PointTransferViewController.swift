//
//  PointTransferViewController.swift
//  pointpow
//
//  Created by thanawat on 14/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class PointTransferViewController: BaseViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var pointCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-point-transfer", comment: "")
        self.setUp()
        
    }
    func setUp(){
        self.backgroundImage?.image = nil
        
        self.pointCollectionView.dataSource = self
        self.pointCollectionView.delegate = self

        self.registerNib(self.pointCollectionView, "ItemBankCell")
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemBankCell", for: indexPath) as? ItemBankCell {
                cell = item
                
                
//                switch indexPath.row {
//                case 0:
//                    item.itemImageView.image = UIImage(named: "ic-account-ticket")
//                    item.nameLabel.text = NSLocalizedString("string-item-ticket", comment: "")
//                case 1:
//                    item.itemImageView.image = UIImage(named: "ic-account-bill")
//                    item.nameLabel.text = NSLocalizedString("string-item-bill", comment: "")
//                case 2:
//                    item.itemImageView.image = UIImage(named: "ic-account-qr")
//                    item.nameLabel.text = NSLocalizedString("string-item-qr", comment: "")
//                case 3:
//                    item.itemImageView.image = UIImage(named: "ic-account-profile")
//                    item.nameLabel.text = NSLocalizedString("string-item-profile", comment: "")
//                case 4:
//                    item.itemImageView.image = UIImage(named: "ic-account-secue-setting")
//                    item.nameLabel.text = NSLocalizedString("string-item-security-setting", comment: "")
//                case 5:
//                    item.itemImageView.image = UIImage(named: "ic-account-setting")
//                    item.nameLabel.text = NSLocalizedString("string-item-setting", comment: "")
//                case 6:
//                    item.itemImageView.image = UIImage(named: "ic-account-about")
//                    item.nameLabel.text = NSLocalizedString("string-item-about", comment: "")
//                    item.name2Label.text = NSLocalizedString("string-item-about2", comment: "")
//                default:
//                    break
//
//                }
        }

        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
    }
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let width = collectionView.frame.width / 3
        return CGSize(width: width, height: width)
    }
}
