//
//  TransactionFilterVIewController.swift
//  pointpow
//
//  Created by thanawat on 21/5/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class TransactionFilterViewController: BaseViewController {

    var filterCallback:((_ filter:String)->Void)?
    
    @IBOutlet weak var statusSuccessImageView: UIImageView!
    @IBOutlet weak var statusPendingImageView: UIImageView!
    @IBOutlet weak var statusFailImageView: UIImageView!
    @IBOutlet weak var statusContainView: UIView!
    @IBOutlet weak var serviceContainView: UIView!
    
    @IBOutlet weak var savingImageView: UIImageView!
    @IBOutlet weak var transferImageView: UIImageView!
    @IBOutlet weak var exchangeImageView: UIImageView!
    @IBOutlet weak var shoppingImageView: UIImageView!
    
    var status:String = ""
    var service:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-transection", comment: "")
        self.backgroundImage?.image = nil
        self.setUp()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.statusContainView.borderDarkGrayColorProperties(borderWidth: 1, radius: 10)
        self.serviceContainView.borderDarkGrayColorProperties(borderWidth: 1, radius: 10)
    }
    
    func setUp(){
        let statusSuccess = UITapGestureRecognizer(target: self, action: #selector(statusSuccessTapped))
        self.statusSuccessImageView.isUserInteractionEnabled = true
        self.statusSuccessImageView.addGestureRecognizer(statusSuccess)
        
        let statusPending = UITapGestureRecognizer(target: self, action: #selector(statusPendingTapped))
        self.statusPendingImageView.isUserInteractionEnabled = true
        self.statusPendingImageView.addGestureRecognizer(statusPending)
        
        let statusfail = UITapGestureRecognizer(target: self, action: #selector(statusFailTapped))
        self.statusFailImageView.isUserInteractionEnabled = true
        self.statusFailImageView.addGestureRecognizer(statusfail)
        
        let pointsaving = UITapGestureRecognizer(target: self, action: #selector(servicePointSavingTapped))
        self.savingImageView.isUserInteractionEnabled = true
        self.savingImageView.addGestureRecognizer(pointsaving)
        
        let pointtransfer = UITapGestureRecognizer(target: self, action: #selector(servicePointTransferTapped))
        self.transferImageView.isUserInteractionEnabled = true
        self.transferImageView.addGestureRecognizer(pointtransfer)
        
        let exchange = UITapGestureRecognizer(target: self, action: #selector(serviceExchangeTapped))
        self.exchangeImageView.isUserInteractionEnabled = true
        self.exchangeImageView.addGestureRecognizer(exchange)
        
        let shopping = UITapGestureRecognizer(target: self, action: #selector(serviceShoppingTapped))
        self.shoppingImageView.isUserInteractionEnabled = true
        self.shoppingImageView.addGestureRecognizer(shopping)
    }
    
    @objc func statusSuccessTapped(){
        self.status = "success"
        let title = NSLocalizedString("string-status-transection-history-success", comment: "")
        let params:Parameters = ["status" : "success" ]
        self.showTransectionFilterResultPage(true, title, params: params)
    }
    @objc func statusPendingTapped(){
        self.status = "pending"
        let title = NSLocalizedString("string-status-transection-history-pending", comment: "")
        let params:Parameters = ["status" : "pending" ]
        self.showTransectionFilterResultPage(true, title, params: params)
    }
    @objc func statusFailTapped(){
        self.status = "fail"
        let title = NSLocalizedString("string-status-transection-history-cancel", comment: "")
        let params:Parameters = ["status" : "fail" ]
        self.showTransectionFilterResultPage(true, title, params: params)
    }
    
    
    
    @objc func servicePointSavingTapped(){
        self.service = "PointSaving"
        let title = NSLocalizedString("string-title-transection-history-service-pointsaving", comment: "")
        let params:Parameters = ["service" : "PointSaving" ]
        self.showTransectionFilterResultPage(true, title, params: params)
    }
    @objc func servicePointTransferTapped(){
        self.service = "PointTransfer"
        let title = NSLocalizedString("string-title-transection-history-service-point-transfer", comment: "")
        let params:Parameters = ["service" : "PointTransfer" ]
        self.showTransectionFilterResultPage(true, title, params: params)
    }
    @objc func serviceExchangeTapped(){
        self.service = "Exchange"
        let title = NSLocalizedString("string-title-transection-history-service-exchange", comment: "")
        let params:Parameters = ["service" : "Exchange" ]
        self.showTransectionFilterResultPage(true, title, params: params)
    }
    @objc func serviceShoppingTapped(){
        self.service = "Shopping"
        let title = NSLocalizedString("string-title-transection-history-service-shopping", comment: "")
        let params:Parameters = ["service" : "Shopping" ]
        self.showTransectionFilterResultPage(true, title, params: params)
    }
}
