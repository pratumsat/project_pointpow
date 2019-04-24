//
//  PointFriendTransferReviewViewController.swift
//  pointpow
//
//  Created by thanawat on 21/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class PointFriendTransferReviewViewController: BaseViewController {

    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var myProfileImageView: UIImageView!
    @IBOutlet weak var transferButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-freind-transfer-review", comment: "")
        self.setUp()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.transferButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        self.myProfileImageView.ovalColorClearProperties()
        self.friendImageView.ovalColorClearProperties()
        
    }
    
    func setUp(){
        self.handlerEnterSuccess = { (pin) in
            self.showPointFriendSummaryTransferView(true) {
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
        
        self.myProfileImageView.image = UIImage(named:"bg-profile-image")
        self.friendImageView.image = UIImage(named:"bg-4")
        self.transferButton.borderClearProperties(borderWidth: 1)
        self.noteView.borderClearProperties(borderWidth: 1 , radius: 10)
        self.backgroundImage?.image = nil
    
    }
      
    @IBAction func confirmTapped(_ sender: Any) {
        self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
    }
    
}
