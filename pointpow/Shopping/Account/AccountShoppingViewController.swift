//
//  AccountShoppingViewController.swift
//  pointpow
//
//  Created by thanawat on 25/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class AccountShoppingViewController: ShoppingBaseViewController {

    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    var countSection = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = NSLocalizedString("string-title-shopping-account", comment: "")
    }
    
    func setUp(){
        self.profileCollectionView.delegate = self
        self.profileCollectionView.dataSource = self
        self.profileCollectionView.showsVerticalScrollIndicator = false
        self.addRefreshViewController(self.profileCollectionView)
        self.registerNib(self.profileCollectionView, "ItemProfileCell")
        self.registerHeaderNib(self.profileCollectionView, "HeaderSectionCell")
    }
    override func reloadData() {
        self.refreshControl?.endRefreshing()
    }

}



extension AccountShoppingViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView != profileCollectionView {
            return super.numberOfSections(in: collectionView)
        }
        return self.countSection
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView != profileCollectionView {
            return super.collectionView(collectionView, numberOfItemsInSection: section)
        }
        
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView != profileCollectionView {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
        var cell:UICollectionViewCell?
        
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemProfileCell", for: indexPath) as? ItemProfileCell{
           
            
            switch indexPath.row  {
            case 0:
                itemCell.nameLabel.text = NSLocalizedString("string-item-shopping-profile", comment: "")
                itemCell.trailLabel.text = ""
                break
            case 1:
                itemCell.nameLabel.text = NSLocalizedString("string-item-shopping-address", comment: "")
                itemCell.trailLabel.text = ""
                break
            case 2:
                itemCell.nameLabel.text = NSLocalizedString("string-item-shopping-history", comment: "")
                itemCell.trailLabel.text = ""
                break
            case 3:
                itemCell.nameLabel.text = NSLocalizedString("string-item-shopping-track-shipping", comment: "")
                itemCell.trailLabel.text = ""
                break
            default:
                break
            }
          
            
            let lineBottom = UIView(frame: CGRect(x: 0, y: itemCell.frame.height - 1 , width: collectionView.frame.width, height: 1 ))
            lineBottom.backgroundColor = Constant.Colors.LINE_PROFILE
            itemCell.addSubview(lineBottom)
            
            cell = itemCell
            
        }
       
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != profileCollectionView {
            super.collectionView(collectionView, didSelectItemAt: indexPath)
        }
        switch indexPath.row  {
        case 0:
            break
        case 1:
            self.showSettingShoppingAddressPage(true)
            break
        case 2:
            self.showShoppingHistory(true)
            break
        case 3:
            break
        default:
            break
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView != profileCollectionView {
            return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        }
        
        
        let width = self.profileCollectionView.frame.width
        let height = CGFloat(50.0)
        return CGSize(width: width, height: height)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == self.countSection - 1 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        }
        
        return UIEdgeInsets.zero
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView != profileCollectionView {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSectionCell", for: indexPath) as! HeaderSectionCell
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if collectionView != profileCollectionView {
            return super.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
        }
        
        return CGSize.zero
        
    }
    
}
