//
//  PointFriendSummaryViewController.swift
//  pointpow
//
//  Created by thanawat on 19/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class PointFriendSummaryViewController: BaseViewController  , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
   
    var addSlipSuccess = false
    
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
            
            self.addSlipSuccess =  true
            self.countDownForSnapShot(1)
        }
        
    }
    
    func countDownForSnapShot(_ time: Double){
        timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: false)
    }
    
    @objc func updateCountDown() {
        guard DataController.sharedInstance.getSaveSlip() else { return }
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
    
    var slipView:UIView?
    var snapView:UIView?
    
    var countDown:Int = 3
    var timer:Timer?
    
    var bgSlip:UIImage?
    
    var hideFinishButton:Bool = false
    var transactionId:String?{
        didSet{
            print("updateView")
            print("transactionId \(transactionId ?? "no id")")
            self.getDetail()
        }
    }
    var transferResult:AnyObject?
    var titlePage:String?
    var heightSectionStatusCell = CGFloat(470)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load background image from api
        self.bgSlip = UIImage(named: "bg-slip")
        
        
        snapView = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 1200))
        snapView!.backgroundColor = UIColor.clear
        
        self.view.addSubview(snapView!)
        self.view.sendSubviewToBack(snapView!)
        
        
        
        if !hideFinishButton {
            self.title = NSLocalizedString("string-title-freind-transfer", comment: "")
            let finishButton = UIBarButtonItem(title: NSLocalizedString("string-title-finish-transfer", comment: ""), style: .plain, target: self, action: #selector(dismissTapped))
            finishButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                                 NSAttributedString.Key.font :  UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.ITEM_TITLE )!]
                , for: .normal)
            
            self.navigationItem.rightBarButtonItem = finishButton
            self.transactionId = (self.navigationController as? PointFreindSummaryNav)?.transactionId
            self.titlePage = (self.navigationController as? PointFreindSummaryNav)?.titlePage
        }
        
        self.title = self.titlePage
        self.setUp()
    }
    
    
    func getDetail(){
        self.modelCtrl.detailTransactionHistory(transactionNumber: self.transactionId ?? "" ,true , succeeded: { (result) in
            
            self.transferResult = result
            
            if let mData = self.transferResult as? [String:AnyObject] {
                let pointable_type = mData["pointable_type"] as? String ?? ""
                let mType = mData["type"] as? String ?? ""
                
                if pointable_type.lowercased() == "pointtransfer" {
                    if mType.lowercased() == "out" {
                        self.heightSectionStatusCell = CGFloat(470)
                    }else{
                        self.heightSectionStatusCell = CGFloat(390)
                    }
                    
                }
            }
            
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
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
     
    }
    @objc func dismissTapped(){
        self.dismiss(animated: false) {
            (self.navigationController as? PointFreindSummaryNav)?.callbackFinish?()
        }
        
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        self.resultCollectionView.dataSource = self
        self.resultCollectionView.delegate = self
        self.resultCollectionView.showsVerticalScrollIndicator = false
        self.registerNib(self.resultCollectionView, "ItemFriendSummaryCell")
        self.registerNib(self.resultCollectionView, "ItemConfirmSummaryCell")
        self.registerHeaderNib(self.resultCollectionView, "HeadCell")
    
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if !hideFinishButton {
            return 2
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return 1
    }
    func nameDisplay(_ model:[String:AnyObject]) ->String {
        let last_name = model["last_name"] as? String ?? ""
        let first_name = model["first_name"] as? String ?? ""
        
        
        let fullname = "\(( (first_name.isEmpty) ? "" : first_name)) \(( (last_name.isEmpty) ? "" : last_name))"
        
        
        if fullname.trimmingCharacters(in: .whitespaces).isEmpty {
            return "-"
        }else{
            return fullname
        }
    }
    func mobileDisplay(_ model:[String:AnyObject]) ->String {
        var mobile = model["mobile"] as? String ?? ""
   
        mobile = mobile.substring(start: 0, end: 7)
        mobile += "xxx"
        let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
        return newMText.chunkFormatted()
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if indexPath.section == 0 {
            if let statusCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemFriendSummaryCell", for: indexPath) as? ItemFriendSummaryCell {
               
                if hideFinishButton {
                    statusCell.bgSuccessImageView.image = nil
                }
                
                if let mData = self.transferResult as? [String:AnyObject] {
                    let statusTransaction = mData["status"] as? String ?? ""
                    let pointable_type = mData["pointable_type"] as? String ?? ""
                    let mType = mData["type"] as? String ?? ""
                    let created_at = mData["created_at"] as? String ?? ""
                    let transaction_ref_id = mData["transaction_ref_id"] as? String ?? ""
                    let point = mData["point"] as? NSNumber ?? 0
                    let note = mData["note"] as? String ?? ""
                    
                    let point_transfer = mData["point_transfer"] as? [String:AnyObject] ?? [:]
                    let sender = point_transfer["sender"] as? [String:AnyObject] ?? [:]
                    let receiver = point_transfer["receiver"] as? [String:AnyObject] ?? [:]
                    
                    statusCell.senderLabel.text = nameDisplay(sender)
                    statusCell.receiverLabel.text = nameDisplay(receiver)
                 
                   
                    statusCell.mobileSenderLabel.text = mobileDisplay(sender)
                    statusCell.mobileReceiverLabel.text = mobileDisplay(receiver)
                    
                    
                    statusCell.noteLabel.text = note
                    
                    
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    
                   
                    statusCell.amountLabel.text = "\(numberFormatter.string(from: point ) ?? "") Point Pow"
                    statusCell.dateLabel.text = created_at
                    statusCell.transectionLabel.text = transaction_ref_id
                    
                    if pointable_type.lowercased() == "pointtransfer" {
                        if mType.lowercased() == "out" {
                            statusCell.serviceLabel.text =  NSLocalizedString("string-status-transection-history-service-point-transfer-out", comment: "")
                            
                            statusCell.titleNoteLabel.isHidden = false
                            statusCell.noteLabel.isHidden = false
                            statusCell.notelineView.isHidden = false
                            
                        }else{
                            statusCell.serviceLabel.text = NSLocalizedString("string-status-transection-history-service-point-transfer-in", comment: "")
                            
                            statusCell.titleNoteLabel.isHidden = true
                            statusCell.noteLabel.isHidden = true
                            statusCell.notelineView.isHidden = true
                        }
                        
                    }else if pointable_type.lowercased() == "shopping" {
                        statusCell.serviceLabel.text =  NSLocalizedString("string-status-transection-history-service-shopping", comment: "")
                        
                        
                    }else if pointable_type.lowercased() == "exchange" {
                        statusCell.serviceLabel.text = NSLocalizedString("string-status-transection-history-service-exchange", comment: "")
                    }
                    
                    
                    switch statusTransaction.lowercased() {
                    case "success":
                        statusCell.statusImageView.image = UIImage(named: "ic-status-success2")
                        statusCell.statusLabel.textColor = Constant.Colors.GREEN
                        statusCell.statusLabel.text = NSLocalizedString("string-dailog-point-transaction-status-success", comment: "")
                        
                        break
                    case "pending":
                        statusCell.statusImageView.image = UIImage(named: "ic-status-waitting")
                        statusCell.statusLabel.textColor = Constant.Colors.ORANGE
                        statusCell.statusLabel.text = NSLocalizedString("string-dailog-point-transaction-status-success", comment: "")
                        
                        break
                    case "fail":
                        statusCell.statusImageView.image = UIImage(named: "ic-status-cancel")
                        statusCell.statusLabel.textColor = Constant.Colors.PRIMARY_COLOR
                        statusCell.statusLabel.text = NSLocalizedString("string-dailog-point-transaction-status-success", comment: "")
                        
                        break
                    case "cancel":
                        //statusCell.statusImageView.image = UIImage(named: "ic-status-cancel")
                        //statusCell.statusLabel.textColor = Constant.Colors.PRIMARY_COLOR
                        //statusCell.statusLabel.text = NSLocalizedString("string-dailog-point-transaction-status-cancel", comment: "")
                        
                        break
                    default:
                        break
                    }
                    
                    
                    if !hideFinishButton {
                        self.slipView = statusCell.mView.copyView()
                        let allSubView = slipView!.allSubViewsOf(type: UIView.self)
                        
                        for itemView  in  allSubView {
                            if let itemTag = itemView.viewWithTag(1) {
                                itemTag.isHidden = true
                            }
                        }
                        if !self.addSlipSuccess {
                            self.addSlipImageView()
                        }
                    }
                }
                
             
               
                cell = statusCell
                
               
                
                
            }
        } else if indexPath.section == 1 {
            if let confirmCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemConfirmSummaryCell", for: indexPath) as? ItemConfirmSummaryCell {
                
                confirmCell.shareCallback = {
                    if let snapImage = self.snapView?.snapshotImage() {
                        let imageShare = [ snapImage ]
                        let activityViewController = UIActivityViewController(activityItems: imageShare, applicationActivities: nil)
                        activityViewController.popoverPresentationController?.sourceView = self.view
                        self.present(activityViewController, animated: true, completion: nil)
                    }
                }
                confirmCell.favorCallback = {
                    //add favorit

                    
                    
                    if let mData = self.transferResult as? [String:AnyObject] {
                        let transaction_ref_id = mData["transaction_ref_id"] as? String ?? ""
                        let point = mData["point"] as? NSNumber ?? 0
                        let pointable_type = mData["pointable_type"] as? String ?? ""

                        self.showAddNameFavoritePopup(true, mType: pointable_type,
                                                      transaction_ref_id: transaction_ref_id,
                                                      amount: point.stringValue) {

                                                        
                                                        confirmCell.disableFav = true
                        }
                    }
                    
                }
                
                cell = confirmCell
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
        if section == 1 {
            return CGSize(width: collectionView.frame.width, height: 20)
        }
       
        
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if !hideFinishButton {
            if section == 1 {
                return CGSize(width: collectionView.frame.width, height: 30)
            }
        }else{
            return CGSize(width: collectionView.frame.width, height: 30)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeadCell", for: indexPath) as! HeadCell
        header.backgroundColor = UIColor.clear
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let width = collectionView.frame.width - 40
            let height = self.heightSectionStatusCell
            //CGFloat(420)
            return CGSize(width: width, height: height)
            
        }else if indexPath.section == 1 {
            
            let width = collectionView.frame.width - 40
            let height = CGFloat(40)
            return CGSize(width: width, height: height)
            
        }else{
            let width = collectionView.frame.width
            let height = CGFloat(60)
            return CGSize(width: width, height: height)
        }
      
    }
}
