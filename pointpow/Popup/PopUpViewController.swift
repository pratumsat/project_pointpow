//
//  PopUpViewController.swift
//  pointpow
//
//  Created by thanawat on 30/10/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class PopUpViewController: BaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var dismissView:(()->Void)?
    
    var model:[String:AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = UIImage(named: "ic-bg-popup")
        
        if let itemData = self.model {
            let cover = itemData["cover"] as? String ?? ""

            
            if let url = URL(string: cover) {
                self.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.PROFILE_PLACEHOLDER))
            }else{
                self.imageView.image = UIImage(named: Constant.DefaultConstansts.DefaultImaege.PROFILE_PLACEHOLDER)
            }
            
        }
    }
    
    override func dismissPoPup() {
        super.dismissPoPup()
        self.dismiss(animated: true, completion: {
            self.dismissView?()
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCloseWhiteView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismissPoPup()
        self.dismissView?()
    }
    

}
