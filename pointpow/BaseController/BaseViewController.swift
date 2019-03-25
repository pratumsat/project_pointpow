//
//  BaseViewController.swift
//  ShopSi
//
//  Created by thanawat on 10/9/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//
import AVFoundation
import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Presentr
import FirebaseMessaging
import Alamofire

class BaseViewController: UIViewController ,  PAPasscodeViewControllerDelegate{

    var positionYTextField:CGFloat = 0
    var isShowKeyBoard = false
    var loadingView:Loading?
   
    var viewPopup: UIView?
    
    var windowSubview:UIImageView?
    var socialLoginSucces:Bool?
    var isExist:Bool = false
    let modelCtrl:ModelController = ModelController()
    
    
    var handlerDidCancel: (()->Void)?
    var handlerEnterSuccess: (()->Void)?
    var hendleSetPasscodeSuccess: ((_ passcode:String)->Void)?
    
    private var searchImageView:UIImageView?
    private var cartImageView:UIImageView?
    private var moreImageView:UIImageView?
    
    var backgroundImage:UIImageView?
    var refreshControl:UIRefreshControl?
    
    private var _fbLoginManager: FBSDKLoginManager?
    var fbLoginManager: FBSDKLoginManager {
        get {
            if _fbLoginManager == nil {
                _fbLoginManager = FBSDKLoginManager()
            }
            return _fbLoginManager!
        }
    }
    
    @objc func backTapped(){
        print("backTapped")
    }
    
    var isHiddenStatusBar:Bool = false {
        didSet{
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .none
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool{
        return isHiddenStatusBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backTapped))
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        //add tap dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        

        NotificationCenter.default.addObserver(self, selector: #selector(GoogleSigInSuccess), name: NSNotification.Name(rawValue: Constant.DefaultConstansts.NotificationGoogleSigInSuccess), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GoogleSigInFailure), name: NSNotification.Name(rawValue: Constant.DefaultConstansts.NotificationGoogleSigInFailure), object: nil)
      
     
        
        backgroundImage = UIImageView()
        backgroundImage!.image = UIImage(named: "background_image")
        backgroundImage!.frame = self.view.frame
        backgroundImage!.contentMode = .scaleAspectFill
        backgroundImage!.clipsToBounds = true
        
        self.view.addSubview(backgroundImage!)
        self.view.sendSubviewToBack(backgroundImage!)
        
        
        var v:UIView = self.view
        if let nav = self.navigationController{
            if let rootNav = nav.navigationController{
                v = rootNav.view
            }else{
                v = nav.view
            }
        }
        self.loadingView = Loading(rootView: v)
        
        modelCtrl.loadingStart = { () in
            print("Start")
            self.loadingView?.showLoading()
        }
        modelCtrl.loadingFinish = { () in
            print("Finish")
            self.loadingView?.hideLoading()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(resetPinCode), name: NSNotification.Name(rawValue: Constant.DefaultConstansts.RESET_PIN), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constant.DefaultConstansts.RESET_PIN), object : nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object : nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object : nil)
    }
    
    @objc func resetPinCode(notification: NSNotification){
        //showResetpin
        self.showSettingPassCodeModalView()
    }
    
    @objc func GoogleSigInSuccess(notification: NSNotification){
//        if let userInfo = notification.userInfo as? [String:AnyObject]{
//
//            print(userInfo)
//
////            let fbtoken = FBSDKAccessToken.current()?.tokenString ?? ""
////            let email = item["email"] as? String ?? ""
////            let first_name = item["first_name"] as? String ?? ""
////            let last_name = item["last_name"] as? String ?? ""
////            let fcmToken = Messaging.messaging().fcmToken ?? ""
////
////            let params:Parameters = ["email" : email,
////                                     "firstname": first_name,
////                                     "lastname" : last_name,
////                                     "social_token" : fbtoken,
////                                     "device_token": fcmToken,
////                                     "app_os": "ios"]
////
////            self.modelCtrl.loginWithSocial(params: params, succeeded: { (result) in
////                if let mResult = result as? [String:AnyObject]{
////                    print(mResult)
////                    let dupicate = mResult["exist_email"] as? NSNumber ?? 0
////                    if dupicate.boolValue {
////                        self.isExist = true
////                    }else{
////                        self.isExist = false
////                    }
////                    self.socialLoginSucces = true
////                }
////            }, error: { (error) in
////                if let mError = error as? [String:AnyObject]{
////                    print(mError)
////                }
////            }, failure: { (messageError) in
////                self.handlerMessageError(messageError , title: "")
////            })
//            //when after call api success
//            //self.socialLoginSucces = true
//
//        }
        
    }
   
    
    @objc func GoogleSigInFailure(notification: NSNotification){
        if let userInfo = notification.userInfo as? [String:AnyObject]{
            self.showMessagePrompt(userInfo["error"] as? String ?? "unknow")
        }
    }
    
    func registerTableViewNib(_ tableTarget:UITableView ,_ nibName:String){
        
        let nib = UINib(nibName: nibName, bundle: nil)
        tableTarget.register(nib, forCellReuseIdentifier: nibName)
        
    }
    
    func registerNib(_ collecionTarget:UICollectionView ,_ nibName:String){
        
        let nib = UINib(nibName: nibName, bundle: nil)
        collecionTarget.register(nib, forCellWithReuseIdentifier: nibName)
        
    }
    func registerHeaderNib(_ collecionTarget:UICollectionView ,_ nibName:String){
        
        let nib = UINib(nibName: nibName, bundle: nil)
        collecionTarget.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: nibName)
    }
    
    func registerFooterNib(_ collecionTarget:UICollectionView ,_ nibName:String){
        
        let nib = UINib(nibName: nibName, bundle: nil)
        collecionTarget.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                 withReuseIdentifier: nibName)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let hH =  UIScreen.main.bounds.height / 2
        

        if self.positionYTextField == 0 {
            return
        }
        if let _ = self.windowSubview {
            self.positionYTextField += 100
        }
        var bottomSafeArea: CGFloat
        
        if #available(iOS 11.0, *) {
            bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            bottomSafeArea = bottomLayoutGuide.length
        }
        self.positionYTextField -= bottomSafeArea
        self.positionYTextField += 50
        
        print("positionTextField y \(self.positionYTextField)")
        print("half height \(hH)")
        
        if self.positionYTextField < hH {
            return
        }
        
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        
            if self.view.bounds.origin.y == 0 {
                if !self.isShowKeyBoard {
                    self.isShowKeyBoard = true
                    
                    if (self.positionYTextField - hH)  > hH{
                        self.gapHeightKeyboard  += 200
                    }else{
                        self.gapHeightKeyboard  += abs(keyboardSize.size.height - self.positionYTextField)
                    }
                    
                    
                    self.view.frame.origin.y -= self.gapHeightKeyboard
                    self.windowSubview?.isHidden = true
                    
                }
                //self.view.frame.origin.y -= (keyboardSize.height)
            }
        }
    }
    var gapHeightKeyboard = CGFloat(0)
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            //if self.view.frame.origin.y < 0 {
                print(self.view.frame.origin.y)
                if self.isShowKeyBoard {
                    self.isShowKeyBoard = false
                
                    self.view.frame.origin.y += self.gapHeightKeyboard
                    self.windowSubview?.isHidden = false
                    self.gapHeightKeyboard = 0
                }
                //self.view.frame.origin.y += (keyboardSize.height)
            //}
        }
    }
    
    
    
    func showScanBarcode(resultScan:((_ model:AnyObject,_ barcode:String)->Void)?){
        if AVCaptureDevice.authorizationStatus(for: .video) !=  .denied {
            if let scanVc:ScannerViewController = self.storyboard?.instantiateViewController(withIdentifier: "ScannerViewController") as? ScannerViewController {
                
                scanVc.barcodeCallback = { (result , code) in
                    resultScan?(result , code )
                }
                
                self.present(scanVc, animated: true, completion: nil)
            }
        } else {
            self.cannotAccessCamera()
        }
        
    }
    func showScanBarcodeForMember(resultScan:((_ model:AnyObject,_ barcode:String)->Void)?){
        if AVCaptureDevice.authorizationStatus(for: .video) !=  .denied {
            if let scanVc:Scanner2ViewController = self.storyboard?.instantiateViewController(withIdentifier: "Scanner2ViewController") as? Scanner2ViewController {
                
                scanVc.barcodeCallback = { (result , code) in
                    resultScan?(result , code )
                }
                
                self.present(scanVc, animated: true, completion: nil)
            }
        } else {
            self.cannotAccessCamera()
        }
        
    }
    func showGoldPage(_ animated:Bool){
        
        if let vc:GoldNavViewController = self.storyboard?.instantiateViewController(withIdentifier: "GoldNavViewController") as? GoldNavViewController {
            
            self.present(vc, animated: animated, completion: nil)
            
         
        }
      
        
        
    }
    
    func confirmGoldSavingPage(_ animated:Bool, modelSaving:(pointBalance:Double?, pointSpend:Double?, goldReceive:Double?, currentGoldprice:Double?)){
        if let vc:ConfirmSavingViewController  = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmSavingViewController") as? ConfirmSavingViewController {
        
            vc.modelSaving = modelSaving
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    

    func chooseShippingPage(_ animated:Bool, withdrawData:(premium:Int, goldbalance:Double,goldAmountToUnit:(amount:Int, unit:Int , price:Double, goldPrice:Int))?){
        if let vc:GoldWithDrawChooseShippingViewController  = self.storyboard?.instantiateViewController(withIdentifier: "GoldWithDrawChooseShippingViewController") as? GoldWithDrawChooseShippingViewController {
    
            vc.withdrawData = withdrawData
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showWithDrawSummaryOfficeView(_ animated:Bool, withdrawData:(premium:Int,  goldbalance:Double,goldAmountToUnit:(amount:Int, unit:Int , price:Double, goldPrice:Int))?){
        
        if let vc:WithDrawSummaryOfficeViewController  = self.storyboard?.instantiateViewController(withIdentifier: "WithDrawSummaryOfficeViewController") as? WithDrawSummaryOfficeViewController {
            vc.withdrawData  = withdrawData
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showWithDrawSummaryThaiPostView(_ animated:Bool,
                                         withdrawData:(premium:Int, goldbalance:Double,goldAmountToUnit:(amount:Int, unit:Int , price:Double, goldPrice:Int))?,
                                         addressModel: [String:AnyObject] , ems:Int ,fee: Int, name:String, mobile:String){
        
        if let vc:WithDrawSummaryThaiPostViewController  = self.storyboard?.instantiateViewController(withIdentifier: "WithDrawSummaryThaiPostViewController") as? WithDrawSummaryThaiPostViewController {
            vc.withdrawData  = withdrawData
            vc.addressModel = addressModel
            vc.ems = ems
            vc.fee = fee
            vc.name = name
            vc.mobile = mobile
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }

    
    func showIntroduce(_ animated:Bool){
        if let vc:IntroNav = self.storyboard?.instantiateViewController(withIdentifier: "IntroNav") as? IntroNav {
            
            self.present(vc, animated: animated, completion: nil)
        }
    }
    func showLogin(_ animated:Bool){
        if let vc:LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showVerify(_ mobilePhone:String, _ ref_id:String, _ member_id:String, _ animated:Bool){
        if let vc:VerifyViewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController") as? VerifyViewController {
            vc.mobilePhone = mobilePhone
            vc.ref_id = ref_id
            vc.member_id = member_id
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showRegister(_ animated:Bool){
        if let vc:RegisterViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showMapFullViewController(_ animated:Bool , dissmissCallback:(()->Void)?){
        if let vc:WebViewMapViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewMapViewController") as? WebViewMapViewController {
            
            vc.dissmissCallback = dissmissCallback
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showPrivacyPolicy(_ animated:Bool){
        if let vc:PrivacyPolicyViewController = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as? PrivacyPolicyViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showRegisterGoldSaving(_ animated:Bool, userData:AnyObject?){
        if let vc:RegisterGoldViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterGoldViewController") as? RegisterGoldViewController {
            
            vc.userData = userData
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
   
    func showRegisterGoldStep2Saving(_ animated:Bool, tupleModel:(image : UIImage?, firstname : String,lastname: String , email: String,mobile: String,idcard: String)?){
        if let vc:RegisterGoldstep2ViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterGoldstep2ViewController") as? RegisterGoldstep2ViewController {
            
            vc.tupleModel = tupleModel
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showRegisterGoldStep3Saving(_ animated:Bool, tupleModel:(image : UIImage?, firstname : String,lastname: String , email: String,mobile: String,idcard: String)?){
        if let vc:RegisterGoldstep3ViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterGoldstep3ViewController") as? RegisterGoldstep3ViewController {
            
            vc.tupleModel = tupleModel
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showForgot(_ animated:Bool){
        if let vc:ForgotPasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showPointManagement(_ animated:Bool){
        if let vc:PointManageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PointManageViewController") as? PointManageViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    @objc func reNewApplication(){
        UIApplication.shared.keyWindow?.rootViewController = storyboard!.instantiateViewController(withIdentifier: "MainNav")
    }
    
    
    func showProfileView(_ animated:Bool){
        if let vc:ProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showPersonalView(_ animated:Bool){
        if let vc:PersonalViewController = self.storyboard?.instantiateViewController(withIdentifier: "PersonalViewController") as? PersonalViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showChangePasswordView(_ animated:Bool){
        if let vc:ChangePasswordViewController  = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showSettingView(_ animated:Bool){
        if let vc:SettingViewController  = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showDisplayNameView(_ animated:Bool){
        if let vc:DisplayNameViewController  = self.storyboard?.instantiateViewController(withIdentifier: "DisplayNameViewController") as? DisplayNameViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showMobilePhoneView(_ animated:Bool){
        if let vc:MobileViewController  = self.storyboard?.instantiateViewController(withIdentifier: "MobileViewController") as? MobileViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showEmailView(_ animated:Bool){
        if let vc:EmailViewController  = self.storyboard?.instantiateViewController(withIdentifier: "EmailViewController") as? EmailViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showPointTransferView(_ animated:Bool){
        if let vc:PointTransferViewController  = self.storyboard?.instantiateViewController(withIdentifier: "PointTransferViewController") as? PointTransferViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showFriendTransferView(_ animated:Bool){
        if let vc:FriendTransferViewController  = self.storyboard?.instantiateViewController(withIdentifier: "FriendTransferViewController") as? FriendTransferViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showPPWebView(_ animated:Bool){
        if let vc:PPWebViewController  = self.storyboard?.instantiateViewController(withIdentifier: "PPWebViewController") as? PPWebViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showResetPasswordView(_ animated:Bool){
        if let vc:ResetPasswordViewController  = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as? ResetPasswordViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showFavoriteView(_ animated:Bool){
        if let vc:FavoriteViewController  = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as? FavoriteViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    
    func showBankTransferView(_ animated:Bool){
        if let vc:BankPointTransferViewController  = self.storyboard?.instantiateViewController(withIdentifier: "BankPointTransferViewController") as? BankPointTransferViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showResultTransferView(_ animated:Bool, finish:(()->Void)? = nil){
        if let vc:ResultTransferNav  = self.storyboard?.instantiateViewController(withIdentifier: "ResultTransferNav") as? ResultTransferNav {
            vc.callbackFinish = {
                finish?()
            }
            self.present(vc, animated: animated, completion: nil)
        }
    }
    
    func showPointFriendSummaryTransferView(_ animated:Bool , finish:(()->Void)? = nil){
        if let vc:PointFreindSummaryNav  = self.storyboard?.instantiateViewController(withIdentifier: "PointFreindSummaryNav") as? PointFreindSummaryNav {
            vc.callbackFinish = {
                finish?()
            }
            self.present(vc, animated: animated, completion: nil)
        }
    }
    
    
    func showGoldSavingResult(_ animated:Bool, transactionId:String, finish:(()->Void)? = nil){
       
        if finish != nil {
            if let vc:SavingResultNav  = self.storyboard?.instantiateViewController(withIdentifier: "SavingResultNav") as? SavingResultNav {
                vc.transactionId = transactionId
                
                
                vc.callbackFinish = {
                    finish?()
                }
                self.present(vc, animated: animated, completion: nil)
                
            }
            
        }else{
            if let vc:SavingResultViewController  = self.storyboard?.instantiateViewController(withIdentifier: "SavingResultViewController") as? SavingResultViewController {
                
                vc.transactionId = transactionId
                vc.hideFinishButton = true
                self.navigationController?.pushViewController(vc, animated: animated)
            }
            
        }
        
        
    }
    
   
    
    func showGoldWithDrawResult(_ animated:Bool, transactionId:String, finish:(()->Void)? = nil){
        
        if finish != nil{
            if let vc:WithDrawResultNav  = self.storyboard?.instantiateViewController(withIdentifier: "WithDrawResultNav") as? WithDrawResultNav {
                vc.transactionId = transactionId
                
                vc.callbackFinish = {
                    finish?()
                }
                self.present(vc, animated: animated, completion: nil)
            }
        }else{
            if let vc:WithDrawResultViewController  = self.storyboard?.instantiateViewController(withIdentifier: "WithDrawResultViewController") as? WithDrawResultViewController {
                
                vc.transactionId = transactionId
                vc.hideFinishButton = true
                self.navigationController?.pushViewController(vc, animated: animated)
            }
        }
        
       
    }
    
    
    
    func showPointFriendTransferView(_ animated:Bool){
        if let vc:PointFriendTransferViewController  = self.storyboard?.instantiateViewController(withIdentifier: "PointFriendTransferViewController") as? PointFriendTransferViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }

    func showPointFriendTransferReviewView(_ animated:Bool){
        if let vc:PointFriendTransferReviewViewController  = self.storyboard?.instantiateViewController(withIdentifier: "PointFriendTransferReviewViewController") as? PointFriendTransferReviewViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showEnterPassCodeModalView(_ title:String = NSLocalizedString("title-enter-passcode", comment: "")){
        let enterPasscode = PAPasscodeViewController(for: PasscodeActionEnter )
        enterPasscode!.centerPosition = true
        enterPasscode!.delegate = self
        enterPasscode!.title = title
        
        let navController = UINavigationController(rootViewController: enterPasscode!)
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                                                           NSAttributedString.Key.font :  UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.TITLE )!]
    
        let presenter: Presentr = {
            let w = self.view.frame.width
            let h = self.view.frame.height
            
            let width = ModalSize.custom(size: Float(w))
            let height = ModalSize.custom(size: Float(h))
            
            let center = ModalCenterPosition.center
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.dismissOnTap = false
            
            return customPresenter
        }()
        
        customPresentViewController(presenter, viewController: navController, animated: true, completion: nil)
    }
    
    
    
    func showPenddingVerifyModalView(_ animated:Bool , dismissCallback:(()->Void)?){
        
        let presenter: Presentr = {
            let w = self.view.frame.width
            let h = self.view.frame.height
            
            let width = ModalSize.custom(size: Float(w))
            let height = ModalSize.custom(size: Float(h))
            
            let center = ModalCenterPosition.center
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.dismissOnTap = false
            
            return customPresenter
        }()
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoldPenddingVerifyNav") as? GoldPenddingVerifyNav {
            
            vc.dismissCallback = {
                dismissCallback?()
            }
            customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
        }
        
    }
    
    
    
    
    func showSettingPassCodeModalView(_ title:String = NSLocalizedString("title-set-passcode", comment: "")){
        let enterPasscode = PAPasscodeViewController(for: PasscodeActionSet )
        enterPasscode!.centerPosition = true
        enterPasscode!.delegate = self
        enterPasscode!.title = title
        
        let navController = UINavigationController(rootViewController: enterPasscode!)
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                                                           NSAttributedString.Key.font :  UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.TITLE )!]
        
        
        
        let presenter: Presentr = {
//            let w = self.view.frame.width
//            //let h = self.view.frame.height
//
//            let width = ModalSize.custom(size: Float(w))
//            let height = ModalSize.custom(size: Float(w / 300 * 500))
//            //let height = ModalSize.custom(size: Float(h))
//
//            let center = ModalCenterPosition.bottomCenter
//            //let center = ModalCenterPosition.center
//            let customType = PresentationType.custom(width: width, height: height, center: center)

            let w = self.view.frame.width
            let h = self.view.frame.height
            
            let width = ModalSize.custom(size: Float(w))
            let height = ModalSize.custom(size: Float(h))
            
            let center = ModalCenterPosition.center
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.dismissOnTap = false
            
            return customPresenter
        }()
        
        customPresentViewController(presenter, viewController: navController, animated: true, completion: nil)
    }
    func paPasscodeViewControllerDidCancel(_ controller: PAPasscodeViewController!) {
        print("paPasscodeViewControllerDidCancel")
        
        self.handlerDidCancel?()
        controller.dismiss(animated: true, completion: nil)
        
    }
    func paPasscodeViewControllerDidEnterPasscodeResult(_ controller: PAPasscodeViewController!, didEnterPassCode passcode: String!) {
        print("enter passcode: \(passcode ?? "unknow")")
        
        
        let params:Parameters = ["pin" : Int(passcode)!]
        self.modelCtrl.enterPinCode(params: params, true, succeeded: { (result) in
            controller.dismiss(animated: false, completion: { () in
                self.handlerEnterSuccess?()
            })
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                
                controller.showFailedMessage(message)
            }
        }) { (messageError) in
            self.handlerMessageError(messageError)
            controller.showFailedMessage("")
        }
        
    
    }
    func paPasscodeViewControllerDidResetEmail(_ controller: PAPasscodeViewController!, didResetEmailPinCode email: String!) {
        
        if email.isEmpty {
            let emptyEmail = NSLocalizedString("string-error-empty-email", comment: "")
            controller.showFailedMessage(emptyEmail)
            return
            
        }
        if isValidEmail(email) {
            let params:Parameters = ["email" : email!]
            self.modelCtrl.forgotPinCode(params: params, true, succeeded: { (result) in
                
                self.showMessagePrompt2(NSLocalizedString("title-forgot-passcode-reset-email", comment: "")) {
                    controller.dismiss(animated: true, completion: nil)
                }
                
            }, error: { (error) in
                if let mError = error as? [String:AnyObject]{
                    let message = mError["message"] as? String ?? ""
                    print(message)
                    
                    controller.showFailedMessage(message)
                }
            }) { (messageError) in
                self.handlerMessageError(messageError)
                controller.showFailedMessage("")
            }
            
        }else{
            let emailNotValid = NSLocalizedString("string-error-invalid-email", comment: "")
            controller.showFailedMessage(emailNotValid)
        }
        
       
        
    }
    func paPasscodeViewControllerDidSetPasscode(_ controller: PAPasscodeViewController!, didSetPassCode passcode: String!) {
        
        print("set passcode: \(passcode ?? "unknow")")
        
        let tokenResetPin = DataController.sharedInstance.getResetPinToken()
        if tokenResetPin != "" {
            let params:Parameters = ["reset_pin_token" : tokenResetPin,
                                     "new_pin" : Int(passcode)!]
            self.modelCtrl.resetPinCodeToken(params: params, true, succeeded: { (result) in
                DataController.sharedInstance.setResetPinToken("")
                
                let message = NSLocalizedString("string-reset-pincode-success", comment: "")
                let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                let ok = UIAlertAction(title: NSLocalizedString("string-button-ok", comment: ""), style: .cancel, handler: { (action) in
                    
                    controller.dismiss(animated: false, completion: { () in
                        //
                    })
                })
                alert.addAction(ok)
                alert.show()
                
               
            }, error: { (error) in
                if let mError = error as? [String:AnyObject]{
                    let message = mError["message"] as? String ?? ""
                    print(message)
                    
                    controller.showFailedMessage(message)
                }
            }) { (messageError) in
                self.handlerMessageError(messageError)
            }
            //
        }else{
            
            
            let params:Parameters = ["new_pin" : Int(passcode)!]
            self.modelCtrl.setPinCode(params: params, true, succeeded: { (result) in
                
                controller.dismiss(animated: false, completion: { () in
                    self.hendleSetPasscodeSuccess?(passcode)
                })
            }, error: { (error) in
                if let mError = error as? [String:AnyObject]{
                    let message = mError["message"] as? String ?? ""
                    print(message)
                    
                    controller.showFailedMessage(message)
                }
            }) { (messageError) in
                self.handlerMessageError(messageError)
            }
            
        }
        
     
       
        
        
        
    }
    func showTransferSuccessPopup(_ animated:Bool , nextStepCallback:(()->Void)? = nil ){
        let presenter: Presentr = {
            
            let customPresenter = Presentr(presentationType: PresentationType.alert)
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 10
            customPresenter.dismissOnSwipe = false
            customPresenter.dismissOnTap = false
            
            
            return customPresenter
        }()
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpTransferSuccessViewController") as? PopUpTransferSuccessViewController{
            
            customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
            
        }
    }
    
    func showRegisterSuccessPopup(_ animated:Bool , nextStepCallback:(()->Void)? = nil ){
        let presenter: Presentr = {
            
            let customPresenter = Presentr(presentationType: PresentationType.alert)
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 10
            customPresenter.dismissOnSwipe = true
            customPresenter.dismissOnTap = true
            
            
            return customPresenter
        }()
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpRegisterSuccessViewController") as? PopUpRegisterSuccessViewController{
            vc.dismissView = {
                nextStepCallback?()
            }
            
            self.viewPopup = vc.view
            customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
            
        }
    }
    func showAddNameFavoritePopup(_ animated:Bool ,favName:String? = nil, savedCallback:(()->Void)? = nil ){
        let presenter: Presentr = {
            
            let w = self.view.frame.width * 0.8
            let h =  CGFloat(250) //w/390*300
            let width = ModalSize.custom(size: Float(w))
            let height = ModalSize.custom(size: Float(h))
            
            let center = ModalCenterPosition.center
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 10
            customPresenter.dismissOnSwipe = false
            customPresenter.dismissOnTap = false
            
            
            return customPresenter
        }()
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavorPopupViewController") as? FavorPopupViewController{
            vc.favName = favName
            vc.didSave =  {
                savedCallback?()
            }
            
            self.viewPopup = vc.view
            customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
            
        }
    }
    func showPersonalPopup(_ animated:Bool , nextStepCallback:(()->Void)? = nil ){
        let presenter: Presentr = {
            
            let w = self.view.frame.width * 0.9
            let h = w/275*479
            let width = ModalSize.custom(size: Float(w))
            let height = ModalSize.custom(size: Float(h))
            
            let center = ModalCenterPosition.center
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 10
            customPresenter.dismissOnSwipe = false
            customPresenter.dismissOnTap = false
 
            
            return customPresenter
        }()
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PersonalPopupViewController") as? PersonalPopupViewController{
            
            vc.nextStep =  {
                nextStepCallback?()
            }
            
            self.viewPopup = vc.view
            customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
            
        }
    }
    
    func showShippingPopup(_ animated:Bool , editData:AnyObject? , fromPopup:Bool = false ,nextStepCallback:((_ address:AnyObject)->Void)? = nil ){
        let presenter: Presentr = {
            
            let w = self.view.frame.width * 0.9
            let h = w/275*479
            let width = ModalSize.custom(size: Float(w))
            let height = ModalSize.custom(size: Float(h))
            
            let center = ModalCenterPosition.center
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 10
            customPresenter.dismissOnSwipe = false
            customPresenter.dismissOnTap = false
            
            
            return customPresenter
        }()
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupShippingAddressViewController") as? PopupShippingAddressViewController{
            vc.fromPopup = fromPopup
            vc.modelAddress = editData
            vc.nextStep =  { (address) in
                nextStepCallback?(address)
            }
            self.viewPopup = vc.view
            customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
            
        }
    }
    
    
    func showEditShippingPopup(_ animated:Bool , editData:AnyObject? , fromPopup:Bool = false ,nextStepCallback:((_ address:AnyObject)->Void)? = nil ){
        let presenter: Presentr = {
            
            let w = self.view.frame.width * 0.9
            let h = w/275*479
            let width = ModalSize.custom(size: Float(w))
            let height = ModalSize.custom(size: Float(h))
            
            let center = ModalCenterPosition.center
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 10
            customPresenter.dismissOnSwipe = false
            customPresenter.dismissOnTap = false
            
            
            return customPresenter
        }()
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupEditAddressViewController") as? PopupEditAddressViewController{
            vc.fromPopup = fromPopup
            vc.modelAddress = editData
            vc.nextStep =  { (address) in
                nextStepCallback?(address)
            }
            self.viewPopup = vc.view
            customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
            
        }
    }
    
    func showShippingAddressPopup(_ animated:Bool, selectCallback:((_ selectedAddress:AnyObject)->Void)? = nil ){
        let presenter: Presentr = {
            
            let w = self.view.frame.width * 0.9
            let h = w/275*320
            let width = ModalSize.custom(size: Float(w))
            let height = ModalSize.custom(size: Float(h))
            
            let center = ModalCenterPosition.center
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 10
            customPresenter.dismissOnSwipe = false
            customPresenter.dismissOnTap = false
            
            
            return customPresenter
        }()
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupShippingMyAddressViewController") as? PopupShippingMyAddressViewController{
            
            
            vc.selectedAddressCallback = { (selectedAddress) in
                selectCallback?(selectedAddress)
            }
            vc.addAddressCallback = { (modelAddress) in
                self.showShippingPopup(true , editData: modelAddress , fromPopup: true) { (address) in
                    selectCallback?(address)
                }
            }
            vc.editAddressCallback = { (modelAddress) in
                self.showEditShippingPopup(true , editData: modelAddress , fromPopup: true) { (address) in
                    selectCallback?(address)
                }
            }
            self.viewPopup = vc.view
            customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
            
        }
    }
    
    
    func showFilterHistoryPopup(_ animated:Bool , editData:AnyObject? , selectedSaving:Bool ,nextStepCallback:((_ data:AnyObject)->Void)? = nil ){
        let presenter: Presentr = {
            
            let w = self.view.frame.width * 0.9
            let h = 260
            let width = ModalSize.custom(size: Float(w))
            let height = ModalSize.custom(size: Float(h))
            
            let center = ModalCenterPosition.topCenter
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.transitionType = .coverVerticalFromTop
            
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 10
            customPresenter.dismissOnSwipe = false
            customPresenter.dismissOnTap = false
            
            let view = UIView(frame: self.view.frame)
            customPresenter.customBackgroundView = view
            
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardPopup))
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(tap)
            
            
            return customPresenter
        }()
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupGoldHistoryFilterViewController") as? PopupGoldHistoryFilterViewController{
            
            vc.editData = editData
            vc.nextStep = {(data) in
                nextStepCallback?(data)
            }
            vc.selectedSaving = selectedSaving
            
            self.viewPopup = vc.view
           customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
            
        }
    }
    
  
    
    func showPoPup(_ animated:Bool , dismissCallback:(()->Void)? = nil){
        let presenter: Presentr = {
            
            let w = self.view.frame.width * 0.8
            let width = ModalSize.custom(size: Float(w))
            let height = ModalSize.custom(size: Float(w / 260 * 310))
            
            let center = ModalCenterPosition.center
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 10
            customPresenter.dismissOnSwipe = true
            customPresenter.dismissOnTap = true
            
            return customPresenter
        }()
    
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController{
        
            vc.dismissView = {
                dismissCallback?()
            }
            self.viewPopup = vc.view
            customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
            
        }
    }
    
    
    func showInfoGoldPremiumPopup(_ animated:Bool , nextStepCallback:(()->Void)? = nil ){
        let presenter: Presentr = {
            
            let w = self.view.frame.width * 0.8
            let h = w/275*315
            let width = ModalSize.custom(size: Float(w))
            let height = ModalSize.custom(size: Float(h))
            
            let center = ModalCenterPosition.center
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 10
            customPresenter.dismissOnSwipe = true
            customPresenter.dismissOnTap = true
            
            
            return customPresenter
        }()
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupGoldPremiumViewController") as? PopupGoldPremiumViewController{
            
            self.viewPopup = vc.view
            
            customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
            
        }
    }
    
    func showInfoThaiPostPopup(_ animated:Bool , nextStepCallback:(()->Void)? = nil ){
        let presenter: Presentr = {
            
            let w = self.view.frame.width * 0.9
            let h = w/275*400
            let width = ModalSize.custom(size: Float(w))
            let height = ModalSize.custom(size: Float(h))
            
            let center = ModalCenterPosition.center
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 10
            customPresenter.dismissOnSwipe = true
            customPresenter.dismissOnTap = true
            
            
            return customPresenter
        }()
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpInfoThaiPostViewController") as? PopUpInfoThaiPostViewController{
            
            self.viewPopup = vc.view
            
            customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
            
        }
    }
    
    
    
    
    func showInfoMapOfficePopup(_ animated:Bool , openMap:(()->Void)? = nil ){
        let presenter: Presentr = {
            
            let w = self.view.frame.width * 0.8
            let h = w/275*315
            let width = ModalSize.custom(size: Float(w))
            let height = ModalSize.custom(size: Float(h))
            
            print("w = \(width)")
            print("h = \(height)")
            
            let center = ModalCenterPosition.center
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 10
            customPresenter.dismissOnSwipe = true
            customPresenter.dismissOnTap = true
            
            
            return customPresenter
        }()
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpMapOfficeViewController") as? PopUpMapOfficeViewController{
            
            self.viewPopup = vc.view
            
            vc.openMap = openMap
            
            customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
            
        }
    }
    
    
    
    
    func handlerMessageError(_ messageError:String ,  title:String =  "Error"){
        if messageError == "-1009"{
            self.AlertMessageDialogOK(NSLocalizedString("error-connect-server-internet", comment: ""))
            return
        }
        if messageError == "401"{
            self.AlertErrorAccessDenied()
            return
        }
        if messageError == "500"{
            self.AlertMessageDialogOK(NSLocalizedString("error-connect-server", comment: ""))
            return
        }
        self.AlertMessageDialogOK(messageError , title: title)
    }
    
    func AlertErrorAccessDenied(){
        let title:String = "Error"
        let message:String = NSLocalizedString("error-access-denied", comment: "")
       
        let confirm = NSLocalizedString("error-access-denied-confirm", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: confirm, style: .default) { _ in
            
            //Logout
            DataController.sharedInstance.setToken("")
             Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.reNewApplication), userInfo: nil, repeats: false)
            
        }
        alert.addAction(confirmAction)
        alert.show()
        //self.present(alert, animated: true, completion: nil)
    }
    
    func AlertMessageDialogOK(_ message:String, title:String = "Error"){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: NSLocalizedString("string-button-ok", comment: ""), style: .default, handler: nil)
        alert.addAction(ok)
        
        alert.show()
        //self.present(alert, animated: true, completion: nil)
    }
    
    func showMessagePrompt(_ message:String){
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: NSLocalizedString("string-button-ok", comment: ""), style: .cancel, handler: nil)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showMessagePrompt2(_ message:String , okCallback:(()->Void)? = nil){
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: NSLocalizedString("string-button-ok", comment: ""), style: .cancel, handler: {
            (alert) in
            okCallback?()
        })
        alert.addAction(ok)
        
        alert.show()
        
    }
    
    func showMessageDeleteAddressPrompt(_ message:String, _ deleteCallback:(()->Void)? = nil){
        let alert = UIAlertController(title: NSLocalizedString("string-dailog-title-address-delete", comment: ""),
                                      message: message, preferredStyle: .alert)
        
        let delete = UIAlertAction(title: NSLocalizedString("string-dailog-title-button-delete", comment: ""), style: .default, handler: {
            (alert) in
            
            deleteCallback?()
        })
        let cancel = UIAlertAction(title: NSLocalizedString("string-dailog-title-button-cancel", comment: ""), style: .default, handler: nil)
        
        
        
        alert.addAction(cancel)
        alert.addAction(delete)
        self.present(alert, animated: true, completion: nil)
    }
  
    
    func confirmSetLanguage(_ languageId:String){
        let title = NSLocalizedString("alert-title-language", comment: "")
        let message = NSLocalizedString("alert-message-language", comment: "")
        let confirm = NSLocalizedString("alert-confirm-language", comment: "")
        let cancel = NSLocalizedString("alert-cancel", comment: "")
        
        let confirmAlertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: confirm, style: .default) { _ in
            print("confirm change")
            

            let title = NSLocalizedString("title-exit-change", comment: "")
            let message = NSLocalizedString("message-exit-change", comment: "")
            let close = NSLocalizedString("close-exit-change", comment: "")
            let cancel = NSLocalizedString("cancel-exit-change", comment: "")
            let confirmAlertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: close, style: .destructive) { _ in
                DataController.sharedInstance.setLanguage(languageId)
                exit(EXIT_SUCCESS)
            }
            confirmAlertCtrl.addAction(confirmAction)
            
            let cancelAction = UIAlertAction(title: cancel, style: .default, handler: nil)
            confirmAlertCtrl.addAction(cancelAction)
            
            self.present(confirmAlertCtrl, animated: true, completion: nil)
            
        }
        
        confirmAlertCtrl.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: cancel, style: .cancel, handler: nil)
        confirmAlertCtrl.addAction(cancelAction)
        
        self.present(confirmAlertCtrl, animated: true, completion: nil)

    }
    @objc func reloadData(){
        print("reload Data")
        self.refreshControl?.endRefreshing()
    }
    
    @objc func dismissPoPup(){
        self.windowSubview?.removeFromSuperview()
        self.windowSubview = nil
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    @objc func dismissKeyboardPopup(){
        viewPopup?.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
}

extension BaseViewController {
    
    func addRefreshViewController(_ collectionView:UICollectionView){
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceVertical = true
        collectionView.addSubview(self.refreshControl!)
    }
    func addRefreshTableViewController(_ tableView:UITableView){
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tableView.isScrollEnabled = true
        tableView.alwaysBounceVertical = true
        tableView.addSubview(self.refreshControl!)
    }
    
    func addCloseWhiteView(){
        let x = CGFloat(self.view.frame.maxX) - 2
        let y = CGFloat(self.view.frame.minY) - 12
        windowSubview = UIImageView()
        windowSubview!.frame = CGRect(x: x, y: y, width: 20, height: 20)
        windowSubview!.image = UIImage(named: "ic-x-white")
        windowSubview!.contentMode = .scaleAspectFit
        windowSubview!.isUserInteractionEnabled = true
        let dismiss = UITapGestureRecognizer(target: self, action: #selector(dismissPoPup))
        windowSubview!.addGestureRecognizer(dismiss)
        
        let window = UIApplication.shared.keyWindow!
        window.addSubview(windowSubview!);
       
    }
    func addCloseBlackView(){
        let x = CGFloat(self.view.frame.maxX) - 12.5
        let y = CGFloat(self.view.frame.minY) - 12.5
        windowSubview = UIImageView()
        windowSubview!.frame = CGRect(x: x, y: y, width: 25, height: 25)
        windowSubview!.image = UIImage(named: "ic-x-red")
        windowSubview!.contentMode = .scaleAspectFit
        windowSubview!.isUserInteractionEnabled = true
        let dismiss = UITapGestureRecognizer(target: self, action: #selector(dismissPoPup))
        windowSubview!.addGestureRecognizer(dismiss)
        
        let window = UIApplication.shared.keyWindow!
        window.addSubview(windowSubview!);
        
    }
    func romoveNavigationViewProductList(){
        self.searchImageView?.removeFromSuperview()
        self.cartImageView?.removeFromSuperview()
        self.moreImageView?.removeFromSuperview()
    }
    func addNavigationViewProductList(){
        let width = CGFloat(20.0)
        let halfWidth = CGFloat(10.0)
        let widthNav = (self.navigationController?.navigationBar.frame.width)!
        let heightNav = (self.navigationController?.navigationBar.frame.height)!
        let centerY = heightNav / 2 - halfWidth
        
        self.searchImageView = UIImageView(frame: CGRect(x: (widthNav - width*3) - 10*3, y: centerY,
                                                         width: width, height: width))
        self.searchImageView!.image  = UIImage(named: "ic-search-white")
        self.navigationController?.navigationBar.addSubview(self.searchImageView!)
        
        self.cartImageView = UIImageView(frame: CGRect(x: (widthNav - width*2) - 10*2, y: centerY,
                                                       width: width, height: width))
        self.cartImageView!.image  = UIImage(named: "ic-cart-white")
        self.navigationController?.navigationBar.addSubview(self.cartImageView!)
        
        self.moreImageView = UIImageView(frame: CGRect(x: (widthNav - width) - 10 , y: centerY,
                                                       width: width, height: width))
        self.moreImageView!.image  = UIImage(named: "ic-more-white")
        self.navigationController?.navigationBar.addSubview(self.moreImageView!)
        
        self.searchImageView!.isUserInteractionEnabled = true
        let search = UITapGestureRecognizer(target: self, action: #selector(searchTapped))
        self.searchImageView!.addGestureRecognizer(search)
        
        self.cartImageView!.isUserInteractionEnabled = true
        let cart = UITapGestureRecognizer(target: self, action: #selector(cartTapped))
        self.cartImageView!.addGestureRecognizer(cart)
        
        self.moreImageView!.isUserInteractionEnabled = true
        let more = UITapGestureRecognizer(target: self, action: #selector(moreTapped))
        self.moreImageView!.addGestureRecognizer(more)
        
    }
    @objc func searchTapped(){
        self.searchImageView?.animationTapped()
    }
    @objc func cartTapped(){
        self.cartImageView?.animationTapped()
    }
    @objc func moreTapped(){
        self.moreImageView?.animationTapped()
    }
    
}

extension BaseViewController {
    func findShadowImage(under view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1 {
            return (view as! UIImageView)
        }
        
        for subview in view.subviews {
            print(subview)
            if let imageView = findShadowImage(under: subview) {
                return imageView
            }
        }
        return nil
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    func cannotAccessCamera(){
        
        let title =  NSLocalizedString("string-title-access-camera", comment: "")
        let message = NSLocalizedString("string-message-access-camera", comment: "")
        let setting = NSLocalizedString("string-button-access-setting", comment: "")
        let cancel = NSLocalizedString("string-button-access-cancel", comment: "")
        
        let alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
        let actionSetting = UIAlertAction(title: setting, style: .default) { (action) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        }
        let actionCancel = UIAlertAction(title: cancel, style: .cancel) { (action) in }
        
        
        alert.addAction(actionSetting)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func cannotAccessPhoto(){
        let title =  NSLocalizedString("string-title-access-photo", comment: "")
        let message = NSLocalizedString("string-message-access-photo", comment: "")
        let setting = NSLocalizedString("string-button-access-setting", comment: "")
        let cancel = NSLocalizedString("string-button-access-cancel", comment: "")
        
        let alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
        let actionSetting = UIAlertAction(title: setting, style: .default) { (action) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        }
        let actionCancel = UIAlertAction(title: cancel, style: .cancel) { (action) in }
        
        
        alert.addAction(actionSetting)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
}
extension BaseViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let y = textField.frame.origin.y + (textField.superview?.frame.origin.y)!;
        
        self.positionYTextField = y
    }
}
extension BaseViewController:GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    }
    
    @objc func loginGoogle(){
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func loginFacebook() {
        self.fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if error == nil {
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if(fbloginresult.isCancelled) {
                    //Show Cancel alert
                } else if(fbloginresult.grantedPermissions.contains("email")) {
                    self.returnUserData()
                    //fbLoginManager.logOut()
                }
            }
        }
    }
    
    func returnUserData(){
            if((FBSDKAccessToken.current()) != nil){
                FBSDKGraphRequest(graphPath: "me", parameters:
                    ["fields":"email,first_name,last_name,gender,picture"]).start(completionHandler: { (connection, result, error) -> Void in
                        
                        if (error == nil){
                            print(result)
                            if let item = result as? [String:AnyObject]{
                              
                                let fbtoken = FBSDKAccessToken.current()?.tokenString ?? ""
                                let email = item["email"] as? String ?? ""
                                let first_name = item["first_name"] as? String ?? ""
                                let last_name = item["last_name"] as? String ?? ""
                                let fcmToken = Messaging.messaging().fcmToken ?? ""
                                
                                let params:Parameters = ["email" : email,
                                                         "firstname": first_name,
                                                         "lastname" : last_name,
                                                         "social_token" : fbtoken,
                                                         "device_token": fcmToken,
                                                         "app_os": "ios"]
                                
                                self.modelCtrl.loginWithSocial(params: params, succeeded: { (result) in
                                    if let mResult = result as? [String:AnyObject]{
                                        print(mResult)
                                        let dupicate = mResult["exist_email"] as? NSNumber ?? 0
                                        if dupicate.boolValue {
                                            self.isExist = true
                                        }else{
                                            self.isExist = false
                                        }
                                        self.socialLoginSucces = true
                                    }
                                }, error: { (error) in
                                    if let mError = error as? [String:AnyObject]{
                                        print(mError)
                                    }
                                }, failure: { (messageError) in
                                    self.handlerMessageError(messageError , title: "")
                                })
                                
                            }
                            
                            
                        }
                    })
            }
        }
    }
