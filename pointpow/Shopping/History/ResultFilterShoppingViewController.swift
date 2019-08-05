//
//  ResultFilterShoppingViewController.swift
//  pointpow
//
//  Created by thanawat on 5/8/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class ResultFilterShoppingViewController: ShoppingHistoryViewController {

    var mTitle:String?
    var params:Parameters?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setUp(){
        self.title = self.mTitle
        
        self.backgroundImage?.image = nil
        
        
        self.historyCollectionView.delegate = self
        self.historyCollectionView.dataSource = self
        
        
        self.historyCollectionView.showsVerticalScrollIndicator = false
        
        self.addRefreshViewController(self.historyCollectionView)
        
        self.registerNib(self.historyCollectionView, "ShoppingHistoryCell")
        self.registerHeaderNib(self.historyCollectionView, "HeaderCollectionReusableView")
    }

    override func getHistory(_ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.shoppingHistory != nil {
            isLoading = false
        }else{
            isLoading = true
        }
      
        modelCtrl.getShoppingHistory(params: self.params , isLoading , succeeded: { (result) in
            
            self.shoppingHistory =  self.getStatementList(result as! [[String : AnyObject]])
            
            avaliable?()
            
            self.refreshControl?.endRefreshing()
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
