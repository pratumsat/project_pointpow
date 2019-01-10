//
//  PopUpRegisterSuccessViewController.swift
//  pointpow
//
//  Created by thanawat on 2/1/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PopUpRegisterSuccessViewController: BaseViewController {

    var dismissView:(()->Void)?
    
    var countDown:Int = 3
    var timer:Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

         self.backgroundImage?.image = nil
        self.countDown(1.0)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.dismissView?()
        self.removeCountDownLable()
    }
    func countDown(_ time: Double){
        timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountDown() {
        if(countDown > 0) {
            countDown = countDown - 1
        } else {
            self.removeCountDownLable()
            self.closeView()
        }
    }
    func removeCountDownLable() {
        //finish
        countDown = 3
        timer?.invalidate()
        timer = nil
        
        
        
    }
    
    
    func closeView(){
        self.dismiss(animated: true, completion: nil)
    }

}
