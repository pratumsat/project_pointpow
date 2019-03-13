//
//  PopUpInfoThaiPostViewController.swift
//  pointpow
//
//  Created by thanawat on 13/3/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PopUpInfoThaiPostViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        
        self.getPriceThaiPost() {
            self.updateUI()
        }
    }
    func updateUI(){
        
    }
    
    func getPriceThaiPost(_ avaliable:(()->Void)?  = nil){
        modelCtrl.getServicePriceThaiPost(params: nil , false , succeeded: { (result) in
            print("get service success")
            avaliable?()
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                //self.showMessagePrompt(message)
            }
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
            
        }
    }
    
    override func dismissPoPup() {
        super.dismissPoPup()
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCloseBlackView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismissPoPup()
    }


}
