//
//  IntroNav.swift
//  pointpow
//
//  Created by thanawat on 2/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class IntroNav: BaseNavigationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    func hideStatusBar(){
         self.isHiddenStatusBar = true
    }
    func showStatusBar(){
         self.isHiddenStatusBar = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
