//
//  SavingSummaryViewController.swift
//  pointpow
//
//  Created by thanawat on 23/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class WithDrawSummaryOfficeViewController: BaseViewController {

    var withdrawData:(premium:Int, goldbalance:Double,goldAmountToUnit:(amount:Int, unit:Int , price:Double))?{
        didSet{
            print(withdrawData!)
        }
    }
    
    @IBOutlet weak var summaryCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("title-gold-pendding-confirm-withdraw", comment: "")
    }
    
    func setUp(){
        self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
        self.handlerEnterSuccess = {
            
                //get at pointpow
                let withdrawAmount = self.withdrawData!.goldAmountToUnit.amount
                var unit = ""
                var pick = ""
                if self.withdrawData!.goldAmountToUnit.unit == 0 {
                    unit = "salueng"
                    pick = "office"
                }else{
                    unit = "baht"
                    pick = "thaipost"
                }
                let params:Parameters = ["withdraw_amount": withdrawAmount,
                                         "unit": unit,
                                         "pick": pick]
                print(params)
                
                self.modelCtrl.withdrawGold(params: params, true , succeeded: { (result) in
                    if let data = result as? [String:AnyObject]{
                        let transactionId = data["withdraw"]?["transaction_no"] as? String ?? ""
                        
                        self.showGoldWithDrawResult(true , transactionId:  transactionId) {
                            if let saving = self.storyboard?.instantiateViewController(withIdentifier: "GoldPageNav") as? UINavigationController {
                                self.revealViewController()?.pushFrontViewController(saving, animated: true)
                                
                            }
                        }
                        
                    }
                    
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
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
