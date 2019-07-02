//
//  PointFriendTransferViewController.swift
//  pointpow
//
//  Created by thanawat on 19/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class PointFriendTransferViewController: BaseViewController {

    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var countNoteLabel: UILabel!
    @IBOutlet weak var moreImageView: UIImageView!
    @IBOutlet weak var lessImageView: UIImageView!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var transferButton: UIButton!
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var myProfileImageView: UIImageView!
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameFriendLabel: UILabel!
    @IBOutlet weak var pointBalanceLabel: UILabel!
    
    @IBOutlet weak var ppIdFriendLabel: UILabel!
    @IBOutlet weak var ppIdLabel: UILabel!
    var userData:AnyObject?
    var settingData:AnyObject?
    
    var friendModel:[String:AnyObject]?{
        didSet{
            //print(friendModel)
        }
    }
    var mNote:String?
    var pointAmount:String?
    
    let exchangeRate = 100
    let minPointTransfer = 100.0
    
    var pointLimitOrder = 0.0
    
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
        
       
        self.backgroundImage?.image = nil
        
        self.transferButton.borderClearProperties(borderWidth: 1)
        self.amountTextField.setRightPaddingPoints(20)
        self.noteTextField.setLeftPaddingPoints(20)
        
        self.noteTextField.borderLightGrayColorProperties(borderWidth: 0.5)
        self.amountTextField.borderRedColorProperties(borderWidth: 1)
     
     
        let less = UITapGestureRecognizer(target: self, action: #selector(lessPointTapped))
        self.lessImageView.isUserInteractionEnabled = true
        self.lessImageView.addGestureRecognizer(less)
        
        
        let more = UITapGestureRecognizer(target: self, action: #selector(morePointTapped))
        self.moreImageView.isUserInteractionEnabled = true
        self.moreImageView.addGestureRecognizer(more)
        
        
        self.amountTextField.delegate = self
        self.amountTextField.autocorrectionType = .no
        
        
        self.noteTextField.delegate = self
        self.noteTextField.autocorrectionType = .no
        
        
        self.amountTextField.text = self.pointAmount
        
        
        if let amount = self.pointAmount {
            
            self.amountTextField.text = amount
        }else{
            //default
            self.amountTextField.text = "100"
            self.disableImageView(lessImageView)
        }
        
       
        if let note = self.mNote {
            self.countNoteLabel.text = "\(note.count)/40"
            self.noteTextField.text = note
        }
        
        
        if let modelFriend = self.friendModel {
            let display_name = modelFriend["display_name"] as? String ?? ""
            let first_name = modelFriend["first_name"] as? String ?? ""
            let last_name = modelFriend["last_name"] as? String ?? ""
            let pointpow_id = modelFriend["pointpow_id"] as? String ?? ""
            let mobile = modelFriend["mobile"] as? String ?? ""
            let picture_data = modelFriend["picture_data"] as? String ?? ""
            let limit_pay = modelFriend["limit_pay"] as? NSNumber ?? 0
       
            
        
            self.pointLimitOrder = limit_pay.doubleValue
        
            //min transfer
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.minimumFractionDigits = 0
            let limitp = numberFormatter.string(from: limit_pay)
            
            var prefixlimit = NSLocalizedString("string-point-transfer-point-limit-today", comment: "")
            prefixlimit += " \(limitp ?? "")"
            self.limitLabel.text = "\(prefixlimit)"
            
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
                self.ppIdFriendLabel.text = mobile
            }
            
        }
        
        
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
                
                if let url = URL(string: picture_data) {
                    self.myProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                    
                }else{
                    self.myProfileImageView.image = UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER)
                }
               
                self.pointBalanceLabel.text = "\(numberFormatter.string(from: pointBalance ) ?? "") Point Pow"
               
                
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
                    
                    self.ppIdLabel.text = mobile
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
    
    @objc func lessPointTapped() {
        let updatedText = self.amountTextField.text!
        
        var amount = 0.0
        if let iPoint = Int(updatedText.replace(target: ",", withString: "")){
            amount = Double(iPoint)
        }
        amount -= Double(exchangeRate)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 0
        
        self.amountTextField.text = numberFormatter.string(from: NSNumber(value: amount))
        
        if amount <= minPointTransfer {
            self.amountTextField.text = "100"
            disableImageView(self.lessImageView)
        }else{
            enableImageView(self.lessImageView)
        }
        
        if let userData = self.userData as? [String:AnyObject] {
            let pointBalance = userData["member_point"]?["total"] as? NSNumber ?? 0
            
            if amount < pointBalance.doubleValue {
                enableImageView(self.moreImageView)
            }
        }

    }
    @objc func morePointTapped() {
        let updatedText = self.amountTextField.text!
        
        var amount = 0.0
        if let iPoint = Int(updatedText.replace(target: ",", withString: "")){
           amount = Double(iPoint)
        }
        
        amount += Double(exchangeRate)
        
        if let userData = self.userData as? [String:AnyObject] {
            let pointBalance = userData["member_point"]?["total"] as? NSNumber ?? 0
           
            if amount > pointBalance.doubleValue {
                disableImageView(self.moreImageView)
                return
            }
        }
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 0
        
        self.amountTextField.text = numberFormatter.string(from: NSNumber(value: amount))
        
        enableImageView(self.lessImageView)
        
       
        
    }
    
    
    func disableImageView(_ image:UIImageView){
        //image.ovalColorClearProperties()
        image.backgroundColor = UIColor.groupTableViewBackground
        image.isUserInteractionEnabled = false
    }
    func enableImageView(_ image:UIImageView){
        //image.ovalColorClearProperties()
        image.backgroundColor = Constant.Colors.PRIMARY_COLOR
        image.isUserInteractionEnabled = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
 
        if textField == self.noteTextField {
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            if newLength <= 40 {
                self.countNoteLabel.text = "\(newLength)/40"
            }
            
            return newLength <= 40
            
        }
        if textField == self.amountTextField {
            guard let textRange = Range(range, in: textField.text!) else { return true}
            let updatedText = textField.text!.replacingCharacters(in: textRange, with: string)

            
            if updatedText.isEmpty {
                textField.text = ""
            }
            if let iPoint = Int(updatedText.replace(target: ",", withString: "")){
                let amount = Double(iPoint)
                if amount <= minPointTransfer {
                    disableImageView(self.lessImageView)
                }else{
                    enableImageView(self.lessImageView)
                }
                
                if let userData = self.userData as? [String:AnyObject] {
                    let pointBalance = userData["member_point"]?["total"] as? NSNumber ?? 0
                    
                    if amount < pointBalance.doubleValue {
                        enableImageView(self.moreImageView)
                    }else{
                        disableImageView(self.moreImageView)
                    }
                }
                
                if let iPoint = Int(updatedText.replace(target: ",", withString: "")){
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    
                    textField.text = numberFormatter.string(from: NSNumber(value: iPoint))
                    return false
                }
            }else{
                return false
            }
            
            
        }
        return true
    }
    
    @IBAction func transferTapped(_ sender: Any) {
        let updatedText = self.amountTextField.text!
        let note = self.noteTextField.text!
        
        
        if let userData = self.userData as? [String:AnyObject] {
            let pointBalance = userData["member_point"]?["total"] as? NSNumber ?? 0
            
            var amount = 0.0
            if let iPoint = Int(updatedText.replace(target: ",", withString: "")){
                amount = Double(iPoint)
            }
            
            if amount == 0 {
                self.showMessagePrompt(NSLocalizedString("string-dailog-saving-point-pointspend-empty", comment: ""))
                return
            }
            if pointBalance.doubleValue < amount {
                self.showMessagePrompt(NSLocalizedString("string-dailog-saving-point-not-enough", comment: ""))
                return
            }
            if self.pointLimitOrder  < amount {
                self.showMessagePrompt(NSLocalizedString("string-dailog-point-over-limit-order", comment: ""))
                return
            }
            if amount < minPointTransfer {
                self.showMessagePrompt(NSLocalizedString("string-dailog-transfer-point-pointspend-min", comment: ""))
                return
            }
            
            self.showPointFriendTransferReviewView(true, self.friendModel, amount: amount, note: note)
        }
    }
}
