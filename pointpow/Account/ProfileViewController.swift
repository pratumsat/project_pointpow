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
    var userData:AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-profile", comment: "")
        self.setUp()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
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
            
            self.profileCollectionView.reloadData()
            self.refreshControl?.endRefreshing()
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
        self.handlerEnterSuccess = { (pin) in
            if let userData = self.userData as? [String:AnyObject] {
                let registerGold = userData["gold_saving_acc"] as? NSNumber ?? 0
                
                if registerGold.boolValue {
                    self.showGoldProfileView(true, fromAccountPointPow : true )
                }else{
                    self.showPersonalView(true)
                }
            }
            //user
            
        }

        self.backgroundImage?.image = nil
        
        self.addRefreshViewController(self.profileCollectionView)
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
            return 2
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
                    
                    if let userData = self.userData as? [String:AnyObject] {
                        let displayName = userData["display_name"] as? String ?? ""
                        itemCell.trailLabel.text = displayName
                    }
                    
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
                
                let lineTop = UIView(frame: CGRect(x: 0, y: 0 , width: collectionView.frame.width, height: 1 ))
                lineTop.backgroundColor = Constant.Colors.LINE_PROFILE
                logOutCell.addSubview(lineTop)
                
                
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
                self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
            }else if indexPath.row == 1 {
                
                if let userData = self.userData as? [String:AnyObject] {
                    let displayName = userData["display_name"] as? String ?? ""
                
                    self.showDisplayNameView(true, displayName)
                    
                }
                
            }
        }
        if indexPath.section == 1 {
            
            let title = NSLocalizedString("exit-app-title", comment: "")
            let message = NSLocalizedString("exit-app-message", comment: "")
            let confirm = NSLocalizedString("exit-app-confirm-button", comment: "")
            let cancel = NSLocalizedString("exit-app-cancel-button", comment: "")
            let confirmAlertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: confirm, style: .default) { _ in
               
                self.modelCtrl.logOut(succeeded: { (result) in
                    Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.reNewApplication), userInfo: nil, repeats: false)
                }, error: { (error) in
                    if let mError = error as? [String:AnyObject]{
                        let message = mError["message"] as? String ?? ""
                        print(message)
                        self.showMessagePrompt(message)
                    }
                    print(error)
                }) { (messageError) in
                    print("messageError")
                    self.handlerMessageError(messageError)
                }
            }
            let cancelAction = UIAlertAction(title: cancel, style: .default, handler: nil)
            
            
            confirmAlertCtrl.addAction(confirmAction)
            confirmAlertCtrl.addAction(cancelAction)
            
            self.present(confirmAlertCtrl, animated: true, completion: nil)
            
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
        
        
        return header
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let height = CGFloat(50)
        return CGSize(width: width, height: height)
    }
    


}
