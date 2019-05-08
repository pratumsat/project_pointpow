//
//  IntroNav.swift
//  pointpow
//
//  Created by thanawat on 2/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
import Presentr

class IntroNav: BaseNavigationViewController {

    var callbackFinish:(()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

       
        NotificationCenter.default.addObserver(self, selector: #selector(resetPassword), name: NSNotification.Name(rawValue: Constant.DefaultConstansts.RESET_PASSWORD), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(verifyEmailRegister), name: NSNotification.Name(rawValue: Constant.DefaultConstansts.VERIFI_EMAIL_REGISTER), object: nil)
        
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
  
    }
    
    @objc func resetPassword(_ notification: NSNotification){
        print("rootView IntroNav resetPassword")
        
    
        
        if let vc:ResetNav  = self.storyboard?.instantiateViewController(withIdentifier: "ResetNav") as? ResetNav {
            present(vc, animated: true, completion: nil)
        }
    }
    @objc func verifyEmailRegister(_ notification: NSNotification){
        print("rootView IntroNav verifyEmailRegister")
        
        let presenter: Presentr = {
            
            let customPresenter = Presentr(presentationType: PresentationType.alert)
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 10
            customPresenter.dismissOnSwipe = true
            customPresenter.dismissOnTap = true
            
            
            return customPresenter
        }()
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpRegisterSuccessViewController") as? PopUpRegisterSuccessViewController{
            
            customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
            
        }
        
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
