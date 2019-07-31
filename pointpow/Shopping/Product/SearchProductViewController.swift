//
//  SearchProductViewController.swift
//  pointpow
//
//  Created by thanawat on 31/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class SearchProductViewController: ProductShoppingViewController {    
    
    override var notFoundHeader:String {
        return "ImageProductNotFoundCell"
    }
    override var sizeNotFoundHeader : CGFloat {
       return self.productCollectionView?.frame.width ?? CGFloat(300.0)
    }
    
    var keyword:String? {
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title  =  NSLocalizedString("string-title-shopping-search-result", comment: "")

    }
    
    override func callAPI(_ reload:Bool = false, _ loadSuccess:(()->Void)?  = nil){
        getProductByCate() {
            self.refreshControl?.endRefreshing()
            loadSuccess?()
        }
    }
    
    override func setUp(){
        self.topConstraintCollectionView.constant = 40
        
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
        
        self.searchView?.removeFromSuperview()
        self.searchView = self.addSearchView()
        
        self.searchCallback = { (keyword) in
            print("ketyword: \(keyword)")
            self.keyword = keyword
        }
        
        self.searchTextField?.text = self.keyword
        
        
    }
   
    
   
    override func updateDataWillUpdate(){
        //ignored
    }
    
    override func getProductByCate(loadmore:Bool = false, _ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.productItems != nil {
            isLoading = true
        }else{
            isLoading = true
        }
        
        if loadmore {
            isLoading = false
        }
        
        
        modelCtrl.searchProducts(word: self.keyword!, skip: self.skipItem, type: self.sortBySelected, isLoading , succeeded: { (result) in
            
            if let mResult = result as? [[String:AnyObject]] {
                
                if self.isLoadmore == false {
                    self.productItems = mResult
                }else{
                    for item in mResult {
                        self.productItems?.append(item)
                    }
                }
                
                self.isLoadmore = false
                
            }
            avaliable?()
            
            
        }, error: { (error) in
             self.refreshControl?.endRefreshing()
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                self.showMessagePrompt(message)
            }
           
            print(error)
        }) { (messageError) in
            print("messageError")
            self.refreshControl?.endRefreshing()
            self.handlerMessageError(messageError)
            
        }
    }
    
}
