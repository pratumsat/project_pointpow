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
        self.pointCollectionView.showsVerticalScrollIndicator = false
        
        self.registerNib(self.pointCollectionView, "ItemBankCell")
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemBankCell", for: indexPath) as? ItemBankCell {
                cell = item
                
                
                switch indexPath.row {
                case 0:
                    item.coverImageView.image = UIImage(named: "ic-bank-1")
                    item.providerLabel.text = "BBL Credit Card"
                case 1:
                    item.coverImageView.image = UIImage(named: "ic-bank-2")
                    item.providerLabel.text = "ICBC Credit Card"
                case 2:
                    item.coverImageView.image = UIImage(named: "ic-bank-3")
                    item.providerLabel.text = "Thanachart Credit Card"
                case 3:
                    item.coverImageView.image = UIImage(named: "ic-bank-4")
                    item.providerLabel.text = "KTC Credit Card"
                case 4:
                    item.coverImageView.image = UIImage(named: "ic-bank-5")
                    item.providerLabel.text = "Kbank Credit Card"
                case 5:
                    item.coverImageView.image = UIImage(named: "ic-bank-6")
                    item.providerLabel.text = "GSB Credit Card"
                case 6:
                    item.coverImageView.image = UIImage(named: "ic-bank-7")
                    item.providerLabel.text = "AIS Point"
                default:
                    break

                }
                item.providerLabel.setLineSpacing(lineSpacing: 0, lineHeightMultiple: 0.7)   // for thai sans
                item.providerLabel.textAlignment = .center
        }

        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        if indexPath.row == 0 {
            self.showPPWebView(true)
        }else if indexPath.row == 6 {
            self.showBankTransferView(true)
        }
    }
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let width = collectionView.frame.width / 3
        return CGSize(width: width, height: width)
    }
}
