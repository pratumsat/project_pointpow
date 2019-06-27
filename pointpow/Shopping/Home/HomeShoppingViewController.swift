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
    
    var countSection = 5
    let cd = DateCountDownTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchView = self.addSearchView()
        self.addCategoryView(searchView)
        
        self.searchCallback = { (keyword) in
            print("ketyword: \(keyword)")
        }
        
        
        self.setUp()
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = NSLocalizedString("string-item-shopping", comment: "")
    }
    
    
    override func categoryTapped(sender: UITapGestureRecognizer) {
        //let tag = sender.view?.tag
        //print(tag)
    }
    func setUp(){
        //start top
        self.topConstraintCollectionView.constant = 120.0 + self.sizeOfViewCateInit
        
        if let layout = self.productCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 10
            
        }
        
        
        self.productCollectionView.dataSource = self
        self.productCollectionView.delegate = self
        
        self.productCollectionView.showsVerticalScrollIndicator = false
        self.addRefreshViewController(self.productCollectionView)
        
        
        self.registerNib(self.productCollectionView, "PageViewCollectionViewCell")
        self.registerNib(self.productCollectionView, "BannerShoppingCell")
        self.registerNib(self.productCollectionView, "RecommendCell")
        self.registerNib(self.productCollectionView, "ShoppingProductCell")
        self.registerHeaderNib(self.productCollectionView, "HeaderSectionCell")
        self.registerHeaderNib(self.productCollectionView, "SpecialHeaderCell")
        
    }
    
    override func reloadData() {
        //get data by refresh
        self.refreshControl?.endRefreshing()
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
            return 8
            
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
                
                itemCell.itemBanner = [["path_mobile" : "http://103.27.201.106/dev-pointpow/imageservice/public/storage/banner/2019/05/banner_11bcd6d6dd4e24bd68e864373d12b10015287c54b0697c86.jpg"],
                                       ["path_mobile" : "http://103.27.201.106/dev-pointpow/imageservice/public/storage/banner/2019/05/banner_3fd4d6320601ae97e1b4848444b809fc88deeeee5f361f47.jpg"]] as [[String : AnyObject]]
                itemCell.autoSlideImage = true
                
                cell = itemCell
            }
            break
            
        case 1:
            if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as? RecommendCell {
                
                cell = itemCell
            }
            break
        case 2:
            if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as? RecommendCell {
                
                cell = itemCell
            }
            break
        case 3:
            if let pageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageViewCollectionViewCell", for: indexPath) as? PageViewCollectionViewCell {

                cell = pageCell
            }
            break
        case 4:
            if let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingProductCell", for: indexPath) as? ShoppingProductCell {
                cell = productCell
                
                productCell.discountLabel.isHidden = true
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
        
        if indexPath.section == 3{
            let indexSet = IndexSet(integer: 4)
            collectionView.reloadSections(indexSet)
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView != productCollectionView {
            return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        }
        
        let width = self.productCollectionView.frame.width
        
        switch indexPath.section {
        case 0:
            let width = collectionView.frame.width
            let height = width/1799*720
            return CGSize(width: width, height: height)
            
        case 1:
            let height = (width/2 - 15) + 100
            return CGSize(width: width, height: height)
        case 2:
            let height = (width/2 - 15) + 100
            return CGSize(width: width, height: height)
        case 3:
            let height = 80.0 + self.sizeOfViewCateInit
            return CGSize(width: width, height: height)
        case 4:
            let height = (width/2 - 15) + 100
            return CGSize(width: width/2 - 15, height: height)
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
        case 1:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SpecialHeaderCell", for: indexPath) as! SpecialHeaderCell
            header.backgroundColor = Constant.Colors.COLOR_LLGRAY
            header.headerLabel.text = NSLocalizedString("string-item-shopping-cate-head-special-deal",
                                                            comment: "")
            
            if !self.cd.running {
                
                cd.initializeTimer("2019-06-28 00:00:00")
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
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSectionCell", for: indexPath) as! HeaderSectionCell
            header.backgroundColor = Constant.Colors.COLOR_LLGRAY
            
            
            if indexPath.section == 2 {
                header.headerNameLabel.text = NSLocalizedString("string-item-shopping-cate-head-hot-redemption",
                                                                comment: "")
            }
            if indexPath.section == 3 {
                header.headerNameLabel.text = NSLocalizedString("string-item-shopping-cate-head-recommend",
                                                                comment: "")
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
        case 0,4:
            return CGSize.zero
        case 1:
            return CGSize(width: collectionView.frame.width, height: 50.0)
        default:
            return CGSize(width: collectionView.frame.width, height: 50.0)
        }
        
    }
}
