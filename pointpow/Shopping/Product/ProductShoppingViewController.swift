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
    
    var countSection = 1 {
        didSet{
            self.productCollectionView.reloadData()
        }
    }
    
    var cateName = NSLocalizedString("string-item-shopping-cate-all", comment: "") {
        didSet{
            self.tabBarController?.title = cateName
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let searchView = self.addSearchView()
        self.addCategoryView(searchView)
        
        self.searchCallback = { (keyword) in
            print("ketyword: \(keyword)")
        }
        self.collapseCallback = { (collpse) in
            if collpse {
                self.countSection = 1
                self.topConstraintCollectionView.constant = 120.0 + self.sizeOfViewCateInit
            }else{
                self.countSection = 2
                self.topConstraintCollectionView.constant = 120.0 + self.sizeOfViewCate
            }
        }
        
        
        self.setUp()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = cateName
    }
    
    override func categoryTapped(sender: UITapGestureRecognizer) {
        super.categoryTapped(sender: sender)
        let tag = sender.view?.tag ?? 0
        
        if tag == 0 {
            self.cateName = NSLocalizedString("string-item-shopping-cate-all", comment: "")
        }else{
            self.cateName = self.cateLists[tag]["name"] as? String ?? ""
        }
        
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
        
        
        self.registerNib(self.productCollectionView, "RecommendCell")
        self.registerNib(self.productCollectionView, "ShoppingProductCell")
        self.registerHeaderNib(self.productCollectionView, "HeaderSectionCell")

    }
    
    override func reloadData() {
        //get data by refresh
        self.refreshControl?.endRefreshing()
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
                return 8 // data test
            }else{
                return 1
            }
            
        case 1:
            return 8 // data test
            
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
                    
                }
            }else{
                if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as? RecommendCell {
                    
                    cell = itemCell
                }

            }
            
            break
            
        case 1:
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
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView != productCollectionView {
            return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        }
        
        let width = self.productCollectionView.frame.width
        
        switch indexPath.section {
        case 0:
            if self.countSection > 1 {
                let height = (width/2 - 15) + 100
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
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSectionCell", for: indexPath) as! HeaderSectionCell
        header.backgroundColor = Constant.Colors.COLOR_LLGRAY
        
        switch indexPath.section {
        case 0:
            if self.countSection == 1 {
                header.headerNameLabel.text = self.cateName
            }else{
                header.headerNameLabel.text = NSLocalizedString("string-item-shopping-cate-head-recommend", comment: "")
            }
            
            break
        case 1:
            header.headerNameLabel.text = self.cateName
            break
        default:
            break
        }
        
        return header
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if collectionView != productCollectionView {
            return super.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
        }
        
        return CGSize(width: collectionView.frame.width, height: 50.0)
        
    }
    
}
