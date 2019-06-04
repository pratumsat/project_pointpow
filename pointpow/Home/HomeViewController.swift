//
//  HomeViewController.swift
//  pointpow
//
//  Created by thanawat on 6/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseMessaging

class HomeViewController: BaseViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var notiView: UIView!
    
    @IBOutlet weak var notificationImageView: UIImageView!
    @IBOutlet weak var pointBalanceLabel: UILabel!
    @IBOutlet weak var pointBalanceConstraintHeight: NSLayoutConstraint!
  
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    
    var isSetHeight = false
    
    var startHome = false
    var banner:[[String:AnyObject]]?
    var userData:AnyObject?
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !DataController.sharedInstance.getDefaultLanguage() {
            UserDefaults.standard.set(["th"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            DataController.sharedInstance.setDefaultLanguage()
        }
        
        let fcmToken = Messaging.messaging().fcmToken ?? ""
        let params:Parameters = ["device_token": fcmToken]
        self.modelCtrl.updateFCMToken(params: params, error: nil)
        
        
        
        
       
        
        ///fontList()
        
        
        
        self.setUp()
        self.receiverNotification(nil)
      
        NotificationCenter.default.addObserver(self, selector: #selector(receiverNotification), name: NSNotification.Name(rawValue: Constant.DefaultConstansts.NOTIFICATION_RECEIVER), object: nil)
        
    }
   
    @objc func receiverNotification(_ notification:NSNotification?){
        if let notiStructHolder = DataController.sharedInstance.getNotificationArrayOfObjectData(){
            guard let count = notiStructHolder.arrayNotification?.count  else { return }
            if count <= 0 {
                print("not found notification data")
                self.notiView.isHidden = true
                self.notiView.isUserInteractionEnabled = false
                
            }else{
                print("found notification data")
                self.notiView.isHidden = false
                self.notiView.isUserInteractionEnabled = true
            }
        }else{
            print("not found notification data")
            self.notiView.isHidden = true
            self.notiView.isUserInteractionEnabled = false
        }
    }
    
    func setUp(){
        self.hendleSetPasscodeSuccess = { (passcode, controller) in
            
            let message = NSLocalizedString("string-set-pincode-success", comment: "")
            let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: NSLocalizedString("string-button-ok", comment: ""), style: .cancel, handler: { (action) in
                
                controller.dismiss(animated: false, completion: { () in
                    //
                    self.startLoadAPI()
                })
            })
            alert.addAction(ok)
            alert.show()
        }
        
        self.hendleSetPasscodeSuccessWithStartApp = { (passcode, controller) in
            self.startLoadAPI()
        }

        self.handlerEnterSuccess = { (pin) in
            self.startLoadAPI()
        }
        
        self.backgroundImage?.image = nil
        self.homeCollectionView.delegate = self
        self.homeCollectionView.dataSource = self
        self.homeCollectionView.showsVerticalScrollIndicator = false
        
        self.addRefreshViewController(self.homeCollectionView)
        
        self.registerNib(self.homeCollectionView, "PromotionCampainCell")
        self.registerNib(self.homeCollectionView, "ItemServiceCell")
        
        
        let tapProfile  = UITapGestureRecognizer(target: self, action: #selector(tapToProfile))
        self.profileImageView.isUserInteractionEnabled = true
        self.profileImageView.addGestureRecognizer(tapProfile)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToPointBalance))
        self.pointBalanceLabel.isUserInteractionEnabled = true
        self.pointBalanceLabel.addGestureRecognizer(tap)
        
        let bell = UITapGestureRecognizer(target: self, action: #selector(tapToNotification))
        self.notificationImageView.isUserInteractionEnabled = true
        self.notificationImageView.addGestureRecognizer(bell)
        
        let bell2 = UITapGestureRecognizer(target: self, action: #selector(tapToNotification))
        self.notiView.isUserInteractionEnabled = true
        self.notiView.addGestureRecognizer(bell2)
        
        
        if DataController.sharedInstance.isLogin() {
            self.getUserInfo({
                self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""), lockscreen: true, startApp : true, animated : false)

            }, notAvaliable: { (action) in
                if action == "nopin"{
                    self.showSettingPassCodeModalView(NSLocalizedString("title-set-passcode", comment: ""), lockscreen: true)
                }
            }, lostConnection: {  (messageError) in

                let message = NSLocalizedString("error-connect-server-cri", comment: "")
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: NSLocalizedString("error-access-denied-confirm", comment: ""), style: .default, handler: { (action) in

                    exit(EXIT_SUCCESS)
                })
                alert.addAction(ok)
                alert.show()

            })
        }else{
            print("notLogin")
            self.showIntroduce(false) {
                //success
                self.startLoadAPI()
            }
        }
       
        // not token
        self.getBanner() {
            self.homeCollectionView.reloadData()
        }
        
        self.getGoldPremiumPrice()
        
       
    }
    
    func startLoadAPI(){
        
        if !self.startHome {
            self.showPoPup(true) {   //dismissView
                self.startHome = true
            }
        }
       
        self.getUserInfo()
        self.getMemberSetting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.isSetHeight {
            self.isSetHeight = true
            let height = self.view.frame.height
            self.pointBalanceConstraintHeight.constant = height*0.18
        }
        
        if DataController.sharedInstance.isLogin() {
            print("isLogin")
            if self.startHome {
                self.getUserInfo()
            }
        }
    }
    
    override func reloadData() {
        self.startLoadAPI()
    }
    
    func getMemberSetting(_ avaliable:(()->Void)?  = nil){
        modelCtrl.getMemberSetting(params: nil, true, succeeded: { (result) in
            avaliable?()
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                self.showMessagePrompt(message)
            }
           
            print(error)
        }) { (messageError) in
            print("messageError")
            
        }
    }
    
    func getGoldPremiumPrice(_ avaliable:(()->Void)?  = nil){
        modelCtrl.getPremiumGoldPrice(params: nil , false , succeeded: { (result) in
            print("get premium success")
            avaliable?()
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
    func getBanner(_ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.banner != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        modelCtrl.getBanner(params: nil , isLoading , succeeded: { (result) in
            
            if let items = result as? [[String:AnyObject]] {
                self.banner = items
            }
            avaliable?()
            
            
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
    
    func getUserInfo(_ avaliable:(()->Void)?  = nil, notAvaliable:((_ action:String)->Void)?  = nil ,
                     lostConnection:((_ messageError:String)->Void)? = nil){
        var isLoading:Bool = true
        if self.userData != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        modelCtrl.getUserData(params: nil , isLoading , succeeded: { (result) in
            self.userData = result
            
            if let data  = result as? [String:AnyObject] {
              
                //let status = data["status"] as? String ?? ""
                let is_pin = data["is_pin"] as? NSNumber ?? 0
                let first_name = data["first_name"] as? String ?? ""
                //let is_profile = data["is_profile"] as? NSNumber ?? 0
                let picture_data = data["picture_data"] as? String ?? ""
                let display_name = data["display_name"] as? String ?? ""
                let pointBalance = data["member_point"]?["total"] as? NSNumber ?? 0
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 2
                
                self.pointBalanceLabel.text = numberFormatter.string(from: pointBalance )
                
                
                if display_name.isEmpty {
                    self.displayNameLabel.text = "\(first_name)"
                }else{
                    self.displayNameLabel.text = "\(display_name)"
                }
                
                
                if let url  = URL(string: picture_data) {
                    self.profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                    
                }else{
                    self.profileImageView.image = UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER)
                }
                
                
                var action = ""
                
                if !is_pin.boolValue {
                    action = "nopin"
                }

                if action.isEmpty {
                    avaliable?()
                }else{
                    notAvaliable?(action)
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
            
            if messageError != "401" {
                lostConnection?(messageError)
            }else{
                self.handlerMessageError(messageError)
            }
            
            self.refreshControl?.endRefreshing()
        }
    }
    
    @objc func tapToProfile(){
        self.tabBarController?.selectedIndex = 4
    }
    @objc func tapToPointBalance(){
        self.showPointManagement(true)
    }
    @objc func tapToNotification(){
        self.showNotificationData(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        

    }
   
   
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.profileImageView.ovalColorWhiteProperties(borderWidth: 2.0)
        self.notiView.ovalColorClearProperties()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 6
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if indexPath.section == 0 {
            if let promo = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCampainCell", for: indexPath) as? PromotionCampainCell{
                promo.itemBanner = self.banner
                promo.autoSlideImage = true
                promo.luckyDrawCallback = {
                    self.showGoldPage(true)
                }
                
                cell = promo
            }
        }
        if indexPath.section == 1 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemServiceCell", for: indexPath) as? ItemServiceCell {
                cell = item
                
                switch indexPath.row {
                case 0:
                    item.itemImageView.image = UIImage(named: "ic-home-transfer-point")
                    item.nameLabel.text = NSLocalizedString("string-item-transfer-point", comment: "")
                    item.name2Label.text = NSLocalizedString("string-item-sub-transfer-point", comment: "")
                case 1:
                    item.itemImageView.image = UIImage(named: "ic-home-transfer-friend")
                    item.nameLabel.text = NSLocalizedString("string-item-transfer-friend", comment: "")
                    item.name2Label.text = NSLocalizedString("string-item-sub-transfer-friend", comment: "")
                case 2:
                    item.itemImageView.image = UIImage(named: "ic-home-point-free")
                    item.nameLabel.text = NSLocalizedString("string-item-free-point", comment: "")
                    item.name2Label.text = NSLocalizedString("string-item-sub-free-point", comment: "")
                case 3:
                    item.itemImageView.image = UIImage(named: "ic-home-gold")
                    item.nameLabel.text = NSLocalizedString("string-item-gold", comment: "")
                    item.name2Label.text = NSLocalizedString("string-item-sub-gold", comment: "")
                case 4:
                    item.itemImageView.image = UIImage(named: "ic-home-shopping")
                    item.nameLabel.text = NSLocalizedString("string-item-shopping", comment: "")
                    item.name2Label.text = NSLocalizedString("string-item-sub-shopping", comment: "")
                case 5:
                    item.itemImageView.image = UIImage(named: "ic-home-bills")
                    item.nameLabel.text = NSLocalizedString("string-item-bills", comment: "")
                    item.name2Label.text = NSLocalizedString("string-item-sub-bills", comment: "")
                default:
                    break
                    
                }
                item.name2Label.setLineSpacing(lineSpacing: 0, lineHeightMultiple: 0.9)
                item.name2Label.textAlignment = .center
                
                switch indexPath.row {
                    case 0,1,3,4:
                        let right = UIView(frame: CGRect(x: item.frame.width - 1, y: 0 ,
                                                         width: 1,
                                                         height: item.frame.height  ))
                        right.backgroundColor = Constant.Colors.LINE_COLOR
                        item.addSubview(right)
                default:
                    break
                }
                
              
                
                let lineBottom = UIView(frame: CGRect(x: 0, y: item.frame.height - 1 , width: collectionView.frame.width, height: 1 ))
                lineBottom.backgroundColor = Constant.Colors.LINE_COLOR
                item.addSubview(lineBottom)
            }
            
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if let data  = self.userData as? [String:AnyObject] {
                let is_profile = data["is_profile"] as? NSNumber ?? 0
                
                self.showPointTransferView(true, isProfile: is_profile.boolValue)
            }
            break
        case 1:
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
            break
        case 2:
            //comming
            break
        case 3:
            self.showGoldPage(true)
            break
        case 4:
            //comming
            
            //text data notification
            DataController.sharedInstance.clearNotificationArrayOfObjectData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.DefaultConstansts.NOTIFICATION_RECEIVER), object: nil, userInfo: [:])
            
            break
        case 5:
            //comming
            
            //test data notification
            mockaaw21Data()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.DefaultConstansts.NOTIFICATION_RECEIVER), object: nil, userInfo: [:])
            break
        default:
            break
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 1 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        }
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let width = collectionView.frame.width
            let height = width/1799*720
            return CGSize(width: width, height: height)
        }
        let width = collectionView.frame.width / 3
        let height = width + 20
        return CGSize(width: width, height: height)
    }
   

}
