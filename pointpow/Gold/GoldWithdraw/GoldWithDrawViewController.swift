//
//  GoldWithDrawViewController.swift
//  pointpow
//
//  Created by thanawat on 4/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class GoldWithDrawViewController: BaseViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var withDrawCollectionView: UICollectionView!
    
    var premiumLabel:UILabel?
    var amountTextField:UITextField? {
        didSet{
            self.amountTextField?.delegate = self    
        }
    }
    var itemReload = false
    var pointBalance:Double = 0.0
    
    //var goldBalanceLabel:UILabel?
    var gold_balance:NSNumber = NSNumber(value: 0.0)
    var point_Balance:NSNumber = NSNumber(value: 0.0)
    var gold_Price:NSNumber = NSNumber(value: 0.0)
    
    var drawCount = 0
    var amountToUnit:(amount:Int, unit:Int , price:Double , goldPrice:Int)?
    var withdrawData:(pointBalance:Double, premium:Int, goldbalance:Double,goldAmountToUnit:(amount:Int, unit:Int , price:Double, goldPrice:Int))?
    
    var sumWeight:Double = 0.00
    
   
    var withDrawCell:WithdrawCell?
    
    var userData:AnyObject?
    var goldPrice:AnyObject?
    
    var savingUpdateButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.revealViewController() != nil) {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.navigationItem.rightBarButtonItem?.target = revealViewController()
            
        }
        
        self.navigationItem.rightBarButtonItem?.action = #selector(SWRevealViewController.rightRevealToggle(_:))
        
        
        self.title  = NSLocalizedString("string-title-gold-page-withdraw", comment: "")
        
        setUp()
     
        getDataMember() {
            self.updateView()
        }
        self.handlerEnterSuccess  = {(pin) in
            // "Profile"
            if let profile = self.storyboard?.instantiateViewController(withIdentifier: "NavProfile") as? NavProfile {
                
                self.revealViewController()?.pushFrontViewController(profile, animated: true)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         NotificationCenter.default.addObserver(self, selector: #selector(messageAlert), name: NSNotification.Name(rawValue: "messageAlert"), object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "messageAlert"), object: nil)
        
    }
    
    @objc func messageAlert(notification: NSNotification){
        if let userInfo = notification.userInfo as? [String:AnyObject]{
            let profile = userInfo["profile"] as? String  ?? ""
            let showTransaction = userInfo["showTransaction"] as? String ?? ""
            
            if !showTransaction.isEmpty {
                if let vc:WithDrawResultNav  = self.storyboard?.instantiateViewController(withIdentifier: "WithDrawResultNav") as? WithDrawResultNav {
                    vc.hideFinishButton = true
                    vc.transactionId = showTransaction
                    
                    self.present(vc, animated: true, completion: nil)
                }
            }
            if !profile.isEmpty{
                self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
            }
           
            
        }
        
    }
    
    func getDataMember(_ loadSuccess:(()->Void)?  = nil){
        var success = 0
        getGoldPrice() {
            success += 1
            if success == 2 {
                loadSuccess?()
            }
        }
        getUserInfo() {
            success += 1
            if success == 2 {
                loadSuccess?()
            }
        }
        
        
        
    }
    func getGoldPrice(_ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.goldPrice != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        modelCtrl.getGoldPrice(params: nil , isLoading , succeeded: { (result) in
            self.goldPrice = result
            avaliable?()
            
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
    
    
    
    
    func updateView(){
        if let data  = self.userData as? [String:AnyObject] {
            let point_balance = data["goldsaving_member"]?["point_balance"] as? NSNumber ?? 0
            self.point_Balance = point_balance
            
            var currentGoldprice = NSNumber(value: 0.0)
            if let gold  = self.goldPrice as? [String:AnyObject] {
                currentGoldprice = gold["open_sell_price"] as? NSNumber ?? 0
                self.gold_Price = currentGoldprice
            }
            let gramToPoint = Double(currentGoldprice.intValue)/15.244
            //let sum = String(format: "%.04f", floor(point_balance.doubleValue/gramToPoint * 10000) / 10000)
            
            self.gold_balance = NSNumber(value:floor(point_balance.doubleValue/gramToPoint * 10000) / 10000)
        }
        self.withDrawCollectionView.reloadData()
    }
    
    func setUp(){
        //self.dummyview = UITextField(frame: CGRect.zero)
        //self.view.addSubview(dummyview!)
        
        
        self.backgroundImage?.image = nil
        self.withDrawCollectionView.delegate = self
        self.withDrawCollectionView.dataSource = self
        self.withDrawCollectionView.showsVerticalScrollIndicator = false
        
        self.registerNib(self.withDrawCollectionView, "WithDrawMyGoldCell")
        self.registerNib(self.withDrawCollectionView, "WithdrawCell")
        self.registerNib(self.withDrawCollectionView, "NextButtonCell")
        self.registerNib(self.withDrawCollectionView, "LogoGoldCell")
    }
    
    @IBAction func bViewTapped(_ sender: Any) {
        if let saving = self.storyboard?.instantiateViewController(withIdentifier: "NavGoldPage") as? NavGoldPage {
            self.revealViewController()?.pushFrontViewController(saving, animated: true)
            
        }
    }
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        //let y = textField.frame.origin.y + (textField.superview?.frame.origin.y)!;
        let pointInTable = textField.superview?.convert(textField.frame.origin, to: self.withDrawCollectionView)
        let y =  pointInTable?.y ?? 600
        self.positionYTextField = y + 50
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
   
        
        if textField == self.amountTextField {
            guard let textRange = Range(range, in: textField.text!) else { return true}
            let updatedText = textField.text!.replacingCharacters(in: textRange, with: string)
            
            
            if updatedText.isEmpty {
                self.withDrawCell?.amountTextField.text = "0"
                self.withDrawCell?.premiumLabel.text = "0"
                
                self.withDrawCell?.withDrawData = (premium : "\(0)" , goldReceive: [])
                //self.goldSpendCallback?(0 , self.selectedUnits)
                
                self.disableButton()
                return true
            }
            
            if  isValidNumber(updatedText) {
                let amount = Double(updatedText)!
                
                if amount >= 1 {
                    self.enableButton()
                }else{
                    self.disableButton()
                }
                
                if self.withDrawCell?.selectedUnits == 0 {
                    if amount > 200 {
                        self.withDrawCell?.amountTextField?.text = "200"
                        self.withDrawCell?.calSalueng("200")
                        return false
                    }else{
                        self.withDrawCell?.calSalueng(updatedText)
                    }
                    
                }else{
                    if amount > 50 {
                        self.withDrawCell?.amountTextField?.text = "50"
                        self.withDrawCell?.calBaht("50")
                        return false
                    }else{
                        self.withDrawCell?.calBaht(updatedText)
                    }
                    
                }
               
            }else{
                return false
            }
            
        }
        
        return true
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
        if indexPath.section == 0 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "WithDrawMyGoldCell", for: indexPath) as? WithDrawMyGoldCell {
                cell = item
                
                
                var numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                item.goldPriceLabel.text = numberFormatter.string(from: self.gold_Price)
                
                numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 4
                
                item.goldBalanceLabel.text = numberFormatter.string(from: self.gold_balance)
                
                numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 2
                
                item.pointTotalLabel.text = numberFormatter.string(from: self.point_Balance)
                
                //self.goldBalanceLabel = item.goldBalanceLabel
            }
            
        } else if indexPath.section == 1 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "WithdrawCell", for: indexPath) as? WithdrawCell {
                cell = item
                
             
                item.amountTextField.autocorrectionType = .no
                item.amountTextField.addDoneButtonToKeyboard()
                
                
                item.withDrawCollectionView = collectionView
                item.gold_balance = self.gold_balance
                
                self.amountTextField = item.amountTextField
                self.premiumLabel = item.premiumLabel
              
                
                item.infoCallback = {
                    self.showInfoGoldPremiumPopup(true)
                }
                item.drawCountCallback = { (count) in
                    self.drawCount = count
                
                    self.itemReload = true
                    self.withDrawCollectionView.performBatchUpdates({
                        collectionView.reloadInputViews()
                    }, completion: { (true) in
                        //item.amountTextField.becomeFirstResponder()
                    })
                }
                
                item.goldSpendCallback = { (amount, unit) in
                    
                    self.amountToUnit = (amount: amount, unit: unit, price: 0.0 , goldPrice: 0)
                    if unit == 0 {
                       //salueng
                        let weightToSalueng = 15.244/4
                        let stg = weightToSalueng*Double(amount)
                        
                        
                        self.sumWeight = self.gold_balance.doubleValue - stg
                        //self.goldBalanceLabel?.text = String(format: "%.04f", sumWeight)
                        
                        if let data  = self.goldPrice as? [String:AnyObject] {
                            
                            let goldprice = data["open_buy_price"] as? NSNumber ?? 0
                            let gramToBaht = Double(goldprice.intValue)/15.244
                            
                            
                            
                            self.amountToUnit?.price = Double(stg)*gramToBaht
                            self.amountToUnit?.goldPrice = goldprice.intValue
                        }
                        
                       
                    }else{
                       //baht
                        let btg = Double(amount)*15.244
                        
                        self.sumWeight = self.gold_balance.doubleValue - btg
                        //self.goldBalanceLabel?.text = String(format: "%.04f", sumWeight)
                        
                        if let data = self.goldPrice as? [String:AnyObject] {
                            
                            let goldprice = data["open_buy_price"] as? NSNumber ?? 0
                            let gramToBaht = Double(goldprice.intValue)/15.244
                            
                            
                           
                            self.amountToUnit?.price = Double(btg)*gramToBaht
                            self.amountToUnit?.goldPrice = goldprice.intValue
                        }
                    }
                }
                   self.withDrawCell = item
                
            }
        } else if indexPath.section == 2 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "NextButtonCell", for: indexPath) as? NextButtonCell {
                cell = item
                
                
                self.savingUpdateButton  = item.nextButton
                
                item.nextCallback = {
                    let amount = self.amountTextField?.text ?? ""
                    let goldbalance = self.sumWeight
                    let premium = Int(self.premiumLabel?.text ?? "") ?? 0
                   
                    
                    if amount.isEmpty {
                            
                        self.showMessagePrompt(NSLocalizedString("string-dailog-saving-gold-amount-empty", comment: ""))
                        
                        
                    }else{
                         
                            if goldbalance < 0 {
                                self.showMessagePrompt(NSLocalizedString("string-dailog-saving-gold-pointspend-not-enogh", comment: ""))
                            }else{
                            
                                if let amountunit = self.amountToUnit {
                                
                                    if let data  = self.userData as? [String:AnyObject] {
                                        let point_balance = data["goldsaving_member"]?["point_balance"] as? NSNumber ?? 0
                                        
                                        self.pointBalance = point_balance.doubleValue - amountunit.price
                                        self.withdrawData = (pointBalance: self.pointBalance, premium: premium, goldbalance: goldbalance,  goldAmountToUnit: amountunit)
                                    }
                                    
                                   
                                    self.chooseShippingPage(true ,withdrawData:  self.withdrawData!)
                                    
                                }
                                
                            
                            }
                            
                            
                        }
                        
                        
                    
                    
                    
                }
                
            }
        } else  {
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
        
        if section == 2  {
            return CGSize(width: collectionView.frame.width, height: 30)
        }
        return CGSize(width: collectionView.frame.width, height: 20)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if indexPath.section == 0 {
            
            let width = collectionView.frame.width - 40
            let height = CGFloat(180)
            return CGSize(width: width, height: height)
        } else if indexPath.section == 1 {
           
            let width = collectionView.frame.width - 40
            var h2 = CGFloat(0)
            if self.drawCount > 0 {
                h2 = heightForViewWithDraw(self.drawCount, width: width , height: 250)
            }else{
                h2 = heightForViewWithDraw(self.drawCount, width: width , height: 130)
            }
            
            return CGSize(width: width, height: h2)
        } else if indexPath.section == 2 {
            
            let width = collectionView.frame.width - 40
            let height = CGFloat(40)
            return CGSize(width: width, height: height)
        } else {
            let width = collectionView.frame.width
            return CGSize(width: width, height: CGFloat(60))
        }
        
    }
    
    func enableButton(){
        if let count = self.savingUpdateButton?.layer.sublayers?.count {
            if count > 1 {
                self.savingUpdateButton?.layer.sublayers?.removeFirst()
            }
        }
        
        
        self.savingUpdateButton?.borderClearProperties(borderWidth: 1)
        self.savingUpdateButton?.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        self.savingUpdateButton?.isEnabled = true
    }
    func disableButton(){
        if let count = self.savingUpdateButton?.layer.sublayers?.count {
            if count > 1 {
                self.savingUpdateButton?.layer.sublayers?.removeFirst()
            }
        }
        self.savingUpdateButton?.borderClearProperties(borderWidth: 1)
        self.savingUpdateButton?.applyGradient(colours: [UIColor.lightGray, UIColor.lightGray])
        
        self.savingUpdateButton?.isEnabled = false
    }
}
