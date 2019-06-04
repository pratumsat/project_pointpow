//
//  TransactionViewController.swift
//  pointpow
//
//  Created by thanawat on 6/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class TransactionViewController: BaseViewController  ,UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var historyCollectionView: UICollectionView!
    
    var pointHistory:[PointHistory]?
    
    
    var shadowImageView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.backgroundImage?.image = nil
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let filterIcon = UIBarButtonItem(image: UIImage(named: "ic-filter"), style: .plain, target: self, action: #selector(filterTapped))
        self.tabBarController?.navigationItem.rightBarButtonItem = filterIcon
        
        self.tabBarController?.title = NSLocalizedString("string-title-transection", comment: "")
        self.navigationController?.isNavigationBarHidden = false
        
//        if shadowImageView == nil {
//            shadowImageView = findShadowImage(under: navigationController!.navigationBar)
//        }
//        shadowImageView?.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
//        shadowImageView?.isHidden = false
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getDataHistory(clearData: false)
    }
    func setUp(){
        self.backgroundImage?.image = nil
        
        self.historyCollectionView.delegate = self
        self.historyCollectionView.dataSource = self
        
        
        self.historyCollectionView.showsVerticalScrollIndicator = false
        
        self.addRefreshViewController(self.historyCollectionView)
        
        self.registerNib(self.historyCollectionView, "HistoryCell")
        self.registerHeaderNib(self.historyCollectionView, "HeaderCollectionReusableView")
        
        
    }
    @objc func filterTapped() {
      
        self.showTransectionFilter(true)
     
    }
    
    override func reloadData() {
        self.getDataHistory(clearData: false)
    }
    
    
    func getHistory(_ avaliable:(()->Void)?  = nil){
        
        var isLoading:Bool = true
        if self.pointHistory != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        let params:Parameters = ["status" : "all",
                                 "service" : "all"]
        
        modelCtrl.getPointHistory(params: params , isLoading , succeeded: { (result) in
        
            self.pointHistory =  self.getStatementList(result as! [[String : AnyObject]])
//                        if self.cur_id == "" {
//                            self.statement = statement
//                        }else{
//                            if let firstItem = statement.first {
//                                if self.statement?.last?.month == firstItem.month {
//                                    if let items = firstItem.items {
//                                        for each in items {
//                                            self.statement?.last?.items?.append(each)
//                                        }
//                                    }
//                                }else{
//                                    for each in  statement {
//                                        self.statement?.append(each)
//                                    }
//
//                                }
//                            }
//                        }
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
    
    
    
    func getStatementList(_ statements:[[String:AnyObject]]) -> [PointHistory] {
        var statementList = [PointHistory]()
        for item in statements {
            let month = item["month"] as? String ?? ""
            if let items = item["items"] as? [[String:AnyObject]] {
                if items.count > 0 {
                    statementList.append(PointHistory(month: month, items: items))
                }
            }
        }
        return statementList
    }
    
    
    
    func getDataHistory(clearData:Bool = false){
        if clearData {
            ///clear fiter
        }
        
        self.getHistory() {
            //updateview
            guard let count = self.pointHistory?.count, count > 0 else {
                
                let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                var centerpoint = view.center
                centerpoint.y -= self.view.frame.height*0.2
                
                let sorry = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
                sorry.center = centerpoint
                sorry.textAlignment = .center
                sorry.font = UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.CONTENT )
                sorry.text = NSLocalizedString("string-not-found-item-transaction", comment: "")
                sorry.textColor = UIColor.lightGray
                view.addSubview(sorry)
                
                self.historyCollectionView.reloadData()
                self.historyCollectionView.backgroundView = view
                return
            }
            
            self.historyCollectionView.backgroundView  = nil
            self.historyCollectionView.reloadData()
            
            
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.pointHistory?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pointHistory?[section].items?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if let transCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath) as? HistoryCell {
            
            cell = transCell
            
            
            if let items = self.pointHistory?[indexPath.section].items?[indexPath.row] {
                var status = items["status"] as? String ?? ""
                var pointable_type = items["pointable_type"] as? String ?? ""
                var date = items["created_at"] as? String ?? ""
                var mType = items["type"] as? String ?? ""
                var point = items["point"] as? NSNumber ?? 0
                
                /*
                date = "17-05-2562 16:01"
                
                if indexPath.row == 0 {
                    pointable_type = "pointsaving"
                    mType = "out"
                    status = "success"
                    point = NSNumber(value: 800)
                    
                }else if indexPath.row == 1 {
                    pointable_type = "shopping"
                    mType = "out"
                    status = "success"
                    point = NSNumber(value: 1800)
                    
                }else if indexPath.row == 2 {
                    pointable_type = "exchange"
                    mType = "in"
                    status = "success"
                    point = NSNumber(value: 3500)
                    
                }else if indexPath.row == 3 {
                    pointable_type = "pointtransfer"
                    mType = "out"
                    status = "success"
                    point = NSNumber(value: 20)
                    
                }else if indexPath.row == 4 {
                    pointable_type = "exchange"
                    mType = "in"
                    status = "success"
                    point = NSNumber(value: 1500)
                    
                }else if indexPath.row == 5 {
                    pointable_type = "pointtransfer"
                    mType = "in"
                    status = "success"
                    point = NSNumber(value: 200)
                    
                }else if indexPath.row == 6 {
                    pointable_type = "pointtransfer"
                    mType = "out"
                    status = "success"
                    point = NSNumber(value: 20)
                    
                }
                */
                

                transCell.dateLabel.text = date

                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 2
                
                transCell.amountLabel.text = numberFormatter.string(from: point)
                
                if status.lowercased() == "success" {
                    transCell.statusLabel.text = NSLocalizedString("string-status-transection-history-success", comment: "")
                
                }else if status.lowercased() == "pending" {
                    transCell.statusLabel.text = NSLocalizedString("string-status-transection-history-pending", comment: "")
                
                }else{
                    transCell.statusLabel.text = NSLocalizedString("string-status-transection-history-cancel", comment: "")
                }
                
                if mType.lowercased() == "out" {
                    transCell.amountLabel.textColor = Constant.Colors.PRIMARY_COLOR
                }else{
                    transCell.amountLabel.textColor = Constant.Colors.GREEN2
                    
                }
                
                if pointable_type.lowercased() == "pointtransfer" {
                    if mType.lowercased() == "out" {
                        transCell.statusImageView.image = UIImage(named: "ic-service-type-point-transfer-out")
                        transCell.titleLabel.text = NSLocalizedString("string-status-transection-history-service-point-transfer-out", comment: "")
                    }else{
                        transCell.statusImageView.image = UIImage(named: "ic-service-type-point-transfer-in")
                        transCell.titleLabel.text = NSLocalizedString("string-status-transection-history-service-point-transfer-in", comment: "")
                    }
                
                }else if pointable_type.lowercased() == "pointsaving" {
                    transCell.statusImageView.image = UIImage(named: "ic-service-type-point-saving")
                    transCell.titleLabel.text = NSLocalizedString("string-status-transection-history-service-pointsaving", comment: "")
                
                }else if pointable_type.lowercased() == "shopping" {
                    transCell.statusImageView.image = UIImage(named: "ic-service-type-shopping")
                    transCell.titleLabel.text = NSLocalizedString("string-status-transection-history-service-shopping", comment: "")
                
                }else if pointable_type.lowercased() == "exchange" {
                    transCell.statusImageView.image = UIImage(named: "ic-service-type-exchange")
                    transCell.titleLabel.text = NSLocalizedString("string-status-transection-history-service-exchange", comment: "")
                }
            }
            
            let heightOfView = transCell.bounds.height
            transCell.heightConstraint.constant = heightOfView
            
            
            transCell.heightLogoConstraint.constant = heightOfView * 0.5
            
            if let size = self.pointHistory?[indexPath.section].items?.count  {
                if (indexPath.row + 1) == size {
                    transCell.heightConstraint.constant = heightOfView * 0.5
                }else{
                    transCell.heightConstraint.constant = heightOfView
                }
            }
            
            
        }
        
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        return CGSize(width: width  , height: 80)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 30.0)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let size = (self.pointHistory?.count ?? 0) - 1
        if section == size {
            return UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        }
        return UIEdgeInsets.zero
    }
   
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header  = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath) as! HeaderCollectionReusableView
        
        if let month = self.pointHistory?[indexPath.section].month {
            header.headerLabel.text  = month
        }
        header.disableLine = true
        header.backgroundColor = Constant.Colors.COLOR_LLGRAY
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        
        if let item = self.pointHistory?[indexPath.section].items?[indexPath.row] {
            let transaction_ref_id  = item["transaction_ref_id"] as? String ?? ""
            let pointable_type = item["pointable_type"] as? String ?? ""
            let mType = item["type"] as? String ?? ""
            
            
           
            
            if pointable_type.lowercased() == "pointtransfer" {
                let titlePage = getTitleNamgePage(pointable_type, mType)
                self.showPointFriendSummaryTransferView(true, transaction_ref_id, titlePage:titlePage)
            }
            if pointable_type.lowercased() == "pointsaving" {
                self.showGoldSavingResult(true, transactionId: transaction_ref_id)
            }
            if pointable_type.lowercased() == "shopping" {
            }
            if pointable_type.lowercased() == "exchange" {
            }
            
        }
    }
    
    func getTitleNamgePage(_ pointable_type:String, _ mType:String)->String{
        var titlePage = ""
        if pointable_type.lowercased() == "pointtransfer" {
            if mType.lowercased() == "out" {
                titlePage = NSLocalizedString("string-status-transection-history-service-point-transfer-out", comment: "")
            }else{
                titlePage = NSLocalizedString("string-status-transection-history-service-point-transfer-in", comment: "")
            }
            
        }else if pointable_type.lowercased() == "shopping" {
            titlePage = NSLocalizedString("string-status-transection-history-service-shopping", comment: "")
            
            
        }else if pointable_type.lowercased() == "exchange" {
            titlePage = NSLocalizedString("string-status-transection-history-service-exchange", comment: "")
        }
        return titlePage
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

  

}
