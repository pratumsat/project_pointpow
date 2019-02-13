//
//  GoldPageViewController.swift
//  pointpow
//
//  Created by thanawat on 4/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit


class GoldPageViewController: GoldBaseViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    
    let arrayItem_registered = ["goldprice","goldbalance","saving", "logo"]
    let arrayItem_no_registered = ["goldprice","register", "logo"]
    var arrayItem:[String] = []
    var isRegistered  = false {
        didSet{
            if isRegistered {
                self.arrayItem = self.arrayItem_registered
            }else{
                self.arrayItem = self.arrayItem_no_registered
            }
            self.homeCollectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-gold-page", comment: "")
        self.setUp()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getUserInfo(){
            self.updateView()
        }
    }
    func setUp(){
        
        self.backgroundImage?.image = nil
    
        self.homeCollectionView.delegate = self
        self.homeCollectionView.dataSource = self
        
        
        self.addRefreshViewController(self.homeCollectionView)
        
        self.registerNib(self.homeCollectionView, "GoldPriceCell")
        self.registerNib(self.homeCollectionView, "MyGoldCell")
        self.registerNib(self.homeCollectionView, "SavingCell")
        self.registerNib(self.homeCollectionView, "RegisterGoldCell")
        self.registerNib(self.homeCollectionView, "LogoGoldCell")
        
       
    }
    
    override func reloadData() {
        self.getUserInfo(){
            self.updateView()
            
        }
    }
    
    func updateView(){
        if let data  = self.userData as? [String:AnyObject] {
            //let pointBalance = data["member_point"]?["total"] as? String ?? "0.00"
            //let profileImage = data["picture_data"] as? String ?? ""
            let registerGold = data["gold_saving_acc"] as? NSNumber ?? 0
            if registerGold.boolValue {
                self.isRegistered = true
            }else{
                self.isRegistered = false
            }
           
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arrayItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        //let y = textField.frame.origin.y + (textField.superview?.frame.origin.y)!;
        let pointInTable = textField.superview?.convert(textField.frame.origin, to: self.homeCollectionView)
        self.positionYTextField = pointInTable?.y ?? 600
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        let menu = self.arrayItem[indexPath.section]
        if menu == "goldprice" {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "GoldPriceCell", for: indexPath) as? GoldPriceCell{
                cell = item
                
                
            }
        }
        if menu == "goldbalance" {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "MyGoldCell", for: indexPath) as? MyGoldCell {
                cell = item
               
            }
            
        }
        if menu == "saving" {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "SavingCell", for: indexPath) as? SavingCell {
                cell = item
                item.pointpowTextField.autocorrectionType = .no
                item.pointpowTextField.delegate = self
                item.savingCallback = {
                    print("saving")
                    self.confirmGoldSavingPage(true)
                }
               
            }
            
        }
        if menu == "register" {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "RegisterGoldCell", for: indexPath) as? RegisterGoldCell {
                cell = item
                
                item.registerCallback = {
                    self.showRegisterGoldSaving(true , userData: self.userData)
                }
               
            }
        }
        if menu == "logo" {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "LogoGoldCell", for: indexPath) as? LogoGoldCell {
                cell = item
               
            }
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        
        return CGSize(width: collectionView.frame.width, height: 20)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let menu = self.arrayItem[indexPath.section]
        
        let cheight = collectionView.frame.height
        if menu == "logo" {
            if isRegistered {
                let width = collectionView.frame.width
                let height = abs((cheight+(80)) - (((width/375*260))+((width/375*250))+(width/375*355)))
                
                return CGSize(width: width, height: height)
            }else{
                let width = collectionView.frame.width
                let height = abs(cheight - (((width/375*260))+(40+80)))
                
                return CGSize(width: width, height: height)
            }
        }
        if menu == "register" {
            let height = CGFloat(40.0)
            let width = collectionView.frame.width - 40
            return CGSize(width: width, height: height)
        }
        if menu == "goldprice" {
            let width = collectionView.frame.width - 40
            let height = width/375*260
            return CGSize(width: width, height: height)
        }
        if menu == "goldbalance"{
            let width = collectionView.frame.width - 40
            let height = width/375*250
            return CGSize(width: width, height: height)
        }
        if menu == "saving"{
            let width = collectionView.frame.width - 40
            let height = width/375*355
            return CGSize(width: width, height: height)
        }
        
        return CGSize.zero
    }

 
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
