//
//  OrderResultViewController.swift
//  pointpow
//
//  Created by thanawat on 26/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class OrderResultViewController: BaseViewController  , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    
    var margintop = CGFloat(58)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load background image from api
        self.bgSlip = UIImage(named: "bg-slip")
        
        
        snapView = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 1200))
        snapView!.backgroundColor = UIColor.clear
        
        self.view.addSubview(snapView!)
        self.view.sendSubviewToBack(snapView!)
        
        if !hideFinishButton {
            
            self.title = NSLocalizedString("string-title-shopping-result-success", comment: "")
            let finishButton = UIBarButtonItem(title: NSLocalizedString("string-title-finish-transfer", comment: ""), style: .plain, target: self, action: #selector(dismissTapped))
            finishButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                                 NSAttributedString.Key.font :  UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.ITEM_TITLE )!]
                , for: .normal)
            
            
            self.navigationItem.rightBarButtonItem = finishButton
            self.transactionId = (self.navigationController as? OrderResultNav)?.transactionId
        }
        
        self.title = NSLocalizedString("string-title-shopping-result-1", comment: "")
        self.setUp()
    }
    
    func getDetail(){
        
        self.modelCtrl.detailShoppingHistory(transactionNumber: self.transactionId ?? "" ,true , succeeded: { (result) in
            
            self.transferResult = result
            
            if let data = self.transferResult {
                let pay_by = data["pay_by"] as? NSNumber ?? 0
                if pay_by == 1 {
                    self.margintop = CGFloat(8)
                }else{
                    self.margintop = CGFloat(58)
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
    
    @objc func dismissTapped(){
        self.dismiss(animated: false) {
            (self.navigationController as? OrderResultNav)?.callbackFinish?()
        }
    }
    func setUp(){
        self.backgroundImage?.image = nil
        
        self.resultCollectionView.dataSource = self
        self.resultCollectionView.delegate = self
        self.resultCollectionView.showsVerticalScrollIndicator = false
        
        self.registerNib(self.resultCollectionView, "OrderResultCell")
        self.registerHeaderNib(self.resultCollectionView, "HeadCell")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard (self.transferResult != nil) else { return 0 }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if let orderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderResultCell", for: indexPath) as? OrderResultCell {
            
            if hideFinishButton {
                orderCell.bgsuccessImageView.image = nil
            }
            
            cell = orderCell
            
            if let data = transferResult {
                
                let created_at = data["created_at"] as? String ?? ""
                let transaction_no = data["transaction_no"] as? String ?? ""
                let payment_status = data["payment_status"] as? String ?? ""
                let total_point = data["total_point"] as?  NSNumber ?? 0
                let pay_by = data["pay_by"] as? NSNumber ?? 0
                let pointpow_amount = data["pointpow_amount"] as? NSNumber ?? 0
                let credit_amount = data["credit_amount"] as? NSNumber ?? 0
                
                let shipping_address = data["shipping_address"] as? [String:AnyObject] ?? [:]
                let address = shipping_address["address"] as? String ?? ""
                let email = shipping_address["email"] as? String ?? ""
                let mobile = shipping_address["mobile"] as? String ?? ""
                let name = shipping_address["name"] as? String ?? ""
               
                let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
                var fulladdress = "\(name) \(newMText.chunkFormatted())"
                fulladdress += "\n\(address)"
              
                
                let itemProducts = data["item"] as? [[String:AnyObject]] ?? []
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 2
                
                orderCell.totalLabel.text = numberFormatter.string(from: total_point)
                
                orderCell.pointLabel.text = numberFormatter.string(from: pointpow_amount)
                
                orderCell.cdLabel.text = numberFormatter.string(from: credit_amount)
                
                var sumAmount = 0
                for item in itemProducts {
                    let amount = item["amount"] as? NSNumber ?? 0
                    sumAmount += amount.intValue
                }
                let txtAmount = NSLocalizedString("string-item-shopping-cart-txt-total-amount", comment: "")
                orderCell.totalAmountLabel.text = txtAmount.replace(target: "{{amount}}", withString: "\(sumAmount)")
                orderCell.transection_ref_Label.text = transaction_no
                orderCell.dateLabel.text = created_at
                orderCell.addressLabel.text = fulladdress
                orderCell.marginTopAddress.constant = margintop
                
                if pay_by == 1 {
                    orderCell.hideCreditCardLabel()
                }else{
                    orderCell.showCreditCardLabel()
                }
                
                
                switch payment_status.lowercased() {
                case "success":
                    orderCell.statusImageView.image = UIImage(named: "ic-status-success2")
                    orderCell.statusLabel.textColor = Constant.Colors.GREEN
                    orderCell.statusLabel.text = NSLocalizedString("string-item-transaction-status-success", comment: "")
                    
                    break
                case "pending":
                    orderCell.statusImageView.image = UIImage(named: "ic-status-waitting")
                    orderCell.statusLabel.textColor = Constant.Colors.ORANGE
                    orderCell.statusLabel.text = NSLocalizedString("string-item-transaction-status-waitting", comment: "")
                    
                    break
                case "fail":
                    orderCell.statusImageView.image = UIImage(named: "ic-status-cancel")
                    orderCell.statusLabel.textColor = Constant.Colors.PRIMARY_COLOR
                    orderCell.statusLabel.text = NSLocalizedString("string-item-transaction-status-fail", comment: "")
                    
                    break
                default:
                    break
                }
                
                if !hideFinishButton {
                    self.slipView = orderCell.mView.copyView()
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
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
       
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeadCell", for: indexPath) as! HeadCell
        header.backgroundColor = UIColor.clear
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let width = collectionView.frame.width - 40
        var height = CGFloat(410)
        height += self.margintop
       
        if let data = transferResult {
           
            let shipping_address = data["shipping_address"] as? [String:AnyObject] ?? [:]
            let address = shipping_address["address"] as? String ?? ""
            let email = shipping_address["email"] as? String ?? ""
            let mobile = shipping_address["mobile"] as? String ?? ""
            let name = shipping_address["name"] as? String ?? ""
            
            let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
            var fulladdress = "\(name) \(newMText.chunkFormatted())"
            fulladdress += "\n\(address)"
            
            let heightAddress = heightForView(text: fulladdress, font: UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: 18)!, width: width - 20)
            height += heightAddress
        }
        
        return CGSize(width: width, height: height)
        
    }

}
