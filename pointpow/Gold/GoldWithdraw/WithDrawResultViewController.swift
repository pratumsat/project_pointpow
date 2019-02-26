//
//  WithDrawResultViewController.swift
//  pointpow
//
//  Created by thanawat on 20/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class WithDrawResultViewController: BaseViewController  , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var resultCollectionView: UICollectionView!
    var withDrawResult:AnyObject?
    var hideFinishButton:Bool = false
    
    
    func  addSlipImageView() {
        
        if let snap = self.snapView {
            let backgroundImage = UIImageView(image: bgSlip)
            backgroundImage.contentMode = .scaleAspectFill
            backgroundImage.clipsToBounds = true
            backgroundImage.translatesAutoresizingMaskIntoConstraints = false
            snap.addSubview(backgroundImage)
            snap.sendSubviewToBack(backgroundImage)
            
            backgroundImage.leftAnchor.constraint(equalTo: snap.leftAnchor).isActive = true
            backgroundImage.rightAnchor.constraint(equalTo: snap.rightAnchor).isActive = true
            backgroundImage.topAnchor.constraint(equalTo: snap.topAnchor).isActive = true
            backgroundImage.bottomAnchor.constraint(equalTo: snap.bottomAnchor).isActive = true
            
            
            slipView!.updateLayerCornerRadiusProperties()
            
            slipView!.translatesAutoresizingMaskIntoConstraints = false
            snap.addSubview(slipView!)
            
            
            slipView!.centerXAnchor.constraint(equalTo: snap.centerXAnchor, constant: 0).isActive = true
            slipView!.centerYAnchor.constraint(equalTo: snap.centerYAnchor, constant: 0).isActive = true
            slipView!.widthAnchor.constraint(equalToConstant: 450).isActive = true
            slipView!.heightAnchor.constraint(equalToConstant: 770).isActive = true
            
            let logo = UIImageView(image: UIImage(named: "ic-logo"))
            logo.contentMode = .scaleAspectFit
            logo.translatesAutoresizingMaskIntoConstraints = false
            snap.addSubview(logo)
            
            logo.centerXAnchor.constraint(equalTo: snap.centerXAnchor, constant: 0).isActive = true
            logo.widthAnchor.constraint(equalTo: snap.widthAnchor, multiplier: 0.5).isActive = true
            logo.bottomAnchor.constraint(equalTo: slipView!.topAnchor, constant: 0).isActive = true
            

            slipView!.drawLightningView(width : CGFloat(450), height: CGFloat(770))
            print("add image slip")
            
            self.countDownForSnapShot(1)
        }
    
    }
    var slipView:UIView?
    var snapView:UIView?
    
    var countDown:Int = 3
    var timer:Timer?
    
    var bgSlip:UIImage?
    
    var rowBar:Int = 0
    
    var transactionId:String?{
        didSet{
            print("updateView")
            print("transactionId \(transactionId)")
            self.getDetail()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //load background image from api
        self.bgSlip = UIImage(named: "bg-slip")
        
        
        snapView = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 1200))
        snapView!.backgroundColor = UIColor.clear
        
        self.view.addSubview(snapView!)
        self.view.sendSubviewToBack(snapView!)
        
        
        self.title = NSLocalizedString("string-title-gold-page-withdraw", comment: "")
        
        if !hideFinishButton {
           
            let finishButton = UIBarButtonItem(title: NSLocalizedString("string-title-finish-transfer", comment: ""), style: .plain, target: self, action: #selector(dismissTapped))
            finishButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                                 NSAttributedString.Key.font :  UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.ITEM_TITLE )!]
                , for: .normal)
            
            self.navigationItem.rightBarButtonItem = finishButton
            self.transactionId = (self.navigationController as? WithDrawResultNav)?.transactionId
        }
        
        self.setUp()
    }
    
    func getDetail(){
        
        self.modelCtrl.detailTransactionGold(transactionNumber: self.transactionId ?? "" ,true , succeeded: { (result) in
            
            if let data = result as? [String:AnyObject]{
                let gold_received = data["withdraw_transaction"]?["gold_received"] as? [[String:AnyObject]] ?? [[:]]
                self.rowBar = gold_received.count
            }
            
            self.withDrawResult = result
            self.resultCollectionView.reloadData()
            
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
    
    
    
    @objc func dismissTapped(){
        self.dismiss(animated: true) {
            (self.navigationController as? WithDrawResultNav)?.callbackFinish?()
        }
    }
    
    func countDownForSnapShot(_ time: Double){
        timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
    }
    @objc func updateCountDown() {
        if let snapImage = self.snapView?.snapshotImage() {
            UIImageWriteToSavedPhotosAlbum(snapImage, nil, nil, nil)
            print("created slip")
            self.removeCountDown()
        }
    }
    func removeCountDown() {
        timer?.invalidate()
        timer = nil
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.slipView != nil {
            self.addSlipImageView()
        }
    }
    
    
    
    func setUp(){
        self.backgroundImage?.image = nil
        self.resultCollectionView.dataSource = self
        self.resultCollectionView.delegate = self
        
        self.registerNib(self.resultCollectionView, "WithDrawResultPointPowCell")
        self.registerNib(self.resultCollectionView, "WidthDrawResultPointPow2Cell")
        self.registerNib(self.resultCollectionView, "WithDrawResultPointPowSuccessCell")
        self.registerNib(self.resultCollectionView, "LogoGoldCell")
        
        
        
        
        
    }
    
    
}


extension WithDrawResultViewController {
    func sectionWithDrawCancelTransactionFromHistory(_ collectionView:UICollectionView, _ indexPath:IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "WithDrawResultPointPowSuccessCell", for: indexPath) as? WithDrawResultPointPowSuccessCell {
            cell = item
            
            if hideFinishButton {
                item.bgSuccessImageView.image = nil
            }
            
            
            if let data = self.withDrawResult as? [String:AnyObject]{
                let created_at = data["created_at"] as? String ?? ""
                let transaction_number = data["withdraw_transaction"]?["transaction_no"] as? String ?? ""
                let gold_unit = data["withdraw_transaction"]?["gold_unit"] as? String ?? ""
                let gold_withdraw = data["withdraw_transaction"]?["gold_withdraw"] as? NSNumber ?? 0
                let gold_received = data["withdraw_transaction"]?["gold_received"] as? [[String:AnyObject]] ??
                    [[:]]
                let premium = data["withdraw_transaction"]?["premium"] as? NSNumber ?? 0
                let statusTransaction = data["status"] as? String ?? ""
                
                let shipping = data["withdraw_transaction"]?["shipping"] as? [String:AnyObject] ?? [:]
                let statusShipping = shipping["status"] as? String ?? ""
                
                
                let unitSalueng = NSLocalizedString("unit-salueng", comment: "")
                let unitBaht = NSLocalizedString("unit-baht", comment: "")
                let unitBar = NSLocalizedString("unit-bar", comment: "")
                print(gold_received)
                
                var txt = ""
                for item in gold_received {
                    let unit = item["unit"] as? String ?? ""
                    let amount = item["amount"] as? NSNumber ?? 0
                    
                    if unit.lowercased() == "1salueng"{
                        txt += "1 \(unitSalueng)"
                    }
                    if unit.lowercased() == "2salueng"{
                        txt += "2 \(unitSalueng)"
                    }
                    if unit.lowercased() == "1baht"{
                        txt += "1 \(unitBaht)"
                    }
                    if unit.lowercased() == "2baht"{
                        txt += "2 \(unitBaht)"
                    }
                    if unit.lowercased() == "5baht"{
                        txt += "5 \(unitBaht)"
                    }
                    if unit.lowercased() == "10baht"{
                        txt += "10 \(unitBaht)"
                    }
                    txt +=  " \(amount) \(unitBar)\n"
                }
                txt = txt.substring(start: 0, end: (txt.count) - "\n".count)
                item.formatGoldReceiveLabel.text = txt
                
                
                if gold_unit.lowercased() == "salueng" {
                    item.withdrawUnitLabel.text = NSLocalizedString("unit-salueng", comment: "")
                }else{
                    item.withdrawUnitLabel.text = NSLocalizedString("unit-baht", comment: "")
                }
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                item.withdrawAmountLabel.text = numberFormatter.string(from: gold_withdraw)
                item.premiumLabel.text = numberFormatter.string(from: premium)
                item.dateLabel.text = created_at
                item.transactionLabel.text = transaction_number
                
                
                
                
                switch statusTransaction.lowercased() {
                case "success":
                    item.statusImageView.image = UIImage(named: "ic-status-success2")
                    item.statusLabel.textColor = Constant.Colors.GREEN
                    item.statusLabel.text = NSLocalizedString("string-dailog-gold-transaction-status-success", comment: "")
                    
                    item.shippingStatusLabel.isHidden = false
                    item.shippingStatusTitleLabel.isHidden = false
                    item.shippingLineView.isHidden = false
                    break
                case "cancel":
                    item.statusImageView.image = UIImage(named: "ic-status-cancel")
                    item.statusLabel.textColor = Constant.Colors.PRIMARY_COLOR
                    item.statusLabel.text = NSLocalizedString("string-dailog-gold-transaction-status-cancel", comment: "")
                    
                    item.shippingStatusLabel.isHidden = true
                    item.shippingStatusTitleLabel.isHidden = true
                    item.shippingLineView.isHidden = true
                    break
                default:
                    break
                }
                
                switch statusShipping {
                case "success":
                    item.shippingStatusLabel.text = NSLocalizedString("string-dailog-gold-shipping-office-status-success", comment: "")
                    break
                case "waiting":
                    item.shippingStatusLabel.text = NSLocalizedString("string-dailog-gold-shipping-office-status-waiting", comment: "")
                    break
                default:
                    break
                }
                
            }
            
        }
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        return cell!
    }
    func sectionWithDrawShipOfficeWaiting(_ collectionView:UICollectionView, _ indexPath:IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "WithDrawResultPointPowCell", for: indexPath) as? WithDrawResultPointPowCell {
            cell = item
            
            if let data = self.withDrawResult as? [String:AnyObject]{
                let created_at = data["created_at"] as? String ?? ""
                let transaction_number = data["withdraw_transaction"]?["transaction_no"] as? String ?? ""
                let qrbase64 = data["withdraw_transaction"]?["qr_code"] as? String ?? ""
                let gold_unit = data["withdraw_transaction"]?["gold_unit"] as? String ?? ""
                let gold_withdraw = data["withdraw_transaction"]?["gold_withdraw"] as? NSNumber ?? 0
                let gold_received = data["withdraw_transaction"]?["gold_received"] as? [[String:AnyObject]] ??
                    [[:]]
                let premium = data["withdraw_transaction"]?["premium"] as? NSNumber ?? 0
                let statusTransaction = data["status"] as? String ?? ""
                
                let shipping = data["withdraw_transaction"]?["shipping"] as? [String:AnyObject] ?? [:]
                let statusShipping = shipping["status"] as? String ?? ""
                
                
                let unitSalueng = NSLocalizedString("unit-salueng", comment: "")
                let unitBaht = NSLocalizedString("unit-baht", comment: "")
                let unitBar = NSLocalizedString("unit-bar", comment: "")
                
                
                var txt = ""
                for item in gold_received {
                    let unit = item["unit"] as? String ?? ""
                    let amount = item["amount"] as? NSNumber ?? 0
                    
                    if unit.lowercased() == "1salueng"{
                        txt += "1 \(unitSalueng)"
                    }
                    if unit.lowercased() == "2salueng"{
                        txt += "2 \(unitSalueng)"
                    }
                    if unit.lowercased() == "1baht"{
                        txt += "1 \(unitBaht)"
                    }
                    if unit.lowercased() == "2baht"{
                        txt += "2 \(unitBaht)"
                    }
                    if unit.lowercased() == "5baht"{
                        txt += "5 \(unitBaht)"
                    }
                    if unit.lowercased() == "10baht"{
                        txt += "10 \(unitBaht)"
                    }
                    txt +=  " \(amount) \(unitBar)\n"
                }
                txt = txt.substring(start: 0, end: (txt.count) - "\n".count)
                item.formatGoldReceiveLabel.text = txt
                
                
                if gold_unit.lowercased() == "salueng" {
                    item.withdrawUnitLabel.text = NSLocalizedString("unit-salueng", comment: "")
                }else{
                    item.withdrawUnitLabel.text = NSLocalizedString("unit-baht", comment: "")
                }
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                item.withdrawAmountLabel.text = numberFormatter.string(from: gold_withdraw)
                item.premiumLabel.text = numberFormatter.string(from: premium)
                item.dateLabel.text = created_at
                item.transactionLabel.text = transaction_number
                
                item.qrCodeImageView.image  = base64Convert(base64String: qrbase64)
                
                
                if validateTransactionTime(created_at) {
                    item.cancelLabel.isHidden = false
                    item.cancelButton.isHidden = false
                }else{
                    item.cancelLabel.isHidden = true
                    item.cancelButton.isHidden = true
                }
                
                switch statusTransaction.lowercased() {
                case "success":
                    item.statusImageView.image = UIImage(named: "ic-status-success2")
                    item.statusLabel.textColor = Constant.Colors.GREEN
                    item.statusLabel.text = NSLocalizedString("string-dailog-gold-transaction-status-success", comment: "")
                    
                    break
                case "cancel":
                    item.statusImageView.image = UIImage(named: "ic-status-cancel")
                    item.statusLabel.textColor = Constant.Colors.PRIMARY_COLOR
                    item.statusLabel.text = NSLocalizedString("string-dailog-gold-transaction-status-cancel", comment: "")
                    
                    
                    break
                default:
                    break
                }
                
                switch statusShipping.lowercased() {
                case "success":
                    item.shippingStatusLabel.text = NSLocalizedString("string-dailog-gold-shipping-office-status-success", comment: "")
                    break
                case "waiting":
                    item.shippingStatusLabel.text = NSLocalizedString("string-dailog-gold-shipping-office-status-waiting", comment: "")
                    break
                default:
                    break
                }
                
            }
            item.viewMapCallback = {
                self.showInfoMapOfficePopup(true){
                    self.showMapFullViewController(true)
                }
            }
            item.saveSlipCallback = {
                if let snapImage = self.snapView?.snapshotImage() {
                    UIImageWriteToSavedPhotosAlbum(snapImage, nil, nil, nil)
                    print("created slip")
                    self.showMessagePrompt(NSLocalizedString("string-dialog-saved-slip", comment: ""))
                }

            }
            
            item.cancelCallback = {
                
                let alert = UIAlertController(title: NSLocalizedString("string-dailog-title-cancel-withdraw", comment: ""),
                                              message: "", preferredStyle: .alert)
                
                let okButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-ok", comment: ""), style: .default, handler: {
                    (alert) in
                    
                    // call cancel api
                    // call cancel api
                    let params:Parameters = ["transaction_ref_id": self.transactionId ?? ""]
                    
                    self.modelCtrl.cancelTransactionGold(params: params, true, succeeded: { (result) in
                        print(result)
                        self.getDetail()
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
                    
                })
                let cancelButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-cancel", comment: ""), style: .default, handler: nil)
                
                
                
                alert.addAction(cancelButton)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            
            self.slipView = item.mView.copyView()
            let allSubView = slipView!.allSubViewsOf(type: UIView.self)

            for itemView  in  allSubView {
                if let itemTag = itemView.viewWithTag(1) {
                    itemTag.isHidden = true
                }
            }
            
            
        }
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        return cell!
    }
    
    
    func sectionWithDrawShipOfficeWaitingFromHistory(_ collectionView:UICollectionView, _ indexPath:IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "WidthDrawResultPointPow2Cell", for: indexPath) as? WidthDrawResultPointPow2Cell {
            cell = item
            
            if hideFinishButton {
                item.bgSuccessImageView.image = nil
            }
            
            
            if let data = self.withDrawResult as? [String:AnyObject]{
                let created_at = data["created_at"] as? String ?? ""
                let transaction_number = data["withdraw_transaction"]?["transaction_no"] as? String ?? ""
                let qrbase64 = data["withdraw_transaction"]?["qr_code"] as? String ?? ""
                let gold_unit = data["withdraw_transaction"]?["gold_unit"] as? String ?? ""
                let gold_withdraw = data["withdraw_transaction"]?["gold_withdraw"] as? NSNumber ?? 0
                let gold_received = data["withdraw_transaction"]?["gold_received"] as? [[String:AnyObject]] ??
                    [[:]]
                let premium = data["withdraw_transaction"]?["premium"] as? NSNumber ?? 0
                let statusTransaction = data["status"] as? String ?? ""
                
                let shipping = data["withdraw_transaction"]?["shipping"] as? [String:AnyObject] ?? [:]
                let statusShipping = shipping["status"] as? String ?? ""
                
                
                let unitSalueng = NSLocalizedString("unit-salueng", comment: "")
                let unitBaht = NSLocalizedString("unit-baht", comment: "")
                let unitBar = NSLocalizedString("unit-bar", comment: "")
                
                
            
                
                if validateTransactionTime(created_at) {
                    item.cancelLabel.isHidden = false
                    item.cancelButton.isHidden = false
                }else{
                    item.cancelLabel.isHidden = true
                    item.cancelButton.isHidden = true
                }
                
                var txt = ""
                for item in gold_received {
                    let unit = item["unit"] as? String ?? ""
                    let amount = item["amount"] as? NSNumber ?? 0
                    
                    if unit.lowercased() == "1salueng"{
                        txt += "1 \(unitSalueng)"
                    }
                    if unit.lowercased() == "2salueng"{
                        txt += "2 \(unitSalueng)"
                    }
                    if unit.lowercased() == "1baht"{
                        txt += "1 \(unitBaht)"
                    }
                    if unit.lowercased() == "2baht"{
                        txt += "2 \(unitBaht)"
                    }
                    if unit.lowercased() == "5baht"{
                        txt += "5 \(unitBaht)"
                    }
                    if unit.lowercased() == "10baht"{
                        txt += "10 \(unitBaht)"
                    }
                    txt +=  " \(amount) \(unitBar)\n"
                }
                txt = txt.substring(start: 0, end: (txt.count) - "\n".count)
                item.formatGoldReceiveLabel.text = txt
                
                
                if gold_unit.lowercased() == "salueng" {
                    item.withdrawUnitLabel.text = NSLocalizedString("unit-salueng", comment: "")
                }else{
                    item.withdrawUnitLabel.text = NSLocalizedString("unit-baht", comment: "")
                }
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                item.withdrawAmountLabel.text = numberFormatter.string(from: gold_withdraw)
                item.premiumLabel.text = numberFormatter.string(from: premium)
                item.dateLabel.text = created_at
                item.transactionLabel.text = transaction_number
                
                item.qrCodeImageView.image  = base64Convert(base64String: qrbase64)
                
                
                switch statusTransaction.lowercased() {
                case "success":
                    item.statusImageView.image = UIImage(named: "ic-status-success2")
                    item.statusLabel.textColor = Constant.Colors.GREEN
                    item.statusLabel.text = NSLocalizedString("string-dailog-gold-transaction-status-success", comment: "")
                    
                    
                    break
                case "cancel":
                    item.statusImageView.image = UIImage(named: "ic-status-cancel")
                    item.statusLabel.textColor = Constant.Colors.PRIMARY_COLOR
                    item.statusLabel.text = NSLocalizedString("string-dailog-gold-transaction-status-cancel", comment: "")
                    
                    break
                default:
                    break
                }
                
                switch statusShipping.lowercased() {
                case "success":
                    item.shippingStatusLabel.text = NSLocalizedString("string-dailog-gold-shipping-office-status-success", comment: "")
                    break
                case "waiting":
                    item.shippingStatusLabel.text = NSLocalizedString("string-dailog-gold-shipping-office-status-waiting", comment: "")
                    break
                default:
                    break
                }
                
            }
            
            item.viewMapCallback = {
                self.showInfoMapOfficePopup(true){
                    self.showMapFullViewController(true)
                    
                }
            }
            item.cancelCallback = {
                
                let alert = UIAlertController(title: NSLocalizedString("string-dailog-title-cancel-withdraw", comment: ""),
                                              message: "", preferredStyle: .alert)
                
                let okButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-ok", comment: ""), style: .default, handler: {
                    (alert) in
                    
                    // call cancel api
                    // call cancel api
                    let params:Parameters = ["transaction_ref_id": self.transactionId ?? ""]
                    
                    self.modelCtrl.cancelTransactionGold(params: params, true, succeeded: { (result) in
                        print(result)
                        self.getDetail()
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
                    
                })
                let cancelButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-cancel", comment: ""), style: .default, handler: nil)
                
                
                
                alert.addAction(cancelButton)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            
            
        
            
            
            
            
        }
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        return cell!
    }
    
    func sectionWithDrawShipOfficeSuccessFromHistory(_ collectionView:UICollectionView, _ indexPath:IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "WithDrawResultPointPowSuccessCell", for: indexPath) as? WithDrawResultPointPowSuccessCell {
            cell = item
            
            if hideFinishButton {
                item.bgSuccessImageView.image = nil
            }
            
            
            if let data = self.withDrawResult as? [String:AnyObject]{
                let created_at = data["created_at"] as? String ?? ""
                let transaction_number = data["withdraw_transaction"]?["transaction_no"] as? String ?? ""
                let gold_unit = data["withdraw_transaction"]?["gold_unit"] as? String ?? ""
                let gold_withdraw = data["withdraw_transaction"]?["gold_withdraw"] as? NSNumber ?? 0
                let gold_received = data["withdraw_transaction"]?["gold_received"] as? [[String:AnyObject]] ??
                    [[:]]
                let premium = data["withdraw_transaction"]?["premium"] as? NSNumber ?? 0
                let statusTransaction = data["status"] as? String ?? ""
                
                let shipping = data["withdraw_transaction"]?["shipping"] as? [String:AnyObject] ?? [:]
                let statusShipping = shipping["status"] as? String ?? ""
                
                
                let unitSalueng = NSLocalizedString("unit-salueng", comment: "")
                let unitBaht = NSLocalizedString("unit-baht", comment: "")
                let unitBar = NSLocalizedString("unit-bar", comment: "")
                print(gold_received)
                
                var txt = ""
                for item in gold_received {
                    let unit = item["unit"] as? String ?? ""
                    let amount = item["amount"] as? NSNumber ?? 0
                    
                    if unit.lowercased() == "1salueng"{
                        txt += "1 \(unitSalueng)"
                    }
                    if unit.lowercased() == "2salueng"{
                        txt += "2 \(unitSalueng)"
                    }
                    if unit.lowercased() == "1baht"{
                        txt += "1 \(unitBaht)"
                    }
                    if unit.lowercased() == "2baht"{
                        txt += "2 \(unitBaht)"
                    }
                    if unit.lowercased() == "5baht"{
                        txt += "5 \(unitBaht)"
                    }
                    if unit.lowercased() == "10baht"{
                        txt += "10 \(unitBaht)"
                    }
                    txt +=  " \(amount) \(unitBar)\n"
                }
                txt = txt.substring(start: 0, end: (txt.count) - "\n".count)
                item.formatGoldReceiveLabel.text = txt
                
                
                if gold_unit.lowercased() == "salueng" {
                    item.withdrawUnitLabel.text = NSLocalizedString("unit-salueng", comment: "")
                }else{
                    item.withdrawUnitLabel.text = NSLocalizedString("unit-baht", comment: "")
                }
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                item.withdrawAmountLabel.text = numberFormatter.string(from: gold_withdraw)
                item.premiumLabel.text = numberFormatter.string(from: premium)
                item.dateLabel.text = created_at
                item.transactionLabel.text = transaction_number
                
               
                
                
                switch statusTransaction.lowercased() {
                case "success":
                    item.statusImageView.image = UIImage(named: "ic-status-success2")
                    item.statusLabel.textColor = Constant.Colors.GREEN
                    item.statusLabel.text = NSLocalizedString("string-dailog-gold-transaction-status-success", comment: "")
                    
                    
                    break
                case "cancel":
                    item.statusImageView.image = UIImage(named: "ic-status-cancel")
                    item.statusLabel.textColor = Constant.Colors.PRIMARY_COLOR
                    item.statusLabel.text = NSLocalizedString("string-dailog-gold-transaction-status-cancel", comment: "")
                    
                    break
                default:
                    break
                }
                
                switch statusShipping.lowercased() {
                case "success":
                    item.shippingStatusLabel.text = NSLocalizedString("string-dailog-gold-shipping-office-status-success", comment: "")
                    break
                case "waiting":
                    item.shippingStatusLabel.text = NSLocalizedString("string-dailog-gold-shipping-office-status-waiting", comment: "")
                    break
                default:
                    break
                }
                
            }
          
            
        }
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        return cell!
    }
    
}











extension WithDrawResultViewController{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if indexPath.section == 0 {
            if let data = self.withDrawResult as? [String:AnyObject]{
                let statusTransaction = data["status"] as? String ?? ""
                let shipping = data["withdraw_transaction"]?["shipping"] as? [String:AnyObject] ?? [:]
                let statusShipping = shipping["status"] as? String ?? ""
                let type = shipping["type"] as? String ?? ""
                
                
                switch type.lowercased() {
                case "office" :
                    if statusShipping == "waiting" {
                        if statusTransaction.lowercased() == "cancel" {
                            cell = sectionWithDrawCancelTransactionFromHistory(collectionView, indexPath)
                        }else{
                            if self.hideFinishButton {
                                cell = sectionWithDrawShipOfficeWaitingFromHistory(collectionView, indexPath)
                            }else{
                                cell = sectionWithDrawShipOfficeWaiting(collectionView, indexPath)
                            }
                        }
                        
                    }else{
                        //success
                        if self.hideFinishButton {
                            cell = sectionWithDrawShipOfficeSuccessFromHistory(collectionView, indexPath)
                        }
                    }
                    break
                case "thaipost" : break
                default:
                    break
                }
                
                
            }
            
        }else{
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
            return CGSize(width: collectionView.frame.width, height: 30)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let width = collectionView.frame.width - 40
            var height = heightForViewWithDraw(self.rowBar, width: width , height: width/360*800 , rowHeight: 20.0)
            
            if let data = self.withDrawResult as? [String:AnyObject]{
                let statusTransaction = data["status"] as? String ?? ""
                let shipping = data["withdraw_transaction"]?["shipping"] as? [String:AnyObject] ?? [:]
                let statusShipping = shipping["status"] as? String ?? ""
                let type = shipping["type"] as? String ?? ""
                
                
                switch type.lowercased() {
                case "office" :
                    if statusShipping == "waiting" {
                        if statusTransaction.lowercased() == "cancel" {
                            height = heightForViewWithDraw(self.rowBar, width: width , height: width/360*420 , rowHeight: 20.0)

                        }else{
                            height = heightForViewWithDraw(self.rowBar, width: width , height: width/360*800 , rowHeight: 20.0)
                        }
                        
                    }else{
                        //success
                        height = heightForViewWithDraw(self.rowBar, width: width , height: width/360*450 , rowHeight: 20.0)
                    }
                    break
                case "thaipost" : break
                    
                default:
                    break
                }
                
                
            }
            
            
            
            return CGSize(width: width, height: height)
        }else{
            let width = collectionView.frame.width
            let cheight = collectionView.frame.height
            var height = heightForViewWithDraw(self.rowBar, width: width , height: width/360*800 , rowHeight: 20.0)
            
            if let data = self.withDrawResult as? [String:AnyObject]{
                let statusTransaction = data["status"] as? String ?? ""
                let shipping = data["withdraw_transaction"]?["shipping"] as? [String:AnyObject] ?? [:]
                let statusShipping = shipping["status"] as? String ?? ""
                let type = shipping["type"] as? String ?? ""
                
                
                switch type.lowercased() {
                case "office" :
                    if statusShipping == "waiting" {
                        if statusTransaction.lowercased() == "cancel" {
                            
                            height = heightForViewWithDraw(self.rowBar, width: width , height: width/360*420 , rowHeight: 20.0)
                        
                        }else{
                            height = heightForViewWithDraw(self.rowBar, width: width , height: width/360*800 , rowHeight: 20.0)
                            
                        }
                        
                    }else{
                        //success
                        height = heightForViewWithDraw(self.rowBar, width: width , height: width/360*450 , rowHeight: 20.0)
                    }
                    break
                case "thaipost" : break
                    
                default:
                    break
                }
                
                
            }
            if height > cheight {
                let vheight = CGFloat(80)
                return CGSize(width: width, height: vheight)
            }else{
                let vheight = abs((cheight) - (((height))+40))
                return CGSize(width: width, height: vheight)
            }
            
            
            
        }
        
    }
}
