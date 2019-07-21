//
//  PopupAddToCartViewController.swift
//  pointpow
//
//  Created by thanawat on 21/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PopupAddToCartViewController: BaseViewController {

    @IBOutlet weak var continueLabel: UIButton!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    var dismissView:(()->Void)?
    
    
    var cartTuple:(amount:Int,
        product: [String:AnyObject],
        brand: [String:AnyObject],
        product_images: [String:AnyObject])? {
        didSet{
            print(cartTuple as Any)
        }
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        
        if let tuple = self.cartTuple {
            
           
            let brand = tuple.brand
            let item = tuple.product
            let product_images = tuple.product_images
            
            let title = item["title"] as? String ?? ""
           
            let special_deal = item["special_deal"] as? [[String:AnyObject]] ?? [[:]]
            
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            
            var price = 0.0
            if special_deal.count == 0{
                //check discount price
                let regular_price = item["regular_price"] as? NSNumber ?? 0
                let discount_price = item["discount_price"]  as? NSNumber ?? 0
                
                if discount_price.intValue > 0 {
                    price = discount_price.doubleValue
                }else{
                    price = regular_price.doubleValue
                }
                
            }else{
                //show special deal
                let deal_price = special_deal.first?["deal_price"] as? NSNumber ?? 0
                price = deal_price.doubleValue
            }
            let amount = tuple.amount
            let total = price * Double(amount)
            priceLabel.text = numberFormatter.string(from: NSNumber(value: total))
            self.productNameLabel.text = title
            self.amountLabel.text = "\(amount)"
            
            if let url = URL(string: getFullPathImageView(brand)) {
                self.brandImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
            }
            
            if let url = URL(string: getFullPathImageView(product_images)) {
                self.coverImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
            }
            
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.payButton.borderClearProperties()
        self.payButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        self.continueLabel.borderRedColorProperties(borderWidth: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @IBAction func continueTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    @IBAction func payTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            self.dismissView?()
        }
    }
    
    
}
