//
//  ResultTransferViewController.swift
//  pointpow
//
//  Created by thanawat on 16/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class ResultTransferViewController: BaseViewController  , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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
            
            let logo = UIImageView(image: UIImage(named: "ic-gold-logo-pp"))
            logo.contentMode = .scaleAspectFit
            logo.translatesAutoresizingMaskIntoConstraints = false
            snap.addSubview(logo)
            
            logo.centerXAnchor.constraint(equalTo: snap.centerXAnchor, constant: 0).isActive = true
            logo.widthAnchor.constraint(equalTo: snap.widthAnchor, multiplier: 0.5).isActive = true
            logo.bottomAnchor.constraint(equalTo: slipView!.topAnchor, constant: -20).isActive = true
            
            
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //load background image from api
        self.bgSlip = UIImage(named: "bg-slip")
        
        
        snapView = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 1200))
        snapView!.backgroundColor = UIColor.clear
        
        self.view.addSubview(snapView!)
        self.view.sendSubviewToBack(snapView!)
        
        if !hideFinishButton {
            
            self.title = NSLocalizedString("string-title-point-transfer", comment: "")
            let finishButton = UIBarButtonItem(title: NSLocalizedString("string-title-finish-transfer", comment: ""), style: .plain, target: self, action: #selector(dismissTapped))
            finishButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                                 NSAttributedString.Key.font :  UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.ITEM_TITLE )!]
                , for: .normal)
            
            
            self.navigationItem.rightBarButtonItem = finishButton
            self.transactionId = (self.navigationController as? ResultTransferNav)?.transactionId
        }
        
        self.title = NSLocalizedString("string-title-point-transfer", comment: "")
        self.setUp()
    }
    
    func getDetail(){
        self.modelCtrl.detailTransactionHistory(transactionNumber: self.transactionId ?? "" ,true , succeeded: { (result) in
            self.transferResult = result
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
        self.dismiss(animated: false) {
            (self.navigationController as? ResultTransferNav)?.callbackFinish?()
        }
    }
    func setUp(){
        self.backgroundImage?.image = nil
        
        self.resultCollectionView.dataSource = self
        self.resultCollectionView.delegate = self
        self.resultCollectionView.showsVerticalScrollIndicator = false
        
        self.registerNib(self.resultCollectionView, "ItemListResultCell")
        self.registerNib(self.resultCollectionView, "ItemFavorCell")
        self.registerHeaderNib(self.resultCollectionView, "HeadCell")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard (self.transferResult != nil) else { return 0 }
        
        if !hideFinishButton {
            return 2
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
    
     
        if indexPath.section == 0 {
            if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemListResultCell", for: indexPath) as? ItemListResultCell {
                
                if hideFinishButton {
                    itemCell.bgsuccessImageView.image = nil
                }

                cell = itemCell
         
                if let data = transferResult {
                    let created_at = data["created_at"] as? String ?? ""
                    
                    let transaction_ref_id = data["transaction_ref_id"] as? String ?? ""
                    let statusTransaction = data["status"] as? String ?? ""
                    
                    let point_refill = data["point_refill"] as? [String:AnyObject] ?? [:]
                    let value_in = point_refill["value_in"] as? NSNumber ?? 0
                    let value_out = point_refill["value_out"] as? NSNumber ?? 0
                    let provider = point_refill["provider"] as? [String:AnyObject] ?? [:]
                    let point_name = provider["point_name"] as? String ?? ""
                    
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    numberFormatter.minimumFractionDigits = 2
                    
                    
                    itemCell.fromLabel.text = point_name
                    itemCell.from_pointLabel.text = "\(numberFormatter.string(from: value_in ) ?? "") Point"
                   
                    itemCell.transection_ref_Label.text = transaction_ref_id
                    itemCell.dateLabel.text = created_at
                    
                    
                    
                   
                    itemCell.pointLabel.text = "\(numberFormatter.string(from: value_out ) ?? "") Point Pow"
                    
                    switch statusTransaction.lowercased() {
                    case "success":
                        itemCell.statusImageView.image = UIImage(named: "ic-status-success2")
                        itemCell.statusLabel.textColor = Constant.Colors.GREEN
                        itemCell.statusLabel.text = NSLocalizedString("string-dailog-point-transaction-status-success", comment: "")
                        
                        break
                    case "pending":
                        itemCell.statusImageView.image = UIImage(named: "ic-status-waitting")
                        itemCell.statusLabel.textColor = Constant.Colors.ORANGE
                        itemCell.statusLabel.text = NSLocalizedString("string-dailog-point-transaction-status-waitting", comment: "")
                        
                        break
                    case "fail":
                        itemCell.statusImageView.image = UIImage(named: "ic-status-cancel")
                        itemCell.statusLabel.textColor = Constant.Colors.PRIMARY_COLOR
                        itemCell.statusLabel.text = NSLocalizedString("string-dailog-point-transaction-status-fail", comment: "")
                        
                        break
                    default:
                        break
                    }
                    
                    if !hideFinishButton {
                        self.slipView = itemCell.mView.copyView()
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
                
              
                
              
            }
        }else if indexPath.section == 1 {
            if let favCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemFavorCell", for: indexPath) as? ItemFavorCell {
                
                favCell.favorCallback = {
                    
                    if let mData = self.transferResult as? [String:AnyObject] {
                        let transaction_ref_id = mData["transaction_ref_id"] as? String ?? ""
                        let point = mData["point"] as? NSNumber ?? 0
                        let pointable_type = mData["pointable_type"] as? String ?? ""
                        
                        self.showAddNameFavoritePopup(true, mType: pointable_type,
                                                      transaction_ref_id: transaction_ref_id,
                                                      amount: point.stringValue) {
                                                        
                                                        
                                                        favCell.disableFav = true
                        }
                    }

                }
                cell = favCell
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
            let height = CGFloat(400)
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
