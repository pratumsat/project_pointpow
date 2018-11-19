//
//  PointFriendTransferViewController.swift
//  pointpow
//
//  Created by thanawat on 19/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class PointFriendTransferViewController: BaseViewController {

    @IBOutlet weak var transferButton: UIButton!
    @IBOutlet weak var toggleCheckbox: CheckBox!
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var myProfileImageView: UIImageView!
    @IBOutlet weak var amountTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-freind-transfer", comment: "")
        self.setUp()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.transferButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        self.myProfileImageView.ovalColorClearProperties()
        self.friendImageView.ovalColorClearProperties()
        
    }
    
    func setUp(){
        self.myProfileImageView.image = UIImage(named:"bg-profile-image")
        self.friendImageView.image = UIImage(named:"bg-4")
       
        self.backgroundImage?.image = nil
        self.toggleCheckbox.isChecked = true
        
        self.transferButton.borderClearProperties(borderWidth: 1)
        self.amountTextField.setRightPaddingPoints(20)
        self.amountTextField.borderLightGroupTableColorProperties(borderWidth: 1)
        
        if #available(iOS 10.0, *) {
            self.amountTextField.textContentType = UITextContentType(rawValue: "")
          
        }
        if #available(iOS 12.0, *) {
            self.amountTextField.textContentType = .oneTimeCode
        }
        
        self.amountTextField.delegate = self
        self.amountTextField.autocorrectionType = .no
        
    }
    @IBAction func toggle(_ sender: Any) {
    }
    
    @IBAction func transferTapped(_ sender: Any) {
       self.showPointFriendSummaryTransferView(true)
    }
}
