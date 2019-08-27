//
//  ShoppingHistoryViewController.swift
//  pointpow
//
//  Created by thanawat on 25/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class ShoppingHistoryViewController: ShoppingBaseViewController {

    @IBOutlet weak var historyCollectionView: UICollectionView!
    
    var countSection:Int = 0
    var shoppingHistory:[ShoppingHistory]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    @objc func filterTapped(){
        self.showHistoryShoppingFilter(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getDataHistory(clearData: false)
    }
    
    
    
    func setUp(){
        self.title = NSLocalizedString("string-title-transection", comment: "")
        
        let filterIcon = UIBarButtonItem(image: UIImage(named: "ic-filter"), style: .plain, target: self, action: #selector(filterTapped))
        navigationItem.rightBarButtonItem = filterIcon
        
        
        self.backgroundImage?.image = nil
        
        
        self.historyCollectionView.delegate = self
        self.historyCollectionView.dataSource = self
        
        
        self.historyCollectionView.showsVerticalScrollIndicator = false
        
        self.addRefreshViewController(self.historyCollectionView)
        
        self.registerNib(self.historyCollectionView, "ShoppingHistoryCell")
        self.registerHeaderNib(self.historyCollectionView, "HeaderCollectionReusableView")
    }
    
    func getHistory(_ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.shoppingHistory != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
       // let params:Parameters = ["status" : "all",
       //                          "service" : "all"]
        
        modelCtrl.getShoppingHistory(params: nil , isLoading , succeeded: { (result) in
            
            self.shoppingHistory =  self.getStatementList(result as! [[String : AnyObject]])

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
    
    
    
    func getStatementList(_ statements:[[String:AnyObject]]) -> [ShoppingHistory] {
        var statementList = [ShoppingHistory]()
        for item in statements {
            let month = item["month"] as? String ?? ""
            if let items = item["items"] as? [[String:AnyObject]] {
                if items.count > 0 {
                    statementList.append(ShoppingHistory(month: month, items: items))
                }
            }
        }
        return statementList
    }
    
    
    override func reloadData() {
        self.getDataHistory(clearData: false)
    }
    
    func getDataHistory(clearData:Bool = false){
        if clearData {
            ///clear fiter
        }
        
        self.getHistory() {
            //updateview
            guard let count = self.shoppingHistory?.count, count > 0 else {
                
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
}

extension ShoppingHistoryViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView != historyCollectionView {
            return super.numberOfSections(in: collectionView)
        }
        return self.shoppingHistory?.count ?? 0
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView != historyCollectionView {
            return super.collectionView(collectionView, numberOfItemsInSection: section)
        }
        
        return self.shoppingHistory?[section].items?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView != historyCollectionView {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
        var cell:UICollectionViewCell?
        
        if let transCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingHistoryCell", for: indexPath) as? ShoppingHistoryCell {
            cell = transCell
            
            if let item = self.shoppingHistory?[indexPath.section].items?[indexPath.row] {
                let payment_status  = item["payment_status"] as? String ?? ""
                let order_status = item["order_status"] as? String ?? ""
                let shipping_status = item["shipping_status"] as? String ?? ""
                let total_point = item["total_point"] as? NSNumber ?? 0
                let transaction_no = item["transaction_no"] as? String ?? ""
                let created_at = item["created_at"] as? String ?? ""
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 2
                
                transCell.titleLabel.text = transaction_no
                transCell.statusImageView.image = UIImage(named: "ic-service-type-shopping")
                transCell.amountLabel.text = numberFormatter.string(from: total_point)
                transCell.dateLabel.text = created_at
                
                if order_status.lowercased() != "cancel" {
                    transCell.trackCallback = {
                        if let items = self.shoppingHistory?[indexPath.section].items?[indexPath.row]["item"] as? [[String:AnyObject]]  {
                            let shipping_status = items.first?["shipping_status"] as? String ?? ""
                            if shipping_status.lowercased() == "cancel" {
                                let shipping_status_second = items.last?["shipping_status"] as? String ?? ""
                                self.showOrderShippingResultView(true , items: items  ,shipping_status: shipping_status_second.lowercased())
                            }else{
                                self.showOrderShippingResultView(true , items: items  ,shipping_status: shipping_status.lowercased())
                            }
                            
                        }
                        
                    }
                }
                
                switch order_status.lowercased() {
                case "cancel":
                    transCell.shippingLabel.text = NSLocalizedString("string-dailog-shopping-order-status-cancel", comment: "")
                    transCell.shippingLabel.textColor = Constant.Colors.PRIMARY_COLOR
                    transCell.followProductView.isHidden = true
                    break
                case "complete":
                    transCell.shippingLabel.text = NSLocalizedString("string-dailog-shopping-order-status-complete", comment: "")
                    transCell.shippingLabel.textColor = Constant.Colors.GREEN
                    transCell.followProductView.isHidden = false
                    break
                case "waiting":
                    transCell.shippingLabel.text = NSLocalizedString("string-dailog-shopping-order-status-waiting", comment: "")
                    transCell.shippingLabel.textColor = Constant.Colors.ORANGE
                    transCell.followProductView.isHidden = false
                    break
            
                    
                default:
                    transCell.followProductView.isHidden = true
                    break
                }
                
                
                switch payment_status.lowercased() {
                case "success":
                    transCell.statusLabel.text = NSLocalizedString("string-status-transection-shopping-history-success", comment: "")
                    break
                case "waiting":
                    transCell.statusLabel.text = NSLocalizedString("string-status-transection-history-pending", comment: "")
                    break
                case "fail":
                    transCell.statusLabel.text = NSLocalizedString("string-status-transection-history-cancel", comment: "")
                    break
                default:
                    break
                }
            }
            
            
            let heightOfView = transCell.bounds.height
            transCell.heightConstraint.constant = heightOfView
            transCell.heightLogoConstraint.constant = heightOfView * 0.3
            
            if let size = self.shoppingHistory?[indexPath.section].items?.count  {
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != historyCollectionView {
            super.collectionView(collectionView, didSelectItemAt: indexPath)
        }
        
        if let item = self.shoppingHistory?[indexPath.section].items?[indexPath.row] {
            let transaction_no  = item["transaction_no"] as? String ?? ""
            self.showOrderResultView(true, transaction_no)
        }
        
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView != historyCollectionView {
            return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        }
        
        
        let width = collectionView.frame.width
        return CGSize(width: width  , height: 90)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if collectionView != historyCollectionView {
            return super.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
        }
        
        return CGSize(width: collectionView.frame.width, height: 30.0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == self.countSection - 1 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        }
        
        return UIEdgeInsets.zero
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView != historyCollectionView {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath) as! HeaderCollectionReusableView
        if let month = self.shoppingHistory?[indexPath.section].month {
            header.headerLabel.text  = month
        }
        header.disableLine = true
        header.backgroundColor = Constant.Colors.COLOR_LLGRAY
        return header
    }
   
    
}
