//
//  PopupChosenQRcodeViewController.swift
//  pointpow
//
//  Created by thanawat on 24/5/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PopupChosenQRcodeViewController: BaseViewController {

    @IBOutlet weak var scanQRcodeImageView: UIImageView!
    @IBOutlet weak var myQRcodeImageView: UIImageView!
    
    var dismissCallback:((_ chooseType:String)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        self.backgroundImage?.image = nil
        
        
        let scan = UITapGestureRecognizer(target: self, action: #selector(scanQRcodeTapped))
        self.scanQRcodeImageView.isUserInteractionEnabled = true
        self.scanQRcodeImageView.addGestureRecognizer(scan)
        
        let myqrcode = UITapGestureRecognizer(target: self, action: #selector(myQRcodeTapped))
        self.myQRcodeImageView.isUserInteractionEnabled = true
        self.myQRcodeImageView.addGestureRecognizer(myqrcode)
    }
    
    @objc func scanQRcodeTapped(){
        self.dismiss(animated: false, completion: {
            self.dismissCallback?("scanqrcode")
        })
    }
    @objc func myQRcodeTapped(){
        self.dismiss(animated: false, completion: {
            self.dismissCallback?("myqrcode")
        })
    }
}
