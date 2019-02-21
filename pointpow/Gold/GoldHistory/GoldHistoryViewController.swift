//
//  GoldHistoryViewController.swift
//  pointpow
//
//  Created by thanawat on 7/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class GoldHistoryViewController: BaseViewController ,UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var historyCollectionView: UICollectionView!
    
    var indexSelected:Int = 0
    var type:String = "all"
    var filterStatus:String = ""
    var startDate:String = ""
    var endDate:String = ""
    
    var goldHistory:[GoldHistory]?
    //var tupleFilter:(startDate:String , endDate:String, status:String)?

    var tupleFilter:AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-history", comment: "")
        self.setUp()
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        
        self.historyCollectionView.delegate = self
        self.historyCollectionView.dataSource = self
        
        
        self.historyCollectionView.showsVerticalScrollIndicator = false
        
        self.addRefreshViewController(self.historyCollectionView)
        
        self.registerNib(self.historyCollectionView, "TransactionGoldCell")
        self.registerHeaderNib(self.historyCollectionView, "HeaderCollectionReusableView")
        
        self.indexSelected = self.segmentedControl.selectedSegmentIndex
        
        //loaddata
        self.getDataHistory(clearData: true)
        
    }
    override func reloadData() {
        self.getDataHistory(clearData: false)
    }
    
    func getHistory(_ avaliable:(()->Void)?  = nil){
        
        var isLoading:Bool = true
        if self.goldHistory != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        var parameter = "type=\(type)"
        
        if !startDate.isEmpty {
            parameter += "&startdate=\(startDate)"
        }
        if !endDate.isEmpty{
            parameter += "&enddate=\(endDate)"
        }
        if !filterStatus.isEmpty{
            parameter += "&status=\(filterStatus)"
        }
        
        modelCtrl.getHistory(params: nil , parameter: parameter , isLoading , succeeded: { (result) in
            
            self.goldHistory =  self.getStatementList(result as! [[String : AnyObject]])
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
            avaliable?()
            
            self.refreshControl?.endRefreshing()
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
    
    
    private func getStatementList(_ statements:[[String:AnyObject]]) -> [GoldHistory] {
        var statementList = [GoldHistory]()
        for item in statements {
            let month = item["month"] as? String ?? ""
            if let items = item["items"] as? [[String:AnyObject]] {
                if items.count > 0 {
                    statementList.append(GoldHistory(month: month, items: items))
                }
            }
        }
        return statementList
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.segmentedControl.layer.cornerRadius = self.segmentedControl.bounds.height / 2
        self.segmentedControl.layer.borderColor = Constant.Colors.PRIMARY_COLOR.cgColor
        self.segmentedControl.layer.borderWidth = 1
        self.segmentedControl.layer.masksToBounds  = true
    }
    
    @IBAction func filterTapped(_ sender: Any) {
        self.showFilterHistoryPopup(true, editData: self.tupleFilter) { (dataFilter) in
            self.tupleFilter = dataFilter
            
            if let data:(startDate:String , endDate:String, status:String) = dataFilter as? (startDate:String , endDate:String, status:String){
                
                self.startDate = data.startDate
                self.endDate = data.endDate
                self.filterStatus = data.status
            }
            
            
            self.getDataHistory(clearData: false)
        }
    }
    
    @IBAction func bViewTapped(_ sender: Any) {
        if let saving = self.storyboard?.instantiateViewController(withIdentifier: "GoldPageNav") as? UINavigationController {
            self.revealViewController()?.pushFrontViewController(saving, animated: true)
            
        }
    }

    
    @IBAction func segmentChange(_ sender: Any) {
        self.indexSelected = self.segmentedControl.selectedSegmentIndex
        switch self.indexSelected {
        case 0 :
            print("all")
            self.type = "all"
            
            break
        case 1 :
            print("saving")
            self.type = "saving"
            
            break
        case 2 :
            print("withdraw")
            self.type = "withdraw"
            break
            
        default:
            break
        }
        self.getDataHistory(clearData: true)
    }
    func clearFilter(){
        self.filterStatus = ""
        self.startDate = ""
        self.endDate = ""
        
        
    }
    
    func getDataHistory(clearData:Bool = false){
        if clearData {
            ///clear fiter
            self.clearFilter()
        }
        
        self.getHistory() {
            //updateview
            self.historyCollectionView.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.goldHistory?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.goldHistory?[section].items?.count ?? 0
    }
    //var constraint:NSLayoutConstraint?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if let transCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransactionGoldCell", for: indexPath) as? TransactionGoldCell {
           
            cell = transCell
            
            
            if let item = self.goldHistory?[indexPath.section].items?[indexPath.row] {
                let status = item["status"] as? String ?? ""
                let type = item["type"] as? String ?? ""
                let date = item["created_at"] as? String ?? ""
                
                transCell.dateLabel.text = date
                
                if type == "saving" {
                    transCell.titleLabel.text = NSLocalizedString("string-title-history-saving", comment: "")
                    transCell.statusImageView.image = UIImage(named: "ic-saving")
                }else{
                    transCell.titleLabel.text = NSLocalizedString("string-title-history-withdraw", comment: "")
                    transCell.statusImageView.image = UIImage(named: "ic-withdraw")
                }
                
                
                
                
                if status.lowercased() == "waiting" {
                    transCell.statusLabel.textColor = Constant.Colors.ORANGE
                    transCell.statusLabel.text = NSLocalizedString("string-status-gold-history-waiting", comment: "")
                }
                if status.lowercased() == "success" {
                    transCell.statusLabel.textColor = Constant.Colors.GREEN
                    transCell.statusLabel.text = NSLocalizedString("string-status-gold-history-success", comment: "")
                }
                if status.lowercased() == "cancel" {
                    transCell.statusLabel.textColor = Constant.Colors.PRIMARY_COLOR
                    transCell.statusLabel.text = NSLocalizedString("string-status-gold-history-cancel", comment: "")
                }
                
            }
            
           

            
            
            let heightOfView = transCell.bounds.height
            transCell.heightConstraint.constant = heightOfView
            
            
            transCell.heightLogoConstraint.constant = heightOfView * 0.25
            
            if let size = self.goldHistory?[indexPath.section].items?.count  {
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
        
        if let month = self.goldHistory?[indexPath.section].month {
            header.headerLabel.text  = month
        }
        header.disableLine = true
        header.backgroundColor = Constant.Colors.COLOR_LLGRAY
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        
     
    }
}
