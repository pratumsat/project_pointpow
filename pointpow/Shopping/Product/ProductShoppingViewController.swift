//
//  ProductShoppingViewController.swift
//  pointpow
//
//  Created by thanawat on 25/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ProductShoppingViewController: ShoppingBaseViewController {

    @IBOutlet weak var productCollectionView: UICollectionView!
    
    @IBOutlet weak var topConstraintCollectionView: NSLayoutConstraint!
    
    var countSection = 0 {
        didSet{
            self.productCollectionView.reloadData()
        }
    }
    
    
    var cateName = NSLocalizedString("string-item-shopping-cate-all", comment: "") {
        didSet{
            self.tabBarController?.title = cateName
        }
    }
    var initHeightViewCate = CGFloat(130.0)
    
    var searchView:UIView?
    var mainCateView:UIView?
    
    var cateItems:[[String:AnyObject]]?
    var productItems:[[String:AnyObject]]?
    
    var cateId = 0 {
        didSet{
            
            getRecommendByCate {
                
                let indexSet = IndexSet(integer: 0)
                self.productCollectionView.reloadSections(indexSet)
            }
        }
    }
    
    var typeProduct = "popular"
    var skipItem = 0
    
    var subCateId = 0 {
        didSet{
            getProductByCate() {
                
                
                if self.subCateId == 0 {
                    let indexSet = IndexSet(integer: 0)
                    self.productCollectionView.reloadSections(indexSet)
                }else{
                    let indexSet = IndexSet(integer: 1)
                    self.productCollectionView.reloadSections(indexSet)
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        }
        
        self.collapseCallback = { (collpse) in
            if collpse {
                self.countSection = 1
                self.topConstraintCollectionView.constant = self.initHeightViewCate + self.sizeOfViewCateInit
            }else{
                self.countSection = 2
                self.topConstraintCollectionView.constant = self.initHeightViewCate + self.sizeOfViewCate
            }
        }
        
        
        self.setUp()
        self.callAPI(){
            self.searchView?.removeFromSuperview()
            self.mainCateView?.removeFromSuperview()
            
            self.searchView = self.addSearchView()
            self.mainCateView =  self.addCategoryView(self.searchView!, allProduct: true)
            
            self.countSection = 1
            self.productCollectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = cateName
    }
    
    override func categoryTapped(sender: UITapGestureRecognizer) {
        super.categoryTapped(sender: sender)
        let tag = sender.view?.tag ?? 0
        self.cateId = tag
        self.subCateId = tag
        
        
        if tag == 0 {
            self.cateName = NSLocalizedString("string-item-shopping-cate-all", comment: "")
        }else{
            self.cateName = self.cateLists[tag]["name"] as? String ?? ""
        }
        
    }
    
    func setUp(){
        //start top
        self.topConstraintCollectionView.constant = self.initHeightViewCate + self.sizeOfViewCateInit
        
        if let layout = self.productCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 10
  
        }
        
        self.productCollectionView.dataSource = self
        self.productCollectionView.delegate = self
        
        self.productCollectionView.showsVerticalScrollIndicator = false
        self.addRefreshViewController(self.productCollectionView)
        
        
        
        self.registerNib(self.productCollectionView, "RecommendCell")
        self.registerNib(self.productCollectionView, "ShoppingProductCell")
        self.registerHeaderNib(self.productCollectionView, "HeaderSectionCell")
        self.registerHeaderNib(self.productCollectionView, "ShoppingHeaderCell")
        self.registerHeaderNib(self.productCollectionView, "NotFoundItemCell")
    }
    
    override func reloadData() {
        //get data by refresh
        
        self.callAPI(true){
            self.productCollectionView.reloadData()
        }
    }
    
    private func callAPI(_ reload:Bool = false, _ loadSuccess:(()->Void)?  = nil){
        var success = 0

        getRecommendByCate(reloadData: reload) {
            success += 1
            if success == 2 {
                loadSuccess?()
                self.refreshControl?.endRefreshing()
            }
        }
        getProductByCate() {
            success += 1
            if success == 2 {
                loadSuccess?()
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
        modelCtrl.getReccommendByCateShopping(cateId: self.cateId, limit: 4,  isLoading , succeeded: { (result) in
            
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
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
            self.refreshControl?.endRefreshing()
        }
        
    }
    
    private  func getProductByCate(reloadData:Bool = false, _ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.productItems != nil {
            isLoading = true
        }else{
            isLoading = true
        }
        
        if reloadData {
            isLoading = false
        }
       
        
        modelCtrl.getProductByCate(cateId: self.subCateId, skip: self.skipItem, type: self.typeProduct, isLoading , succeeded: { (result) in
            
            if let mResult = result as? [[String:AnyObject]] {
                self.productItems = mResult
                
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

}


extension ProductShoppingViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView != productCollectionView {
            return super.numberOfSections(in: collectionView)
        }
        return self.countSection
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView != productCollectionView {
            return super.collectionView(collectionView, numberOfItemsInSection: section)
        }
        
        switch section {
        case 0:
            if self.countSection == 1 {
                return productItems?.count ?? 0
            }else{
                return 1
            }
            
        case 1:
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

        
        switch indexPath.section {
        case 0:
            if self.countSection == 1 {
                if let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingProductCell", for: indexPath) as? ShoppingProductCell {
                    cell = productCell
                    
                    if let item = self.productItems?[indexPath.row] {
                        let title = item["title"] as? String ?? ""
                        let brand = item["brand"] as? [String:AnyObject] ?? [:]
                        let special_deal = item["special_deal"] as? [[String:AnyObject]] ?? [[:]]
                        
                        
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
                            productCell.brandImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.BANNER_HOME_PLACEHOLDER))
                        }
                        if let url = URL(string: getFullPathImageView(item)) {
                            productCell.productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.BANNER_HOME_PLACEHOLDER))
                        }
                    }
                }
            }else{
                if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as? RecommendCell {
                    itemCell.recomendItems = self.cateItems
                    itemCell.itemClickCallback = { (product) in
                        //self.showProductDetail(true, product_id: "")
                    }
                    

                    cell = itemCell
                }

            }
            
            break
            
        case 1:
            if let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingProductCell", for: indexPath) as? ShoppingProductCell {
                cell = productCell
               
                
                if let item = self.productItems?[indexPath.row] {
                    let title = item["title"] as? String ?? ""
                    let brand = item["brand"] as? [String:AnyObject] ?? [:]
                    let special_deal = item["special_deal"] as? [[String:AnyObject]] ?? [[:]]
                    
                    
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
                        productCell.brandImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.BANNER_HOME_PLACEHOLDER))
                    }
                    if let url = URL(string: getFullPathImageView(item)) {
                        productCell.productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.BANNER_HOME_PLACEHOLDER))
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
        
        print("production select \(indexPath.row)")
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView != productCollectionView {
            return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        }
        
        let width = self.productCollectionView.frame.width
        
        switch indexPath.section {
        case 0:
            if self.countSection > 1 {
                let height = (width/2 - 15) + 110
                return CGSize(width: width, height: height)
            }
        default:
            break
        }
        let height = (width/2 - 15) + 100
        return CGSize(width: width/2 - 15, height: height)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == self.countSection - 1 {
            return UIEdgeInsets(top: 0, left: 10, bottom: 60, right: 10)
        }
        
        return UIEdgeInsets.zero
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView != productCollectionView {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        }
        
        
        
        switch indexPath.section {
        case 0:
            if self.countSection == 1 {
                guard let count = self.productItems?.count, count > 0 else {
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NotFoundItemCell", for: indexPath) as! NotFoundItemCell
                    header.nameLabel.text = NSLocalizedString("string-string-not-found-product", comment: "")
                    return header
                }
                
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSectionCell", for: indexPath) as! HeaderSectionCell
                header.headerNameLabel.text = self.cateName
                return header
            }else{
                
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ShoppingHeaderCell", for: indexPath) as! ShoppingHeaderCell
                header.nameLabel.text = NSLocalizedString("string-item-shopping-cate-head-recommend",comment: "")
                header.bgImageView.image = UIImage(named: "ic-shopping-bg-recommend")
                return header
            }
            
            
        case 1:
            guard let count = self.productItems?.count, count > 0 else {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NotFoundItemCell", for: indexPath) as! NotFoundItemCell
                header.nameLabel.text = NSLocalizedString("string-string-not-found-product", comment: "")
                return header
            }
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSectionCell", for: indexPath) as! HeaderSectionCell
            header.headerNameLabel.text = self.cateName
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
        let height = collectionView.frame.width/10*1  //CGFloat(50.0)
        return CGSize(width: width, height: height)
        
    }
    
}
