//
//  GoldWithDrawViewController.swift
//  pointpow
//
//  Created by thanawat on 4/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class GoldWithDrawViewController: GoldBaseViewController {

    @IBOutlet weak var pLabel1: UILabel!
    @IBOutlet weak var pLabel2: UILabel!
    @IBOutlet weak var bTextfield: UITextField!
    @IBOutlet weak var sTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sTextfield.delegate = self
        self.bTextfield.delegate = self
        
        setUp()
     
    }
    
    func setUp(){
        
    }
    @IBAction func bViewTapped(_ sender: Any) {
        if let saving = self.storyboard?.instantiateViewController(withIdentifier: "GoldPageNav") as? UINavigationController {
            self.revealViewController()?.pushFrontViewController(saving, animated: true)
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        if textField == self.sTextfield {
            let textRange = Range(range, in: textField.text!)!
            let updatedText = textField.text!.replacingCharacters(in: textRange, with: string)
            cal1(updatedText)
        }
        if textField == self.bTextfield {
            let textRange = Range(range, in: textField.text!)!
            let updatedText = textField.text!.replacingCharacters(in: textRange, with: string)
            cal2(updatedText)
        }
        return true
    }
    
    // 1 salueng = premium 100
    // 2 salueng = premium 130
    
    // 1 baht = premium 150
    // 2 baht = premium 200
    // 5 baht = premium 250
    // 10 baht = premium 399
    
    
    func cal1(_ s:String){
        if let amount = Int(s) {
            var text = ""
        
//            text += "จำนวนทองที่ได้รับ 10 บาท \(amount/40) แท่ง พรีเมียม:\((amount/40)*300)\n"
//            let difference10 = amount%40
//
//            text += "จำนวนทองที่ได้รับ 5 บาท \(difference10/20) แท่ง พรีเมียม:\((difference10/20)*250)\n"
//            let difference5 = difference10%20
//
//            text += "จำนวนทองที่ได้รับ 2 บาท \(difference5/8) แท่ง พรีเมียม:\((difference5/8)*200)\n"
//            let difference2 = difference5%8
//
//            text += "จำนวนทองที่ได้รับ 1 บาท \(difference2/4) แท่ง พรีเมียม:\((difference2/4)*150)\n"
//            let difference1 = difference2%4
//
//            text += "จำนวนทองที่ได้รับ 2 สลึง \(difference1/2) แท่ง พรีเมียม:\((difference1/2)*130)\n"
//            text += "จำนวนทองที่ได้รับ 1 สลึง \(difference1%2) แท่ง พรีเมียม:\((difference1%2)*100)\n"
//
//            let premium = ( ((amount/40)*300)+((difference10/20)*250)+((difference5/8)*200)+((difference2/4)*150)+((difference1/2)*130)+((difference1%2)*100))
            
            
            text += "จำนวนทองที่ได้รับ 2 สลึง \(amount/2) เส้น พรีเมียม:\((amount/2)*130)\n"
            text += "จำนวนทองที่ได้รับ 1 สลึง \(amount%2) เส้น พรีเมียม:\((amount%2)*100)\n"
            let premium = (((amount/2)*130)+(amount%2)*100)
            
            text += "ค่าพรีเมียม: \(premium)"
            
            self.pLabel1.text = text
        }
       
    }
    func cal2(_ s:String){
        if let amount = Int(s) {
            var text = ""
            
            text += "จำนวนทองที่ได้รับ 10 บาท \(amount/10) แท่ง พรีเมียม:\((amount/10)*300)\n"
            let difference10 = amount%10
            
            text += "จำนวนทองที่ได้รับ 5 บาท \(difference10/5) แท่ง พรีเมียม:\((difference10/5)*250)\n"
            let difference5 = difference10%5

            text += "จำนวนทองที่ได้รับ 2 บาท \(difference5/2) แท่ง พรีเมียม:\((difference5/2)*200)\n"
            let difference2 = difference5%2

            text += "จำนวนทองที่ได้รับ 1 บาท \(difference2%2) แท่ง พรีเมียม:\((difference2%2)*150)\n"
          
            let premium = ( ((amount/10)*300)+((difference10/5)*250)+((difference5/2)*200)+((difference2%2)*150))
            text += "ค่าพรีเมียม: \(premium)"
            
            self.pLabel2.text = text
        }
        
    }
    
}
