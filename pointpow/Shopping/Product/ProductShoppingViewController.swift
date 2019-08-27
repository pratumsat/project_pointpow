//
//  ProductShoppingViewController.swift
//  pointpow
//
//  Created by thanawat on 25/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ProductShoppingViewController: ShoppingBaseViewController ,UIPickerViewDelegate , UIPickerViewDataSource, UIGestureRecognizerDelegate{
  
    var searchProduct:Bool {
        return false
    }
    var notFoundHeader:String {
        return "NotFoundItemCell"
    }
    var sizeNotFoundHeader : CGFloat {
        return CGFloat(50.0)
    }
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    @IBOutlet weak var topConstraintCollectionView: NSLayoutConstraint!
    
    var sortPickerView:UIPickerView?
    var sortBy = ["popular","low","high"]
    var sortBySelected = "popular" {
        didSet{
            if let index = self.itemSection.firstIndex(of: "no_more_item") {
                self.itemSection.remove(at: index)
            }
            
            self.productItems = nil
            self.skipItem = 0
            getProductByCate() {
                self.productCollectionView.reloadData()
            }
        }
    }
    
    var itemSection = ["filter","product"] {
        didSet{
            self.productCollectionView.reloadData()
        }
    }
    
    
    var cateName = NSLocalizedString("string-item-shopping-cate-all", comment: "") {
        didSet{
            guard let tab = self.tabBarController else {
                self.title = cateName
                return
            }
            tab.title = cateName
            
        }
    }
    //var initHeightViewCate = CGFloat(130.0)
    
    var searchView:UIView?
    var mainCateView:UIView?
    
    var cateItems:[[String:AnyObject]]?
    var productItems:[[String:AnyObject]]?
    var total_amount:Int?
    
    var cateId = 0 {
        didSet{
            getRecommendByCate {
                self.productCollectionView.reloadData()
            }
        }
    }
    
    var loadDataByCateID = 0 
    
    var isLoadmore = false
    var skipItem = 0
    
    var subCateId = 0 {
        didSet{
           
            
            if let index = self.itemSection.firstIndex(of: "no_more_item") {
                self.itemSection.remove(at: index)
            }
            
            
            
            self.productItems = nil
            self.skipItem = 0
            
            if subCateId > 5 {
                self.itemSection = ["filter","product"]
            }
            getProductByCate() {
                self.productCollectionView.reloadData()
            }
        }
    }
    var filterTextField:UITextField? {
        didSet{
            self.filterTextField?.delegate = self
            self.sortPickerView = UIPickerView()
            self.sortPickerView?.delegate = self
            self.sortPickerView?.dataSource = self
            
            self.filterTextField?.tintColor = UIColor.clear
            self.filterTextField?.isUserInteractionEnabled = true
            self.filterTextField?.inputView = self.sortPickerView
            
            let selected =  sortBy.firstIndex(of: self.sortBySelected)  ?? 0
            self.sortPickerView?.selectRow(selected, inComponent: 0, animated: true)
            
            switch sortBy[selected] {
            case "popular":
               
                self.filterTextField?.text =  NSLocalizedString("string-item-shopping-sort-popuplar", comment: "")
            case "low":
                
                self.filterTextField?.text =  NSLocalizedString("string-item-shopping-sort-low", comment: "")
            case "high":
                
                self.filterTextField?.text =  NSLocalizedString("string-item-shopping-sort-high", comment: "")
            default:
                self.filterTextField?.text =  ""
            }
        }
    }
    
    
    override func hideView() {
        if self.start_animation {
            return
        }
        UIView.animate(withDuration: 0.5,  delay: 0, options:.beginFromCurrentState,animations: {
            //start animation
            self.start_animation = true
            
            self.mainCateView?.isHidden = true
           
            
            
            if self.collpse {
                self.topConstraintCollectionView.constant = (self.searchProduct) ? 40 : 40 + self.sizeOfViewCateInit
            }else{
                self.topConstraintCollectionView.constant = (self.searchProduct) ? 40 : 40 + self.sizeOfViewCate
            }
            //self.view.layoutIfNeeded()
        }) { (completed) in
            //completed
            self.start_animation = false
        }
    }
    
    override func showView() {
        if self.start_animation {
            return
        }
        UIView.animate(withDuration: 0.5,  delay: 0, options:.beginFromCurrentState,animations: {
            //start animation
            self.start_animation = true

            self.mainCateView?.isHidden = false

            if self.collpse {
                self.topConstraintCollectionView.constant = (self.searchProduct) ? 40 : 130 + self.sizeOfViewCateInit
            }else{
                self.topConstraintCollectionView.constant = (self.searchProduct) ? 40 : 140 + self.sizeOfViewCate
            }
            
            //self.view.layoutIfNeeded()
        }) { (completed) in
            //completed
            self.start_animation = false

        }
    }
    var start_animation = false
    var collpse = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
        
      
    }

    func updateDataWillUpdate(){
        guard  let tab = self.tabBarController else {
            self.title = self.cateLists[self.loadDataByCateID]["name"] as? String ?? ""
            return
        }
        tab.title = cateName
        
        self.getItemToCart() { (itemCart) in
            var count = 0
            let cart_item = itemCart.first?["cart_item"] as? [[String:AnyObject]] ?? []
            for item in cart_item {
                let amount = item["amount"] as? NSNumber ?? 0
                count += amount.intValue
            }
            var userInfo:[String:String] = [:]
            if count >= 100 {
                userInfo = ["count" : "99+"]
            }else{
                userInfo = ["count" : "\(count)"]
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.DefaultConstansts.UPDATE_BADGE), object: nil, userInfo: userInfo)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateDataWillUpdate()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.loadDataByCateID > 0 {
            
            
            self.getSubCateByCate(self.loadDataByCateID) {
                self.addSubCate()
            }
            
            self.selectCateItem = self.loadDataByCateID
            self.selectedCategory(self.loadDataByCateID)
            
            self.cateId = self.loadDataByCateID
            self.subCateId = self.loadDataByCateID
            
            
            self.itemSection = ["recommend","filter","product"]
        }
    }
    
    private func getItemToCart(_ getSuccess:((_ itemCart:[[String:AnyObject]])->Void)? = nil){
        
        modelCtrl.getCart(params: nil , true , succeeded: { (result) in
            if let mResult = result as? [[String:AnyObject]] {
                getSuccess?(mResult)
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
    
    override func categoryTapped(sender: UITapGestureRecognizer) {
        super.categoryTapped(sender: sender)
        let tag = sender.view?.tag ?? 0
        self.cateId = tag
        self.subCateId = tag
        
        if tag == 0 {
            self.itemSection = ["filter","product"]
            self.cateName = NSLocalizedString("string-item-shopping-cate-all", comment: "")
        }else{
            self.itemSection = ["recommend","filter","product"]
            self.cateName = self.cateLists[tag]["name"] as? String ?? ""
        }
        
         self.productCollectionView?.contentOffset.y = 0
    }
    
    func setUp(){
        
        cateLists = [["name": NSLocalizedString("string-item-shopping-cate-1", comment: ""),
                      "image" : UIImage(named: "ic-shopping-cate-r-1")!],
                     ["name": NSLocalizedString("string-item-shopping-cate-2", comment: ""),
                      "image" : UIImage(named: "ic-shopping-cate-r-2")!],
                     ["name": NSLocalizedString("string-item-shopping-cate-3", comment: ""),
                      "image" : UIImage(named: "ic-shopping-cate-r-3")!],
                     ["name": NSLocalizedString("string-item-shopping-cate-4", comment: ""),
                      "image" : UIImage(named: "ic-shopping-cate-r-4")!],
                     ["name": NSLocalizedString("string-item-shopping-cate-5", comment: ""),
                      "image" : UIImage(named: "ic-shopping-cate-r-5")!],
                     ["name": NSLocalizedString("string-item-shopping-cate-6", comment: ""),
                      "image" : UIImage(named: "ic-shopping-cate-r-6")!]]
        
        
        
        self.searchCallback = { (keyword) in
            print("ketyword: \(keyword)")
            self.showSearchProductByKeyword(true, keyword : keyword)
        }
        
        self.collapseCallback = { (collpse) in
            self.collpse = collpse
            
            if collpse {
                self.topConstraintCollectionView.constant = 130 + self.sizeOfViewCateInit
            }else{
                self.topConstraintCollectionView.constant = 140 + self.sizeOfViewCate
            }
        }
        
        //start top
        self.topConstraintCollectionView.constant = 130 + self.sizeOfViewCateInit
        
        if let layout = self.productCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 10
  
        }
        
        self.productCollectionView.dataSource = self
        self.productCollectionView.delegate = self
        
        self.productCollectionView.showsVerticalScrollIndicator = false
        self.addRefreshViewController(self.productCollectionView)
        
        
        self.registerNib(self.productCollectionView, "SectionFilterCell")
        self.registerNib(self.productCollectionView, "RecommendCell")
        self.registerNib(self.productCollectionView, "ShoppingProductCell")
        self.registerHeaderNib(self.productCollectionView, "HeaderSectionCell")
        self.registerHeaderNib(self.productCollectionView, "ShoppingHeaderCell")
        self.registerHeaderNib(self.productCollectionView, "NotFoundItemCell")
        self.registerHeaderNib(self.productCollectionView, "ImageProductNotFoundCell")
        
        if self.loadDataByCateID > 0 {
            self.searchView?.removeFromSuperview()
            self.mainCateView?.removeFromSuperview()
            
            self.searchView = self.addSearchView()
            self.mainCateView =  self.addCategoryView(self.searchView!, allProduct: true)
            
            
            self.topConstraintCollectionView.constant = 140 + self.sizeOfViewCate
            self.collpse = false
            self.heightMainCategoryView?.constant = 95.0 + self.sizeOfViewCate
            self.mainCategoryView?.layoutIfNeeded()
            self.subCategoryCollectionView?.isHidden = false
            
        }else{
            self.callAPI(){
                self.searchView?.removeFromSuperview()
                self.mainCateView?.removeFromSuperview()
                
                self.searchView = self.addSearchView()
                self.mainCateView =  self.addCategoryView(self.searchView!, allProduct: true)
                
                self.productCollectionView.reloadData()
            }
        }
        
        
    }
    
    override func reloadData() {
        //get data by refresh
        
        self.callAPI(true){
            self.productCollectionView.reloadData()
        }
    }
    
     func callAPI(_ reload:Bool = false, _ loadSuccess:(()->Void)?  = nil){
        var success = 0

        self.loadingView?.showLoading()
        getRecommendByCate(reloadData: reload) {
            success += 1
            if success == 2 {
                loadSuccess?()
                self.loadingView?.hideLoading()
                self.refreshControl?.endRefreshing()
            }
        }
        getProductByCate() {
            success += 1
            if success == 2 {
                loadSuccess?()
                self.loadingView?.hideLoading()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    private  func getRecommendByCate(reloadData:Bool = false, _ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.cateItems != nil {
            isLoading = true
        }else{
            isLoading = true
        }
        
        if reloadData {
            isLoading = false
        }
        
        if self.cateId == 0 {
            avaliable?()
            return
        }
        modelCtrl.getReccommendByCateShopping(cateId: self.cateId, limit: 4,  false , succeeded: { (result) in
            
            if let mResult = result as? [[String:AnyObject]] {
                self.cateItems = mResult
                
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
    
    func getProductByCate(loadmore:Bool = false, _ avaliable:(()->Void)?  = nil){
        
        var isLoading:Bool = true
        if self.productItems != nil {
            isLoading = true
        }else{
            isLoading = true
        }
        
        if loadmore {
            isLoading = false
        }
       
        
        
        modelCtrl.getProductByCate(cateId: self.subCateId, skip: self.skipItem, type: self.sortBySelected, false , succeeded: { (result) in
            
            if let data = result as? [String:AnyObject]  {
                let total_amount = data["total"] as? Int ?? 0
                let mResult = data["result"] as? [[String:AnyObject]] ?? []
                //if let mResult = result as? [[String:AnyObject]] {
                self.total_amount = total_amount
               
                if self.isLoadmore == false {
                    self.productItems = mResult
                }else{
                    for item in mResult {
                        self.productItems?.append(item)
                    }
                }
                
                self.isLoadmore = false
                    
                //}
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
    
   override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            
            if let count =  self.productItems?.count {
                if count == skipItem {
                    return
                }
            }
            
            
            if !isLoadmore {
                isLoadmore = true
                print("load more ")
                
                self.skipItem = self.productItems?.count ?? 0
                getProductByCate(loadmore: false, {
                    
                    if let count =  self.productItems?.count {
                        if count > 0 {
                            if count == self.skipItem {
                                if let index = self.itemSection.firstIndex(of: "no_more_item") {
                                    self.itemSection.remove(at: index)
                                }
                                self.itemSection.append("no_more_item")
                            }
                        }
                        
                    }
                    
                    self.productCollectionView.reloadData()
                })
                
            }
        }
    }
    

}
extension ProductShoppingViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.sortBy.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch sortBy[row] {
        case "popular":
            return NSLocalizedString("string-item-shopping-sort-popuplar", comment: "")
        case "low":
            return NSLocalizedString("string-item-shopping-sort-low", comment: "")
        case "high":
            return NSLocalizedString("string-item-shopping-sort-high", comment: "")
        default:
            return ""
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch sortBy[row] {
        case "popular":
            sortBySelected = "popular"
            self.filterTextField?.text =  NSLocalizedString("string-item-shopping-sort-popuplar", comment: "")
        case "low":
            sortBySelected = "low"
            self.filterTextField?.text =  NSLocalizedString("string-item-shopping-sort-low", comment: "")
        case "high":
            sortBySelected = "high"
            self.filterTextField?.text =  NSLocalizedString("string-item-shopping-sort-high", comment: "")
        default:
            self.filterTextField?.text =  ""
        }
       
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @objc func pickerTapped(_ tapRecognizer:UITapGestureRecognizer){
        if tapRecognizer.state == .ended {
            let rowHeight = self.sortPickerView!.rowSize(forComponent: 0).height
            let selectedRowFrame = self.sortPickerView!.bounds.insetBy(dx: 0, dy: (self.sortPickerView!.frame.height - rowHeight) / 2)
            let userTappedOnSelectedRow = selectedRowFrame.contains(tapRecognizer.location(in: self.sortPickerView))
            if userTappedOnSelectedRow {
                let selectedRow = self.sortPickerView!.selectedRow(inComponent: 0)
                
                switch sortBy[selectedRow] {
                case "popular":
                    sortBySelected = "popular"
                    self.filterTextField?.text =  NSLocalizedString("string-item-shopping-sort-popuplar", comment: "")
                case "low":
                    sortBySelected = "low"
                    self.filterTextField?.text =  NSLocalizedString("string-item-shopping-sort-low", comment: "")
                case "high":
                    sortBySelected = "high"
                    self.filterTextField?.text =  NSLocalizedString("string-item-shopping-sort-high", comment: "")
                default:
                    self.filterTextField?.text =  ""
                }
                self.filterTextField?.resignFirstResponder()
          
            }
        }
    }
    
}

extension ProductShoppingViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView != productCollectionView {
            return super.numberOfSections(in: collectionView)
        }
       
        return self.itemSection.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView != productCollectionView {
            return super.collectionView(collectionView, numberOfItemsInSection: section)
        }

        
        switch self.itemSection[section] {
        case "recommend":
            guard let count = self.cateItems?.count, count > 0 else {
                return 0
            }
            return 1
            
        
        case "filter":
            return 1
            
        case "product":
            return self.productItems?.count ?? 0
            
        default:
            break
        }
        
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView != productCollectionView {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
        
        var cell:UICollectionViewCell?

        switch self.itemSection[indexPath.section] {
        case "no_more_item":
            
            if let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingProductCell", for: indexPath) as? ShoppingProductCell {
                cell = productCell
            }
            break
        case "recommend":
            if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as? RecommendCell {
                itemCell.recomendItems = self.cateItems
                itemCell.itemClickCallback = { (product) in
                    let id = product["id"] as? NSNumber ?? 0
                    let variant_status = product["variant_status"] as? String ?? ""
                    
                    if variant_status.lowercased() != "complete" {
                        self.showProductDetail(true, product_id: id.intValue)
                    }
                    
                }
                
                
                cell = itemCell
            }
            break
        case "filter":
            if let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionFilterCell", for: indexPath) as? SectionFilterCell {
                
                filterCell.filterTextField.autocorrectionType = .no
                filterCell.filterTextField.addDoneButtonToKeyboard()
                self.filterTextField = filterCell.filterTextField
                
                var countProduct = NSLocalizedString("string-item-shopping-cate-item-count", comment: "")
                countProduct += " \(self.total_amount ?? 0) "
                countProduct += NSLocalizedString("string-item-shopping-cate-item-count-list", comment: "")
                filterCell.headerNameLabel.text = countProduct
               
                cell = filterCell
            }
            break
        case "product":
            if let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingProductCell", for: indexPath) as? ShoppingProductCell {
                cell = productCell
                
                
                if let item = self.productItems?[indexPath.row] {
                    let title = item["title"] as? String ?? ""
                    let brand = item["brand"] as? [String:AnyObject] ?? [:]
                    let special_deal = item["special_deal"] as? [[String:AnyObject]] ?? [[:]]
                    let variant_status = item["variant_status"] as? String ?? ""
                    
                    if variant_status.lowercased() == "complete" {
                        productCell.soldOut = true
                    }else{
                        productCell.soldOut = false
                    }
                    
                    if special_deal.count == 0{
                        //check discount price
                        let regular_price = item["regular_price"] as? NSNumber ?? 0
                        let discount_price = item["discount_price"]  as? NSNumber ?? 0
                        
                        
                        
                        if discount_price.intValue > 0 {
                            let numberFormatter = NumberFormatter()
                            numberFormatter.numberStyle = .decimal
                            
                            let text = numberFormatter.string(from: regular_price) ?? "0"
                            let trail = NSLocalizedString("string-symbol-point-baht", comment: "")
                            
                            productCell.discountLabel.isHidden = false
                            productCell.discountLabel?.stuckCharacters( "\(text) \(trail)")
                            productCell.amountLabel.text = numberFormatter.string(from: discount_price)
                        }else{
                            let numberFormatter = NumberFormatter()
                            numberFormatter.numberStyle = .decimal
                            
                            productCell.discountLabel.isHidden = true
                            productCell.amountLabel.text = numberFormatter.string(from: regular_price)
                        }
                        
                        
                    }else{
                        //show special deal
                        let deal_price = special_deal.first?["deal_price"] as? NSNumber ?? 0
                        let price = special_deal.first?["price"]  as? NSNumber ?? 0
                        
                        let numberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = .decimal
                        
                        let text = numberFormatter.string(from: price) ?? "0"
                        let trail = NSLocalizedString("string-symbol-point-baht", comment: "")
                        
                        productCell.discountLabel.isHidden = false
                        productCell.discountLabel?.stuckCharacters( "\(text) \(trail)")
                        productCell.amountLabel.text = numberFormatter.string(from: deal_price)
                    }
                    
                    productCell.desLabel.text = title
                    
                    if let url = URL(string: getFullPathImageView(brand)) {
                        productCell.brandImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                    }
                    if let url = URL(string: getFullPathImageView(item)) {
                        productCell.productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                    }
                }
            }
            break
        default:
            break
        }
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }

        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != productCollectionView {
            super.collectionView(collectionView, didSelectItemAt: indexPath)
            
            
            if let subCate = self.dataItemSubCates?[indexPath.row] {
                let id = subCate["id"] as? NSNumber ?? 0
                self.subCateId = id.intValue
            }
          
            
            return
        }
        
        guard let count = self.productItems?.count  else {
            return
        }
        if  count > 0 {
            if let product = self.productItems?[indexPath.row] {
                let id = product["id"] as? NSNumber ?? 0
                let variant_status = product["variant_status"] as? String ?? ""
                
                if variant_status.lowercased() != "complete" {
                    self.showProductDetail(true, product_id: id.intValue)
                }
            }
        }
        
       
        
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView != productCollectionView {
            return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        }
        
        let width = self.productCollectionView.frame.width
        
        switch self.itemSection[indexPath.section] {
        case "recommend":
            let height = (width/2 - 15) + 110
            return CGSize(width: width, height: height)
        
        case "filter":
            guard let count = self.productItems?.count, count > 0 else {
                return CGSize.zero
            }
            let height = CGFloat(60.0)
            return CGSize(width: width, height: height)
            
        case "product":
            let height = (width/2 - 15) + 100
            return CGSize(width: width/2 - 15, height: height)
       
        case "no_more_item":
            let height = CGFloat(0)
            return CGSize(width: width, height: height)
        default:
            return CGSize.zero
        }
       
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == self.itemSection.count - 1 {
            return UIEdgeInsets(top: 0, left: 10, bottom: 60, right: 10)
        }
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func showProductNotFoundCell(_ collectionView: UICollectionView, kind:String,  indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NotFoundItemCell", for: indexPath) as! NotFoundItemCell
        header.nameLabel.text = NSLocalizedString("string-string-not-found-product", comment: "")
        return header
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView != productCollectionView {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        }
        
        switch self.itemSection[indexPath.section] {
        case "recommend":
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ShoppingHeaderCell", for: indexPath) as! ShoppingHeaderCell
            header.nameLabel.text = NSLocalizedString("string-item-shopping-cate-head-recommend",comment: "")
            header.bgImageView.image = UIImage(named: "ic-shopping-bg-recommend")
            return header
            
        case "filter":
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSectionCell", for: indexPath) as! HeaderSectionCell
            header.headerNameLabel.text = ""
            return header
            
        case "product":
            if let product = self.productItems {
                if product.count > 0 {
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSectionCell", for: indexPath) as! HeaderSectionCell
                    header.headerNameLabel.text = ""
                    return header
                }else{
                    if self.notFoundHeader == "NotFoundItemCell" {
                        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NotFoundItemCell", for: indexPath) as! NotFoundItemCell
                        
                        
                        header.nameLabel.text = NSLocalizedString("string-string-not-found-product", comment: "")
                        return header
                    }else{
                        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ImageProductNotFoundCell", for: indexPath) as! ImageProductNotFoundCell
                        header.nameLabel.text = NSLocalizedString("string-string-sesarch-not-found-product", comment: "")
                        return header
                    }
                }
            }
        
            
            /*
             
             */
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSectionCell", for: indexPath) as! HeaderSectionCell
            header.headerNameLabel.text = ""
            return header
           
            
        case "no_more_item":
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSectionCell", for: indexPath) as! HeaderSectionCell
            header.headerNameLabel.text = NSLocalizedString("string-item-shopping-no-more-item", comment: "")
            return header
            
        default:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSectionCell", for: indexPath) as! HeaderSectionCell
            header.headerNameLabel.text = ""
            return header
        }
        
        
    }

    
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if collectionView != productCollectionView {
            return super.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
        }
        
        let width = collectionView.frame.width
        let height = collectionView.frame.width/10*1

        switch self.itemSection[section] {
        case "recommend":
            guard let count = self.cateItems?.count, count > 0 else {
                return CGSize.zero
            }
            return CGSize(width: width, height: height)
            
            
        case "filter":
            guard let _ = itemSection.firstIndex(of: "recommend") else {
                return (self.searchProduct) ?  CGSize(width: width, height: CGFloat(15.0)) : CGSize.zero
            }
            return  CGSize(width: width, height: CGFloat(0.0))
            //return  CGSize(width: width, height: CGFloat(10.0))
            
        case "product":
            guard let count = self.productItems?.count, count > 0 else {
                return CGSize(width: width, height: self.sizeNotFoundHeader)
            }
            
            return CGSize.zero
        
        case "no_more_item":
            return CGSize(width: width, height: CGFloat(80.0))
        default:
            return CGSize.zero
        }
    }
    
    
}
