//
//  GoldPageViewController.swift
//  pointpow
//
//  Created by thanawat on 4/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit


class GoldPageViewController: BaseViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    let arrayItem_registered_waiting = ["banner","goldprice", "logo"]
    let arrayItem_registered_waiting_edit = ["banner","goldprice", "goldbalance", "logo"]
    let arrayItem_registered = ["banner","goldprice","goldbalance","saving", "logo"]
    let arrayItem_no_registered = ["banner","goldprice","register", "logo"]
    var arrayItem:[String] = []
    var statusMemberGold = ""
    var point_balance = NSNumber(value: 0.00)
    
    var isRegistered  = false {
        didSet{
            if isRegistered {
                self.navigationItem.rightBarButtonItem = self.menuBarButton
                self.revealViewController()?.panGestureRecognizer()?.isEnabled = true
                
                //open menu click
                self.navigationItem.rightBarButtonItem?.action = #selector(SWRevealViewController.rightRevealToggle(_:))
                
                if self.statusMemberGold == "waiting"{
                   self.arrayItem = self.arrayItem_registered_waiting_edit
                
                }else if self.statusMemberGold == "edit"{
                    self.arrayItem = self.arrayItem_registered_waiting_edit
                    
                }else if self.statusMemberGold == "fail"{
                   self.arrayItem = self.arrayItem_registered_waiting_edit
                
                }else if self.statusMemberGold == "approve"{
                    self.arrayItem = self.arrayItem_registered
                }
                
                if self.point_balance.doubleValue <= 0 {
                    self.arrayItem.remove(at: 2)
                }
                
            }else{
                self.navigationItem.rightBarButtonItem = nil
                self.revealViewController()?.panGestureRecognizer()?.isEnabled = false
                
                self.arrayItem = self.arrayItem_no_registered
            }
            self.homeCollectionView.reloadData()
        }
    }
    
    var pointpowTextField:UITextField? {
        didSet{
            self.pointpowTextField?.delegate = self
        }
    }
    var savingUpdateButton:UIButton?
    
    
    var userData:AnyObject?
    var goldPrice:AnyObject?
    var banner:[[String:AnyObject]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (self.revealViewController() != nil) {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.navigationItem.rightBarButtonItem?.target = revealViewController()
            
        }
        
        self.title = NSLocalizedString("string-title-gold-page", comment: "")
        self.setUp()
     
       
        self.handlerEnterSuccess  = {(pin) in
            // "Profile"
            if let profile = self.storyboard?.instantiateViewController(withIdentifier: "NavProfile") as? NavProfile {
                
                self.revealViewController()?.pushFrontViewController(profile, animated: true)
                
            }
        }
    }
   
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getDataMember(){
            self.updateView()
            
        }

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
            if success == 3 {
                loadSuccess?()
                self.refreshControl?.endRefreshing()
            }
        }
        getUserInfo() {
            success += 1
            if success == 3 {
                loadSuccess?()
                self.refreshControl?.endRefreshing()
            }
        }
        getBanner() {
            success += 1
            if success == 3 {
                loadSuccess?()
                self.refreshControl?.endRefreshing()
            }
        }
        
        
        
    }
    
    func getBanner(_ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.banner != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        modelCtrl.getBanner(params: nil , isLoading , succeeded: { (result) in
            
            if let items = result as? [[String:AnyObject]] {
                self.banner = []
                for item  in items {
                    let type = item["type"] as? String ?? ""
                    if type == "luckydraw" {
                        self.banner?.append(item)
                    }
                }
            }
            avaliable?()
            
            
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
        
        self.backgroundImage?.image = nil
    
        self.homeCollectionView.delegate = self
        self.homeCollectionView.dataSource = self
        self.homeCollectionView.showsVerticalScrollIndicator = false
        
        self.addRefreshViewController(self.homeCollectionView)
        
        self.registerNib(self.homeCollectionView, "GoldPriceCell")
        self.registerNib(self.homeCollectionView, "MyGoldCell")
        self.registerNib(self.homeCollectionView, "SavingCell")
        self.registerNib(self.homeCollectionView, "RegisterGoldCell")
        self.registerNib(self.homeCollectionView, "LogoGoldCell")
        self.registerNib(self.homeCollectionView, "PromotionCampainCell")
       
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
            let point_balance = data["goldsaving_member"]?["point_balance"] as? NSNumber ?? 0
            
            
            self.point_balance = point_balance
            self.statusMemberGold = status
            
            
            
            if registerGold.boolValue {
                self.isRegistered = true
            }else{
                self.isRegistered = false
            }
            

            //self.isRegistered = false
            
            self.pointpowTextField?.text = ""
            
            
            
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
        let y =  pointInTable?.y ?? 600
        self.positionYTextField = y + 50
        
    }
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.pointpowTextField {
            let textRange = Range(range, in: textField.text!)!
            let updatedText = textField.text!.replacingCharacters(in: textRange, with: string)

            
            if updatedText.isEmpty {
                return true
            }
            
            if isValidNumber(updatedText) {
                let point = Double(updatedText)!
                if point >= 100 {
                    self.enableButton()
                }else{
                    self.disableButton()
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
        
        if menu == "banner" {
            if let promo = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCampainCell", for: indexPath) as? PromotionCampainCell{
                
                promo.itemBanner = self.banner
                promo.autoSlideImage = true
                promo.luckyDrawCallback = {
                    if self.isRegistered {
                        if self.statusMemberGold == "approve" {
                            if let withdraw = self.storyboard?.instantiateViewController(withIdentifier: "NavLuckyDraw") as? NavLuckyDraw {
                                
                                self.revealViewController()?.pushFrontViewController(withdraw, animated: true)
                            }
                        }
                        
                    }
                   
                }
                
                cell = promo
            }
        }
        if menu == "goldprice" {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "GoldPriceCell", for: indexPath) as? GoldPriceCell{
                cell = item
                
                if let data  = self.goldPrice as? [String:AnyObject] {
                    let buyPrice = data["open_buy_price"] as? NSNumber ?? 0
                    let sellPrice = data["open_sell_price"] as? NSNumber ?? 0
                    
                    let created_at = data["updated_at"] as? String ?? ""
                    
                    item.dateLabel.text  = created_at
                    
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                 
                    item.buyPriceLabel.text  = numberFormatter.string(from: buyPrice)
                    item.sellPriceLabel.text = numberFormatter.string(from: sellPrice)

                }
            }
        }
        if menu == "goldbalance" {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "MyGoldCell", for: indexPath) as? MyGoldCell {
                cell = item
                
                if let data  = self.userData as? [String:AnyObject] {
                    let point_balance = data["goldsaving_member"]?["point_balance"] as? NSNumber ?? 0
                    
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    numberFormatter.minimumFractionDigits = 2
                    item.pointTotalLabel.text = numberFormatter.string(from: point_balance)
            
                    var currentGoldprice = NSNumber(value: 0.0)
                    if let data  = self.goldPrice as? [String:AnyObject] {
                        currentGoldprice = data["open_sell_price"] as? NSNumber ?? 0
                    }
                    let gramToPoint = Double(currentGoldprice.intValue)/15.244
                    
                    
                    let sum = String(format: "%.04f", floor(point_balance.doubleValue/gramToPoint * 10000) / 10000)
                    
                    item.goldExchangeLabel.text = "\(sum)"
                }
            }
        }
        if menu == "saving" {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "SavingCell", for: indexPath) as? SavingCell {
                cell = item
                
                
                item.pointpowTextField.autocorrectionType = .no
                item.pointpowTextField.addDoneButtonToKeyboard()
                
                
                self.pointpowTextField = item.pointpowTextField
                self.savingUpdateButton = item.savingButton
                self.disableButton()
                
                if let data  = self.userData as? [String:AnyObject] {
                    let pointBalance = data["member_point"]?["total"] as? NSNumber ?? 0
                    
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    numberFormatter.minimumFractionDigits = 2
                    
                    item.pointBalanceLabel.text = numberFormatter.string(from: pointBalance )
                }
                
                item.savingCallback = {
                    print("saving")
                 
                    
                    if self.statusMemberGold == "waiting"{
                        self.showMessagePrompt(NSLocalizedString("string-dailog-gold-profile-status-waitting", comment: ""))
                    }else if self.statusMemberGold == "edit"{
                        self.showMessagePrompt(NSLocalizedString("string-dailog-gold-profile-status-waitting", comment: ""))
                    }else if self.statusMemberGold == "fail"{
                        self.showMessagePrompt(NSLocalizedString("string-dailog-gold-profile-status-fail", comment: ""))
                    }else if self.statusMemberGold == "approve"{
                        
                        var modelSaving:(pointBalance:Double?, pointSpend:Double?, goldReceive:Double?, currentGoldprice:Double?) = (pointBalance:nil, pointSpend:nil, goldReceive:nil, currentGoldprice:nil)
                        
                        var pointBalance:NSNumber = NSNumber(value: 0.0)
                        var currentGoldprice:NSNumber = NSNumber(value: 0)
                        let pointSpend:NSNumber = NSNumber(value: Double(self.pointpowTextField?.text! ?? "0")!)
                        //var goldReceive:NSNumber = NSNumber(value: 0.0)
                        
                        
                        
                        if let data  = self.userData as? [String:AnyObject] {
                            pointBalance = data["member_point"]?["total"] as? NSNumber ?? 0
                            
                            modelSaving.pointBalance = pointBalance.doubleValue - pointSpend.doubleValue
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
                            
                            
                            modelSaving.goldReceive = 0
                            modelSaving.pointSpend = pointSpend.doubleValue
                            modelSaving.currentGoldprice  = currentGoldprice.doubleValue
                            
                            if (pointSpend.doubleValue) > (pointBalance.doubleValue) {
                                self.showMessagePrompt(NSLocalizedString("string-dailog-saving-point-not-enough", comment: ""))
                            }else{
                                self.confirmGoldSavingPage(true, modelSaving: modelSaving)
                            }
                        }
                        
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
        
        if section == 0 {
            return CGSize.zero
            
        }
        let menu = self.arrayItem[section]
        if menu == "register" {
            return CGSize(width: collectionView.frame.width, height: 30)
        }
        return CGSize(width: collectionView.frame.width, height: 20)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let menu = self.arrayItem[indexPath.section]
        
        if menu == "banner"{
            let width = collectionView.frame.width
            let height = width/1799*720
            return CGSize(width: width, height: height)
        }
        if menu == "logo" {
            let width = collectionView.frame.width
            return CGSize(width: width, height: CGFloat(60))
        }
        if menu == "register" {
            let height = CGFloat(40.0)
            let width = collectionView.frame.width - 40
            return CGSize(width: width, height: height)
        }
        if menu == "goldprice" {
            let width = collectionView.frame.width - 40
            let height = CGFloat(150) //width/375*260
            return CGSize(width: width, height: height)
        }
        if menu == "goldbalance"{
            let width = collectionView.frame.width - 40
            let height = CGFloat(160) //width/375*250
            return CGSize(width: width, height: height)
        }
        if menu == "saving"{
            let width = collectionView.frame.width - 40
            let height =   CGFloat(270) //width/375*355
            return CGSize(width: width, height: height)
        }
        
        return CGSize.zero
    }

 
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
