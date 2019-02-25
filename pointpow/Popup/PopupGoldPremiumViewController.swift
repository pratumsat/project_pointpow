//
//  PopupGoldPremiumViewController.swift
//  pointpow
//
//  Created by thanawat on 17/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PopupGoldPremiumViewController: BaseViewController {

    @IBOutlet weak var p1salueng: UILabel!
    @IBOutlet weak var p2salueng: UILabel!
    @IBOutlet weak var p1baht: UILabel!
    @IBOutlet weak var p2baht: UILabel!
    @IBOutlet weak var p5baht: UILabel!
    @IBOutlet weak var p10baht: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()
    }
    func setUp(){
        self.backgroundImage?.image = nil
        
        if let premium = DataController.sharedInstance.getDataGoldPremium(){
            if let premiums = premium as? [[String:AnyObject]]{
                for item in premiums {
                    let unit = item["unit"] as? String ?? ""
                    let weight = (item["weight"] as? NSNumber)?.intValue ?? 0
                    let price = (item["premium"] as? NSNumber)?.intValue ?? 0
                    if unit == "salueng"{
                        if weight == 2 {
                            setData(self.p2salueng , price)
                        }
                        if weight == 1 {
                            setData(self.p1salueng , price)
                        }
                    }else{
                        if weight == 1 {
                            setData(self.p1baht , price)
                        }
                        if weight == 2 {
                            setData(self.p2baht , price)
                        }
                        if weight == 5 {
                            setData(self.p5baht , price)
                        }
                        if weight == 10 {
                            setData(self.p10baht , price)
                        }
                    }
                }
            }
        }
    }
    
    func setData(_ label:UILabel, _ price:Int){
        label.text = "\(price) \(NSLocalizedString("unit-baht", comment: ""))"
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
