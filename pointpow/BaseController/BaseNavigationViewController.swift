//
//  BaseNavigationViewController.swift
//  ShopSi
//
//  Created by thanawat on 11/9/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    var isHiddenStatusBar:Bool = false {
        didSet{
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

}
extension BaseNavigationViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
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
