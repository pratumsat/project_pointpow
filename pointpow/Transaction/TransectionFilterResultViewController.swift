//
//  TransectionFilterResultViewController.swift
//  pointpow
//
//  Created by thanawat on 23/5/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class TransectionFilterResultViewController: TransactionViewController {

    var mTitle:String?
    var params:Parameters?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.mTitle
    }
    
    override func getHistory(_ avaliable:(()->Void)?  = nil){
        
        var isLoading:Bool = true
        if self.pointHistory != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        modelCtrl.getPointHistory(params: self.params , isLoading , succeeded: { (result) in
            
            self.pointHistory =  self.getStatementList(result as! [[String : AnyObject]])
            //                        if self.cur_id == "" {
            //                            self.statement = statement
            //                        }else{
            //                            if let firstItem = statement.first {
            //                                if self.statement?.last?.month == firstItem.month {
            //                                    if let items = firstItem.items {
            //                                        for each in items {
            //                                            self.statement?.last?.items?.append(each)
            //                                        }
            //                                    }
            //                                }else{
            //                                    for each in  statement {
            //                                        self.statement?.append(each)
            //                                    }
            //
            //                                }
            //                            }
            //                        }
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
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    override func viewWillDisappear(_ animated: Bool) {
      
    }
    

}
