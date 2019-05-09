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
    
    @IBOutlet weak var pointBalanceLabel: UILabel!
    
    var isFriend:Bool = false
    var userData:AnyObject?
    
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getUserInfo()
    }
    func getUserInfo(_ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.userData != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        modelCtrl.getUserData(params: nil , isLoading , succeeded: { (result) in
            self.userData = result
            avaliable?()
            if let userData = self.userData as? [String:AnyObject] {
                let pointBalance = userData["member_point"]?["total"] as? NSNumber ?? 0
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 2
                
                self.pointBalanceLabel.text = numberFormatter.string(from: pointBalance )
            }
            self.refreshControl?.endRefreshing()
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                //self.showMessagePrompt(message)
            }
            self.refreshControl?.endRefreshing()
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
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
