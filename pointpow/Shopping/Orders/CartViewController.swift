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
    
    var fullAddressShopping:(id:String, rawAddress:String) = (id:"", rawAddress:"")
    var fullAddressTaxInvoice:(id:String, rawAddress:String) = (id:"", rawAddress:"")
    var cart_id:Int = 0
    var lateShippingModel:AnyObject?
    
    enum StatePage {
        case LIMITPAY, NONE
    }
    var statePage = StatePage.LIMITPAY;
    
    var isTaxInvoice = false {
        didSet{
            self.setItemSection()
            self.cartCollectionView.reloadData()
        }
    }
    
    func setItemSection(){
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
    
    }
    
    func updateSelectedItem(){
        var isFalse = 0
        var isTrue = 0
        if let tuple = self.tupleProduct {
            for item in tuple {
                if item.select {
                    isTrue += 1
                }else{
                    isFalse += 1
                }
            }
        }
        if isFalse > 0 {
            self.checkAll = false
        }else{
            self.checkAll = true
        }
        
        self.reloadSelectAllSection()
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
        var amountItem = 0
        if let Tuple = self.tupleProduct {
            for item in Tuple {
                amountItem += item.amount
                if item.select {
                    let sum = Double(item.amount) * item.price
                    total += sum
                    
                    amount += item.amount
                }
                i += 1
            }
        }
        self.totalOrder = (amount: amount, totalPrice: total)
        
        let mtitle = NSLocalizedString("string-title-cart-product", comment: "")
        self.title = "\(mtitle) (\(amountItem))"
    }
    
    var totalOrder:(amount:Int, totalPrice:Double)? {
        didSet{
            print(itemSection.count)
            
            if let index = itemSection.firstIndex(of: "pointbalance"){
                let indexSet = IndexSet(integer: index)
      
                UIView.performWithoutAnimation {
                    self.cartCollectionView.reloadSections(indexSet)
                }
            }
            
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
            
            
        }
        
    }
    
    
    
    var tupleProduct:[(title:String, id:Int, amount:Int, price:Double, select:Bool, brand:String, cover:String, stock:Int)]?{
        didSet{
            print(tupleProduct as Any)
            if tupleProduct != nil {
                if tupleProduct!.count > 0 {
                   
                    self.setItemSection()
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
        
        
        self.handlerEnterSuccess  = {(pin) in
            
            switch self.statePage {
            case .LIMITPAY:
                self.showPointLimitView(true)
                break
            case .NONE:
                break
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callAPI() {
            self.updateView()
            
            self.checkStock(updateSuccess: nil, updateWithChangeSuccess: {
                self.callAPI() {
                    self.updateView()
                }
            })
            
        }
    }
    
    private func callAPI(_ loadSuccess:(()->Void)? = nil){
        var success = 0
        self.loadingView?.showLoading()
        getUserInfo(){
            success += 1
            if success == 3 {
                loadSuccess?()
                self.loadingView?.hideLoading()
                self.refreshControl?.endRefreshing()
            }
        }
        getItemToCart(){
            success += 1
            if success == 3 {
                loadSuccess?()
                self.loadingView?.hideLoading()
                self.refreshControl?.endRefreshing()
            }
        }
        getMemberSetting(){
            success += 1
            if success == 3 {
                loadSuccess?()
                self.loadingView?.hideLoading()
                self.refreshControl?.endRefreshing()
            }
        }
        
        
    }
    func getMemberSetting(_ avaliable:(()->Void)?  = nil){
        modelCtrl.getMemberSetting(params: nil, false, succeeded: { (result) in
        //success
            avaliable?()
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                self.showMessagePrompt(message)
            }
            self.refreshControl?.endRefreshing()
            avaliable?()
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
            self.refreshControl?.endRefreshing()
            avaliable?()
        }
    }
    
    func updateView(){
        if let itemCart = self.cartItems as? [[String:AnyObject]] {
            let cart_item = itemCart.first?["cart_item"] as? [[String:AnyObject]] ?? []
            
            
            if cart_item.count > 0 {
                self.setItemSection()
                let mtitle = NSLocalizedString("string-title-cart-product", comment: "")
                self.title = "\(mtitle) (\(cart_item.count))"
            }else{
                self.itemSection = ["no_item"]
            }
        }else{
            self.itemSection = ["no_item"]
        }
        self.cartCollectionView.reloadData()
        self.updateTotalAmountPrice()
       
        

    }
    
    func getStock(success:((_ tupleProduct: [(title:String, id:Int, amount:Int, price:Double, select:Bool, brand:String, cover:String, stock:Int)])->Void)?=nil){
        
        modelCtrl.getCart(params: nil , false , succeeded: { (result) in
            self.cartItems = result
            
            if let itemCart = self.cartItems as? [[String:AnyObject]] {
                
                var tupleProduct:[(title:String, id:Int, amount:Int, price:Double, select:Bool, brand:String, cover:String, stock:Int)] = []
                
                let cart_item = itemCart.first?["cart_item"] as? [[String:AnyObject]] ?? []
                
                var i = 0
                for cart in cart_item {
                    let amount = cart["amount"] as? NSNumber ?? 0
                    
                    let item = cart["product"] as? [String:AnyObject] ?? [:]
                    let title = item["title"] as? String ?? ""
                    let id = item["id"] as? NSNumber ?? 0
                    let special_deal = item["special_deal"] as? [[String:AnyObject]] ?? [[:]]
                    let brand = item["brand"] as? [String:AnyObject] ?? [:]
                    let variation = cart["variation"] as? [String:AnyObject] ?? [:]
                    let stock = variation["stock"] as? NSNumber ?? 0
                    
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
                    
                    
                    tupleProduct.append((title: title,
                                         id: id.intValue ,
                                         amount: amount.intValue,
                                         price: price,
                                         select: self.tupleProduct?[i].select ?? true,
                                         brand: urlbrand,
                                         cover: urlCover,
                                         stock: stock.intValue))
                    i += 1
                }
                success?(tupleProduct)
                
            }
            
            
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
    func compareStock(_ inputAmount:Int, currentStock:Int) -> Int{
        if inputAmount > currentStock {
            return currentStock
        }else{
            return inputAmount
        }
        
    }
    func checkStock(_ product: [(title:String, id:Int, amount:Int, price:Double, select:Bool, brand:String, cover:String, stock:Int)]? = nil, updateSuccess:(()->Void)? = nil, updateWithChangeSuccess:(()->Void)? = nil,
                    cancel:(()->Void)? = nil){
        
        var errorMessage = ""
        guard let tuple = self.tupleProduct ,tuple.count > 0 else {  return }
        let txt_soldout = NSLocalizedString("string-status-shopping-cart-popup-sold-out", comment: "")
        let txt_less_stock1 = NSLocalizedString("string-status-shopping-cart-popup-less-input-1", comment: "")
        let txt_less_stock2 = NSLocalizedString("string-status-shopping-cart-popup-less-input-2", comment: "")
        let txt_update_cart = NSLocalizedString("string-status-shopping-cart-popup-update", comment: "")
//        "string-status-shopping-cart-popup-sold-out" = "\nสินค้าหมด\n";
//        "string-status-shopping-cart-popup-less-input-1" = "\nเหลือจำนวน ";
//        "string-status-shopping-cart-popup-less-input-2" = " รายการ\n";
//        "string-status-shopping-cart-popup-update" = "คุณต้องการอัพเดต ตะกร้าสินค้าหรือไม่";
        
        
        if product != nil {
            
            guard tuple.count == product!.count else {  return }
            print("tuple product count  = \(tuple.count)")
            print("product count = \(product!.count)")
            var i = 0
            for item in product! {
                
                let inputAmount = tuple[i].amount
                let stock = compareStock(inputAmount, currentStock: item.stock)
                
                let title = item.title
                
                if stock <= 0 {
                    errorMessage += "\(title)\(txt_soldout)"
                }else  if stock < inputAmount {
                    errorMessage += "\(title)\(txt_less_stock1)\(stock)\(txt_less_stock2)"
                }
                
                i += 1
            }
        }else{
            for item in tuple {
                let stock = item.stock
                let amount = item.amount
                let title = item.title
                
                if stock <= 0 {
                    errorMessage += "\(title)\(txt_soldout)"
                }else  if stock < amount {
                    errorMessage += "\(title)\(txt_less_stock1)\(stock)\(txt_less_stock2)"
                }
            }
        }
       
        if !errorMessage.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage += txt_update_cart
            let alert = UIAlertController(title: "", message: errorMessage, preferredStyle: .alert)
            
            let confirm = UIAlertAction(title: NSLocalizedString("string-dailog-gold-button-confirm", comment: ""), style: .default, handler: {
                (alert) in
                //confirm
                
                self.updateCart(ignoreDelete: 0) {
                    updateWithChangeSuccess?()
                }
                
            })
            let cancel = UIAlertAction(title: NSLocalizedString("string-dailog-gold-button-cancel", comment: ""), style: .default, handler: { (alert) in
                
                cancel?()
                
            })
            
            
            alert.addAction(cancel)
            alert.addAction(confirm)
            
            self.present(alert, animated: true, completion: nil)
        }else{
            self.updateCart(ignoreDelete: 1){
                updateSuccess?()
            }
        }
        
    }
   
    func updateCart(ignoreDelete:Int = 0 , _ updateSuccess:(()->Void)? = nil){
        guard let tuple = self.tupleProduct ,tuple.count > 0 else {  return }
        var product:[String:String] = [:]
        for item in tuple {
            product["\(item.id)"] = "\(item.amount)"
        }
        self.updateItemCart(ignoreDelete: ignoreDelete, product) {
            updateSuccess?()
        }
    }
    
    @objc func backViewTapped(){
        guard let tuple = self.tupleProduct ,tuple.count > 0 else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        self.updateCart(ignoreDelete: 1){
            self.navigationController?.popViewController(animated: true)
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
        print(parameter)
      
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
    func updateItemCart(ignoreDelete:Int = 0, _ product:[String:String], success:(()->Void)?){
        let parameter:Parameters = ["app_id" : Constant.PointPowAPI.APP_ID,
                                    "secret" : Constant.PointPowAPI.SECRET_SHOPPING,
                                    "cart_id" : self.cart_id,
                                    "ignore_delete" : ignoreDelete,
                                    "product" : product]
        
        modelCtrl.updateCart(params: parameter , true , succeeded: { (result) in
            success?()
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
//                if ignoreDelete == 0 {
//
//                }
                self.showMessagePrompt(message)
                
            }
            
            print(error)
        }) { (messageError) in
            print("messageError")
//            if ignoreDelete == 0 {
//
//            }
            self.handlerMessageError(messageError)
            
        }
    }
    
//    override func reloadData() {
//        self.callAPI() {
//            self.updateView()
//        }
//    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        
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
    
    
    func getSelectAddress(_ memberAddress:[[String:AnyObject]]) -> (id:String, rawAddress:String) {
        for data in memberAddress {
            let id = data["id"] as? NSNumber ?? 0
            let address = data["address"] as? String ?? ""
            let districtName = data["district"]?["name_in_thai"] as? String ?? ""
            let subdistrictName = data["subdistrict"]?["name_in_thai"] as? String ?? ""
            let provinceName = data["province"]?["name_in_thai"] as? String ?? ""
            let zip_code = data["subdistrict"]?["zip_code"] as? NSNumber ?? 0
            let name = data["name"] as? String ?? ""
            let mobile = data["mobile"] as? String ?? ""
            let latest_shipping = data["latest_shipping"] as? NSNumber ?? 0
            
            let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
            var rawAddress = "\(name) \(newMText.chunkFormatted())"
            rawAddress += "\n\(address) \(subdistrictName) \(districtName) \(provinceName) \(zip_code)"
            
            if latest_shipping.boolValue {
                self.lateShippingModel = data as AnyObject
                return (id: "\(id.intValue)", rawAddress: rawAddress)
            }
        }
        
        guard  let data = memberAddress.first else {
            return (id: "", rawAddress: "")
        }
        let id = data["id"] as? NSNumber ?? 0
        let address = data["address"] as? String ?? ""
        let districtName = data["district"]?["name_in_thai"] as? String ?? ""
        let subdistrictName = data["subdistrict"]?["name_in_thai"] as? String ?? ""
        let provinceName = data["province"]?["name_in_thai"] as? String ?? ""
        let zip_code = data["subdistrict"]?["zip_code"] as? NSNumber ?? 0
        let name = data["name"] as? String ?? ""
        let mobile = data["mobile"] as? String ?? ""
        
        let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
        var rawAddress = "\(name) \(newMText.chunkFormatted())"
        rawAddress += "\n\(address) \(subdistrictName) \(districtName) \(provinceName) \(zip_code)"
        
        self.lateShippingModel = data as AnyObject
        return (id: "\(id.intValue)", rawAddress: rawAddress)
    }
    
    func getSelectAddressTaxInVoice(_ memberAddress:[[String:AnyObject]]) -> (id:String, rawAddress:String) {
        for data in memberAddress {
            let id = data["id"] as? NSNumber ?? 0
            let address = data["address"] as? String ?? ""
            let districtName = data["district"]?["name_in_thai"] as? String ?? ""
            let subdistrictName = data["subdistrict"]?["name_in_thai"] as? String ?? ""
            let provinceName = data["province"]?["name_in_thai"] as? String ?? ""
            let zip_code = data["subdistrict"]?["zip_code"] as? NSNumber ?? 0
            let latest_shipping = data["latest_shipping"] as? NSNumber ?? 0
            let tax_invoice = data["tax_invoice"] as? String ?? ""
            let name = data["name"] as? String ?? ""
            let mobile = data["mobile"] as? String ?? ""
            
            let newText = String((tax_invoice).filter({ $0 != "-" }).prefix(13))
            let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
            var rawAddress = "\(name) \(newText.chunkFormattedPersonalID())"
            rawAddress += "\n\(newMText.chunkFormatted()) \(address) \(subdistrictName) \(districtName) \(provinceName) \(zip_code)"
            
            if latest_shipping.boolValue {
                return (id: "\(id.intValue)", rawAddress: rawAddress)
            }
        }
        guard  let data = memberAddress.first else {
            return (id: "", rawAddress: "")
        }
        
        let id = data["id"] as? NSNumber ?? 0
        let address = data["address"] as? String ?? ""
        let districtName = data["district"]?["name_in_thai"] as? String ?? ""
        let subdistrictName = data["subdistrict"]?["name_in_thai"] as? String ?? ""
        let provinceName = data["province"]?["name_in_thai"] as? String ?? ""
        let zip_code = data["subdistrict"]?["zip_code"] as? NSNumber ?? 0
        let tax_invoice = data["tax_invoice"] as? String ?? ""
        let name = data["name"] as? String ?? ""
        let mobile = data["mobile"] as? String ?? ""
       
        let newText = String((tax_invoice).filter({ $0 != "-" }).prefix(13))
        let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
        var rawAddress = "\(name) \(newText.chunkFormattedPersonalID())"
        rawAddress += "\n\(newMText.chunkFormatted()) \(address) \(subdistrictName) \(districtName) \(provinceName) \(zip_code)"
        
        return (id: "\(id.intValue)", rawAddress: rawAddress)
    }
   
    
    func getUserInfo(_ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.userData != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        modelCtrl.getUserData(params: nil , false , succeeded: { (result) in
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
                    
                    
                    self.fullAddressTaxInvoice = self.getSelectAddressTaxInVoice(invoiceAddress)
                    
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
            avaliable?()
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
            self.refreshControl?.endRefreshing()
            avaliable?()
        }
    }
    private func getItemToCart(_ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.cartItems != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        modelCtrl.getCart(params: nil , false , succeeded: { (result) in
            self.cartItems = result
            
            if let itemCart = self.cartItems as? [[String:AnyObject]] {
                
                var tupleProduct:[(title:String, id:Int, amount:Int, price:Double, select:Bool, brand:String, cover:String, stock:Int)] = []
                
                let cart_item = itemCart.first?["cart_item"] as? [[String:AnyObject]] ?? []
                let id  = itemCart.first?["id"] as? NSNumber ?? 0
                
                self.cart_id = id.intValue
                
                var i = 0
                
                for cart in cart_item {
                    let amount = cart["amount"] as? NSNumber ?? 0
                    
                    let item = cart["product"] as? [String:AnyObject] ?? [:]
                    let title = item["title"] as? String ?? ""
                    let id = item["id"] as? NSNumber ?? 0
                    let special_deal = item["special_deal"] as? [[String:AnyObject]] ?? [[:]]
                    let brand = item["brand"] as? [String:AnyObject] ?? [:]
                    let variation = cart["variation"] as? [String:AnyObject] ?? [:]
                    let stock = variation["stock"] as? NSNumber ?? 0
                    
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
                    
                    
                    tupleProduct.append((title: title,
                                               id: id.intValue ,
                                               amount: amount.intValue,
                                               price: price,
                                               select: self.tupleProduct?[i].select ?? true,
                                               brand: urlbrand,
                                               cover: urlCover,
                                               stock: stock.intValue))
                    i += 1
                }
                self.tupleProduct = tupleProduct
                
            }
            
            avaliable?()
            
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                self.showMessagePrompt(message)
            }
            self.refreshControl?.endRefreshing()
            avaliable?()
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
            self.refreshControl?.endRefreshing()
            avaliable?()
        }
        
    }
    
    func reloadCheckOutItemData(){
        self.callAPI({
            self.updateView()
            
            if self.checkOut() {
                
                self.showConfirmOrderViewController(true ,
                                                    cart_id: "\(self.cart_id)",
                    invoice_id: self.isTaxInvoice ? self.fullAddressTaxInvoice.id : "",
                    shipping_id: self.fullAddressShopping.id,
                    tupleProduct: self.tupleProduct as AnyObject)
            }
            
        })
    }
    func checkOut() -> Bool{
        guard let tuple = self.tupleProduct ,tuple.count > 0 else {  return false }
        let checkselectItem = self.totalOrder?.amount ?? 0
        if checkselectItem <= 0 {
            self.showMessagePrompt2(NSLocalizedString("string-item-cart-product-not-select", comment: ""))
            return false
        }
        if self.fullAddressShopping.rawAddress.trimmingCharacters(in: .whitespaces).isEmpty {
            self.showMessagePrompt2(NSLocalizedString("string-item-cart-address-not-select", comment: ""))
            return false
        }
        if self.isTaxInvoice {
            if self.fullAddressTaxInvoice.rawAddress.trimmingCharacters(in: .whitespaces).isEmpty {
                self.showMessagePrompt2(NSLocalizedString("string-item-cart-tax-invoice-not-select", comment: ""))
                return false
            }
        }
        let pointBalance = DataController.sharedInstance.getCurrentPointBalance()
        
        if pointBalance.doubleValue <= 0 {
            self.showMessagePrompt(NSLocalizedString("string-dailog-saving-point-not-enough", comment: ""))
            return false
        }
        
        
        let total = self.totalOrder?.totalPrice ?? 0
        let pointLimitOrder = DataController.sharedInstance.getLimitPerDay()
        var pointpow_spend = 0.0
        var credit_spend = 0.0
        
        if pointBalance.doubleValue < total {
            credit_spend = total - pointBalance.doubleValue
            pointpow_spend  = pointBalance.doubleValue
        }else{
            pointpow_spend  = total
        }
        print("pointLimitOrder \(pointLimitOrder)")
        print("pointpow_spend \(pointpow_spend)")
        print("credit_spend \(credit_spend)")
        
        if pointLimitOrder.doubleValue  < pointpow_spend {
          
            let title = NSLocalizedString("string-dailog-point-over-limit-order", comment: "")
            let alert = UIAlertController(title: "", message: title, preferredStyle: .alert)
            let confirm = UIAlertAction(title: NSLocalizedString("string-dailog-gold-button-confirm", comment: ""), style: .default, handler: {
                (alert) in
                //confirm
                self.statePage = .LIMITPAY
                self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
                
            })
            let cancel = UIAlertAction(title: NSLocalizedString("string-dailog-gold-button-cancel", comment: ""), style: .default, handler: { (alert) in
                
            })
            
            alert.addAction(cancel)
            alert.addAction(confirm)
            
            self.present(alert, animated: true, completion: nil)
            
            //self.showMessagePrompt(NSLocalizedString("string-dailog-point-over-limit-order", comment: ""))
            return false
        }
        return true
        
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
                
                let total = self.totalOrder?.totalPrice ?? 0
                let pointBalance = DataController.sharedInstance.getCurrentPointBalance()
                var pointpow_spend = 0.0
                var credit_spend = 0.0
                var disableRedeemView = true
                
                if pointBalance.doubleValue < total {
                    credit_spend = total - pointBalance.doubleValue
                    pointpow_spend  = pointBalance.doubleValue
                    disableRedeemView = false
                }else{
                    pointpow_spend  = total
                    disableRedeemView = true
                }
                
                pointCell.disableRedeemView = disableRedeemView
                pointCell.redeemCallback = {
                    //redeem
                    self.updateCart(ignoreDelete: 1){
                        if let data  = self.userData as? [String:AnyObject] {
                            let is_profile = data["is_profile"] as? NSNumber ?? 0
                            self.showPointTransferView(true, isProfile: is_profile.boolValue)
                        }
                    }
                   
                }
            }
        case "selectall":
            if let selectCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItenCartProductSelectAllCell", for: indexPath) as? ItenCartProductSelectAllCell {
                cell = selectCell
                selectCell.checkBox.isChecked = self.checkAll
                
                selectCell.checkCallback = {
                    var i = 0
                    if let Tuple = self.tupleProduct {
                        for _ in Tuple {
                            self.tupleProduct![i].select = !self.checkAll
                            i += 1
                        }
                    }
                    self.updateTotalAmountPrice()
                    self.checkAll = !self.checkAll
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
//                    if let url = URL(string: itemTuple.brand) {
//                        productCell.brandImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
//                    }
                    productCell.brandImageView.isHidden = true
                    
                    if let url = URL(string: itemTuple.cover) {
                        productCell.productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                    }
                    productCell.maxAmount = itemTuple.stock
                    productCell.priceOfProduct = itemTuple.price
                    productCell.priceLabel.text = numberFormatter.string(from: NSNumber(value: itemTuple.price))
                    productCell.amount = itemTuple.amount
                    productCell.checkBox.isChecked = itemTuple.select
                    productCell.isCheck = itemTuple.select
                    
                    
                     productCell.callBackTotalPrice  = { (amount, totalPrice) in
                        print("amount= \(amount)")
                        self.tupleProduct?[self.getItemPositionByItemId(itemTuple.id)].amount = amount
                        
                       
                        self.updateTotalAmountPrice()
                    }
                    
                    productCell.checkCallback = { (isCheck) in
                        self.tupleProduct?[self.getItemPositionByItemId(itemTuple.id)].select = isCheck

                        self.updateSelectedItem()
                        self.updateTotalAmountPrice()
                    }
                    
                    let maxCount = self.tupleProduct?.count ?? 0
                    if (maxCount - 1) == indexPath.row {
                        productCell.bottomLineView.isHidden = true
                    }else{
                        productCell.bottomLineView.isHidden = false
                    }
                }
            }
        case "summary":
            if let sumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartSummaryCell", for: indexPath) as? CartSummaryCell {
                cell = sumCell
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                //numberFormatter.minimumFractionDigits = 2
                
                sumCell.totalAmountPriceLabel.text  = numberFormatter.string(from: NSNumber(value: self.totalOrder?.totalPrice ?? 0))
                
                sumCell.totalLabel.text = numberFormatter.string(from: NSNumber(value: self.totalOrder?.totalPrice ?? 0))
                
                sumCell.shippingPriceLabel.text = numberFormatter.string(from: NSNumber(value: 0))
                
                let txtAmount = NSLocalizedString("string-item-shopping-cart-txt-total-amount", comment: "")
                
                sumCell.totalAmountLabel.text = txtAmount.replace(target: "{{amount}}", withString: "\(self.totalOrder?.amount ?? 0)")
            }
        case "howtopay":
            if let howtoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartHowtoSummary", for: indexPath) as? CartHowtoSummary {
                cell = howtoCell
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                //numberFormatter.minimumFractionDigits = 2
                
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
                
                if !self.fullAddressShopping.rawAddress.trimmingCharacters(in: .whitespaces).isEmpty {
                    addressCell.addressLabel.text = self.fullAddressShopping.rawAddress
                    
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

                
                invoiceCell.checkCallback = {
                    self.isTaxInvoice = !self.isTaxInvoice
                }
            }
        case "shopping_taxinvoice":
            if let taxInvoiceCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartAdressTaxInvoiceCell", for: indexPath) as? CartAdressTaxInvoiceCell {
                cell = taxInvoiceCell
                
                 if !self.fullAddressTaxInvoice.rawAddress.trimmingCharacters(in: .whitespaces).isEmpty {
                    taxInvoiceCell.addressLabel.text = self.fullAddressTaxInvoice.rawAddress
                    
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
                nextCell.nextCallback = {
                    nextCell.nextButton.isEnabled = false
                    
                    if self.checkOut() {
                        self.getStock() { (tupleProduct) in
                            self.checkStock(tupleProduct, updateSuccess: {
                                nextCell.nextButton.isEnabled = true
                                self.reloadCheckOutItemData()
                                
                            }, updateWithChangeSuccess: { () in
                                nextCell.nextButton.isEnabled = true
                                self.reloadCheckOutItemData()
                                
                            }, cancel: { () in
                                nextCell.nextButton.isEnabled = true
                            })
                        }
                        
                    }else{
                         nextCell.nextButton.isEnabled = true
                    }
                    
                   
                    
                }
                
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

        switch self.itemSection[indexPath.section] {
        case "shipping_address":
            
            self.updateCart(ignoreDelete: 1){
                if !self.fullAddressShopping.rawAddress.trimmingCharacters(in: .whitespaces).isEmpty {
                    //isAddress
                    self.showShoppingAddressPage(true)
                }else{
                    //no address
                    self.showShoppingAddAddressPage(true)
                }
            }
            
            
           
            break
            
        case "shopping_taxinvoice":
           
            self.updateCart(ignoreDelete: 1){
                if !self.fullAddressTaxInvoice.rawAddress.trimmingCharacters(in: .whitespaces).isEmpty {
                    //isAddress
                    self.showTaxInvoiceAddressPage(true, self.lateShippingModel)
                }else{
                    //no address
                    self.showTaxInvoiceAddDuplicateAddressPage(true, self.lateShippingModel )
                    //self.showTaxInvoiceAddAddressPage(true)
                }
            }
          
          
            
            break
            
        default:
            break
        }
        
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
            let height = CGFloat(10.0)
            return CGSize(width: collectionView.frame.width, height: height)
            
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
            let height = CGFloat(80.0)
            return CGSize(width: collectionView.frame.width, height: height)
            
        case "selectall":
            let height = CGFloat(50.0)
            return CGSize(width: collectionView.frame.width, height: height)
            
        case "product":
            let height = CGFloat(140.0)
            return CGSize(width: collectionView.frame.width, height: height)
            
        case "summary":
            let height = CGFloat(150.0)
            return CGSize(width: collectionView.frame.width, height: height)
            
        case "howtopay":
            let pointbalance = DataController.sharedInstance.getCurrentPointBalance()
            let total = self.totalOrder?.totalPrice ?? 0
            if pointbalance.doubleValue < total {
                let height = CGFloat(190.0)
                return CGSize(width: collectionView.frame.width, height: height)
            }else{
                let height = CGFloat(140.0)
                return CGSize(width: collectionView.frame.width, height: height)
            }
            
        case "taxinvoice":
            let height = CGFloat(40.0)
            return CGSize(width: collectionView.frame.width, height: height)
            
            
        case "shipping_address":
            
            
            let width = collectionView.frame.width
            var heightAddress = CGFloat(0)
            if !self.fullAddressShopping.rawAddress.trimmingCharacters(in: .whitespaces).isEmpty {
                heightAddress += heightForView(text: self.fullAddressShopping.rawAddress, font: UIFont(name:   Constant.Fonts.THAI_SANS_REGULAR, size: 18)!, width: width - 60)
                heightAddress += CGFloat(90)
            }else{
                heightAddress = CGFloat(150)
            }
            
            
            return CGSize(width: width, height: heightAddress)
            
        case "shopping_taxinvoice":
           
            let width = collectionView.frame.width
            var heightAddress = CGFloat(0)
            if !self.fullAddressTaxInvoice.rawAddress.trimmingCharacters(in: .whitespaces).isEmpty {
                heightAddress += heightForView(text: self.fullAddressTaxInvoice.rawAddress, font: UIFont(name:   Constant.Fonts.THAI_SANS_REGULAR, size: 18)!, width: width - 60)
                heightAddress += CGFloat(90)
            }else{
                heightAddress = CGFloat(150)
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
