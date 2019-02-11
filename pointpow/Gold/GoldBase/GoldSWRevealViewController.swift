//
//  GoldSWRevealViewController.swift
//  pointpow
//
//  Created by thanawat on 11/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class GoldSWRevealViewController: SWRevealViewController {

   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
