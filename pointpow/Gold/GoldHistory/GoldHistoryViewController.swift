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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.goldHistory != nil {
            self.getDataHistory(clearData: false)
        }
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
            parameter += "&startdate=\(convertBuddhaToChris(startDate))"
        }
        if !endDate.isEmpty{
            parameter += "&enddate=\(convertBuddhaToChris(endDate))"
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
        var saving = false
        if self.indexSelected == 1 {
            saving = true
        }
        self.showFilterHistoryPopup(true, editData: self.tupleFilter , selectedSaving: saving) { (dataFilter) in
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
        self.tupleFilter = nil
        
        
    }
    
    func getDataHistory(clearData:Bool = false){
        if clearData {
            ///clear fiter
            self.clearFilter()
        }
        
        self.getHistory() {
            //updateview
            guard let count = self.goldHistory?.count, count > 0 else {
                
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
        return self.goldHistory?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.goldHistory?[section].items?.count ?? 0
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if let transCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransactionGoldCell", for: indexPath) as? TransactionGoldCell {
           
            cell = transCell
            
            
            if let items = self.goldHistory?[indexPath.section].items?[indexPath.row] {
                let status = items["status"] as? String ?? ""
                let type = items["type"] as? String ?? ""
                let date = items["updated_at"] as? String ?? ""
                
                transCell.dateLabel.text = date
                
                var numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 2
                
                
                
                if type == "saving" {
                    let gold_price = items["saving_transaction"]?["pointpow_total"] as? NSNumber ?? 0
                    
                    transCell.amountLabel.text  = numberFormatter.string(from: gold_price)
                    transCell.titleLabel.text = NSLocalizedString("string-title-history-saving", comment: "")
                    transCell.statusImageView.image = UIImage(named: "ic-saving")
                    transCell.shippingLabel.isHidden  = true
                    transCell.unitLabel.text = "PP"
                    
                    
                    transCell.shippingLabel.isHidden = true
                    
                    if status.lowercased() == "success" {
                        transCell.statusLabel.textColor = Constant.Colors.GREEN
                        transCell.statusLabel.text = NSLocalizedString("string-status-gold-history-success", comment: "")
                        
                        
                    }
                    if status.lowercased() == "cancel" {
                        transCell.statusLabel.textColor = Constant.Colors.PRIMARY_COLOR
                        transCell.statusLabel.text = NSLocalizedString("string-status-gold-history-cancel", comment: "")
                        
                        
                    }
                    
                }else{
                    let gold_unit = items["withdraw_transaction"]?["gold_unit"] as? String ?? ""
                    let gold_withdraw = items["withdraw_transaction"]?["gold_withdraw"] as? NSNumber ?? 0
                    let shipping = items["withdraw_transaction"]?["shipping"] as? [String:AnyObject] ?? [:]
                    let statusShipping = shipping["status"] as? String ?? ""
                    let type = shipping["type"] as? String ?? ""
                    
                    transCell.shippingLabel.isHidden  = false
                    
             
                    switch type.lowercased() {
                    case "office" :
                        if statusShipping == "waiting" {
                            transCell.shippingLabel.textColor = Constant.Colors.ORANGE
                            transCell.shippingLabel.text = NSLocalizedString("string-dailog-gold-shipping-office-status-waiting", comment: "")
                        }else{
                            transCell.shippingLabel.textColor = Constant.Colors.GREEN
                            transCell.shippingLabel.text = NSLocalizedString("string-dailog-gold-shipping-office-status-success", comment: "")
                        }
                        break
                    case "thaipost" :
                        if statusShipping == "waiting" {
                            transCell.shippingLabel.textColor = Constant.Colors.ORANGE
                            transCell.shippingLabel.text = NSLocalizedString("string-dailog-gold-shipping-thaipost-status-waiting", comment: "")
                        }else{
                            transCell.shippingLabel.textColor = Constant.Colors.GREEN
                            transCell.shippingLabel.text = NSLocalizedString("string-dailog-gold-shipping-thaipost-status-success", comment: "")
                        }
                        break
                        
                    default:
                        break
                    }
                    
                    if gold_unit.lowercased() == "salueng" {
                        transCell.unitLabel.text = NSLocalizedString("unit-salueng", comment: "")
                    }else{
                        transCell.unitLabel.text = NSLocalizedString("unit-baht", comment: "")
                    }
                    
                    numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    
                    transCell.amountLabel.text = numberFormatter.string(from: gold_withdraw)
                    transCell.titleLabel.text = NSLocalizedString("string-title-history-withdraw", comment: "")
                    transCell.statusImageView.image = UIImage(named: "ic-withdraw")
                    
                    
                    if status.lowercased() == "success" {
                        transCell.statusLabel.textColor = Constant.Colors.GREEN
                        transCell.statusLabel.text = NSLocalizedString("string-status-gold-history-success", comment: "")
                        
                        transCell.shippingLabel.isHidden = false
                    }
                    if status.lowercased() == "cancel" {
                        transCell.statusLabel.textColor = Constant.Colors.PRIMARY_COLOR
                        transCell.statusLabel.text = NSLocalizedString("string-status-gold-history-cancel", comment: "")
                        
                        transCell.shippingLabel.isHidden = true
                    }
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
        
     
        
        if let item = self.goldHistory?[indexPath.section].items?[indexPath.row] {
            let transaction_ref_id  = item["transaction_ref_id"] as? String ?? ""
            let type = item["type"] as? String ?? ""
         
            if type == "saving" {
                self.showGoldSavingResult(true, transactionId: transaction_ref_id)
            }else{
                self.showGoldWithDrawResult(true, transactionId: transaction_ref_id)
            }
            
            
        }
    }
}
