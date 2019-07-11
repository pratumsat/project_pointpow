//
//  SavingResultViewController.swift
//  pointpow
//
//  Created by thanawat on 15/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit


class SavingResultViewController: BaseViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var resultCollectionView: UICollectionView!
    var hideFinishButton:Bool = false
    var transactionId:String?{
        didSet{
            print("updateView")
            print("transactionId \(transactionId ?? "no id")")
            self.getDetail()
        }
    }
    var savingResult:AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.title = NSLocalizedString("string-title-gold-page-result", comment: "")
        
        
        if !hideFinishButton {
            let finishButton = UIBarButtonItem(title: NSLocalizedString("string-title-finish-transfer", comment: ""), style: .plain, target: self, action: #selector(dismissTapped))
            finishButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                                 NSAttributedString.Key.font :  UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.ITEM_TITLE )!]
                , for: .normal)
            
            self.navigationItem.rightBarButtonItem = finishButton
             self.transactionId = (self.navigationController as? SavingResultNav)?.transactionId
        }
       
        self.setUp()
    }
    func setUp(){
        self.backgroundImage?.image = nil
        self.resultCollectionView.dataSource = self
        self.resultCollectionView.delegate = self
        self.resultCollectionView.showsVerticalScrollIndicator = false
        
        self.registerNib(self.resultCollectionView, "SavingResultCell")
        self.registerNib(self.resultCollectionView, "LogoGoldCell")
     
        
       
        
    }
    
    func getDetail(){
        
        self.modelCtrl.detailTransactionGold(transactionNumber: self.transactionId ?? "" ,true , succeeded: { (result) in
            self.savingResult = result
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
            (self.navigationController as? SavingResultNav)?.callbackFinish?()
        }
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard (self.savingResult != nil) else { return 0 }
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if indexPath.section == 0 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "SavingResultCell", for: indexPath) as? SavingResultCell {
                cell = item
                
                if hideFinishButton {
                    item.bgSuccessImageView.image = nil
                }
                
                if let data = self.savingResult as? [String:AnyObject]{
                    let transaction_number = data["saving_transaction"]?["transaction_no"] as? String ?? ""
                    let created_at = data["saving_transaction"]?["created_at"] as? String ?? ""
                    let _ = data["saving_transaction"]?["gold_price"] as? NSNumber ?? 0
                    let pointpow_total = data["saving_transaction"]?["pointpow_total"] as? NSNumber ?? 0
                    let _ = data["saving_transaction"]?["gold_received"] as? NSNumber ?? 0
                    
                    item.dateLabel.text = created_at
                    item.transactionNumberLabel.text = transaction_number
                    
                    
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    numberFormatter.minimumFractionDigits = 2
                    item.pointpowLabel.text = numberFormatter.string(from: pointpow_total)
                   
                   
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
            let height =  CGFloat(240) //width/360*330
            return CGSize(width: width, height: height)
        }else{
            let width = collectionView.frame.width
            return CGSize(width: width, height: CGFloat(60))
        }
        
    }

    
    
}
