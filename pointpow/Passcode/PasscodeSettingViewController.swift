//
//  PasscodeSettingViewController.swift
//  pointpow
//
//  Created by thanawat on 6/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
//not use
class PasscodeSettingViewController: BaseViewController {

    var countDown:Int = 1
    var timer:Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.setUp()
    }
    
    func setUp(){
        
        self.countDown(1.0)
    }
    
    func countDown(_ time: Double){
        timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountDown() {
        if(countDown > 0) {
            countDown = countDown - 1
            //
        } else {
            self.removeCountDownLable()
        }
    }
    func removeCountDownLable() {
        //finish
        countDown = 60
        timer?.invalidate()
        timer = nil
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

}
