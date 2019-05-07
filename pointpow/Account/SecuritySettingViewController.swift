//
//  SecuritySettingViewController.swift
//  pointpow
//
//  Created by thanawat on 29/4/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class SecuritySettingViewController: BaseViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var userData:AnyObject?
    
    var item:ITEM?
    enum ITEM {
        case CHANGE_PIN, CHANGE_PWD, CHANGE_MOBILE
    }
    let dash = "\u{25CF}\u{25CF}\u{25CF}\u{25CF}\u{25CF}\u{25CF}\u{25CF}\u{25CF}"
    
    @IBOutlet weak var settingCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-security-setting", comment: "")
        self.setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if DataController.sharedInstance.isLogin() {
            self.getUserInfo()
        }
    }
    
    override func reloadData() {
        self.getUserInfo()
    }
    
    func getUserInfo(_ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.userData != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        modelCtrl.getUserData(params: nil , isLoading , succeeded: { (result) in
            self.userData = result
            avaliable?()
            
            self.settingCollectionView.reloadData()
            self.refreshControl?.endRefreshing()
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                //self.showMessagePrompt(message)
            }
            self.refreshControl?.endRefreshing()
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
            self.refreshControl?.endRefreshing()
        }
    }
    
    func setUp(){
        self.handlerEnterSuccess = { (passcode) in
            if let typeForPin = self.item {
                switch typeForPin {
                case .CHANGE_PIN:
                    DataController.sharedInstance.setPasscode(passcode)
                    self.showSettingPassCodeModalView()
                    break
                    
                case .CHANGE_PWD:
                    self.showChangePasswordView(true)
                    break
                    
                case .CHANGE_MOBILE:
                    self.showMobilePhoneView(true)
                    break
                }
            }
        }
        
        
        self.hendleSetPasscodeSuccess = { (passcode, controller) in
            DataController.sharedInstance.setPasscode("")
        
            let message = NSLocalizedString("string-change-pincode-success", comment: "")
            let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: NSLocalizedString("string-button-ok", comment: ""), style: .cancel, handler: { (action) in
                
                controller.dismiss(animated: false, completion: { () in
                    //
                })
            })
            alert.addAction(ok)
            alert.show()
            
        }
        self.handlerDidCancel = {
            DataController.sharedInstance.setPasscode("")
        }
        
        
        self.backgroundImage?.image = nil
        
        self.settingCollectionView.dataSource = self
        self.settingCollectionView.delegate = self
        self.settingCollectionView.showsVerticalScrollIndicator = false
        
        self.addRefreshViewController(self.settingCollectionView)
        
        self.registerHeaderNib(self.settingCollectionView, "HeadCell")
        self.registerNib(self.settingCollectionView, "ItemProfileCell")
        self.registerNib(self.settingCollectionView, "SwitchCell")
        self.registerNib(self.settingCollectionView, "LogoutCell")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        if indexPath.section == 0 {
        
            switch indexPath.row {
            case 0,2,3,4:
                if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemProfileCell", for: indexPath) as? ItemProfileCell{
                    cell = itemCell
                    
                    let limitpoint_perday = "10,000"
                    var mobile = ""
                    if let userData = self.userData as? [String:AnyObject] {
                        mobile = userData["mobile"] as? String ?? ""
                    }
                    
                    if !mobile.isEmpty {
                        mobile = mobile.substring(start: 0, end: 6)
                        mobile += "xxxx"
                    }
                    
                    
                    
                    
                    if indexPath.row == 0{
                        itemCell.nameLabel.text = NSLocalizedString("string-item-profile-change-pin", comment: "")
                        itemCell.trailLabel.text = ""
                    }else if indexPath.row == 2{
                        itemCell.nameLabel.text = NSLocalizedString("string-item-profile-change-point-limit", comment: "")
                        itemCell.trailLabel.text = limitpoint_perday
                    }else if indexPath.row == 3{
                        itemCell.nameLabel.text = NSLocalizedString("string-item-profile-change-mobile", comment: "")
                        let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
                        itemCell.trailLabel.text = newMText.chunkFormatted()
                    }else if indexPath.row == 4{
                        itemCell.nameLabel.text = NSLocalizedString("string-item-profile-change-pwd", comment: "")
                        itemCell.trailLabel.text = dash
                    }
                    
                    
                    let lineBottom = UIView(frame: CGRect(x: 0, y: itemCell.frame.height - 1 , width: collectionView.frame.width, height: 1 ))
                    lineBottom.backgroundColor = Constant.Colors.LINE_PROFILE
                    itemCell.addSubview(lineBottom)
                    
                }
                break;
            case 1:
                
                if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwitchCell", for: indexPath) as? SwitchCell {
                    cell = itemCell
                    
                    itemCell.nameLabel.text = NSLocalizedString("string-item-setting-faceid", comment: "")
                    
                    
                    let lineBottom = UIView(frame: CGRect(x: 0, y: itemCell.frame.height - 1 , width: collectionView.frame.width, height: 1 ))
                    lineBottom.backgroundColor = Constant.Colors.LINE_PROFILE
                    itemCell.addSubview(lineBottom)
                }
                break;
            default:
                break;
            }
            
            
            
        }else{
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
                self.item = .CHANGE_PIN
                self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
            }
            if indexPath.row == 3 {
                self.item = .CHANGE_MOBILE
                self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
            }
            if indexPath.row == 4 {
                self.item = .CHANGE_PWD
                self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
            }
        }
        if indexPath.section == 1 {
            self.modelCtrl.logOut() { (result) in
                Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.reNewApplication), userInfo: nil, repeats: false)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.frame.width, height: CGFloat(20.0))
        }
        return CGSize.zero
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
