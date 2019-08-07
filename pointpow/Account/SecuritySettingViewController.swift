//
//  SecuritySettingViewController.swift
//  pointpow
//
//  Created by thanawat on 29/4/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import LocalAuthentication

class SecuritySettingViewController: BaseViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var userData:AnyObject?
    var dataSetting:AnyObject?
    
    var item:ITEM?
    enum ITEM {
        case CHANGE_PIN, CHANGE_PWD, CHANGE_MOBILE , POINT_LIMIT , POINTPOW_ID
    }
    let dash = "\u{25CF}\u{25CF}\u{25CF}\u{25CF}\u{25CF}\u{25CF}\u{25CF}\u{25CF}"
    
    var sectionItem = 0
    var toggleSwitch:UISwitch?
    @IBOutlet weak var settingCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-security-setting", comment: "")
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if DataController.sharedInstance.isLogin() {
            self.getDataUserProfileSetting()
        }
    }
    func getDataUserProfileSetting(){
        var success = 0
        self.getUserInfo() {
            success += 1
            if success == 2 {
                self.sectionItem = 1
                self.settingCollectionView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
        self.getMemberSetting(){
            success += 1
            if success == 2 {
                self.sectionItem = 1
                self.settingCollectionView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
        
        
    }
    
    override func reloadData() {
        self.getDataUserProfileSetting()
    }
    
    func getMemberSetting(_ avaliable:(()->Void)?  = nil){
        modelCtrl.getMemberSetting(params: nil, true, succeeded: { (result) in
            
            self.dataSetting = result
            avaliable?()
            
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                self.showMessagePrompt(message)
            }
            self.refreshControl?.endRefreshing()
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
            self.refreshControl?.endRefreshing()
        }
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
            
           
            
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                self.showMessagePrompt(message)
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
                    if let userData = self.userData as? [String:AnyObject] {
                        let mobile = userData["mobile"] as? String ?? ""
                    
                        self.showMobilePhoneView(true, mobile)
                    }
                    
                    break
                case .POINT_LIMIT:
                    if let data = self.dataSetting as? [String:AnyObject] {
                        let limit_pay = data["limit_pay"] as? NSNumber ?? 0
                        self.showPointLimitView(true, limit_pay.stringValue)
                    }
                    break
                case .POINTPOW_ID:
                    self.showPointPowIDView(true)
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
        //self.registerNib(self.settingCollectionView, "LogoutCell")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionItem
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
            case 0,2,3,4,5:
                if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemProfileCell", for: indexPath) as? ItemProfileCell{
                    cell = itemCell
                    
                    var limitpoint_perday = NSNumber(value: 0)
                    var mobile = ""
                    if let userData = self.userData as? [String:AnyObject] {
                        mobile = userData["mobile"] as? String ?? ""
                    }
                    
                    if let data = self.dataSetting as? [String:AnyObject] {
                        limitpoint_perday = data["limit_pay"] as? NSNumber ?? 0
                    }
                    if !mobile.isEmpty {
                        mobile = mobile.substring(start: 0, end: 6)
                        mobile += "xxxx"
                    }
                    
                    
                    if indexPath.row == 0{
                        itemCell.nameLabel.text = NSLocalizedString("string-item-profile-change-pin", comment: "")
                        itemCell.trailLabel.text = ""
                        itemCell.arrowImageView.isHidden = false
                        itemCell.marginRight.constant = 20.0
                        
                    }else if indexPath.row == 2{
                        
                        itemCell.nameLabel.text = NSLocalizedString("string-title-pointpow-id", comment: "")
                        
                        if let data = self.userData as? [String:AnyObject] {
                            let pointpow_id = data["pointpow_id"] as? String ?? "-"
                            itemCell.trailLabel.text = pointpow_id
                            
                            if pointpow_id == "-" {
                                itemCell.arrowImageView.isHidden = false
                                itemCell.marginRight.constant = 20.0
                            }else{
                                itemCell.arrowImageView.isHidden = true
                                itemCell.marginRight.constant = 0.0
                            }
                            
                        }
                       
                        
                    }else if indexPath.row == 3{
                        itemCell.nameLabel.text = NSLocalizedString("string-item-profile-change-point-limit", comment: "")
                        let numberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = .decimal
                        //numberFormatter.minimumFractionDigits = 2
                        itemCell.trailLabel.text = numberFormatter.string(from: limitpoint_perday)
                        itemCell.arrowImageView.isHidden = false
                        itemCell.marginRight.constant = 20.0
                        
                    }else if indexPath.row == 4{
                        itemCell.nameLabel.text = NSLocalizedString("string-item-profile-change-mobile", comment: "")
                        let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
                        itemCell.trailLabel.text = newMText.chunkFormatted()
                        itemCell.arrowImageView.isHidden = false
                        itemCell.marginRight.constant = 20.0
                        
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

                    let isFaceID = DataController.sharedInstance.getFaceID()
                    itemCell.toggleSwitch.isOn = isFaceID
                    itemCell.typeValue = "face_id"
                    itemCell.toggleSwitch.isUserInteractionEnabled  = false
                    self.toggleSwitch = itemCell.toggleSwitch
                    itemCell.toggleValueCallback = {(toggleValue, typeValue) in



                        let currentType = LAContext().biometricType
                        if currentType == .none  {
                            itemCell.toggleSwitch.isOn = false
                            self.showMessagePrompt2(NSLocalizedString("error-problem-fingerprint-not-support", comment: ""))
                            return
                        }else{
                            itemCell.toggleSwitch.isOn = true
                        }

                        print("\(typeValue) : \(toggleValue)")

                        DataController.sharedInstance.setFaceID(toggleValue)
                    }


                    let lineBottom = UIView(frame: CGRect(x: 0, y: itemCell.frame.height - 1 , width: collectionView.frame.width, height: 1 ))
                    lineBottom.backgroundColor = Constant.Colors.LINE_PROFILE
                    itemCell.addSubview(lineBottom)
                }
                break;
            default:
                break;
            }
            
        }else{
//            if let logOutCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LogoutCell", for: indexPath) as? LogoutCell {
//                cell = logOutCell
//
//                logOutCell.logoutLabel.text = NSLocalizedString("string-item-profile-logout", comment: "")
//                logOutCell.logoutLabel.textColor = Constant.Colors.PRIMARY_COLOR
//
//                let lineTop = UIView(frame: CGRect(x: 0, y: 0 , width: collectionView.frame.width, height: 1 ))
//                lineTop.backgroundColor = Constant.Colors.LINE_PROFILE
//                logOutCell.addSubview(lineTop)
//
//
//                let lineBottom = UIView(frame: CGRect(x: 0, y: logOutCell.frame.height - 1 , width: collectionView.frame.width, height: 1 ))
//                lineBottom.backgroundColor = Constant.Colors.LINE_PROFILE
//                logOutCell.addSubview(lineBottom)
//            }
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
            if indexPath.row == 1 {
                let currentType = LAContext().biometricType
                
                
                if currentType == .none  {
                   
                    self.showMessagePrompt2(NSLocalizedString("error-problem-fingerprint-not-support", comment: ""))
                    return
                }else{
                    let toggleValue = !self.toggleSwitch!.isOn
                    DataController.sharedInstance.setFaceID(toggleValue)
                    
                    self.toggleSwitch?.isOn = toggleValue
                }
                
                //print("\(typeValue) : \(toggleValue)")
                //let toggleValue = !self.toggleSwitch!.isOn
                //DataController.sharedInstance.setFaceID(toggleValue)
            }
            if indexPath.row == 2 {
                //pointpowid
                if let data = self.userData as? [String:AnyObject] {
                    let pointpow_id = data["pointpow_id"] as? String ?? ""
                    
                    if pointpow_id.isEmpty {
//                        self.showPointPowIDView(true)
                        self.item = .POINTPOW_ID
                        self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
                    }
                   
                }
                
            }
            if indexPath.row == 3 {
                self.item = .POINT_LIMIT
                self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
            }
            if indexPath.row == 4 {
                self.item = .CHANGE_MOBILE
                self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
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
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let height = CGFloat(50)
        return CGSize(width: width, height: height)
    }

}
