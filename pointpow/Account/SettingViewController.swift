//
//  SettingViewController.swift
//  pointpow
//
//  Created by thanawat on 13/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-setting", comment: "")
        self.setUp()
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
        
        
        self.settingCollectionView.dataSource = self
        self.settingCollectionView.delegate = self
        self.settingCollectionView.showsVerticalScrollIndicator = false
        
        self.registerNib(self.settingCollectionView, "SwitchCell")
        self.registerNib(self.settingCollectionView, "ItemProfileCell")
        self.registerNib(self.settingCollectionView, "LogoutCell")
        self.registerHeaderNib(self.settingCollectionView, "HeadCell")
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
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
                
                
                if indexPath.row == 0 {
                    itemCell.nameLabel.text = NSLocalizedString("string-item-setting-sms", comment: "")
                }else if indexPath.row == 1 {
                    itemCell.nameLabel.text = NSLocalizedString("string-item-setting-email", comment: "")
                }else if indexPath.row == 2 {
                    itemCell.nameLabel.text = NSLocalizedString("string-item-setting-noti", comment: "")
                }else if indexPath.row == 3 {
                    itemCell.nameLabel.text = NSLocalizedString("string-item-setting-receipt", comment: "")
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
        return CGSize(width: collectionView.frame.width, height: CGFloat(40.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeadCell", for: indexPath) as! HeadCell
        
        if indexPath.section == 1 {
            header.nameLabel.text = NSLocalizedString("string-item-header-setting", comment: "")
        }else{
            header.nameLabel.text = ""
        }
        
        
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
