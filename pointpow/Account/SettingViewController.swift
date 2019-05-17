//
//  SettingViewController.swift
//  pointpow
//
//  Created by thanawat on 13/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class SettingViewController: BaseViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate , UIPickerViewDataSource, UIGestureRecognizerDelegate {
    @IBOutlet weak var settingCollectionView: UICollectionView!
    
    var language = [(id:"en" ,lang:"English"),
                    (id:"th",lang:"ไทย")]
    var selectedRow = 0
    var languageId =  "en"
    var textLanguage = "English"
    var pickerView:UIPickerView?
    var dummyview:UITextField?{
        didSet{
            self.dummyview?.delegate = self
        }
    }
    
    var sectionItem = 0
    
    var dataSetting:AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-setting", comment: "")
        self.setUp()
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if DataController.sharedInstance.isLogin() {
            self.getMemberSetting()
        }
    }
    
    override func reloadData() {
        self.getMemberSetting()
    }
    
    func getMemberSetting(_ avaliable:(()->Void)?  = nil){
        modelCtrl.getMemberSetting(params: nil, true, succeeded: { (result) in
            self.dataSetting = result
            
            self.sectionItem = 3
            self.settingCollectionView.reloadData()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func setUp(){
        var i = 0
        for lang  in language {
            if DataController.sharedInstance.getLanguage() == lang.id {
                self.textLanguage = lang.lang
            }
            i += 1
        }
        self.backgroundImage?.image = nil
        
        self.addRefreshViewController(self.settingCollectionView)
        self.settingCollectionView.dataSource = self
        self.settingCollectionView.delegate = self
        self.settingCollectionView.showsVerticalScrollIndicator = false
        
        self.registerNib(self.settingCollectionView, "SwitchCell")
        self.registerNib(self.settingCollectionView, "ItemProfileCell")
        self.registerNib(self.settingCollectionView, "LogoutCell")
        self.registerHeaderNib(self.settingCollectionView, "HeadCell")
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionItem
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return 4
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if indexPath.section == 0 {
            if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemProfileCell", for: indexPath) as? ItemProfileCell{
                cell = itemCell
               
                itemCell.nameLabel.text = NSLocalizedString("string-item-setting-change-language", comment: "")
                itemCell.trailLabel.text = self.textLanguage
                
           
                let lineBottom = UIView(frame: CGRect(x: 0, y: itemCell.frame.height - 1 , width: collectionView.frame.width, height: 1 ))
                lineBottom.backgroundColor = Constant.Colors.LINE_PROFILE
                itemCell.addSubview(lineBottom)
            }
        }
        if indexPath.section == 1 {
            if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwitchCell", for: indexPath) as? SwitchCell {
                cell = itemCell
                
                var sms = false
                var email = false
                var noti = false
                var slip = false
                if let data = self.dataSetting as? [String:AnyObject] {
                    sms = (data["send_sms"] as? NSNumber)?.boolValue ?? false
                    email = (data["send_email"] as? NSNumber)?.boolValue ?? false
                    noti = (data["send_noti"] as? NSNumber)?.boolValue ?? false
                    slip = (data["save_slip"] as? NSNumber)?.boolValue ?? false
                }
                
                if indexPath.row == 0 {
                    itemCell.typeValue = "send_sms"
                    itemCell.nameLabel.text = NSLocalizedString("string-item-setting-sms", comment: "")
                    itemCell.toggleSwitch.isOn = sms
                }else if indexPath.row == 1 {
                    itemCell.typeValue = "send_email"
                    itemCell.nameLabel.text = NSLocalizedString("string-item-setting-email", comment: "")
                    itemCell.toggleSwitch.isOn = email
                }else if indexPath.row == 2 {
                    itemCell.typeValue = "send_noti"
                    itemCell.nameLabel.text = NSLocalizedString("string-item-setting-noti", comment: "")
                    itemCell.toggleSwitch.isOn = noti
                }else if indexPath.row == 3 {
                    itemCell.typeValue = "save_slip"
                    itemCell.nameLabel.text = NSLocalizedString("string-item-setting-receipt", comment: "")
                    itemCell.toggleSwitch.isOn = slip
                }
                itemCell.toggleValueCallback = { (toggleValue, typeValue) in
                   
                    if typeValue == "save_slip"{
                        DataController.sharedInstance.setSaveSlip(toggleValue)
                    }
                    
                    let params:Parameters = [typeValue  : toggleValue]
                    
                    self.modelCtrl.memberSetting(params: params, true, succeeded: { (result) in
                        print(result)
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
                
                
                let lineBottom = UIView(frame: CGRect(x: 0, y: itemCell.frame.height - 1 , width: collectionView.frame.width, height: 1 ))
                lineBottom.backgroundColor = Constant.Colors.LINE_PROFILE
                itemCell.addSubview(lineBottom)
            }
        }

        if indexPath.section == 2 {
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
            self.chooseLanguage()
        }
        if indexPath.section == 2 {
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
    }
    
    
    func chooseLanguage(){
        pickerView = UIPickerView()
        pickerView!.delegate = self
        pickerView!.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickerTapped))
        tap.delegate = self
        pickerView!.addGestureRecognizer(tap)
        
        
        
        dummyview  = UITextField(frame: CGRect.zero)
        dummyview!.returnKeyType = .done
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(selectLanguage))
        
        dummyview!.addDoneButtonToKeyboard(doneButton : done)
        
        self.view.addSubview(dummyview!)
        
        dummyview!.inputView = pickerView
        dummyview!.becomeFirstResponder()
        
        var i = 0
        for lang  in language {
            if DataController.sharedInstance.getLanguage() == lang.id {
                self.languageId = lang.id
                self.textLanguage = lang.lang
                self.selectedRow = i
                pickerView!.selectRow(i, inComponent: 0, animated: true)
                break
            }
            i += 1
        }
        
    }
    @objc func selectLanguage(){
        if DataController.sharedInstance.getLanguage() == self.language[selectedRow].id {
            dummyview?.resignFirstResponder()
            return
        }
        self.confirmSetLanguage(self.language[selectedRow].id)
        
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @objc func pickerTapped(_ tapRecognizer:UITapGestureRecognizer){
        if tapRecognizer.state == .ended {
            let rowHeight = self.pickerView!.rowSize(forComponent: 0).height
            let selectedRowFrame = self.pickerView!.bounds.insetBy(dx: 0, dy: (self.pickerView!.frame.height - rowHeight) / 2)
            let userTappedOnSelectedRow = selectedRowFrame.contains(tapRecognizer.location(in: self.pickerView))
            if userTappedOnSelectedRow {
                let selectedRow = self.pickerView!.selectedRow(inComponent: 0)
                if DataController.sharedInstance.getLanguage() == self.language[selectedRow].id {
                    dummyview?.resignFirstResponder()
                    return
                }
                self.confirmSetLanguage(self.language[selectedRow].id)
             
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.language.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.selectedRow = row
        return "\(self.language[row].lang)"
    }

    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            return CGSize.zero
        }
        if section == 2 {
            return CGSize(width: collectionView.frame.width, height: CGFloat(20.0))
        }
        return CGSize(width: collectionView.frame.width, height: CGFloat(40.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeadCell", for: indexPath) as! HeadCell
        
        if indexPath.section == 1{
            header.nameLabel.text = NSLocalizedString("string-item-header-setting", comment: "")
            
            let lineBottom = UIView(frame: CGRect(x: 0, y: header.frame.height - 1 , width: collectionView.frame.width, height: 1 ))
            lineBottom.backgroundColor = Constant.Colors.LINE_PROFILE
            header.addSubview(lineBottom)
            
        }else{
            header.nameLabel.text = ""
        }
        
        
        
       
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let height = CGFloat(50)
        return CGSize(width: width, height: height)
    }
    
    
    
}
