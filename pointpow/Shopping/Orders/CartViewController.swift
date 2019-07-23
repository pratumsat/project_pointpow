//
//  CartViewController.swift
//  pointpow
//
//  Created by thanawat on 3/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class CartViewController: BaseViewController  , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIWebViewDelegate {

    @IBOutlet weak var cartCollectionView: UICollectionView!
    var userData:AnyObject?
    var cartItems:AnyObject?
    var checkAll = true
    
    var fullAddressShopping = ""
    var fullAddressTaxInvoice = ""
    var cart_id:Int = 0
    
    var isTaxInvoice = false {
        didSet{
            if isTaxInvoice {
                self.itemSection = ["pointbalance",
                                    "selectall",
                                    "product",
                                    "summary",
                                    "howtopay",
                                    "shipping_address",
                                    "taxinvoice",
                                    "shopping_taxinvoice",
                                    "nextbutton"]
            }else{
                self.itemSection = ["pointbalance",
                                    "selectall",
                                    "product",
                                    "summary",
                                    "howtopay",
                                    "shipping_address",
                                    "taxinvoice",
                                    "nextbutton"]
            }
            
            self.cartCollectionView.reloadData()
        }
    }
    
    func reloadSelectAllSection(){
        if let index = itemSection.firstIndex(of: "selectall"){
            let indexSet = IndexSet(integer: index)
            
            UIView.performWithoutAnimation {
                self.cartCollectionView.reloadSections(indexSet)
            }
        }
    }
    func reloadProductSection(){
        if let index = itemSection.firstIndex(of: "product"){
            let indexSet = IndexSet(integer: index)
            
            UIView.performWithoutAnimation {
                self.cartCollectionView.reloadSections(indexSet)
            }
        }
    }
    
    func getItemPositionByItemId(_ id:Int) -> Int{
        var i = 0
        if let Tuple = self.tupleProduct {
            for item in Tuple {
                if item.id == id {
                    return i
                }
                i += 1
            }
        }
        return 0
    }
   
    
    func updateTotalAmountPrice() {
        var total = 0.0
        var amount = 0
        var i = 0
        if let Tuple = self.tupleProduct {
            for item in Tuple {
                if item.select {
                    let sum = Double(item.amount) * item.price
                    total += sum
                    
                    amount += item.amount
                }
                i += 1
            }
        }
        self.totalOrder = (amount: amount, totalPrice: total)
    }
    
    var totalOrder:(amount:Int, totalPrice:Double)? {
        didSet{
            if let index = itemSection.firstIndex(of: "summary"){
                let indexSet = IndexSet(integer: index)
                
                UIView.performWithoutAnimation {
                    self.cartCollectionView.reloadSections(indexSet)
                }
            }
            if let index = itemSection.firstIndex(of: "howtopay"){
                let indexSet = IndexSet(integer: index)
                
                UIView.performWithoutAnimation {
                    self.cartCollectionView.reloadSections(indexSet)
                }
            }
            
            let mtitle = NSLocalizedString("string-title-cart-product", comment: "")
            self.title = "\(mtitle) (\(totalOrder?.amount ?? 0))"
        }
        
    }
    
    
    
    var tupleProduct:[(title:String, id:Int, amount:Int, price:Double, select:Bool, brand:String, cover:String)]?{
        didSet{
            print(tupleProduct as Any)
            if tupleProduct != nil {
                if tupleProduct!.count > 0 {
                    self.itemSection = ["pointbalance",
                                        "selectall",
                                        "product",
                                        "summary",
                                        "howtopay",
                                        "shipping_address",
                                        "taxinvoice",
                                        "nextbutton"]
                }else{
                    self.itemSection = ["no_item"]
                }
            }
        }
    }
    
    var itemSection = [""]
    
    var currentPointBalance:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.title = NSLocalizedString("string-title-cart-product", comment: "")
        
        let backImage = UIImage(named: "ic-back-white")
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backViewTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 2, left: -10, bottom: -2, right: 10)
        
        
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
                                    "taxinvoice",
                                    "nextbutton"]
                
                
                
            }else{
                self.itemSection = ["no_item"]
            }
        }else{
            self.itemSection = ["no_item"]
        }
        
        self.cartCollectionView.reloadData()
        self.updateTotalAmountPrice()
    }
    
   
    @objc func backViewTapped(){
        guard let tuple = self.tupleProduct ,tuple.count > 0 else {
            self.navigationController?.popViewController(animated: true)
            return
        }
 
        let count = tuple.count
        
        var success = 0
        for item in tuple {
            let id = item.id
            let amount = item.amount
            
            self.updateItemCart(id, amount: amount) {
                success += 1
                if success == count {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
     
        
    }
    
    func deleteProductByID(_ id:Int){
        print("id = \(id)")
        let positdion = self.getItemPositionByItemId(id)
        print("positdion = \(positdion)")
        
        self.tupleProduct?.remove(at: positdion)
    }
    
    func confirmDeleteItemInCart(_ productIds:[Int]){
        
        if productIds.count > 0 {
            let dTitle = NSLocalizedString("string-item-shopping-cart-delete-title", comment: "")
            //let message = NSLocalizedString("string-item-shopping-cart-delete-message", comment: "")
            let alert = UIAlertController(title: dTitle,
                                          message: "", preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-ok", comment: ""), style: .default, handler: {
                (alert) in
                
             
                self.delItemCart(productIds){
                    for id in productIds {
                        self.deleteProductByID(id)
                    }
                    self.cartCollectionView.reloadData()
                    self.updateTotalAmountPrice()
                }
                
            })
            let cancelButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-cancel", comment: ""), style: .default, handler: nil)
            
            alert.addAction(cancelButton)
            alert.addAction(okButton)
            
            self.present(alert, animated: true, completion: nil)
            
        }else{
            self.showMessagePrompt2(NSLocalizedString("string-item-shopping-cart-delete-empty", comment: ""))
        }
        
       
        
    }

    func delItemCart(_ productIds:[Int], success:(()->Void)? = nil){
        let parameter:Parameters = ["app_id" : Constant.PointPowAPI.APP_ID,
                                    "secret" : Constant.PointPowAPI.SECRET_SHOPPING,
                                    "cart_id" : self.cart_id,
                                    "product_id" : productIds]
        
      
        modelCtrl.delCart(params: parameter , true , succeeded: { (result) in
            //del success
            success?()
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
    func updateItemCart(_ product_id:Int, amount:Int, success:(()->Void)?){
        let parameter:Parameters = ["app_id" : Constant.PointPowAPI.APP_ID,
                                    "secret" : Constant.PointPowAPI.SECRET_SHOPPING,
                                    "cart_id" : self.cart_id,
                                    "product_id" : product_id,
                                    "amount" : amount]
        
        modelCtrl.updateCart(params: parameter , true , succeeded: { (result) in
            success?()
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
    
//    override func reloadData() {
//        self.callAPI() {
//            self.updateView()
//        }
//    }
    
    func setUp(){
        self.cartCollectionView.delegate = self
        self.cartCollectionView.dataSource = self
        
        self.cartCollectionView.showsVerticalScrollIndicator = false
//        self.addRefreshViewController(self.cartCollectionView)
        
        
        
        self.registerNib(self.cartCollectionView, "TaxInvoiceSelectCell")
        self.registerNib(self.cartCollectionView, "NotFoundItemCell")
        self.registerNib(self.cartCollectionView, "CartPointBalanceCell")
        self.registerNib(self.cartCollectionView, "ItenCartProductSelectAllCell")
        self.registerNib(self.cartCollectionView, "ItemCartProductCell")
        self.registerNib(self.cartCollectionView, "CartSummaryCell")
        self.registerNib(self.cartCollectionView, "CartHowtoSummary")
        self.registerNib(self.cartCollectionView, "CartAddressShippingCell")
        self.registerNib(self.cartCollectionView, "CartAdressTaxInvoiceCell")
        self.registerNib(self.cartCollectionView, "CartNextButtonCell")
        self.registerHeaderNib(self.cartCollectionView, "HeaderSectionCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    func getSelectAddress(_ memberAddress:[[String:AnyObject]]) -> String {
        for address in memberAddress {
            let full_address = address["full_address"] as? String ?? ""
            let mobile = address["mobile"] as? String ?? ""
            let latest_shipping = address["latest_shipping"] as? NSNumber ?? 0
            
            if latest_shipping.boolValue {
                return "\(full_address)\n\(mobile)"
            }
        }
        let full_address = memberAddress.first?["full_address"] as? String ?? ""
        let mobile = memberAddress.first?["mobile"] as? String ?? ""
        
        if full_address.isEmpty {
            return ""
        }
        return "\(full_address)\n\(mobile)"
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
                
                let member_addresses = userData["member_addresses"] as? [[String:AnyObject]] ?? [[:]]
                
                
                if member_addresses.count > 0 {
                    
                    var invoiceAddress:[[String:AnyObject]] = []
                    var shoppingAddress:[[String:AnyObject]] = []
                    
                    for address in member_addresses {
                        let type = address["type"] as? String ?? ""
                    
                        if type.lowercased() == "shopping" {
                            shoppingAddress.append(address)
                        }
                        if type.lowercased() == "invoice" {
                            invoiceAddress.append(address)
                        }
                    }
                    self.fullAddressShopping = self.getSelectAddress(shoppingAddress)
                    self.fullAddressTaxInvoice = self.getSelectAddress(invoiceAddress)
                    
                }
                
                
                
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
                let id  = itemCart.first?["id"] as? NSNumber ?? 0
                
                self.cart_id = id.intValue
                
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
//            if let itemCart = self.cartItems as? [[String:AnyObject]] {
//                let cart_item = itemCart.first?["cart_item"] as? [[String:AnyObject]] ?? []
//                return cart_item.count
//            }
            return self.tupleProduct?.count ?? 0
        case "summary":
            return 1
        case "howtopay":
            return 1
        case "shipping_address":
            return 1
        case "taxinvoice":
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
                
                
                if let current = self.currentPointBalance {
                    pointCell.pointBalanceLabel.text = "\(current)"
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
                    self.updateTotalAmountPrice()
                    self.checkAll = isCheck
                    self.reloadProductSection()
                    
                }
                selectCell.deleteCallback = {
                    var productIds:[Int] = []
                    if let Tuple = self.tupleProduct {
                        for item in Tuple {
                            if item.select {
                                productIds.append(item.id)
                            }
                        }
                        self.confirmDeleteItemInCart(productIds)
                    }
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
                    productCell.checkBox.isChecked = itemTuple.select
                 
                   
                     productCell.callBackTotalPrice  = { (amount, totalPrice) in
                        self.tupleProduct?[self.getItemPositionByItemId(itemTuple.id)].amount = amount
                        
                       
                        self.updateTotalAmountPrice()
                    }
                    
                    productCell.checkBox.toggle  = { (isCheck) in
                       self.tupleProduct?[self.getItemPositionByItemId(itemTuple.id)].select = isCheck
                        if !isCheck {
                            self.checkAll = false
                            self.reloadSelectAllSection()
                        }
                        
                        self.updateTotalAmountPrice()
                    }
                    
                }
            }
        case "summary":
            if let sumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartSummaryCell", for: indexPath) as? CartSummaryCell {
                cell = sumCell
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 2
                
                sumCell.totalLabel.text = numberFormatter.string(from: NSNumber(value: self.totalOrder?.totalPrice ?? 0))
                
                let txtAmount = NSLocalizedString("string-item-shopping-cart-txt-total-amount", comment: "")
                
                sumCell.totalAmountLabel.text = txtAmount.replace(target: "{{amount}}", withString: "\(self.totalOrder?.amount ?? 0)")
            }
        case "howtopay":
            if let howtoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartHowtoSummary", for: indexPath) as? CartHowtoSummary {
                cell = howtoCell
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 2
                
                let pointbalance = DataController.sharedInstance.getCurrentPointBalance()
                let total = self.totalOrder?.totalPrice ?? 0
                if pointbalance.doubleValue < total {
                    let sum  = total - pointbalance.doubleValue
                    howtoCell.howtoPayLabel.text = NSLocalizedString("string-item-shopping-cart-howto-pay-pc", comment: "")
                    howtoCell.cdLabel.text = numberFormatter.string(from: NSNumber(value: sum))
                    howtoCell.pointLabel.text = numberFormatter.string(from: pointbalance)
                    
                    howtoCell.showCreditCardLabel()
                }else{
                    
                    howtoCell.howtoPayLabel.text = NSLocalizedString("string-item-shopping-cart-howto-pay-pp", comment: "")
                    howtoCell.cdLabel.text = ""
                    howtoCell.pointLabel.text = numberFormatter.string(from: NSNumber(value: total))
                    
                    howtoCell.hideCreditCardLabel()
                }
                
                
            }
        case "shipping_address":
            if let addressCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartAddressShippingCell", for: indexPath) as? CartAddressShippingCell {
                cell = addressCell
                
                if !self.fullAddressShopping.trimmingCharacters(in: .whitespaces).isEmpty {
                    addressCell.addressLabel.text = self.fullAddressShopping
                    
                    addressCell.addView.isHidden = true
                    addressCell.addressLabel.isHidden = false
                }else{
                 
                    addressCell.addView.isHidden = false
                    addressCell.addressLabel.isHidden = true
                }
               
                
            }
        case "taxinvoice":
            if let invoiceCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaxInvoiceSelectCell", for: indexPath) as? TaxInvoiceSelectCell {
                cell = invoiceCell
                invoiceCell.checkBox.isChecked = self.isTaxInvoice
                invoiceCell.checkBox.toggle = { (isCheck) in
                    self.isTaxInvoice = isCheck
                }
            }
        case "shopping_taxinvoice":
            if let taxInvoiceCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartAdressTaxInvoiceCell", for: indexPath) as? CartAdressTaxInvoiceCell {
                cell = taxInvoiceCell
                
                 if !self.fullAddressTaxInvoice.trimmingCharacters(in: .whitespaces).isEmpty {
                    taxInvoiceCell.addressLabel.text = self.fullAddressTaxInvoice
                    
                    taxInvoiceCell.addView.isHidden = true
                    taxInvoiceCell.addressLabel.isHidden = false
                 }else{
                    taxInvoiceCell.addView.isHidden = false
                    taxInvoiceCell.addressLabel.isHidden = true
                }
               
                
                
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSectionCell", for: indexPath) as! HeaderSectionCell
        header.headerNameLabel.text = ""
        header.backgroundColor = UIColor.groupTableViewBackground
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        switch self.itemSection[section] {
        case "pointbalance":
            return CGSize.zero
            
        case "selectall":
            return CGSize.zero
            
        case "product":
            return CGSize.zero
            
        case "summary":
            let height = CGFloat(10.0)
            return CGSize(width: collectionView.frame.width, height: height)
            
        case "howtopay":
            
            return CGSize.zero
            
        case "shipping_address":
            return CGSize.zero
            
        case "taxinvoice":
            return CGSize.zero
            
        case "shopping_taxinvoice":
            return CGSize.zero
            
        case "nextbutton":
            return CGSize.zero
            
        case "no_item":
            return CGSize.zero
        default:
            return CGSize.zero
        }
        
        
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
            let pointbalance = DataController.sharedInstance.getCurrentPointBalance()
            let total = self.totalOrder?.totalPrice ?? 0
            if pointbalance.doubleValue < total {
                let height = CGFloat(160.0)
                return CGSize(width: collectionView.frame.width, height: height)
            }else{
                let height = CGFloat(120.0)
                return CGSize(width: collectionView.frame.width, height: height)
            }
            
        case "taxinvoice":
            let height = CGFloat(40.0)
            return CGSize(width: collectionView.frame.width, height: height)
            
            
        case "shipping_address":
            
            
            let width = collectionView.frame.width
            var heightAddress = CGFloat(0)
            if !self.fullAddressShopping.trimmingCharacters(in: .whitespaces).isEmpty {
                heightAddress += heightForView(text: self.fullAddressShopping, font: UIFont(name:   Constant.Fonts.THAI_SANS_BOLD, size: 18)!, width: width - 50)
                heightAddress += CGFloat(100)
            }else{
                heightAddress = CGFloat(160)
            }
            
            
            return CGSize(width: width, height: heightAddress)
            
        case "shopping_taxinvoice":
           
            let width = collectionView.frame.width
            var heightAddress = CGFloat(0)
            if !self.fullAddressTaxInvoice.trimmingCharacters(in: .whitespaces).isEmpty {
                heightAddress += heightForView(text: self.fullAddressTaxInvoice, font: UIFont(name:   Constant.Fonts.THAI_SANS_BOLD, size: 18)!, width: width - 50)
                heightAddress += CGFloat(100)
            }else{
                heightAddress = CGFloat(160)
            }
            
            
            return CGSize(width: width, height: heightAddress)
            
            
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
