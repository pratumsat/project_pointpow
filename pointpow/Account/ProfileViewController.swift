//
//  ProfileViewController.swift
//  pointpow
//
//  Created by thanawat on 12/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    enum SelectType {
        case MOBILE ,EDITPROFILE
    }
    var select:SelectType = .EDITPROFILE
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-profile", comment: "")
        self.setUp()
    }
    
    
    func setUp(){
        self.hendleSetPasscodeSuccess = { (passcode) in
            print("new passcode= \(passcode)")
            
        }
        self.handlerEnterSuccess = { (pin) in
            switch self.select {
            case .EDITPROFILE:
                self.showPersonalView(true)
                
            case .MOBILE:
                self.showMobilePhoneView(true)
            }
        }

        self.backgroundImage?.image = nil
        
        
        self.profileCollectionView.dataSource = self
        self.profileCollectionView.delegate = self
        self.profileCollectionView.showsVerticalScrollIndicator = false
        
        self.registerNib(self.profileCollectionView, "ItemProfileCell")
        self.registerNib(self.profileCollectionView, "LogoutCell")
        self.registerHeaderNib(self.profileCollectionView, "HeadCell")
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if indexPath.section == 0 {
            if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemProfileCell", for: indexPath) as? ItemProfileCell{
                cell = itemCell
                
                if indexPath.row == 0 {
                    itemCell.nameLabel.text = NSLocalizedString("string-item-profile-change", comment: "")
                    itemCell.trailLabel.text = ""
                }else if indexPath.row == 1{
                    itemCell.nameLabel.text = NSLocalizedString("string-item-profile-change-displayname", comment: "")
                    itemCell.trailLabel.text = "Lazy"
                }else if indexPath.row == 2{
                    itemCell.nameLabel.text = NSLocalizedString("string-item-profile-change-mobile", comment: "")
                    itemCell.trailLabel.text = ""
                }else if indexPath.row == 3{
                    itemCell.nameLabel.text = NSLocalizedString("string-item-profile-change-pwd", comment: "")
                    itemCell.trailLabel.text = ""
                }
                let lineBottom = UIView(frame: CGRect(x: 0, y: itemCell.frame.height - 1 , width: collectionView.frame.width, height: 1 ))
                lineBottom.backgroundColor = Constant.Colors.LINE_PROFILE
                itemCell.addSubview(lineBottom)
            }
        }
        if indexPath.section == 1 {
            if let logOutCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LogoutCell", for: indexPath) as? LogoutCell {
                cell = logOutCell

                logOutCell.logoutLabel.text = NSLocalizedString("string-item-profile-logout", comment: "")
                logOutCell.logoutLabel.textColor = Constant.Colors.PRIMARY_COLOR
                
                let lineBottom = UIView(frame: CGRect(x: 0, y: logOutCell.frame.height - 1 , width: collectionView.frame.width, height: 1 ))
                lineBottom.backgroundColor = Constant.Colors.LINE_PROFILE
                logOutCell.addSubview(lineBottom)
            }
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                //check isPassCode
                //self.showSettingPassCodeModalView()
                
                self.select = .EDITPROFILE
                self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
                
            }else if indexPath.row == 1 {
                self.showDisplayNameView(true)
            
            }else if indexPath.row == 2 {
                
                self.select = .MOBILE
                self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
                
                
            }else if indexPath.row == 3 {
                self.showChangePasswordView(true)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    
        if section == 0 {
            return CGSize.zero
            
        }
       return CGSize(width: collectionView.frame.width, height: CGFloat(20.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeadCell", for: indexPath) as! HeadCell
        
        let lineBottom = UIView(frame: CGRect(x: 0, y: header.frame.height - 1 , width: collectionView.frame.width, height: 1 ))
        lineBottom.backgroundColor = Constant.Colors.LINE_PROFILE
        header.addSubview(lineBottom)
        
        return header
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let height = CGFloat(50)
        return CGSize(width: width, height: height)
    }
    


}
