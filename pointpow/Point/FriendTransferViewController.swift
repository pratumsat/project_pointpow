//
//  FriendTransferViewController.swift
//  pointpow
//
//  Created by thanawat on 14/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class FriendTransferViewController: BaseViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var searchView: UIView!
   
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var friendCollectionView: UICollectionView!
    
    var friendModel:[String:AnyObject]? {
        didSet{
            if friendModel == nil && recentFriend == nil{
                
                //self.addViewNotfoundData()
            }else{
                self.friendCollectionView.backgroundView = nil
            }
        }
    }
    var recentFriend:[[String:AnyObject]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("string-title-freind-transfer", comment: "")
        
        let scanIcon = UIBarButtonItem(image: UIImage(named: "ic-qr-scan"), style: .plain, target: self, action: #selector(popupQRTapped))
        
        self.navigationItem.rightBarButtonItem = scanIcon
        
        
        self.setUp()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getRecentFriend()
    }
    override func reloadData() {
        self.getRecentFriend()
    }
    
    func addViewNotfoundData(){
        if self.friendModel != nil {
            return
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        var centerpoint = view.center
        centerpoint.y -= self.view.frame.height*0.2
        
        let sorry = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        sorry.center = centerpoint
        sorry.textAlignment = .center
        sorry.font = UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.CONTENT )
        sorry.text = NSLocalizedString("string-not-found-item-transfer-friend", comment: "")
        sorry.textColor = UIColor.lightGray
        view.addSubview(sorry)
        
        self.friendCollectionView.reloadData()
        self.friendCollectionView.backgroundView = view
    }
    
    func getRecentFriend(_ avaliable:(()->Void)?  = nil){
        modelCtrl.recentFriendTransfer(params: nil , true , succeeded: { (result) in
            avaliable?()
            if let mResults = result as? [[String:AnyObject]] {
                
                if mResults.count <= 0 {
                    //self.addViewNotfoundData()
                }else{
                    self.recentFriend  = mResults
                    self.friendCollectionView.backgroundView = nil
                    self.friendCollectionView.reloadData()
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
    
    func searchBy(params:Parameters, _ callbackFriendModel:((_ friendModel:[String:AnyObject])->Void)? = nil){
        print(params)
        self.modelCtrl.searchMember(params: params, succeeded: { (result) in
            if let mResult = result as? [String:AnyObject]{
                print(mResult)
                
                if callbackFriendModel == nil{
                    self.friendModel = mResult
                    self.friendCollectionView.reloadData()
                }else{
                    callbackFriendModel?(mResult)
                }
                
                
              
            }
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                print(mError)
                if let mError = error as? [String:AnyObject]{
                    let message = mError["message"] as? String ?? ""
                    self.showMessagePrompt(message)
                    
                    if callbackFriendModel == nil{
                        self.friendModel = nil
                        self.friendCollectionView.reloadData()
                    }
                    
                }
            }
        }, failure: { (messageError) in
            self.handlerMessageError(messageError , title: "")
            if callbackFriendModel == nil{
                self.friendModel = nil
                self.friendCollectionView.reloadData()
            }
            
        })
    }
    
    @objc func popupQRTapped(){
        
        self.showPoPupChosenQRCode(true) { (choose) in
            if choose == "myqrcode" {
                self.showMyQRCodeView(true)
            }else{
                self.showScanBarcodeForMember { (result, barcode) in
                    
                    if let mResult = result as? [String : AnyObject] {
                        let qrType = mResult["type"] as? String ?? ""
                        
                        if qrType.lowercased() == "friend"{
                           
                            self.showNextStepTransfer(mResult)
                        }
                        
                    }
                   
                }
                
            }
        }
    }
   
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.searchView.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }

    func setUp(){
        self.searchTextField.delegate = self
        self.searchTextField.autocorrectionType = .no
        
        let search = UITapGestureRecognizer(target: self, action: #selector(searchFriendTapped))
        self.searchView.isUserInteractionEnabled = true
        self.searchView.addGestureRecognizer(search)
        
        self.searchTextField.borderRedColorProperties(borderWidth: 1.0)
        self.searchTextField.setLeftPaddingPoints(20)
        self.searchTextField.setRightPaddingPoints(40)
        
        self.searchView.borderClearProperties(borderWidth: 1)
        
        self.backgroundImage?.image = nil
        self.friendCollectionView.backgroundColor = UIColor.white
        
        self.addRefreshViewController(self.friendCollectionView)
        
        self.friendCollectionView.delegate = self
        self.friendCollectionView.dataSource = self
        self.friendCollectionView.showsVerticalScrollIndicator = false
        
        self.registerNib(self.friendCollectionView, "ItemFriendCell")
        self.registerNib(self.friendCollectionView, "ItemFriendSearchCell")
        self.registerHeaderNib(self.friendCollectionView, "HeadCell")
        
        
    }
    
    @objc func searchFriendTapped(){
        let keyword = self.searchTextField.text!
        self.searchFriend(keyword)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let keyword = self.searchTextField.text!
        self.searchFriend(keyword)
        
        return true
    }
    
    
    func searchFriend(_ keyword:String) {
        print("keyword = \(keyword)")
        if keyword.trimmingCharacters(in: .whitespaces).isEmpty {
             self.showMessagePrompt(NSLocalizedString("string-error-empty-search", comment: ""))
            return
        }
        
        if isValidEmail(keyword){
            print("email")
            let params:Parameters = ["email":keyword]
            self.searchBy(params: params)
            return
        }
        if validateMobile(keyword){
            print("mobile")
            let params:Parameters = ["mobile":keyword]
            self.searchBy(params: params)
            return
        }
        
        print("point id")
        let params:Parameters = ["pointpow_id":keyword]
        self.searchBy(params: params)

    }
    
    
    
    func validateMobile(_ mobile:String)-> Bool{
        var errorMobile = 0
        var errorMessage = ""
        let nMobile = mobile.replace(target: "-", withString: "")
        if nMobile.count != 10 {
            errorMobile += 1
        }
        if !checkPrefixcellPhone(nMobile) {
            errorMessage = NSLocalizedString("string-error-invalid-mobile", comment: "")
            errorMobile += 1
        }
        if nMobile.count < 10 {
            errorMessage = NSLocalizedString("string-error-invalid-mobile1", comment: "")
            errorMobile += 1
        }
        if nMobile.count > 10 {
            errorMessage = NSLocalizedString("string-error-invalid-mobile2", comment: "")
            errorMobile += 1
        }
        if errorMobile > 0 {
            //self.showMessagePrompt(errorMessage)
            return false
        }
        return true
    }
    func showNextStepTransfer(_ modelFriend:[String:AnyObject]){
        let is_profile = modelFriend["is_profile"] as? NSNumber ?? 0
        if is_profile.boolValue {
            self.showPointFriendTransferView(true, modelFriend)
        }else{
            self.showMessagePrompt2(NSLocalizedString("string-error-friendข-account-not-activated", comment: "")) {
                //callback click ok
            }
        }
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return (self.friendModel != nil) ? 1 : 0
        }
        return self.recentFriend?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if indexPath.section == 0 {
            if let friendCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemFriendSearchCell", for:  indexPath) as? ItemFriendSearchCell {
                
                
                cell = friendCell
                
                if let modelFriend = self.friendModel {
                    let display_name = modelFriend["display_name"] as? String ?? ""
                    let first_name = modelFriend["first_name"] as? String ?? ""
                    let last_name = modelFriend["last_name"] as? String ?? ""
                    var mobile = modelFriend["mobile"] as? String ?? ""
                    let picture_data = modelFriend["picture_data"] as? String ?? ""
                    let pointpow_id = modelFriend["pointpow_id"] as? String ?? ""
                
                    if let url = URL(string: picture_data) {
                        friendCell.coverImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                    }else{
                        friendCell.coverImageView.image = UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER)
                    }
                    
                    
                    //Display name / First name / Point Pow ID / Mobile Number
                    var showName = mobile
//                    if !showName.isEmpty {
//                        showName = showName.substring(start: 0, end: 7)
//                        showName += "xxx"
//
//                    }
                    if !pointpow_id.trimmingCharacters(in: .whitespaces).isEmpty {
                        showName = pointpow_id
                    }
                    if !first_name.trimmingCharacters(in: .whitespaces).isEmpty {
                        showName = first_name
                    }
                    if !display_name.trimmingCharacters(in: .whitespaces).isEmpty {
                        showName = display_name
                    }
                    friendCell.nameLabel.text = showName
                    
                    friendCell.didSelectImageView = {
                        self.showNextStepTransfer(modelFriend)
                    }
                    friendCell.tappedCallback = {
                        self.showNextStepTransfer(modelFriend)
                    }
                
                
                }
                
                
                let lineBottom = UIView(frame: CGRect(x: 0, y: friendCell.frame.height - 10 , width: friendCell.frame.width, height: 1 ))
                lineBottom.backgroundColor = Constant.Colors.LINE_PROFILE
                friendCell.addSubview(lineBottom)
                
            }
        }
        if indexPath.section == 1 {
            if let friendCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemFriendCell", for:  indexPath) as? ItemFriendCell {
                
                
                cell = friendCell
                
                if let modelFriend = self.recentFriend?[indexPath.row]["receiver"] as? [String:AnyObject] {
                    let display_name = modelFriend["display_name"] as? String ?? ""
                    let first_name = modelFriend["first_name"] as? String ?? ""
                    let last_name = modelFriend["last_name"] as? String ?? ""
                    var mobile = modelFriend["mobile"] as? String ?? ""
                    let picture_data = modelFriend["picture_data"] as? String ?? ""
                    let pointpow_id = modelFriend["pointpow_id"] as? String ?? ""
                    
                    
                    if let url = URL(string: picture_data) {
                        friendCell.coverImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                    }else{
                        friendCell.coverImageView.image = UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER)
                    }
                    
    
                    //Display name / First name / Point Pow ID / Mobile Number
                    var showName = mobile
                    //if !showName.isEmpty {
                        //showName = showName.substring(start: 0, end: 7)
                        //showName += "xxx"
                    //}
                    if !pointpow_id.trimmingCharacters(in: .whitespaces).isEmpty {
                        showName = pointpow_id
                    }
                    if !first_name.trimmingCharacters(in: .whitespaces).isEmpty {
                        showName = first_name
                    }
                    if !display_name.trimmingCharacters(in: .whitespaces).isEmpty {
                        showName = display_name
                    }
                    friendCell.nameLabel.text = showName
                 
                    
                    
                    //Recent
                    friendCell.didSelectImageView = {
                        let params:Parameters = ["mobile": mobile]
                        self.searchBy(params: params) { (model) in
                            self.showNextStepTransfer(model)
                        }
                        
                        
                    }
                    friendCell.tappedCallback = {
                        let params:Parameters = ["mobile": mobile]
                        self.searchBy(params: params) { (model) in
                            self.showNextStepTransfer(model)
                        }
                    }
                    
                }
                
            }
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            return CGSize.zero
            
        }
        return CGSize(width: collectionView.frame.width, height: CGFloat(30.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeadCell", for: indexPath) as! HeadCell
        
        let count = self.recentFriend?.count ?? 0
        if count > 0 {
            header.nameLabel.text = NSLocalizedString("string-point-transfer-friend-header-recent", comment: "")
            header.nameLabel.font = UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.FRIEND_HEADER_RECENT)!
        }
       
        header.backgroundColor = UIColor.white
        header.marginLeftConstrantLabel.constant = 35

        
        return header
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if indexPath.section == 0 {
            let width = collectionView.frame.width
            let height = width/155*125
            return CGSize(width: width, height: height)
        }
        let width = (collectionView.frame.width-40)/3
        let height = width/110*170
        return CGSize(width: width, height: height)
        
        
    }
    
}
