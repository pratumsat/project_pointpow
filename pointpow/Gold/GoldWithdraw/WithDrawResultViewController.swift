//
//  WithDrawResultViewController.swift
//  pointpow
//
//  Created by thanawat on 20/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class WithDrawResultViewController: BaseViewController  , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var resultCollectionView: UICollectionView!
    var withDrawResult:AnyObject?
    
    var slipImageView:UIImageView? {
        didSet{
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
                
                
                slipImageView!.center = snap.center
                slipImageView!.updateLayerCornerRadiusProperties()
                slipImageView!.drawLightningView()
                snap.addSubview(slipImageView!)
                
                
                let logo = UIImageView(image: UIImage(named: "ic-logo"))
                logo.contentMode = .scaleAspectFit
                logo.translatesAutoresizingMaskIntoConstraints = false
                snap.addSubview(logo)
                
                logo.centerXAnchor.constraint(equalTo: snap.centerXAnchor, constant: 0).isActive = true
                logo.widthAnchor.constraint(equalTo: snap.widthAnchor, multiplier: 0.5).isActive = true
                logo.bottomAnchor.constraint(equalTo: slipImageView!.topAnchor, constant: 0).isActive = true
                
                print("add image slip")
                
                self.countDownForSnapShot(1)
            }
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
        snapView = UIView(frame: self.view.frame)
        snapView!.backgroundColor = UIColor.clear
        
        self.view.addSubview(snapView!)
        self.view.sendSubviewToBack(snapView!)
        
        
        //load background image from api
        self.bgSlip = UIImage(named: "bg-slip")
       
        self.title = NSLocalizedString("string-title-gold-page", comment: "")
        let finishButton = UIBarButtonItem(title: NSLocalizedString("string-title-finish-transfer", comment: ""), style: .plain, target: self, action: #selector(dismissTapped))
        finishButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                             NSAttributedString.Key.font :  UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.ITEM_TITLE )!]
            , for: .normal)
        
        self.navigationItem.rightBarButtonItem = finishButton
        
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
        
//        if let slip = self.slipView {
//            slipImageView = UIImageView(image: slip.snapshotImage())
//        }
    }
    
    
    
    func setUp(){
        self.backgroundImage?.image = nil
        self.resultCollectionView.dataSource = self
        self.resultCollectionView.delegate = self
        
        self.registerNib(self.resultCollectionView, "WithDrawResultPointPowCell")
        self.registerNib(self.resultCollectionView, "LogoGoldCell")
        
        
        self.transactionId = (self.navigationController as? WithDrawResultNav)?.transactionId
        
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if indexPath.section == 0 {
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
                    let status = data["status"] as? String ?? ""
                    
                    
                    
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
                 
                    item.qrCodeImageView.image  = base64Convert(base64String: qrbase64)
                    
                    
                    switch status {
                    case "waiting":
                        item.statusImageView.image = UIImage(named: "ic-status-waitting")
                        item.statusLabel.textColor = Constant.Colors.ORANGE
                        item.statusLabel.text = NSLocalizedString("string-dailog-gold-transaction-status-waitting", comment: "")
                        break
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
                   
                }
                item.saveSlipCallback = {
                    self.slipImageView = UIImageView(image: item.mView.snapshotImage())
                    self.showMessagePrompt(NSLocalizedString("string-dialog-saved-slip", comment: ""))
                }
                
                self.slipView =  item.mView
                
                
               
                
                
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
            let height = heightForViewWithDraw(self.rowBar, width: width , height: width/360*700 , rowHeight: 20.0)
            
            return CGSize(width: width, height: height)
        }else{
            let width = collectionView.frame.width
            let cheight = collectionView.frame.height
            let height = abs((cheight) - (((width/360*720))+80))
            
            return CGSize(width: width, height: height)
        }
        
    }

}
