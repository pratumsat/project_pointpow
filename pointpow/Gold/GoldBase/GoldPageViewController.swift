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
    var statusMemberGold = ""
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
    
    var goldamountLabel:UILabel?
    var pointpowTextField:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-gold-page", comment: "")
        self.setUp()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getDataMember(){
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
        self.getDataMember(){
            self.updateView()
        }
       
        
    }
    
    func updateView(){
        if let data  = self.userData as? [String:AnyObject] {
            //let pointBalance = data["member_point"]?["total"] as? String ?? "0.00"
            //let profileImage = data["picture_data"] as? String ?? ""
            let registerGold = data["gold_saving_acc"] as? NSNumber ?? 0
            let status = data["goldsaving_member"]?["status"] as? String ?? ""
            self.statusMemberGold = status
            if registerGold.boolValue {
                self.isRegistered = true
            }else{
                self.isRegistered = false
            }
            
            self.pointpowTextField?.text = ""
            self.goldamountLabel?.text = "0.0000"
            
            
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.pointpowTextField {
            let textRange = Range(range, in: textField.text!)!
            let updatedText = textField.text!.replacingCharacters(in: textRange, with: string)

            
            if updatedText.isEmpty {
                self.goldamountLabel?.text = "0.0000"
                return true
            }
            if let point = Int(updatedText) {

                if let data  = self.goldPrice as? [String:AnyObject] {
                    
                    let goldprice = data["open_sell_price"] as? NSNumber ?? 0
                    let gramToPoint = Double(goldprice.intValue)/15.244
                    
                    
                    let sum = String(format: "%.04f", Double(point)/gramToPoint)
                    self.goldamountLabel?.text = "\(sum)"
                }
                

            }else{
                return false
            }
            
        }
        
        return true
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        let menu = self.arrayItem[indexPath.section]
        if menu == "goldprice" {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "GoldPriceCell", for: indexPath) as? GoldPriceCell{
                cell = item
                
                if let data  = self.goldPrice as? [String:AnyObject] {
                    let buyPrice = data["open_buy_price"] as? NSNumber ?? 0
                    let sellPrice = data["open_sell_price"] as? NSNumber ?? 0
                    let diff = data["diff"] as? NSNumber ?? 0
                    let created_at = data["updated_at"] as? String ?? ""
                    
                    item.dateLabel.text  = created_at
                    
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                 
                    item.buyPriceLabel.text  = numberFormatter.string(from: buyPrice)
                    item.sellPriceLabel.text = numberFormatter.string(from: sellPrice)
                    item.diffLabel.text = numberFormatter.string(from: NSNumber(value: abs(diff.intValue)))
                    
                    if diff == 0 {
                        item.diffLabel.textColor = UIColor.darkGray
                        item.diffImageView.image = nil
                    }
                    if diff.intValue > 0 {
                        item.diffLabel.textColor = Constant.Colors.GREEN
                        item.diffImageView.image = UIImage(named: "ic-gold-value-more")
                    }
                    if diff.intValue < 0 {
                        item.diffLabel.textColor = Constant.Colors.PRIMARY_COLOR
                        item.diffImageView.image = UIImage(named: "ic-gold-value-less")
                    }
                }
            }
        }
        if menu == "goldbalance" {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "MyGoldCell", for: indexPath) as? MyGoldCell {
                cell = item
               
                if let data  = self.userData as? [String:AnyObject] {
                    let gold_balance = data["goldsaving_member"]?["gold_balance"] as? NSNumber ?? 0
                    
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    numberFormatter.minimumFractionDigits = 4
                   
                    
                    item.goldBalanceLabel.text = numberFormatter.string(from: gold_balance)
                    
                }
            }
            
        }
        if menu == "saving" {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "SavingCell", for: indexPath) as? SavingCell {
                cell = item
                self.pointpowTextField = item.pointpowTextField
                self.goldamountLabel = item.goldamountLabel
                
                item.pointpowTextField.autocorrectionType = .no
                item.pointpowTextField.delegate = self
                
                if let data  = self.userData as? [String:AnyObject] {
                    let pointBalance = data["member_point"]?["total"] as? NSNumber ?? 0
                    
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    numberFormatter.minimumFractionDigits = 2
                    
                    item.pointBalanceLabel.text = numberFormatter.string(from: pointBalance )
                }
                
                item.savingCallback = {
                    print("saving")
                    
                    var modelSaving:(pointBalance:Double?, pointSpend:Double?, goldReceive:Double?, currentGoldprice:Double?) = (pointBalance:nil, pointSpend:nil, goldReceive:nil, currentGoldprice:nil)
                    
                    var pointBalance:NSNumber = NSNumber(value: 0.0)
                    var currentGoldprice:NSNumber = NSNumber(value: 0)
                    var pointSpend:NSNumber = NSNumber(value: 0)
                    var goldReceive:NSNumber = NSNumber(value: 0.0)
                    
                  
                    
                    if let data  = self.userData as? [String:AnyObject] {
                        pointBalance = data["member_point"]?["total"] as? NSNumber ?? 0
                        
                        modelSaving.pointBalance = pointBalance.doubleValue
                    }
                    
                    if let data  = self.goldPrice as? [String:AnyObject] {
                        currentGoldprice = data["open_sell_price"] as? NSNumber ?? 0
                        
                        
                        let ppspend = self.pointpowTextField?.text! ?? ""
                        if ppspend.isEmpty {
                            self.showMessagePrompt(NSLocalizedString("string-dailog-saving-point-pointspend-empty", comment: ""))
                            return
                        }
                        
                        
                        if (Double(ppspend)!) < 100 {
                            self.showMessagePrompt(NSLocalizedString("string-dailog-saving-point-pointspend-min", comment: ""))
                            return
                        }
                        
                        goldReceive = NSNumber(value: Double(self.goldamountLabel?.text ?? "0")!)
                        pointSpend =  NSNumber(value: Double(self.pointpowTextField?.text! ?? "0")!)
                        
                        modelSaving.pointSpend = pointSpend.doubleValue
                        modelSaving.goldReceive = goldReceive.doubleValue
                        modelSaving.currentGoldprice  = currentGoldprice.doubleValue
                        
                        if (pointSpend.doubleValue) > (pointBalance.doubleValue) {
                            self.showMessagePrompt(NSLocalizedString("string-dailog-saving-point-not-enough", comment: ""))
                        }else{
                            self.confirmGoldSavingPage(true, modelSaving: modelSaving)
                        }
                    }
                    
                    
                    
                    
                    if self.statusMemberGold == "waiting"{
                        self.showMessagePrompt(NSLocalizedString("string-dailog-gold-profile-status-waitting", comment: ""))
                    }else if self.statusMemberGold == "fail"{
                        self.showMessagePrompt(NSLocalizedString("string-dailog-gold-profile-status-fail", comment: ""))
                    }else if self.statusMemberGold == "approve"{
                        
                       
                        
                    }
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
