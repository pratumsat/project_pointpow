//
//  ShoppingSWRevealViewController.swift
//  pointpow
//
//  Created by thanawat on 25/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ShoppingSWRevealViewController: SWRevealViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(messageAlert), name: NSNotification.Name(rawValue: "messageAlert"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        
    }
    
    @objc func messageAlert(notification: NSNotification){
        if let userInfo = notification.userInfo as? [String:AnyObject]{
            let message = userInfo["message"] as? String  ?? ""
            let profile = userInfo["profile"] as? String  ?? ""
            
            
            if !message.isEmpty {
                let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                let ok = UIAlertAction(title: NSLocalizedString("string-button-ok", comment: ""), style: .cancel, handler: nil)
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
            }
            if !profile.isEmpty{
                
            }
            
        }
        
    }
    var isHiddenStatusBar:Bool = false {
        didSet{
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
        
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .none
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool{
        return isHiddenStatusBar
    }


}
