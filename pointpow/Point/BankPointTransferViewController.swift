//
//  BankPointTransferViewController.swift
//  pointpow
//
//  Created by thanawat on 16/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class BankPointTransferViewController: BaseViewController  {
    
    @IBOutlet weak var moreImageView: UIImageView!
    @IBOutlet weak var lessImageView: UIImageView!
    @IBOutlet weak var providerImageView: UIImageView!
    @IBOutlet weak var pointpowImageView: UIImageView!
    
    @IBOutlet weak var providerNamgeLabel: UILabel!
    @IBOutlet weak var balancePointLabel: UILabel!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var providerPointNameLabel: UILabel!
    @IBOutlet weak var exchangeRateView: UIView!
    @IBOutlet weak var exchangeRateLabel: UILabel!
    @IBOutlet weak var transferButton: UIButton!
    
    @IBOutlet weak var exchangeRate2Label: UILabel!
    @IBOutlet weak var exchange2View: UIView!
    

    var userData:AnyObject?
    var itemData:[String:AnyObject]?
    
    var exchangeRate = 0
    var minPointTransfer = 0.0
    var pointLimitOrder = 0.0
    var rate = 0.0
    var pointName:String = "KTC Point"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        self.title = NSLocalizedString("string-title-profile-bank-transfer", comment: "")
        self.setUp()
    }
    
   
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.transferButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
        self.providerImageView.ovalColoLightGrayProperties()
        self.pointpowImageView.ovalColorClearProperties()
        
        self.lessImageView.ovalColorClearProperties()
        self.moreImageView.ovalColorClearProperties()
    }
    
   
    func setUp(){
        self.handlerEnterSuccess = { (pin) in
            
            self.showResultTransferView(true) {
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
        
        
        
        self.backgroundImage?.image = nil
        
        self.exchangeRateView.borderClearProperties(borderWidth: 1, radius: 10)
        self.exchange2View.borderClearProperties(borderWidth: 1)
        self.transferButton.borderClearProperties(borderWidth: 1)
        
        self.amountTextField.borderRedColorProperties(borderWidth: 1)
        self.amountTextField.setRightPaddingPoints(20)
        
      
        
        let less = UITapGestureRecognizer(target: self, action: #selector(lessPointTapped))
        self.lessImageView.isUserInteractionEnabled = true
        self.lessImageView.addGestureRecognizer(less)
        
        
        let more = UITapGestureRecognizer(target: self, action: #selector(morePointTapped))
        self.moreImageView.isUserInteractionEnabled = true
        self.moreImageView.addGestureRecognizer(more)
        
        
        self.amountTextField.delegate = self
        self.amountTextField.autocorrectionType = .no
        
        
        if let data = self.itemData {
            let provider_image = data["provider_image_url"] as? String ?? ""
            let name = data["name"] as? String ?? ""
            let exchange_rate = data["exchange_rate"] as? [[String:AnyObject]] ?? [[:]]
            
            if let firstExchangeRate = exchange_rate.first {
                let minimum = firstExchangeRate["minimum"] as? NSNumber ?? 0
                let point_in = firstExchangeRate["point_in"] as? NSNumber ?? 0
                let point_out = firstExchangeRate["point_out"] as? NSNumber ?? 0
                let rate = firstExchangeRate["rate"] as? NSNumber ?? 0
                
                self.rate = rate.doubleValue
                self.exchangeRate = minimum.intValue
                self.minPointTransfer = minimum.doubleValue
                self.amountTextField.text = "\(minimum.intValue)"
                
                let txtExchange = "\(point_in) \(pointName) = \(point_out) Point Pow"
                self.providerPointNameLabel.text = pointName
                self.providerPointNameLabel.setLineSpacing(lineSpacing: 0, lineHeightMultiple: 0.9)
                self.providerPointNameLabel.textAlignment = .center
                // for thai sans
                
                
                self.exchangeRateLabel.text = txtExchange
                
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .none
                numberFormatter.minimumFractionDigits = 0
                
                let toPointPow = minimum.doubleValue*rate.doubleValue
                self.exchangeRate2Label.text = numberFormatter.string(from: NSNumber(value: toPointPow))
            }
            
           self.providerNamgeLabel.text = name
            
            if let url = URL(string: provider_image) {
                self.providerImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
            }else{
                self.providerImageView.image = UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER)
            }
            
        }
        
        self.getUserInfo()
    }

    
    func getUserInfo(_ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.userData != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        modelCtrl.getUserData(params: nil , isLoading , succeeded: { (result) in
            self.userData = result
            avaliable?()
            if let userData = self.userData as? [String:AnyObject] {
                //let pointpow_id = userData["pointpow_id"] as? String ?? ""
                let pointBalance = userData["member_point"]?["total"] as? NSNumber ?? 0
//                let picture_data = userData["picture_data"] as? String ?? ""
//                let display_name = userData["display_name"] as? String ?? ""
//                let first_name = userData["first_name"] as? String ?? ""
//                let last_name = userData["last_name"] as? String ?? ""
//                let mobile = userData["mobile"] as? String ?? ""
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 2
                
           
                self.balancePointLabel.text = "\(numberFormatter.string(from: pointBalance ) ?? "") Point Pow"
                
            }
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
    
    @objc func lessPointTapped() {
        let updatedText = self.amountTextField.text!
        
        var amount = 0.0
        if  (Double(updatedText) != nil) {
            amount = Double(updatedText)!
        }
        amount -= Double(exchangeRate)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.minimumFractionDigits = 0
        
        self.amountTextField.text = numberFormatter.string(from: NSNumber(value: amount))
        
        if amount <= minPointTransfer {
            self.amountTextField.text = "\(exchangeRate)"
            disableImageView(self.lessImageView)
        }else{
            enableImageView(self.lessImageView)
        }
        
        let toPointPow = amount*rate
        self.exchangeRate2Label.text = numberFormatter.string(from: NSNumber(value: toPointPow))
        
    }
    @objc func morePointTapped() {
        let updatedText = self.amountTextField.text!
        
        var amount = 0.0
        if  (Double(updatedText) != nil) {
            amount = Double(updatedText)!
        }
        
        amount += Double(exchangeRate)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.minimumFractionDigits = 0
        
        self.amountTextField.text = numberFormatter.string(from: NSNumber(value: amount))
        
        enableImageView(self.lessImageView)
        
        let toPointPow = amount*rate
        self.exchangeRate2Label.text = numberFormatter.string(from: NSNumber(value: toPointPow))
    }
    
    
    func disableImageView(_ image:UIImageView){
        //image.ovalColorClearProperties()
        image.backgroundColor = UIColor.groupTableViewBackground
        image.isUserInteractionEnabled = false
    }
    func enableImageView(_ image:UIImageView){
        //image.ovalColorClearProperties()
        image.backgroundColor = Constant.Colors.PRIMARY_COLOR
        image.isUserInteractionEnabled = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
     
        if textField == self.amountTextField {
            let textRange = Range(range, in: textField.text!)!
            let updatedText = textField.text!.replacingCharacters(in: textRange, with: string)
            
            
            if  (Double(updatedText) != nil) {
                let amount = Double(updatedText)!
                if amount <= minPointTransfer {
                    
                    disableImageView(self.lessImageView)
                    
                }else{
                    enableImageView(self.lessImageView)
                }
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .none
                numberFormatter.minimumFractionDigits = 0
                let toPointPow = amount*rate
                self.exchangeRate2Label.text = numberFormatter.string(from: NSNumber(value: toPointPow))
            }else{
                //return false
            }
        }
        return true
    }
    
    @IBAction func transferTapped(_ sender: Any) {
        let updatedText = self.amountTextField.text!
        
        var amount = 0
        if  (Int(updatedText) != nil) {
            amount = Int(updatedText)!
        }
        if amount == 0 {
            self.showMessagePrompt(NSLocalizedString("string-dailog-saving-point-pointspend-empty", comment: ""))
            return
        }
        
        if amount%exchangeRate == 0{
            
            
            print("ok")
            self.showPaymentWebView(true, "", url: "") { (any) in
                print("return result \n \(any)")
                if let userInfo = any as? [String:AnyObject]{
                    let status = userInfo["status"] as? String ?? ""
                    let transection_ref_id = userInfo["transection_ref_id"] as? String ?? ""
                    
                    switch status {
                    case "success", "fail" :
                        self.showResultTransferView(true, finish: {
                            self.navigationController?.popToRootViewController(animated: false)
                        })
                        break
                    case "cancel":
                        break
                    default:
                        break
                        
                    }
                    
                }
            }
            
            /*if let data = self.itemData {
                let provider_id = data["id"] as? NSNumber ?? 0
                let provider_image = data["provider_image_url"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let exchange_rate = data["exchange_rate"] as? [[String:AnyObject]] ?? [[:]]
 
                let params:Parameters = ["provider_id" : provider_id.intValue,
                                         "select_point" : amount,
                                         "value_in" : amount]
                
                self.modelCtrl.exchangeTransferPoint(params: params , true , succeeded: { (result) in
                    //success
                    //if let mResult  = result as? [String:AnyObject] {
                    //
                    //}
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
             }*/
            
        }else{
            let message = NSLocalizedString("string-error-amount-fill", comment: "")
            self.showMessagePrompt2("\(message) \(self.exchangeRate)")
        }
        //self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
    }
}
