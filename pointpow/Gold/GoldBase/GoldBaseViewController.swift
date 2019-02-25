//
//  GoldMenuViewController.swift
//  pointpow
//
//  Created by thanawat on 4/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import SWRevealViewController
class GoldBaseViewController: BaseViewController {

    var userData:AnyObject?
    var goldPrice:AnyObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (self.revealViewController() != nil) {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.navigationItem.rightBarButtonItem?.target = revealViewController()
            
        }
    }
    
    func getDataMember(_ loadSuccess:(()->Void)?  = nil){
        var success = 0
        getGoldPrice() {
            success += 1
            if success == 2 {
                loadSuccess?()
            }
        }
        getUserInfo() {
            success += 1
            if success == 2 {
                loadSuccess?()
            }
        }
       
        
        
    }
    
   
    func getGoldPrice(_ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.goldPrice != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        modelCtrl.getGoldPrice(params: nil , isLoading , succeeded: { (result) in
            self.goldPrice = result
            avaliable?()
            
            self.refreshControl?.endRefreshing()
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                //self.showMessagePrompt(message)
            }
            self.refreshControl?.endRefreshing()
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
            self.refreshControl?.endRefreshing()
        }
    }
    
    func getUserInfo(_ avaliable:(()->Void)?  = nil){

        var isLoading:Bool = true
        if self.userData != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        
        modelCtrl.getUserData(params: nil , isLoading , succeeded: { (result) in
            self.userData = result
            avaliable?()
         
            self.refreshControl?.endRefreshing()
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                //self.showMessagePrompt(message)
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
