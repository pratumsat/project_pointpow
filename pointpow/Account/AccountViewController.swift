//
//  AccountViewController.swift
//  pointpow
//
//  Created by thanawat on 6/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class AccountViewController: BaseViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let sizeArray = 8
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
  
    
    func setUp(){
        self.backgroundImage?.image = nil
        self.profileCollectionView.backgroundColor = UIColor.white
        
        if #available(iOS 11.0, *) {
            self.profileCollectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        self.profileCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.profileCollectionView.dataSource = self
        self.profileCollectionView.delegate = self
        
        self.registerNib(self.profileCollectionView, "ProfileCell")
        self.registerNib(self.profileCollectionView, "ItemServiceCell")
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return sizeArray
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if indexPath.section == 0 {
            if let profileCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as? ProfileCell{
                
                
                cell = profileCell
                
                let lineBottom = UIView(frame: CGRect(x: 0, y: profileCell.frame.height - 0.5 , width: collectionView.frame.width, height: 0.5 ))
                lineBottom.backgroundColor = Constant.Colors.LINE_COLOR
                profileCell.addSubview(lineBottom)
            }
        }
        if indexPath.section == 1 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemServiceCell", for: indexPath) as? ItemServiceCell {
                cell = item
                
                switch indexPath.row {
                case 0:
                    item.itemImageView.image = UIImage(named: "ic-account-history")
                    item.nameLabel.text = NSLocalizedString("string-item-history", comment: "")
                    item.name2Label.text = NSLocalizedString("string-item-history2", comment: "")
                case 1:
                    item.itemImageView.image = UIImage(named: "ic-account-bill")
                    item.nameLabel.text = NSLocalizedString("string-item-bill", comment: "")
                    item.name2Label.text = ""
                case 2:
                    item.itemImageView.image = UIImage(named: "ic-account-ticket")
                    item.nameLabel.text = NSLocalizedString("string-item-ticket", comment: "")
                    item.name2Label.text = ""
                case 3:
                    item.itemImageView.image = UIImage(named: "ic-account-qr")
                    item.nameLabel.text = NSLocalizedString("string-item-qr", comment: "")
                    item.name2Label.text = ""
                case 4:
                    item.itemImageView.image = UIImage(named: "ic-account-profile")
                    item.nameLabel.text = NSLocalizedString("string-item-profile", comment: "")
                    item.name2Label.text = ""
                case 5:
                    item.itemImageView.image = UIImage(named: "ic-account-secue-setting")
                    item.nameLabel.text = NSLocalizedString("string-item-security-setting", comment: "")
                    item.name2Label.text = ""
                case 6:
                    item.itemImageView.image = UIImage(named: "ic-account-setting")
                    item.nameLabel.text = NSLocalizedString("string-item-setting", comment: "")
                    item.name2Label.text = ""
                case 7:
                    item.itemImageView.image = UIImage(named: "ic-account-about")
                    item.nameLabel.text = NSLocalizedString("string-item-about", comment: "")
                    item.name2Label.text = NSLocalizedString("string-item-about2", comment: "")
                default:
                    break
                    
                }
                if  indexPath.row % 3 == 1  {
                    let right = UIView(frame: CGRect(x: item.frame.width - 1, y: 0 ,
                                                     width: 1,
                                                     height: item.frame.height  ))
                    right.backgroundColor = Constant.Colors.LINE_COLOR
                    item.addSubview(right)
                    
                    let left = UIView(frame: CGRect(x: 0, y: 0 ,
                                                    width: 1,
                                                    height: item.frame.height  ))
                    left.backgroundColor = Constant.Colors.LINE_COLOR
                    item.addSubview(left)
                }
                
                
                if indexPath.row ==  sizeArray-1 {
                    if indexPath.row % 3 == 0 {
                        let right = UIView(frame: CGRect(x: item.frame.width - 1, y: 0 ,
                                                         width: 1,
                                                         height: item.frame.height  ))
                        right.backgroundColor = Constant.Colors.LINE_COLOR
                        item.addSubview(right)
                        
                    }
                }
                
                
                let lineBottom = UIView(frame: CGRect(x: 0, y: item.frame.height - 1 , width: collectionView.frame.width, height: 1 ))
                lineBottom.backgroundColor = Constant.Colors.LINE_COLOR
                item.addSubview(lineBottom)
            }
        }

        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1{
            if indexPath.row == 4 {
                self.showProfileView(true)
            }
            if indexPath.row == 6 {
                self.showSettingView(true)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if section == 1 {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        return CGSize.zero
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let width = collectionView.frame.width
            let height = width/370*300
            return CGSize(width: width, height: height)
        }
        
        let width = collectionView.frame.width / 3
        return CGSize(width: width, height: width)
    }


}
