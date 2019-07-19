//
//  CartViewController.swift
//  pointpow
//
//  Created by thanawat on 3/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class CartViewController: BaseViewController  , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIWebViewDelegate {

    @IBOutlet weak var cartCollectionView: UICollectionView!
    var userData:AnyObject?
    var cartItems:AnyObject?
    var checkAll = true {
        didSet{
            
            if let index = itemSection.firstIndex(of: "product"){
                let indexSet = IndexSet(integer: index)

                UIView.performWithoutAnimation {
                    self.cartCollectionView.reloadSections(indexSet)
                }
            }
        }
    }
    
   
    var totalPrice:Double = 0.0 {
        didSet{
            if let index = itemSection.firstIndex(of: "summary"){
                let indexSet = IndexSet(integer: index)
                
                UIView.performWithoutAnimation {
                    self.cartCollectionView.reloadSections(indexSet)
                }
               
               
                
            }
        }
    }
    
    var tupleProduct:[(title:String, id:Int, amount:Int, price:Double, select:Bool, brand:String, cover:String)]? {
        didSet{
                print(tupleProduct)
        }
    }
    
    var itemSection = [""]
    
    var currentPointBalance:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.title = NSLocalizedString("string-title-cart-product", comment: "")
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        self.currentPointBalance = numberFormatter.string(from: DataController.sharedInstance.getCurrentPointBalance() )
        
        self.callAPI() {
            self.updateView()
        }
        
    }
    private func callAPI(_ loadSuccess:(()->Void)? = nil){
        var success = 0
        getUserInfo(){
            success += 1
            if success == 2 {
                loadSuccess?()
                self.refreshControl?.endRefreshing()
            }
        }
        getItemToCart(){
            success += 1
            if success == 2 {
                loadSuccess?()
                self.refreshControl?.endRefreshing()
            }
        }
        
        
    }
    
    func updateView(){
        if let itemCart = self.cartItems as? [[String:AnyObject]] {
            let cart_item = itemCart.first?["cart_item"] as? [[String:AnyObject]] ?? []
            if cart_item.count > 0 {
                self.itemSection = ["pointbalance",
                                    "selectall",
                                    "product",
                                    "summary",
                                    "howtopay",
                                    "shipping_address",
                                    "shopping_taxinvoice",
                                    "nextbutton"]
                
            }else{
                self.itemSection = ["no_item"]
            }
        }else{
            self.itemSection = ["no_item"]
        }
        self.cartCollectionView.reloadData()
    }
    
//    override func reloadData() {
//        self.callAPI() {
//            self.updateView()
//        }
//    }
    
    func setUp(){
        self.cartCollectionView.delegate = self
        self.cartCollectionView.dataSource = self
        
//        self.addRefreshViewController(self.cartCollectionView)
        
        self.registerNib(self.cartCollectionView, "NotFoundItemCell")
        self.registerNib(self.cartCollectionView, "CartPointBalanceCell")
        self.registerNib(self.cartCollectionView, "ItenCartProductSelectAllCell")
        self.registerNib(self.cartCollectionView, "ItemCartProductCell")
        self.registerNib(self.cartCollectionView, "CartSummaryCell")
        self.registerNib(self.cartCollectionView, "CartHowtoSummary")
        self.registerNib(self.cartCollectionView, "CartAddressShippingCell")
        self.registerNib(self.cartCollectionView, "CartAdressTaxInvoiceCell")
        self.registerNib(self.cartCollectionView, "CartNextButtonCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
           
            if let userData = self.userData as? [String:AnyObject] {
                let pointBalance = userData["member_point"]?["total"] as? NSNumber ?? 0
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 2

                self.currentPointBalance = numberFormatter.string(from: pointBalance )
            }
             avaliable?()
            
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
    private func getItemToCart(_ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.cartItems != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        modelCtrl.getCart(params: nil , isLoading , succeeded: { (result) in
            self.cartItems = result
            
            if let itemCart = self.cartItems as? [[String:AnyObject]] {
                
                self.tupleProduct = []
                let cart_item = itemCart.first?["cart_item"] as? [[String:AnyObject]] ?? []
                
                for cart in cart_item {
                    let amount = cart["amount"] as? NSNumber ?? 0
                    
                    let item = cart["product"] as? [String:AnyObject] ?? [:]
                    let title = item["title"] as? String ?? ""
                    let id = item["id"] as? NSNumber ?? 0
                    let special_deal = item["special_deal"] as? [[String:AnyObject]] ?? [[:]]
                    let brand = item["brand"] as? [String:AnyObject] ?? [:]
                    
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
                    
                    let urlbrand = getFullPathImageView(brand)
                    let urlCover = getFullPathImageView(item)
                    
                    self.tupleProduct?.append((title: title, id: id.intValue , amount: amount.intValue, price: price, select: true, brand: urlbrand, cover: urlCover))
                }
                
            }
            
            avaliable?()
            
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
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.itemSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        switch self.itemSection[section] {
        case "pointbalance":
            return 1
        case "selectall":
            return 1
        case "product":
            if let itemCart = self.cartItems as? [[String:AnyObject]] {
                let cart_item = itemCart.first?["cart_item"] as? [[String:AnyObject]] ?? []
                return cart_item.count
            }
            return 0
        case "summary":
            return 1
        case "howtopay":
            return 1
        case "shipping_address":
            return 1
        case "shopping_taxinvoice":
            return 1
        case "nextbutton":
            return 1
        case "no_item":
            return 1
        default:
            return 0
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
      
        
        switch self.itemSection[indexPath.section] {
        case "pointbalance":
            if let pointCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartPointBalanceCell", for: indexPath) as? CartPointBalanceCell {
                cell = pointCell
                
                let unit = NSLocalizedString("string-unit-pointpow", comment: "")
                if let current = self.currentPointBalance {
                    pointCell.pointBalanceLabel.text = "\(current)\(unit)"
                }
                
            }
        case "selectall":
            if let selectCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItenCartProductSelectAllCell", for: indexPath) as? ItenCartProductSelectAllCell {
                cell = selectCell
                selectCell.checkBox.isChecked = self.checkAll
                selectCell.checkBox.toggle  = { (isCheck) in
                    
                    var i = 0
                    if let Tuple = self.tupleProduct {
                        for _ in Tuple {
                            self.tupleProduct![i].select = isCheck
                            i += 1
                        }
                    }
                    
                    self.checkAll = isCheck
                }
               
            }
        case "product":
            if let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCartProductCell", for: indexPath) as? ItemCartProductCell {
                cell = productCell
                
                
                if let itemTuple = self.tupleProduct?[indexPath.row] {
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    
                    productCell.productNameLabel.text = itemTuple.title
                    if let url = URL(string: itemTuple.brand) {
                        productCell.brandImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                    }
                    if let url = URL(string: itemTuple.cover) {
                        productCell.productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                    }
                    
                    productCell.priceOfProduct = itemTuple.price
                    productCell.priceLabel.text = numberFormatter.string(from: NSNumber(value: itemTuple.price))
                    productCell.amount = itemTuple.amount
                    
                 
                   
                     productCell.callBackTotalPrice  = { (amount, totalPrice) in
                        
                        var i = 0
                        if let Tuple = self.tupleProduct {
                            for item in Tuple {
                                if item.id == itemTuple.id {
                                    self.tupleProduct![indexPath.row].amount = amount
                                }
                                i += 1
                            }
                        }
                    }
                    
                    productCell.checkBox.toggle  = { (isCheck) in
//                        var i = 0
//                        if let Tuple = self.tupleProduct {
//                            for item in Tuple {
//                                if item.id == id.intValue {
//                                    self.tupleProduct![i].select = isCheck
//                                }
//                                i += 1
//                            }
//                            //self.reloadProductCell()
//                        }
                    }
                   
                    
                    
                }
                
                
            }
        case "summary":
            if let sumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartSummaryCell", for: indexPath) as? CartSummaryCell {
                cell = sumCell
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                sumCell.totalLabel.text = numberFormatter.string(from: NSNumber(value: self.totalPrice))
            }
        case "howtopay":
            if let howtoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartHowtoSummary", for: indexPath) as? CartHowtoSummary {
                cell = howtoCell
                
               
            }
        case "shipping_address":
            if let addressCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartAddressShippingCell", for: indexPath) as? CartAddressShippingCell {
                cell = addressCell
                
                
            }
        case "shopping_taxinvoice":
            if let taxInvoiceCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartAdressTaxInvoiceCell", for: indexPath) as? CartAdressTaxInvoiceCell {
                cell = taxInvoiceCell
                
            }
        case "nextbutton":
            if let nextCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartNextButtonCell", for: indexPath) as? CartNextButtonCell {
                cell = nextCell
                
            }
        case "no_item":
            if let noItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotFoundItemCell", for:
                indexPath) as? NotFoundItemCell {
                cell = noItemCell
                noItemCell.nameLabel.text = NSLocalizedString("string-string-not-found-product-incart", comment: "")
            }
        default:
            break
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.section == 5 {
//            self.showShoppingAddressPage(true)
//        }
//        if indexPath.section == 6 {
//            self.showTaxInvoiceAddressPage(true)
//
//        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == self.itemSection.count - 1 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        }
        
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch self.itemSection[indexPath.section] {
        case "pointbalance":
            let height = CGFloat(50.0)
            return CGSize(width: collectionView.frame.width, height: height)
            
        case "selectall":
            let height = CGFloat(50.0)
            return CGSize(width: collectionView.frame.width, height: height)
            
        case "product":
            let height = CGFloat(140.0)
            return CGSize(width: collectionView.frame.width, height: height)
            
        case "summary":
            let height = CGFloat(130.0)
            return CGSize(width: collectionView.frame.width, height: height)
            
        case "howtopay":
            let height = CGFloat(130.0)
            return CGSize(width: collectionView.frame.width, height: height)
            
        case "shipping_address":
            let height = CGFloat(140.0)
            return CGSize(width: collectionView.frame.width, height: height)
            
        case "shopping_taxinvoice":
            let height = CGFloat(140.0)
            return CGSize(width: collectionView.frame.width, height: height)
            
        case "nextbutton":
            let width = collectionView.frame.width - 40
            let height = CGFloat(60)
            return CGSize(width: width, height: height)
            
        case "no_item":
            return CGSize(width: collectionView.frame.width, height: CGFloat(80.0))
        default:
            return CGSize(width: collectionView.frame.width, height: CGFloat(50.0))
        }
        
    }
    
    
}
