//
//  GoldMenuViewController.swift
//  pointpow
//
//  Created by thanawat on 4/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import SWRevealViewController
class GoldBaseViewController: BaseViewController{

    var userData:AnyObject?
    var goldPrice:AnyObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if (self.revealViewController() != nil) {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.navigationItem.rightBarButtonItem?.target = revealViewController()
            
        }
        
        self.handlerEnterSuccess  = {
            // "Profile"
            if let profile = self.storyboard?.instantiateViewController(withIdentifier: "GoldAccount") as? UINavigationController {
                
                self.revealViewController()?.pushFrontViewController(profile, animated: true)
                
            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
   
        NotificationCenter.default.addObserver(self, selector: #selector(messageAlert), name: NSNotification.Name(rawValue: "messageAlert"), object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "messageAlert"), object: nil)
        
    }
    
    
    @objc func messageAlert(notification: NSNotification){
        if let userInfo = notification.userInfo as? [String:AnyObject]{
            let profile = userInfo["profile"] as? String  ?? ""
            if !profile.isEmpty{
                self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
            }
            
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
