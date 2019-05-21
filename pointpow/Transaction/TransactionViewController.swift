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
    
    var filter:String = ""
    
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
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
    }
    func setUp(){
        self.backgroundImage?.image = nil
        
        self.historyCollectionView.delegate = self
        self.historyCollectionView.dataSource = self
        
        
        self.historyCollectionView.showsVerticalScrollIndicator = false
        
        self.addRefreshViewController(self.historyCollectionView)
        
        self.registerNib(self.historyCollectionView, "HistoryCell")
        self.registerHeaderNib(self.historyCollectionView, "HeaderCollectionReusableView")
        
        //loaddata
        self.getDataHistory(clearData: true)
        
    }
    @objc func filterTapped() {
      
        self.showTransectionFilter(true) { (filter) in
            self.filter = filter
            //self.getDataHistory(clearData: false)
        }
     
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
        
        var parameter = "filter=\(self.filter)"
        
        //modelCtrl.getPointHistory(params: nil , parameter: parameter , isLoading , succeeded: { (result) in
        //
        //    self.pointHistory =  self.getStatementList(result as! [[String : AnyObject]])
            //            if self.cur_id == "" {
            //                self.statement = statement
            //            }else{
            //                if let firstItem = statement.first {
            //                    if self.statement?.last?.month == firstItem.month {
            //                        if let items = firstItem.items {
            //                            for each in items {
            //                                self.statement?.last?.items?.append(each)
            //                            }
            //                        }
            //                    }else{
            //                        for each in  statement {
            //                            self.statement?.append(each)
            //                        }
            //
            //                    }
            //                }
            //            }
//            avaliable?()
//
//            self.refreshControl?.endRefreshing()
//        }, error: { (error) in
//            if let mError = error as? [String:AnyObject]{
//                let message = mError["message"] as? String ?? ""
//                print(message)
//                self.showMessagePrompt(message)
//            }
//            self.refreshControl?.endRefreshing()
//            print(error)
//        }) { (messageError) in
//            print("messageError")
//            self.handlerMessageError(messageError)
//            self.refreshControl?.endRefreshing()
//        }
    }
    
    
    
    private func getStatementList(_ statements:[[String:AnyObject]]) -> [PointHistory] {
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
            self.filter = ""
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
            
            
//            if let items = self.pointHistory?[indexPath.section].items?[indexPath.row] {
//                let status = items["status"] as? String ?? ""
//                let type = items["type"] as? String ?? ""
//                let date = items["updated_at"] as? String ?? ""
//
//                transCell.dateLabel.text = date
//
//                var numberFormatter = NumberFormatter()
//                numberFormatter.numberStyle = .decimal
//                numberFormatter.minimumFractionDigits = 2
//            }
            
            let heightOfView = transCell.bounds.height
            transCell.heightConstraint.constant = heightOfView
            
            
            transCell.heightLogoConstraint.constant = heightOfView * 0.25
            
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
        return CGSize(width: width  , height: width / 300 * 80)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 30.0)
        
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
            let type = item["type"] as? String ?? ""
            
            if type == "saving" {
                
            }else{
                
            }
            
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    func mockaaw21Data(){
        var id = "1"
        var image_url = ""
        var type = "transfer"
        var transfer_from = "KTC"
        var title = "โอนพ้อยมา Point Pow"
        var detail = ""
        var ref_id = "120101010"
        var amount = "3000"
        var gold_unit = ""
        var gold_amount = ""
        var date = "13-05-2562 11:22"
        
        var newNotiModel = NotificationStruct(id: id,
                                              image_url: image_url,
                                              title: title,
                                              detail: detail,
                                              type: type ,
                                              ref_id: ref_id,
                                              amount:amount,
                                              date:date,
                                              transfer_from:transfer_from,
                                              gold_unit:gold_unit,
                                              gold_amount:gold_amount)
        
        DataController.sharedInstance.saveNotifiacationArrayOfObjectData(newNoti: newNotiModel)
        
        id = "2"
        image_url = "http://www.eunittrust.com.my/Scripts/js/images/index/web-banner-New-web-promo.jpg"
        type = "adverties"
        transfer_from = ""
        title = "Point Pow ช่วยจ่ายเพิ่ม 70%"
        detail = "Point Pow ช่วยจ่ายเพิ่ม 70% Point Pow ช่วยจ่ายเพิ่ม 70%"
        ref_id = "2222233322"
        amount = ""
        gold_unit = ""
        gold_amount = ""
        date = "14-05-2562 14:22"
        
        newNotiModel = NotificationStruct(id: id,
                                          image_url: image_url,
                                          title: title,
                                          detail: detail,
                                          type: type ,
                                          ref_id: ref_id,
                                          amount:amount,
                                          date:date,
                                          transfer_from:transfer_from,
                                          gold_unit:gold_unit,
                                          gold_amount:gold_amount)
        
        DataController.sharedInstance.saveNotifiacationArrayOfObjectData(newNoti: newNotiModel)
        
        id = "3"
        image_url = ""
        type = "gold"
        transfer_from = ""
        title = "รับทองคำเรียบร้อย"
        detail = ""
        ref_id = "33233322"
        amount = ""
        gold_unit = "salueng"
        gold_amount = "4"
        date = "16-05-2562 08:22"
        
        newNotiModel = NotificationStruct(id: id,
                                          image_url: image_url,
                                          title: title,
                                          detail: detail,
                                          type: type ,
                                          ref_id: ref_id,
                                          amount:amount,
                                          date:date,
                                          transfer_from:transfer_from,
                                          gold_unit:gold_unit,
                                          gold_amount:gold_amount)
        
        DataController.sharedInstance.saveNotifiacationArrayOfObjectData(newNoti: newNotiModel)
    }

}
