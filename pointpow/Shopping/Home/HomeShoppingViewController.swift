//
//  HomeShoppingViewController.swift
//  pointpow
//
//  Created by thanawat on 25/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class HomeShoppingViewController: ShoppingBaseViewController {

    @IBOutlet weak var productCollectionView: UICollectionView!
    
    @IBOutlet weak var topConstraintCollectionView: NSLayoutConstraint!
    
    var countSection = 0
    let cd = DateCountDownTimer()
    
    var banner:[[String:AnyObject]]?
    var hotRedemtion:[[String:AnyObject]]?
    var specialDeal:[[String:AnyObject]]?
    var cateItems:[[String:AnyObject]]?
    
    var searchView:UIView?
    var mainCateView:UIView?
    
    
    var cateId = 0 {
        didSet{
            getRecommendByCate {
                let indexSet = IndexSet(integer: 4)
                self.productCollectionView.reloadSections(indexSet)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cateLists = [["name": NSLocalizedString("string-item-shopping-cate-1", comment: ""),
                      "image" : UIImage(named: "ic-shopping-cate-1")!],
                     ["name": NSLocalizedString("string-item-shopping-cate-2", comment: ""),
                      "image" : UIImage(named: "ic-shopping-cate-2")!],
                     ["name": NSLocalizedString("string-item-shopping-cate-3", comment: ""),
                      "image" : UIImage(named: "ic-shopping-cate-3")!],
                     ["name": NSLocalizedString("string-item-shopping-cate-4", comment: ""),
                      "image" : UIImage(named: "ic-shopping-cate-4")!],
                     ["name": NSLocalizedString("string-item-shopping-cate-5", comment: ""),
                      "image" : UIImage(named: "ic-shopping-cate-5")!],
                     ["name": NSLocalizedString("string-item-shopping-cate-6", comment: ""),
                      "image" : UIImage(named: "ic-shopping-cate-6")!]]
        
        
        
        self.searchCallback = { (keyword) in
            print("ketyword: \(keyword)")
        }
        
        self.setUp()
        self.callAPI(){
            self.searchView?.removeFromSuperview()
            self.mainCateView?.removeFromSuperview()
            
            self.searchView = self.addSearchView()
            self.mainCateView =  self.addCategoryView(self.searchView!)
            
            self.countSection = 6
            self.productCollectionView.reloadData()
        }
    }
    
    func callAPI(_ reload:Bool = false, _ loadSuccess:(()->Void)?  = nil){
        var success = 0
        getBanner() {
            success += 1
            if success == 4 {
                loadSuccess?()
                self.refreshControl?.endRefreshing()
            }
        }
        getSpecial() {
            success += 1
            if success == 4 {
                loadSuccess?()
                self.refreshControl?.endRefreshing()
            }
        }
        getHotRedemption() {
            success += 1
            if success == 4 {
                loadSuccess?()
                self.refreshControl?.endRefreshing()
            }
        }
        getRecommendByCate(reloadData: reload) {
            success += 1
            if success == 4 {
                loadSuccess?()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    
    private  func getRecommendByCate(reloadData:Bool = false , _ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.cateItems != nil {
            isLoading = true
        }else{
            isLoading = true
        }
        if reloadData {
            isLoading = false
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
  
    private  func getBanner(_ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.banner != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        modelCtrl.getBannerShopping(params: nil , isLoading , succeeded: { (result) in
            
            if let mResult = result as? [[String:AnyObject]] {
                self.banner = mResult
                
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
    private  func getSpecial(_ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.specialDeal != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        modelCtrl.getSpecailDealShopping(params: nil , isLoading , succeeded: { (result) in
            
            if let mResult = result as? [[String:AnyObject]] {
                self.specialDeal = mResult
                
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
    private  func getHotRedemption(_ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.hotRedemtion != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        modelCtrl.getHotRedemptionShopping(params: nil , isLoading , succeeded: { (result) in
            
            if let mResult = result as? [[String:AnyObject]] {
                self.hotRedemtion = mResult
                
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = NSLocalizedString("string-title-shopping-home", comment: "")
    }
    
    
    override func categoryTapped(sender: UITapGestureRecognizer) {
        //let tag = sender.view?.tag
        //print(tag)
    }
    func setUp(){
        //start top
        self.topConstraintCollectionView.constant = 130.0 + self.sizeOfViewCateInit
        
        if let layout = self.productCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 10
            
        }
        
        
        self.productCollectionView.dataSource = self
        self.productCollectionView.delegate = self
        
        self.productCollectionView.showsVerticalScrollIndicator = false
        self.addRefreshViewController(self.productCollectionView)
        
        
        self.registerNib(self.productCollectionView, "PageViewFooterCollectionViewCell")
        self.registerNib(self.productCollectionView, "Recommend2Cell")
        self.registerNib(self.productCollectionView, "PageViewCollectionViewCell")
        self.registerNib(self.productCollectionView, "BannerShoppingCell")
        self.registerNib(self.productCollectionView, "RecommendCell")
        self.registerNib(self.productCollectionView, "ShoppingProductCell")
        self.registerHeaderNib(self.productCollectionView, "HeaderSectionCell")
        self.registerHeaderNib(self.productCollectionView, "SpecialHeaderCell")
        self.registerHeaderNib(self.productCollectionView, "ShoppingHeaderCell")
        
    }
    
    override func reloadData() {
        //get data by refresh
        self.callAPI(true){
            self.searchView?.removeFromSuperview()
            self.mainCateView?.removeFromSuperview()
            
            self.searchView = self.addSearchView()
            self.mainCateView =  self.addCategoryView(self.searchView!)
            
            self.countSection = 6
            self.productCollectionView.reloadData()
        }
    }
}


extension HomeShoppingViewController {
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
            return 1
            
        case 1:
            return 1
        
        case 2:
            return 1
       
        case 3:
            return 1
            
        case 4:
            return self.cateItems?.count ?? 0
            
        case 5:
            return 1
            
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
            if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerShoppingCell", for: indexPath) as? BannerShoppingCell {
                
                itemCell.itemBanner = self.banner
                itemCell.autoSlideImage = true
                
                cell = itemCell
            }
            break
            
        case 1:
            if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as? RecommendCell {
                itemCell.recomendItems = self.specialDeal
                itemCell.itemClickCallback = { (product) in
                    //self.showProductDetail(true, product_id: "")
                }
                
                cell = itemCell
            }
            break
        case 2:
            if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Recommend2Cell", for: indexPath) as? Recommend2Cell {
                itemCell.recomendItems = self.hotRedemtion
                itemCell.itemClickCallback = { (product) in
                    //self.showProductDetail(true, product_id: "")
                }
                cell = itemCell
            }
            break
        case 3:
            if let pageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageViewCollectionViewCell", for: indexPath) as? PageViewCollectionViewCell {

              
                pageCell.selectedCallback  = { (cateId) in
                    self.cateId = cateId
                }
                cell = pageCell
            }
            break
        case 4:
            if let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingProductCell", for: indexPath) as? ShoppingProductCell {
                cell = productCell
                
                
                if let item = self.cateItems?[indexPath.row] {
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
        case 5:
            if let moreCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageViewFooterCollectionViewCell", for: indexPath) as? PageViewFooterCollectionViewCell {
                
                cell = moreCell
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
            let width = collectionView.frame.width
            let height = width/950*400
            return CGSize(width: width, height: height)
            
        case 1:
            let height = (width/2 - 15) + 110
            return CGSize(width: width, height: height)
        case 2:
            let height = CGFloat(160) //(width/2 - 15) + 100
            return CGSize(width: width, height: height)
        case 3:
            let height = 90.0 + self.sizeOfViewCateInit
            return CGSize(width: width - 10, height: height)
        case 4:
            let height = (width/2 - 15) + 110
            return CGSize(width: width/2 - 15, height: height)
        case 5:
            let width = collectionView.frame.width - 40
            let height = CGFloat(40)
            return CGSize(width: width, height: height)
        default:
            break
        }
        let height = (width/2 - 15) + 100
        return CGSize(width: width/2 - 15, height: height)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
       
        if section == 3 {
            return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        }
        if section == 4 {
            return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        }
        if section == 5 {
            return UIEdgeInsets(top: 30, left: 10, bottom: 60, right: 10)
        }
       
        
        return UIEdgeInsets.zero
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView != productCollectionView {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        }
        
       
        
        switch indexPath.section {
        case 1:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SpecialHeaderCell", for: indexPath) as! SpecialHeaderCell
            
            header.headerLabel.text = NSLocalizedString("string-item-shopping-cate-head-special-deal",
                                                            comment: "")
            
            if !self.cd.running {
                
                cd.initializeTimer("2019-07-10 00:00:00")
                cd.startTimer(pUpdateActionHandler: { (timeString) in
                    
                    
                    header.hoursLabel.text = timeString.hours
                    header.minLabel.text = timeString.minutes
                    header.secLabel.text = timeString.seconds
                    
                }) {

                    header.hoursLabel.text = "00"
                    header.minLabel.text = "00"
                    header.secLabel.text = "00"
                    
                }
            }
            
            return header
        case 2,3:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ShoppingHeaderCell", for: indexPath) as! ShoppingHeaderCell
            
            
            if indexPath.section == 2 {
                header.nameLabel.text = NSLocalizedString("string-item-shopping-cate-head-hot-redemption",
                                                                comment: "")
                header.bgImageView.image = UIImage(named: "ic-shopping-bg-hot-redemption")
            }
            if indexPath.section == 3 {
                header.nameLabel.text = NSLocalizedString("string-item-shopping-cate-head-recommend",
                                                                comment: "")
                header.bgImageView.image = UIImage(named: "ic-shopping-bg-recommend")
            }
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
        
        switch section {
        case 0,4,5:
            return CGSize.zero
        case 1:
            return CGSize(width: collectionView.frame.width, height: 50.0)
            
        case 2,3:
            let width = collectionView.frame.width
            let height = collectionView.frame.width/10*1  //CGFloat(50.0)
            return CGSize(width: width, height: height)
        default:
            return CGSize.zero
        }
        
    }
}
