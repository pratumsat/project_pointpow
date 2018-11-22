//
//  PointFriendTransferViewController.swift
//  pointpow
//
//  Created by thanawat on 19/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class PointFriendTransferViewController: BaseViewController {

    @IBOutlet weak var moreImageView: UIImageView!
    @IBOutlet weak var lessImageView: UIImageView!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var transferButton: UIButton!
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
        
        self.lessImageView.ovalColorClearProperties()
        self.moreImageView.ovalColorClearProperties()
    }
    
    func setUp(){
        self.myProfileImageView.image = UIImage(named:"bg-profile-image")
        self.friendImageView.image = UIImage(named:"bg-4")
       
        self.backgroundImage?.image = nil
        
        self.transferButton.borderClearProperties(borderWidth: 1)
        self.amountTextField.setRightPaddingPoints(20)
        self.noteTextField.setLeftPaddingPoints(20)
        
        self.noteTextField.borderLightGrayColorProperties(borderWidth: 0.5)
        self.amountTextField.borderRedColorProperties(borderWidth: 1)
        
        if #available(iOS 10.0, *) {
            self.amountTextField.textContentType = UITextContentType(rawValue: "")
            self.noteTextField.textContentType = UITextContentType(rawValue: "")
        }
        if #available(iOS 12.0, *) {
            self.amountTextField.textContentType = .oneTimeCode
            self.noteTextField.textContentType = .oneTimeCode
        }
        
        self.amountTextField.delegate = self
        self.amountTextField.autocorrectionType = .no
        
        
        self.noteTextField.delegate = self
        self.noteTextField.autocorrectionType = .no
        
        
    }
    @IBAction func toggle(_ sender: Any) {
    }
    
    @IBAction func transferTapped(_ sender: Any) {
       self.showPointFriendTransferReviewView(true)
    }
}
