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
    
    override func viewDidLoad() {
        super.viewDidLoad()

         self.backgroundImage?.image = nil
    }
    
    
    func closeView(){
        self.dismiss(animated: true, completion: {
            self.dismissView?()
        })
    }

}
