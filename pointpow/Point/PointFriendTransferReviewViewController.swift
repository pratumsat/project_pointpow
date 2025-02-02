//
//  PointFriendTransferReviewViewController.swift
//  pointpow
//
//  Created by thanawat on 21/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class PointFriendTransferReviewViewController: BaseViewController {

    @IBOutlet weak var pointPowLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var myProfileImageView: UIImageView!
    @IBOutlet weak var transferButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameFriendLabel: UILabel!
    
    @IBOutlet weak var ppIdFriendLabel: UILabel!
    @IBOutlet weak var ppIdLabel: UILabel!
    
    var userData:AnyObject?
    var amount:Double = 0.0
    var note:String = ""
    
    var friendModel:[String:AnyObject]?{
        didSet{
            //print(friendModel)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-freind-transfer-review", comment: "")
        self.setUp()
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
                let pointpow_id = userData["pointpow_id"] as? String ?? ""
                let pointBalance = userData["member_point"]?["total"] as? NSNumber ?? 0
                let picture_data = userData["picture_data"] as? String ?? ""
                let display_name = userData["display_name"] as? String ?? ""
                let first_name = userData["first_name"] as? String ?? ""
                let last_name = userData["last_name"] as? String ?? ""
                let mobile = userData["mobile"] as? String ?? ""
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 2
                
               
                if DataController.sharedInstance.getProfilPath().isEmpty {
                    if let url = URL(string: picture_data) {
                        self.myProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                        
                    }else{
                        self.myProfileImageView.image = UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER)
                    }
                }
                
                
                //            let fullname = "\(( (first_name.isEmpty) ? "" : first_name)) \(( (last_name.isEmpty) ? "" : last_name))"
                
                let fullname = "\(( (first_name.isEmpty) ? "-" : first_name))"
                
                if !display_name.isEmpty {
                    self.nameLabel.text = display_name
                }else{
                    self.nameLabel.text = fullname
                }
                
                if !pointpow_id.isEmpty {
                    self.ppIdLabel.text = pointpow_id
                }else{
                    let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
                    self.ppIdLabel.text = newMText.chunkFormatted()
                }
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
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.transferButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        self.myProfileImageView.ovalColorClearProperties()
        self.friendImageView.ovalColorClearProperties()
        
    }
    
    func setUp(){
        
        if let url = URL(string: DataController.sharedInstance.getProfilPath()) {
            self.myProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
            
        }else{
            self.myProfileImageView.image = UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER)
        }

        
        self.handlerEnterSuccess = { (pin) in
            if let modelFriend = self.friendModel {
                let mobile = modelFriend["mobile"] as? String ?? ""
                
                let params:Parameters = ["mobile" : mobile,
                                         "amount" : self.amount,
                                         "note" : self.note]
                if let loading = self.loadingView{
                    loading.mRootView = self.view
                }
                self.modelCtrl.friendTransferPoint(params: params , true , succeeded: { (result) in

                    //success
                    if let mResult  = result as? [String:AnyObject] {
                        let transaction_id = mResult["transaction_ref_id"] as? String ?? ""

                        let titlePage = NSLocalizedString("string-status-transection-history-service-point-transfer-out", comment: "")
                        self.showPointFriendSummaryTransferView(true, transaction_id, titlePage:titlePage) {
                            self.navigationController?.popToRootViewController(animated: false)
                        }

                    }


                }, error: { (error) in
                    if let mError = error as? [String:AnyObject]{
                        let message = mError["message"] as? String ?? ""
                        print(message)
                        self.showMessagePrompt(message)
                    }

                    print(error)
                }) { (messageError) in
                    print("messageError")
                    self.handlerMessageError(messageError)

                }
            }
            
            
            
        }
        
        
       
        self.transferButton.borderClearProperties(borderWidth: 1)
        self.noteView.borderClearProperties(borderWidth: 1 , radius: 10)
        self.backgroundImage?.image = nil
    
        if let modelFriend = self.friendModel {
            let display_name = modelFriend["display_name"] as? String ?? ""
            let first_name = modelFriend["first_name"] as? String ?? ""
            let last_name = modelFriend["last_name"] as? String ?? ""
            let mobile = modelFriend["mobile"] as? String ?? ""
            let picture_data = modelFriend["picture_data"] as? String ?? ""
            let pointpow_id = modelFriend["pointpow_id"] as? String ?? ""
            
            if let url = URL(string: picture_data) {
                self.friendImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
            }else{
                self.friendImageView.image = UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER)
            }
            
//            let fullname = "\(( (first_name.isEmpty) ? "" : first_name)) \(( (last_name.isEmpty) ? "" : last_name))"

            let fullname = "\(( (first_name.isEmpty) ? "-" : first_name))"
            
            if !display_name.isEmpty {
                self.nameFriendLabel.text = display_name
            }else{
                self.nameFriendLabel.text = fullname
            }
            
            if !pointpow_id.isEmpty {
                self.ppIdFriendLabel.text = pointpow_id
            }else{
                let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
                self.ppIdFriendLabel.text = newMText.chunkFormatted()
            }

        }
        
        if self.note.isEmpty {
            self.noteLabel.text = " "
        }else{
            self.noteLabel.text = self.note
        }
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        
        self.pointPowLabel.text = numberFormatter.string(from: NSNumber(value: self.amount))
        
    }
      
    @IBAction func confirmTapped(_ sender: Any) {
        
        self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
    }
    
}
