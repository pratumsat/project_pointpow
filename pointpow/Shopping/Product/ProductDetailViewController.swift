//
//  ProductDetailViewController.swift
//  pointpow
//
//  Created by thanawat on 1/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import WebKit

class ProductDetailViewController: BaseViewController  , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIWebViewDelegate {

    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var disCountLabel: UILabel!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var relatedTitleLabel: UILabel!
    @IBOutlet weak var heightProductRelatedConstraint: NSLayoutConstraint!
    @IBOutlet weak var productRelatedCollectionView: UICollectionView!
    @IBOutlet weak var mscrollView: UIScrollView!
    @IBOutlet weak var heightConstraintWebview: NSLayoutConstraint!
    @IBOutlet weak var detailWebview: UIWebView!
    @IBOutlet weak var lessImageView: UIImageView!
    @IBOutlet weak var moreImageView: UIImageView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    
    var timer:Timer? = nil
    var x = 1
    var count = 0
    var productItems:[[String:AnyObject]]?
    var productDetail:[[String:AnyObject]]?
    var productImage:[[String:AnyObject]]?
    var product_id:Int?
    
    
    
    var itemBanner:[[String:AnyObject]]?
    
    var luckyDrawCallback:(()->Void)?
    
    var autoSlideImage = false {
        didSet{
            if autoSlideImage {
                setTimer()
            }
        }
    }
    func setTimer() {
        if self.x < count {
            timer?.invalidate()
            timer = nil
            timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(autoScroll), userInfo: nil,  repeats: true)
        }
        
    }
    @objc func autoScroll(){
        
        
        if self.x < count {
            let indexPath = IndexPath(item: x, section: 0)
            self.imageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            self.x += 1
            self.pageLabel.text = "\(x)/\(count)"
        } else {
            
            self.x = 1
            self.pageLabel.text = "\(x)/\(count)"
            
            self.imageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        }
        
     
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  NSLocalizedString("string-title-product-detail", comment: "")
        
        self.setUp()
        
       
        self.callAPI {
            //update detail
            self.updateViewProductDetail()
           
            //update related product
           self.updateViewProductRelated()
            
            //update image
            self.updateProductImage()
        }
    }
    func updateProductImage(){
        
        
        if let mResult = self.productImage {
            self.itemBanner = []
            for item in mResult {
                let type = item["type"] as? String ?? ""
                if type.lowercased() == "big_thumb" {
                    self.itemBanner?.append(["path_mobile" : getFullPathImageView(item) as AnyObject])
                }
            }
        }
        self.count = itemBanner?.count ?? 0
        self.pageLabel.text = "\(x)/\(count)"
        
        //self.autoSlideImage = true
        self.imageCollectionView.reloadData()
    }
    
    
    
    func updateViewProductDetail(){
        if let item = self.productDetail?.first {
            let title = item["title"] as? String ?? ""
            let description = item["description"] as? String ?? ""
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
                    
                    disCountLabel.isHidden = false
                    disCountLabel?.stuckCharacters( "\(text) \(trail)")
                    priceLabel.text = numberFormatter.string(from: discount_price)
                }else{
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    
                    disCountLabel.text = ""
                    disCountLabel.isHidden = true
                    priceLabel.text = numberFormatter.string(from: regular_price)
                }
                
            }else{
                //show special deal
                let deal_price = special_deal.first?["deal_price"] as? NSNumber ?? 0
                let price = special_deal.first?["price"]  as? NSNumber ?? 0
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                let text = numberFormatter.string(from: price) ?? "0"
                let trail = NSLocalizedString("string-symbol-point-baht", comment: "")
                
                disCountLabel.isHidden = false
                disCountLabel?.stuckCharacters( "\(text) \(trail)")
                priceLabel.text = numberFormatter.string(from: deal_price)
            }
            
            var htmlCode = "<html><head><style> body { font-family:\"\(Constant.Fonts.THAI_SANS_REGULAR)\"; font-size: \(Constant.Fonts.Size.CONTENT_HTML);} </style></head><body>"
            htmlCode += description
            htmlCode += "</body></html>"
            self.detailWebview.loadHTMLString(htmlCode, baseURL: nil)
            
            self.productNameLabel.text = title
            
            if let url = URL(string: getFullPathImageView(brand)) {
                self.brandImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
            }
            
        }
       
    }
    func updateViewProductRelated(){
        guard let count = self.productItems?.count else {
            self.heightProductRelatedConstraint.constant = 0
            self.relatedTitleLabel.isHidden = true
            return
        }
        if count > 0 {
            let width = self.view.frame.width
            let height = (width/2 - 15) + 120
            self.heightProductRelatedConstraint.constant = height*2
            self.productRelatedCollectionView.reloadData()
            self.relatedTitleLabel.isHidden = false
        }else{
            self.heightProductRelatedConstraint.constant = 0
            self.relatedTitleLabel.isHidden = true
        }
    }
    
    override func reloadData() {
        self.callAPI {
            //update detail
            self.updateViewProductDetail()
            
            //update related product
            self.updateViewProductRelated()
            
            //update image
            self.updateProductImage()
        }
    }
    
    func callAPI(_ loadSuccess:(()->Void)?  = nil){
        var success = 0
        
        self.getProductDetail(){
            success += 1
            if success == 3 {
                loadSuccess?()
                self.refreshControl?.endRefreshing()
            }
            
        }
        
        self.getProductRelated {
            success += 1
            if success == 3 {
                loadSuccess?()
                self.refreshControl?.endRefreshing()
            }
            
        }
        
        self.getProductImage() {
            success += 1
            if success == 3 {
                loadSuccess?()
                self.refreshControl?.endRefreshing()
            }
            
        }
    }
    
    func setUp(){
        self.addRefreshScrollViewController(self.mscrollView)
        
        self.backgroundImage?.image = nil
        
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        self.imageCollectionView.showsHorizontalScrollIndicator  = false
        self.registerNib(self.imageCollectionView, "ImageCell")
        
        
        self.productRelatedCollectionView.delegate = self
        self.productRelatedCollectionView.dataSource = self
        self.productRelatedCollectionView.showsHorizontalScrollIndicator  = false
        self.registerNib(self.productRelatedCollectionView, "ShoppingProductCell")
        
        
        
        self.detailWebview.delegate = self
        
        
        self.amountTextField.borderRedColorProperties(borderWidth: 1)
        
        let less = UITapGestureRecognizer(target: self, action: #selector(lessPointTapped))
        self.lessImageView.isUserInteractionEnabled = true
        self.lessImageView.addGestureRecognizer(less)
        
        
        let more = UITapGestureRecognizer(target: self, action: #selector(morePointTapped))
        self.moreImageView.isUserInteractionEnabled = true
        self.moreImageView.addGestureRecognizer(more)
        
        
        self.amountTextField.delegate = self
        self.amountTextField.autocorrectionType = .no
        self.amountTextField.text = "1"
        
    }
    
    
    private  func getProductDetail(_ avaliable:(()->Void)?  = nil){
        
        var isLoading:Bool = true
        if self.productDetail != nil {
            isLoading = true
        }else{
            isLoading = true
        }
        
        modelCtrl.getProductDetailById(productId: self.product_id!, isLoading , succeeded: { (result) in
            
            if let mResult = result as? [[String:AnyObject]] {
                self.productDetail = mResult
                
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
    
    
    private  func getProductImage(_ avaliable:(()->Void)?  = nil){
        
        var isLoading:Bool = true
        if self.productImage != nil {
            isLoading = true
        }else{
            isLoading = true
        }
        
        modelCtrl.getProductImageById(productId: self.product_id!, isLoading , succeeded: { (result) in
            
            if let mResult = result as? [[String:AnyObject]] {
                self.productImage = mResult
                
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
    
    private  func getProductRelated(_ avaliable:(()->Void)?  = nil){
        
        var isLoading:Bool = true
        if self.productItems != nil {
            isLoading = true
        }else{
            isLoading = true
        }
        
        modelCtrl.getProductRelatedByID(productId: self.product_id!, isLoading , succeeded: { (result) in
            
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
            self.relatedTitleLabel.isHidden = true
            self.heightProductRelatedConstraint.constant = 0
            self.refreshControl?.endRefreshing()
            print(error)
        }) { (messageError) in
            print("messageError")
            self.relatedTitleLabel.isHidden = true
            self.heightProductRelatedConstraint.constant = 0
            self.handlerMessageError(messageError)
            self.refreshControl?.endRefreshing()
        }
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.detailWebview.frame.size = webView.scrollView.contentSize
        let height = webView.scrollView.contentSize.height
        print("html height =  \(height)")
        self.heightConstraintWebview.constant = height
        self.view.layoutIfNeeded()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       
        self.lessImageView.ovalColorClearProperties()
        self.moreImageView.ovalColorClearProperties()
        self.pageView.borderClearProperties()
    }
    
   
    
    @objc func lessPointTapped() {
        let updatedText = self.amountTextField.text!
        
        var amount = 0.0
        if let iPoint = Int(updatedText.replace(target: ",", withString: "")){
            amount = Double(iPoint)
        }
        amount -= 1
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.minimumFractionDigits = 0
        
        self.amountTextField.text = numberFormatter.string(from: NSNumber(value: amount))
        
        if amount <= 1 {
            self.amountTextField.text = "1"
            disableImageView(self.lessImageView)
        }else{
            enableImageView(self.lessImageView)
        }
        
        
    }
    @objc func morePointTapped() {
        let updatedText = self.amountTextField.text!
        
        var amount = 0.0
        if let iPoint = Int(updatedText.replace(target: ",", withString: "")){
            amount = Double(iPoint)
        }
        
        amount += 1
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.minimumFractionDigits = 0
        
        self.amountTextField.text = numberFormatter.string(from: NSNumber(value: amount))
        
        enableImageView(self.lessImageView)
        
        
    }
    
    
    func disableImageView(_ image:UIImageView){
        //image.ovalColorClearProperties()
        image.backgroundColor = UIColor.groupTableViewBackground
        image.isUserInteractionEnabled = false
    }
    func enableImageView(_ image:UIImageView){
        //image.ovalColorClearProperties()
        image.backgroundColor = Constant.Colors.PRIMARY_COLOR
        image.isUserInteractionEnabled = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.amountTextField {
            guard let textRange = Range(range, in: textField.text!) else { return true}
            var updatedText = textField.text!.replacingCharacters(in: textRange, with: string)
            
            
            if updatedText.isEmpty {
                updatedText = "1"
            }
            if let iPoint = Int(updatedText.replace(target: ",", withString: "")){
                let amount = Double(iPoint)
                if amount <= 1 {
                    disableImageView(self.lessImageView)
                }else{
                    enableImageView(self.lessImageView)
                }
                
                
                if let iPoint = Int(updatedText.replace(target: ",", withString: "")){
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .none
                    
                    textField.text = numberFormatter.string(from: NSNumber(value: iPoint))
                    return false
                }
            }else{
                return false
            }
            
            
        }
        return true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.productRelatedCollectionView {
            return self.productItems?.count ?? 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if collectionView == self.productRelatedCollectionView {
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
                        productCell.brandImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                    }
                    if let url = URL(string: getFullPathImageView(item)) {
                        productCell.productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                    }
                }
                
                return cell!
            }
        }
        
        if let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell {
            cell = imageCell
            
            if let itemData = self.itemBanner?[indexPath.row] {
                let path = itemData["path_mobile"] as? String ?? ""
                
                if let url = URL(string: path) {
                    imageCell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.BANNER_HOME_PLACEHOLDER))
                }
            }
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.productRelatedCollectionView {
           
            if let product = self.productItems?[indexPath.row] {
                let id = product["id"] as? NSNumber ?? 0
                self.showProductDetail(true, product_id: id.intValue)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.productRelatedCollectionView {
            return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        }
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.productRelatedCollectionView {
            let width = collectionView.frame.width
            let height = (width/2 - 15) + 100
            
            return CGSize(width: width/2 - 15, height: height)
            
        }
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        self.x = Int(pageNumber + 1)
        self.pageLabel.text = "\(x)/\(count)"
    }
    
    
}

