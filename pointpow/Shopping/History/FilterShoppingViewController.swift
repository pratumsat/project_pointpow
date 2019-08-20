//
//  FilterShoppingViewController.swift
//  pointpow
//
//  Created by thanawat on 1/8/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class FilterShoppingViewController: BaseViewController {

    @IBOutlet weak var pointImageView: UIImageView!
    @IBOutlet weak var pointCreditImageView: UIImageView!
    @IBOutlet weak var completeImageView: UIImageView!
    @IBOutlet weak var waitingImageView: UIImageView!
    @IBOutlet weak var shippingImageView: UIImageView!
    @IBOutlet weak var statusContainView: UIView!
    @IBOutlet weak var serviceContainView: UIView!
    
    @IBOutlet weak var completeOrderImageView: UIImageView!
    @IBOutlet weak var waitingOrderImageView: UIImageView!
    @IBOutlet weak var orderContainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-filter-shopping-transection", comment: "")
        self.backgroundImage?.image = nil
        self.setUp()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.statusContainView.borderDarkGrayColorProperties(borderWidth: 1, radius: 10)
        self.serviceContainView.borderDarkGrayColorProperties(borderWidth: 1, radius: 10)
        self.orderContainView.borderDarkGrayColorProperties(borderWidth: 1, radius: 10)
    }
    
    
    func setUp(){
        let waitting = UITapGestureRecognizer(target: self, action: #selector(waitingTapped))
        self.waitingImageView.isUserInteractionEnabled = true
        self.waitingImageView.addGestureRecognizer(waitting)
        
        let shipping = UITapGestureRecognizer(target: self, action: #selector(shippingTapped))
        self.shippingImageView.isUserInteractionEnabled = true
        self.shippingImageView.addGestureRecognizer(shipping)
        
        let complete = UITapGestureRecognizer(target: self, action: #selector(completeTapped))
        self.completeImageView.isUserInteractionEnabled = true
        self.completeImageView.addGestureRecognizer(complete)
        
        let point = UITapGestureRecognizer(target: self, action: #selector(payByPointPowTapped))
        self.pointImageView.isUserInteractionEnabled = true
        self.pointImageView.addGestureRecognizer(point)
        
        let pointCredit = UITapGestureRecognizer(target: self, action: #selector(payByPointPowAndCreditCardTapped))
        self.pointCreditImageView.isUserInteractionEnabled = true
        self.pointCreditImageView.addGestureRecognizer(pointCredit)
        
        let orderComplete = UITapGestureRecognizer(target: self, action: #selector(orderCompleteTapped))
        self.completeOrderImageView.isUserInteractionEnabled = true
        self.completeOrderImageView.addGestureRecognizer(orderComplete)
        
        let orderWaiting = UITapGestureRecognizer(target: self, action: #selector(orderWaitingTapped))
        self.waitingOrderImageView.isUserInteractionEnabled = true
        self.waitingOrderImageView.addGestureRecognizer(orderWaiting)
        
    }
    @objc func orderWaitingTapped(){
        let title = NSLocalizedString("string-dailog-shopping-shipping-status-waiting", comment: "")
        let params:Parameters = ["order_status" : "waiting"]
        self.showShoppingFilterResultPage(true, title, params: params)
    }
    @objc func orderCompleteTapped(){
        let title = NSLocalizedString("string-dailog-shopping-shipping-status-shipping", comment: "")
        let params:Parameters = ["order_status" : "complete"]
        self.showShoppingFilterResultPage(true, title, params: params)
    }
    
    @objc func waitingTapped(){
        let title = NSLocalizedString("string-dailog-shopping-shipping-status-waiting", comment: "")
        let params:Parameters = ["shipping_status" : "waiting"]
        self.showShoppingFilterResultPage(true, title, params: params)
    }
    @objc func shippingTapped(){
        let title = NSLocalizedString("string-dailog-shopping-shipping-status-shipping", comment: "")
        let params:Parameters = ["shipping_status" : "shipping"]
        self.showShoppingFilterResultPage(true, title, params: params)
    }
    @objc func completeTapped(){
        let title = NSLocalizedString("string-dailog-shopping-shipping-status-success", comment: "")
        let params:Parameters = ["shipping_status" : "complete"]
        self.showShoppingFilterResultPage(true, title, params: params)
    }
    @objc func payByPointPowTapped(){
        let title = NSLocalizedString("string-dailog-shopping-payment-type-pointpow", comment: "")
        let params:Parameters = ["payment_type" : "1"]
        self.showShoppingFilterResultPage(true, title, params: params)
    }
    @objc func payByPointPowAndCreditCardTapped(){
        let title = NSLocalizedString("string-dailog-shopping-payment-type-pointpow-and-credit", comment: "")
        let params:Parameters = ["payment_type" : "3"]
        self.showShoppingFilterResultPage(true, title, params: params)
    }
}
