//
//  PointManageViewController.swift
//  pointpow
//
//  Created by thanawat on 6/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class PointManageViewController: BaseViewController {

    @IBOutlet weak var friendTransfer: UIImageView!
    @IBOutlet weak var transferPointImageView: UIImageView!
    
    
    var isFriend:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.title = NSLocalizedString("string-title-point-manage", comment: "")
        self.setUp()
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
                
        let friend = UITapGestureRecognizer(target: self, action: #selector(friendTransferTapped))
        self.friendTransfer.isUserInteractionEnabled = true
        self.friendTransfer.addGestureRecognizer(friend)
        
        let point = UITapGestureRecognizer(target: self, action: #selector(transferPointTapped))
        self.transferPointImageView.isUserInteractionEnabled = true
        self.transferPointImageView.addGestureRecognizer(point)
    }
    
    @objc func transferPointTapped(){
        
        self.showPointTransferView(true)
//        let alert = UIAlertController(title: NSLocalizedString("string-dailog-title-fill-firstname-lastname", comment: ""),
//                                      message: "", preferredStyle: .alert)
//
//        let okButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-ok", comment: ""), style: .default, handler: {
//            (alert) in
//
//            self.showPersonalPopup(true) {
//                self.isFriend = false
//
//            }
            //
            //self.showPointTransferView(true)
//        })
//
//        let cancelButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-cancel", comment: ""), style: .default, handler: nil)
//
//
//
//        alert.addAction(cancelButton)
//        alert.addAction(okButton)
//        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func friendTransferTapped(){
        self.showFriendTransferView(true)
        
//        let alert = UIAlertController(title: NSLocalizedString("string-dailog-title-set-passcode", comment: ""),
//                                      message: "", preferredStyle: .alert)
//
//        let okButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-ok", comment: ""), style: .default, handler: {
//            (alert) in
//
//            self.isFriend = true
//            //
//            //self.showFriendTransferView(true)
//            //self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
//        })
//        let cancelButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-cancel", comment: ""), style: .default, handler: nil)
//
//
//
//        alert.addAction(cancelButton)
//        alert.addAction(okButton)
//        self.present(alert, animated: true, completion: nil)
    }

}
