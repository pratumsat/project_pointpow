//
//  PopUpInfoThaiPostViewController.swift
//  pointpow
//
//  Created by thanawat on 13/3/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PopUpInfoThaiPostViewController: BaseViewController {

    @IBOutlet weak var insurance1Label: UILabel!
    @IBOutlet weak var insurance2Label: UILabel!
    @IBOutlet weak var insurance3Label: UILabel!
    @IBOutlet weak var insurance4Label: UILabel!
    @IBOutlet weak var insurance5Label: UILabel!
    @IBOutlet weak var insurance6Label: UILabel!
    @IBOutlet weak var insurance7Label: UILabel!
    @IBOutlet weak var insurance8Label: UILabel!
    
    @IBOutlet weak var fee1Label: UILabel!
    @IBOutlet weak var fee2Label: UILabel!
    @IBOutlet weak var fee3Label: UILabel!
    @IBOutlet weak var fee4Label: UILabel!
    @IBOutlet weak var fee5Label: UILabel!
    @IBOutlet weak var fee6Label: UILabel!
    @IBOutlet weak var fee7Label: UILabel!
    @IBOutlet weak var fee8Label: UILabel!
    
    var ems_price:Int = 0
    var fee_price:Int = 0
    
    @IBOutlet weak var serviceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        
        self.getPriceThaiPost() {
            self.updateUI()
        }
    }
    func updateUI(){
        print("ems = \(ems_price)")
        print("fee = \(fee_price)")
        self.serviceLabel.text = "\(fee_price) \(NSLocalizedString("unit-baht", comment: ""))"
        
        
        self.updateInsuranceLabel(5000, self.insurance1Label)
        self.updateInsuranceLabel(10000, self.insurance2Label)
        self.updateInsuranceLabel(15000, self.insurance3Label)
        self.updateInsuranceLabel(20000, self.insurance4Label)
        self.updateInsuranceLabel(25000, self.insurance5Label)
        self.updateInsuranceLabel(30000, self.insurance6Label)
        self.updateInsuranceLabel(35000, self.insurance7Label)
        self.updateInsuranceLabel(40000, self.insurance8Label)
        
        self.updateFeeLabel(self.fee1Label)
        self.updateFeeLabel(self.fee2Label)
        self.updateFeeLabel(self.fee3Label)
        self.updateFeeLabel(self.fee4Label)
        self.updateFeeLabel(self.fee5Label)
        self.updateFeeLabel(self.fee6Label)
        self.updateFeeLabel(self.fee7Label)
        self.updateFeeLabel(self.fee8Label)
    }
    
    func updateInsuranceLabel(_ amount:Double, _ label:UILabel){
        let baht = NSLocalizedString("unit-baht", comment: "")
        var insurance = 0
        if amount <= 20000 {
            insurance = Int(amount*0.01)
        }else{
            insurance = Int(amount*0.02)
        }
        
        label.text = "\(insurance) \(baht)"
    }
    func updateFeeLabel(_ label:UILabel){
        let baht = NSLocalizedString("unit-baht", comment: "")
        let feeAndService = self.ems_price + self.fee_price
        
        label.text = "\(feeAndService) \(baht)"
    }
    
    func getPriceThaiPost(_ avaliable:(()->Void)?  = nil){
        modelCtrl.getServicePriceThaiPost(params: nil , false , succeeded: { (result) in
            print("get price thaipost")
            if let data = result as? [String:AnyObject] {
                let shipping = data["shipping"] as? [[String:AnyObject]] ?? []
                if shipping.count > 0 {
                    for item in shipping {
                        let name = item["name"] as? String ?? ""
                        let ems_price = item["ems_price"] as? NSNumber ?? 0
                        let fee_price = item["fee_price"] as? NSNumber ?? 0
                        
                        if name.lowercased() == "thaipost"{
                            self.ems_price = ems_price.intValue
                            self.fee_price = fee_price.intValue
                        }
                    }
                    
                }
            }
            avaliable?()
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                //self.showMessagePrompt(message)
            }
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
            
        }
    }
    
    override func dismissPoPup() {
        super.dismissPoPup()
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCloseBlackView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismissPoPup()
    }


}
