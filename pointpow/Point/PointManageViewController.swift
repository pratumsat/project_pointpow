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
                self.showMessagePrompt(message)
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
        if let data  = self.userData as? [String:AnyObject] {
            let is_profile = data["is_profile"] as? NSNumber ?? 0
            
            self.showPointTransferView(true, isProfile: is_profile.boolValue)
        }
        
        
    }
    
    
    @objc func friendTransferTapped(){
        
        
        if let data  = self.userData as? [String:AnyObject] {
            let is_profile = data["is_profile"] as? NSNumber ?? 0
            
            if is_profile.boolValue {
                self.showFriendTransferView(true)
            }else{
                self.showPopupProfileInfomation(){
                    self.showFriendTransferView(true)
                }
            }
        }
        
    }

    
}
