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
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    
    var timer:Timer? = nil
    var x = 0
    var count = 0
    
    var itemBanner:[[String:AnyObject]]?{
        didSet{
            print(itemBanner ?? "no item")
            self.count = itemBanner?.count ?? 0
            if count > 1 {
                self.pageControl.numberOfPages = count
            }
            self.imageCollectionView.reloadData()
        }
    }
    
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
            timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(autoScroll), userInfo: nil,  repeats: true)
        }
        
    }
    @objc func autoScroll(){
        self.pageControl.currentPage = x
        if self.x < count {
            let indexPath = IndexPath(item: x, section: 0)
            self.imageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.x += 1
        } else {
            
            self.x = 0
            
            self.pageControl.currentPage = x
            self.imageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  NSLocalizedString("string-title-product-detail", comment: "")
        
        self.setUp()
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        
        self.pageControl.numberOfPages = 0
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        self.imageCollectionView.showsHorizontalScrollIndicator  = false
        self.registerNib(self.imageCollectionView, "ImageCell")
        
        
        self.productRelatedCollectionView.delegate = self
        self.productRelatedCollectionView.dataSource = self
        self.productRelatedCollectionView.showsHorizontalScrollIndicator  = false
        self.registerNib(self.productRelatedCollectionView, "RecommendCell")
        
        
        // MOCK DATA
        self.itemBanner = [["path_mobile" : "https://f.btwcdn.com/store-37976/product/bd496fb4-9a37-819c-45cc-5c9ca51af10d.jpg"],
                           ["path_mobile" : "https://f.btwcdn.com/store-37976/product-thumb/dad5aa1e-b42c-215d-b283-5c9ca53d3d9b.jpg"]] as [[String : AnyObject]]
        self.autoSlideImage = true
        
        
        // MOCK DATA
        var htmlCode = "<html><head><style> body { font-family:\"\(Constant.Fonts.THAI_SANS_BOLD)\"; font-size: \(Constant.Fonts.Size.CONTENT_HTML);} </style></head><body>"
        
        htmlCode += "<br><p>แอนเนสซ่า เพอร์เฟ็ค ยูวี ซันสกีน สกินแคร์ มิลค์ เอสพีเอฟ 50+ พีเอ++++ 60มล  ครีมกันแดดสูตรน้ำนม เนื้อบางเบา ไม่เหนียวเหนอะหนะ กันน้ำ กันเหงื่อ ช่วยปกป้องผิวจากรังสี UVA และ UVB ด้วยค่า SPF50+/PA++++ พร้อมฟื้นฟูผิวจากการทำร้ายของแสงแดดในขั้นตอนเดียว เหมาะสำหรับกิจกรรมกลางแจ้งและในน้ำ</p><img width=100% src=\"https://f.btwcdn.com/store-37976/product/bd496fb4-9a37-819c-45cc-5c9ca51af10d.jpg\"><br><br><p>คุณสมบัติโดดเด่น</p><p>- สูตรน้ำนม เนื้อบางเบา ไม่เหนียวเหนอะหนะ</p><p>- กันน้ำ กันเหงื่อ เหมาะกับผิวหน้าและผิวกาย</p><p>- ปกป้องผิวจากรังสี UVA และ UVB ด้วยค่า SPF50+/PA++++</p><p>- ฟื้นบำรุงผิวหมองคล้ำจากแสงแดด</p><p>- สามารถใช้ได้ทั้งในชีวิตประจำวัน การเล่นกีฬากลางแจ้งหรือการว่ายน้ำ</p><p>- ใช้เป็นเมคอัพเบส ช่วยให้การแต่งหน้าเนียนเรียบ ติดทนนาน</p><br><p>วิธีการใช้งาน</p><p>เขย่าขวดก่อนใช้ เกลี่ยผลิตภัณฑ์ให้ทั่วใบหน้าและลำคอหลังการบำรุงผิว สามารถทาซ้ำได้ระหว่างวัน ล้างออกด้วยผลิตภัณฑ์ล้างหน้า</p><br><p>ส่วนประกอบ</p><p>Dimethi:one, Water, Alcohol, zinc ide, Ethylhexyl ate, Talc,</p> <p>Iscpropyl myristate, Methyl Methacrylate cross. opantasiloxana,</p> <p>Isododecane, octocrylene, Titanium Dioxide, Methoryci lymer,</p> <p>Hydroxy benzoyl Hexyl Benzoate, PEG-9 Polydimethylsilory. saa ethy amino sebacate,</p><p>Glycerin, silica, DImethicone, Dextrin Falmiitate, Diisopropyl PPG-17,</p><p>viny Dimethicone/Methicone Silsesquioxane Crosspolymer,xylitol, Triethory Trinnethylsiloxysilicate</p>"
        
        htmlCode += "</body></html>"
        
        self.detailWebview.loadHTMLString(htmlCode, baseURL: nil)
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
        
    
    
        let width = self.view.frame.width
        let height = (width/2 - 15) + 100
        self.heightProductRelatedConstraint.constant = height
        
        
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.detailWebview.frame.size = webView.scrollView.contentSize
        let height = webView.scrollView.contentSize.height
        self.heightConstraintWebview.constant = height
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       
        self.lessImageView.ovalColorClearProperties()
        self.moreImageView.ovalColorClearProperties()
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
            return 1
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if collectionView == self.productRelatedCollectionView {
           if let relatedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as?  RecommendCell {
                cell = relatedCell
            }
            return cell!
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
            print("related item ")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.productRelatedCollectionView {
            let width = collectionView.frame.width
            let height = self.heightProductRelatedConstraint.constant
            return CGSize(width: width, height: height)
        }
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
    }
    
    
}

