//
//  BaseViewController.swift
//  ShopSi
//
//  Created by thanawat on 10/9/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//
import AVFoundation
import UIKit
import Presentr
import FirebaseMessaging
import Alamofire
import LocalAuthentication

class BaseViewController: UIViewController , UITextFieldDelegate, PAPasscodeViewControllerDelegate
{

    var LOCKSCREEN = false
    var startApp = false
    //fingerprint
    var context = LAContext()
    var  passCodeController: PAPasscodeViewController?
    
    var positionYTextField:CGFloat = 0
    var isShowKeyBoard = false
    var loadingView:Loading?
   
    var viewPopup: UIView?
    
    var windowSubview:UIImageView?
    var socialLoginSucces:Bool?
    var isExist:Bool = false
    let modelCtrl:ModelController = ModelController()
    
    
    var handlerDidCancel: (()->Void)?
    var handlerEnterSuccess: ((_ pin:String)->Void)?
    var hendleSetPasscodeSuccess: ((_ passcode:String, _ controller:PAPasscodeViewController)->Void)?
    var hendleSetPasscodeSuccessWithStartApp: ((_ passcode:String, _ controller:PAPasscodeViewController)->Void)?
    
    private var searchImageView:UIImageView?
    private var cartImageView:UIImageView?
    private var moreImageView:UIImageView?
    
    var backgroundImage:UIImageView?
    var refreshControl:UIRefreshControl?
    
   
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
        

        //add tap dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        

        NotificationCenter.default.addObserver(self, selector: #selector(showSplashLock), name: NSNotification.Name(rawValue: Constant.DefaultConstansts.NOTIFICATION_SPLASH_LOCKAPP), object: nil)

      
        NotificationCenter.default.addObserver(self, selector: #selector(resetPinCode), name: NSNotification.Name(rawValue: Constant.DefaultConstansts.RESET_PIN), object: nil)
        
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
    
    @objc func showSplashLock(notification:NSNotification){
        //return
        if DataController.sharedInstance.isLogin() {
            if let top = Constant.TopViewController.top {
                if self == top  {
                    if DataController.sharedInstance.countTimeLockScreen(){
                        self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""), lockscreen: true)
                    }
                }
            }
        }
    }
    
    @objc func resetPinCode(notification: NSNotification){
        //showResetpin
        self.passCodeController?.dismiss(animated: false, completion: nil)
        self.showSettingPassCodeModalView(NSLocalizedString("title-set-passcode", comment: ""), lockscreen: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constant.DefaultConstansts.RESET_PIN), object : nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object : nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object : nil)
    }
    
  
    
    
    func registerTableViewNib(_ tableTarget:UITableView ,_ nibName:String){
        
        let nib = UINib(nibName: nibName, bundle: nil)
        tableTarget.register(nib, forCellReuseIdentifier: nibName)
       
    }
    func registerTableViewHeaderNib(_ tableTarget:UITableView ,_ nibName:String){
        
        let nib = UINib(nibName: nibName, bundle: nil)
        tableTarget.register(nib, forHeaderFooterViewReuseIdentifier: nibName)
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
                        let gap = abs(keyboardSize.size.height - self.positionYTextField)
                        if gap < keyboardSize.size.height {
                           self.gapHeightKeyboard  += gap
                        }else{
                            self.gapHeightKeyboard  += keyboardSize.size.height
                        }
                        
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
        //if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
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
        //}
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
    func showShoppingPage(_ animated:Bool){
        
        if let vc:ShoppingNavViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingNavViewController") as? ShoppingNavViewController {
            
            self.present(vc, animated: animated, completion: nil)
        }
    }
    
    func showSettingShoppingAddressPage(_ animated:Bool){
        if let vc:SettingAddressViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingAddressViewController") as? SettingAddressViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showShoppingAddressPage(_ animated:Bool){
        if let vc:ShoppingAddressViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingAddressViewController") as? ShoppingAddressViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showShoppingAddAddressPage(_ animated:Bool){
        if let vc:ShoppingAddShippingAddressViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingAddShippingAddressViewController") as? ShoppingAddShippingAddressViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showShoppingEditAddressPage(_ animated:Bool, _ modelAddress:AnyObject){
        if let vc:ShoppingAddShippingAddressViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingAddShippingAddressViewController") as? ShoppingAddShippingAddressViewController {
            vc.modelAddress = modelAddress
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    
    
    func showTaxInvoiceAddressPage(_ animated:Bool){
        if let vc:ShoppingTaxInvoiceAddressViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingTaxInvoiceAddressViewController") as? ShoppingTaxInvoiceAddressViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showTaxInvoiceAddAddressPage(_ animated:Bool){
        if let vc:ShoppingAddTaxInvoiceAddressViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingAddTaxInvoiceAddressViewController") as? ShoppingAddTaxInvoiceAddressViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showTaxInvoiceEditAddressPage(_ animated:Bool, _ modelAddress:AnyObject?){
        if let vc:ShoppingAddTaxInvoiceAddressViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingAddTaxInvoiceAddressViewController") as? ShoppingAddTaxInvoiceAddressViewController {
            vc.modelAddress = modelAddress
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showTaxInvoiceAddDuplicateAddressPage(_ animated:Bool, _ modelAddress:AnyObject?){
        if let vc:ShoppingAddTaxInvoiceAddressViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingAddTaxInvoiceAddressViewController") as? ShoppingAddTaxInvoiceAddressViewController {
            vc.modelDuplicateAddress = modelAddress
            self.navigationController?.pushViewController(vc, animated: animated)
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
    

    func chooseShippingPage(_ animated:Bool, withdrawData:(pointBalance:Double, premium:Int, goldbalance:Double, goldAmountToUnit:(amount:Int, unit:Int , price:Double, goldPrice:Int), goldReceive:[(amount:Int,unit:String)]? )?){
        if let vc:GoldWithDrawChooseShippingViewController  = self.storyboard?.instantiateViewController(withIdentifier: "GoldWithDrawChooseShippingViewController") as? GoldWithDrawChooseShippingViewController {
    
            vc.withdrawData = withdrawData
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showWithDrawSummaryOfficeView(_ animated:Bool, withdrawData:(pointBalance:Double, premium:Int, goldbalance:Double, goldAmountToUnit:(amount:Int, unit:Int , price:Double, goldPrice:Int), goldReceive:[(amount:Int,unit:String)]? )?){
        
        if let vc:WithDrawSummaryOfficeViewController  = self.storyboard?.instantiateViewController(withIdentifier: "WithDrawSummaryOfficeViewController") as? WithDrawSummaryOfficeViewController {
            vc.withdrawData  = withdrawData
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
   
    
    func showWithDrawSummaryThaiPostView(_ animated:Bool,
                                         withdrawData:(pointBalance:Double, premium:Int, goldbalance:Double, goldAmountToUnit:(amount:Int, unit:Int , price:Double, goldPrice:Int), goldReceive:[(amount:Int,unit:String)]? )?,
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

    
    func showIntroduce(_ animated:Bool, require_login:Bool = false,  finish:(()->Void)? = nil){
        if let vc:IntroNav = self.storyboard?.instantiateViewController(withIdentifier: "IntroNav") as? IntroNav {
            
            vc.require_login = require_login
            
            vc.callbackFinish = {
                finish?()
            }
            
            self.present(vc, animated: animated, completion: nil)
            
        }
    }
    func showLogin(_ animated:Bool){
        if let vc:LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showLoginMobile(_ animated:Bool){
        if let vc:LoginMobileViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginMobileViewController") as? LoginMobileViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showRegister(_ animated:Bool){
        if let vc:RegisterViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showRegisterMobile(_ animated:Bool){
        if let vc:RegisterMobileViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterMobileViewController") as? RegisterMobileViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showVerify(_ mobilePhone:String, _ ref_id:String, register:Bool = false, _ animated:Bool){
        if let vc:VerifyViewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController") as? VerifyViewController {
            vc.mobilePhone = mobilePhone
            vc.ref_id = ref_id
            vc.register = register
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showMobileVerify(_ mobilePhone:String, _ ref_id:String, _ animated:Bool){
        if let vc:VerifyMobileNumberViewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyMobileNumberViewController") as? VerifyMobileNumberViewController {
            vc.mobilePhone = mobilePhone
            vc.ref_id = ref_id
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showPersonalData(_ animated:Bool , dissmissCallback:(()->Void)?){
        if let vc:PersonalDataViewController = self.storyboard?.instantiateViewController(withIdentifier: "PersonalDataViewController") as? PersonalDataViewController {
            
            //self.navigationController?.pushViewController(vc, animated: animated)
            
            let navController = BaseNavigationViewController(rootViewController: vc)
            navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                               NSAttributedString.Key.font :  UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.TITLE )!]
            navController.navigationBar.tintColor = UIColor.white
            navController.navigationBar.backgroundColor  = Constant.Colors.PRIMARY_COLOR
            navController.navigationBar.barTintColor = Constant.Colors.PRIMARY_COLOR
            navController.navigationBar.isTranslucent = true;
            
            vc.dismiss = {
                dissmissCallback?()
            }
            
            self.present(navController, animated: animated, completion: nil)
        }
    }
    
    func showMapFullViewController(_ animated:Bool , dissmissCallback:(()->Void)?){
        if let vc:WebViewMapViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewMapViewController") as? WebViewMapViewController {
            
            vc.dissmissCallback = dissmissCallback
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showTermAndConGold(_ animated:Bool){
        if let vc:TermPointSavingViewController = self.storyboard?.instantiateViewController(withIdentifier: "TermPointSavingViewController") as? TermPointSavingViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showPrivacyPolicyPointPow(_ animated:Bool){
        if let vc:PrivacyPolicyPointPowViewController = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyPointPowViewController") as? PrivacyPolicyPointPowViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showTermAndConPointPow(_ animated:Bool){
        if let vc:TermPointPowViewController = self.storyboard?.instantiateViewController(withIdentifier: "TermPointPowViewController") as? TermPointPowViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showAboutPointPow(_ animated:Bool){
        if let vc:AboutPointPowViewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutPointPowViewController") as? AboutPointPowViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showNotificationData(_ animated:Bool){
        if let vc:NotificationTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "NotificationTableViewController") as? NotificationTableViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showPromotionDetail(_ id:String, _ animated:Bool){
        if let vc:PromotionDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "PromotionDetailViewController") as? PromotionDetailViewController {
        
            vc.id = id
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showShoppingPromotionDetail(_ id:String, _ animated:Bool){
        if let vc:PromotionShoppingDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "PromotionShoppingDetailViewController") as? PromotionShoppingDetailViewController {
            
            vc.id = id
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showRegisterGoldSaving(_ animated:Bool, userData:AnyObject?){
        if let vc:RegisterGoldViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterGoldViewController") as? RegisterGoldViewController {
            
            vc.userData = userData
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    
    func showWinnerLuckyDraw(_ animated:Bool){
        if let vc:WinnerLuckyDrawViewController = self.storyboard?.instantiateViewController(withIdentifier: "WinnerLuckyDrawViewController") as? WinnerLuckyDrawViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
   
    func showRegisterGoldStep2Saving(_ animated:Bool, tupleModel:(image : UIImage?, firstname : String,lastname: String , email: String,mobile: String,idcard: String , birthdate:String, laserId:String, isCheck:Bool)?){
        if let vc:RegisterGoldstep2ViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterGoldstep2ViewController") as? RegisterGoldstep2ViewController {
            
            vc.tupleModel = tupleModel
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showRegisterGoldStep3Saving(_ animated:Bool, tupleModel:(image : UIImage?, firstname : String,lastname: String , email: String,mobile: String,idcard: String , birthdate:String, laserId:String, isCheck:Bool)?){
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
    func showProductByCate(_ animated:Bool, cateId:Int){
        
        if let vc:ProductShoppingViewController  = self.storyboard?.instantiateViewController(withIdentifier: "ProductShoppingViewController") as? ProductShoppingViewController {
            
            vc.loadDataByCateID = cateId
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showSearchProductByKeyword(_ animated:Bool, keyword:String){
        
        if let vc:SearchProductViewController  = self.storyboard?.instantiateViewController(withIdentifier: "SearchProductViewController") as? SearchProductViewController {
            
            vc.keyword = keyword
            vc.loadDataByCateID = 0
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    
    func showProductDetail(_ animated:Bool, product_id:Int){
        
        if let vc:ProductDetailViewController  = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController {
            
            vc.product_id = product_id
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    
    
    @objc func reNewApplication(){
        UIApplication.shared.keyWindow?.rootViewController = storyboard!.instantiateViewController(withIdentifier: "MainNav")
    }
    @objc func reNewApplicationLogin(){
        
        if let vc = storyboard!.instantiateViewController(withIdentifier: "MainNav") as? MainNav {
            vc.require_login = true
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
        
    }
    
    
    func showProfileView(_ animated:Bool){
        if let vc:ProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showMyQRCodeView(_ animated:Bool){
        if let vc:MyQRCodeViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyQRCodeViewController") as? MyQRCodeViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showShoppingHistory(_ animated:Bool){
        if let vc:ShoppingHistoryViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingHistoryViewController") as? ShoppingHistoryViewController{
        
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func showShippingList(_ animated:Bool){
        if let vc:ShippingViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShippingViewController") as? ShippingViewController{
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showTransectionFilter(_ animated:Bool , filterCallback:((_ filter:String)->Void)? = nil ){
        if let vc:TransactionFilterViewController = self.storyboard?.instantiateViewController(withIdentifier: "TransactionFilterViewController") as? TransactionFilterViewController{
            vc.filterCallback  =  {(filter) in
                filterCallback?(filter)
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func showHistoryShoppingFilter(_ animated:Bool){
        if let vc:FilterShoppingViewController = self.storyboard?.instantiateViewController(withIdentifier: "FilterShoppingViewController") as? FilterShoppingViewController{
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showTransectionFilterResultPage(_ animated:Bool, _ titlePage:String, params:Parameters?){
        
        if let vc:TransectionFilterResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "TransectionFilterResultViewController") as? TransectionFilterResultViewController{
            
            vc.mTitle = titlePage
            vc.params = params
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showShoppingFilterResultPage(_ animated:Bool, _ titlePage:String, params:Parameters?){
        
        if let vc:ResultFilterShoppingViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResultFilterShoppingViewController") as? ResultFilterShoppingViewController{
            
            vc.mTitle = titlePage
            vc.params = params
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func showAboutView(_ animated:Bool){
        if let vc:AboutViewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as? AboutViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showPersonalView(_ animated:Bool , disableField:Bool = false){
        if let vc:PersonalViewController = self.storyboard?.instantiateViewController(withIdentifier: "PersonalViewController") as? PersonalViewController {
            vc.disableField = disableField
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showGoldProfileView(_ animated:Bool, fromAccountPointPow:Bool = false){
        if let vc:GoldProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "GoldProfileViewController") as? GoldProfileViewController {
            vc.fromAccountPointPow = fromAccountPointPow
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
    func showSecuritySettingView(_ animated:Bool){
        if let vc:SecuritySettingViewController  = self.storyboard?.instantiateViewController(withIdentifier: "SecuritySettingViewController") as? SecuritySettingViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showDisplayNameView(_ animated:Bool, _ displayName:String){
        if let vc:DisplayNameViewController  = self.storyboard?.instantiateViewController(withIdentifier: "DisplayNameViewController") as? DisplayNameViewController {
            vc.displayName = displayName
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showMobilePhoneView(_ animated:Bool, _ mobile:String){
        if let vc:MobileViewController  = self.storyboard?.instantiateViewController(withIdentifier: "MobileViewController") as? MobileViewController {
            vc.mobile = mobile
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showPointLimitView(_ animated:Bool, _ amount:String){
        if let vc:PointLimitViewController  = self.storyboard?.instantiateViewController(withIdentifier: "PointLimitViewController") as? PointLimitViewController {
            vc.pointlimit = amount
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showPointPowIDView(_ animated:Bool){
        if let vc:PointPowIDViewController  = self.storyboard?.instantiateViewController(withIdentifier: "PointPowIDViewController") as? PointPowIDViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showPointTransferView(_ animated:Bool , isProfile:Bool){
        if let vc:PointTransferViewController  = self.storyboard?.instantiateViewController(withIdentifier: "PointTransferViewController") as? PointTransferViewController {
            vc.isProfile = isProfile
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showFriendTransferView(_ animated:Bool){
        if let vc:FriendTransferViewController  = self.storyboard?.instantiateViewController(withIdentifier: "FriendTransferViewController") as? FriendTransferViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showPPWebView( _ animated:Bool, _ title:String, htmlString:String){
        if let vc:PPWebViewController  = self.storyboard?.instantiateViewController(withIdentifier: "PPWebViewController") as? PPWebViewController {
            vc.mTitle = title
            vc.htmlString = htmlString
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showPPWebViewURL( _ animated:Bool, _ title:String, url:String){
        if let vc:PPWebViewController  = self.storyboard?.instantiateViewController(withIdentifier: "PPWebViewController") as? PPWebViewController {
            vc.mTitle = title
            vc.mUrl = url
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showPaymentWebView( _ animated:Bool, _ title:String, url:String, callbackResult:((_ any:AnyObject)->Void)? = nil){
        if let vc:NavPaymentViewController  = self.storyboard?.instantiateViewController(withIdentifier: "NavPaymentViewController") as? NavPaymentViewController {
            vc.mTitle = title
            vc.mUrl = url
            vc.callbackResult = { (any) in
                callbackResult?(any)
            }
            self.present(vc, animated: animated, completion: nil)
        }
    }
    
    func showResetPasswordView(_ animated:Bool, forgotPassword:Bool = false){
        if let vc:ResetPasswordViewController  = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as? ResetPasswordViewController {
            vc.forgotPassword = forgotPassword
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showFavoriteView(_ animated:Bool){
        if let vc:FavoriteViewController  = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as? FavoriteViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    
    func showBankTransferView(_ animated:Bool, itemData:[String:AnyObject], pointAmount:String? = nil){
        if let vc:BankPointTransferViewController  = self.storyboard?.instantiateViewController(withIdentifier: "BankPointTransferViewController") as? BankPointTransferViewController {
            vc.itemData = itemData
            vc.pointAmount = pointAmount
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
   
    
    func showOrderResultView( _ animated:Bool, _ transaction_id:String, finish:(()->Void)? = nil){
        
        if finish != nil {
            if let vc:OrderResultNav  = self.storyboard?.instantiateViewController(withIdentifier: "OrderResultNav") as? OrderResultNav {
                vc.callbackFinish = {
                    finish?()
                }
                
                vc.transactionId = transaction_id
                self.present(vc, animated: animated, completion: nil)
            }
        }else{
            if let vc:OrderResultViewController  = self.storyboard?.instantiateViewController(withIdentifier: "OrderResultViewController") as? OrderResultViewController {
                
                vc.transactionId = transaction_id
                vc.hideFinishButton = true
                self.navigationController?.pushViewController(vc, animated: animated)
            }
        }
    }
    
    func showOrderShippingResultView( _ animated:Bool , items:[[String:AnyObject]]?, shipping_status:String){
        if let vc:ProductShippingViewController  = self.storyboard?.instantiateViewController(withIdentifier: "ProductShippingViewController") as? ProductShippingViewController {
            vc.selectType = shipping_status
            vc.items = items
           
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showRefillPointTransferView( _ animated:Bool, _ transaction_id:String, finish:(()->Void)? = nil){
        
        if finish != nil {
            if let vc:ResultTransferNav  = self.storyboard?.instantiateViewController(withIdentifier: "ResultTransferNav") as? ResultTransferNav {
                vc.callbackFinish = {
                    finish?()
                }
            
                vc.transactionId = transaction_id
                self.present(vc, animated: animated, completion: nil)
            }
        }else{
            if let vc:ResultTransferViewController  = self.storyboard?.instantiateViewController(withIdentifier: "ResultTransferViewController") as? ResultTransferViewController {
                
                vc.transactionId = transaction_id
                vc.hideFinishButton = true
                self.navigationController?.pushViewController(vc, animated: animated)
            }
        }
    }
    
    func showPointFriendSummaryTransferView( _ animated:Bool, _ transaction_id:String, titlePage:String , finish:(()->Void)? = nil){
        
        if finish != nil {
            if let vc:PointFreindSummaryNav  = self.storyboard?.instantiateViewController(withIdentifier: "PointFreindSummaryNav") as? PointFreindSummaryNav {
                vc.callbackFinish = {
                    finish?()
                }
                vc.titlePage = titlePage
                vc.transactionId = transaction_id
                self.present(vc, animated: animated, completion: nil)
            }
        }else{
            if let vc:PointFriendSummaryViewController  = self.storyboard?.instantiateViewController(withIdentifier: "PointFriendSummaryViewController") as? PointFriendSummaryViewController {
                
                vc.titlePage = titlePage
                vc.transactionId = transaction_id
                vc.hideFinishButton = true
                self.navigationController?.pushViewController(vc, animated: animated)
            }
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
    
    
    
    func showPointFriendTransferView(_ animated:Bool, _ friendModel:[String:AnyObject], note:String? = nil, pointAmount:String? = nil){
        if let vc:PointFriendTransferViewController  = self.storyboard?.instantiateViewController(withIdentifier: "PointFriendTransferViewController") as? PointFriendTransferViewController {
            vc.friendModel = friendModel
            vc.mNote = note
            vc.pointAmount = pointAmount
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }

    func showPointFriendTransferReviewView(_ animated:Bool, _ friendModel:[String:AnyObject]?, amount:Double, note:String){
        if let vc:PointFriendTransferReviewViewController  = self.storyboard?.instantiateViewController(withIdentifier: "PointFriendTransferReviewViewController") as? PointFriendTransferReviewViewController {
            vc.friendModel = friendModel
            vc.amount = amount
            vc.note = note
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func checkLAPolicy( status:((_ type:String)->Void)? ){
        var policy: LAPolicy?
        // Depending the iOS version we'll need to choose the policy we are able to use
        //if #available(iOS 9.0, *) {
        // iOS 9+ users with Biometric and Passcode verification
        //    policy = .deviceOwnerAuthentication
        //} else {
        // iOS 8+ users with Biometric and Custom (Fallback button) verification
        //    policy = .deviceOwnerAuthenticationWithBiometrics
        //}
        context = LAContext()
        context.localizedFallbackTitle = ""
        policy =  .deviceOwnerAuthenticationWithBiometrics
        var err: NSError?
        
        // Check if the user is able to use the policy we've selected previously
        guard context.canEvaluatePolicy(policy!, error: &err) else {
            print("TouchID_OFF!!")
            return
        }
        
        print("TouchID_ON!!")
        
        loginProcess(policy: policy!) { (stringResult) in
            //successful
            
            if stringResult == "1"{
                status?("login_success")
            }else if stringResult == "2"{
                status?("problem_verifying")
            }else if stringResult == "3" {
                status?("problem_configured")
            }else{
                status?("user_dismiss")
            }
            
        }
    }
    @objc func becomeTouchID(){
        
        self.checkLAPolicy { (type) in
            if type == "login_success"{
                self.passCodeController?.showPassCodeSuccess()
                self.passCodeController?.dismiss(animated: false, completion: { () in
                    if !self.LOCKSCREEN {
                        self.handlerEnterSuccess?("")
                    }
                    if self.startApp {
                        self.handlerEnterSuccess?("")
                    }
                    self.LOCKSCREEN = false
                    self.startApp = false
                })
                
                
            }else if type == "problem_verifying"{
                self.passCodeController?.showFailedMessage(NSLocalizedString("error-problem-verifying", comment: ""))
                self.passCodeController?.showKeyboard()
            }else if type == "problem_configured" {
                self.passCodeController?.showFailedMessage(NSLocalizedString("error-problem-configured", comment: ""))
                self.passCodeController?.showKeyboard()
            }else if type == "user_dismiss" {
                self.passCodeController?.showKeyboard()
            }else{
                self.passCodeController?.showKeyboard()
            }
        }
    }
    private func loginProcess(policy: LAPolicy , successful:((_ stringResult:String)->Void)?) {
        context.evaluatePolicy(policy, localizedReason: NSLocalizedString("string-dismiss-fingerprint", comment: ""), reply: { (success, error) in
            DispatchQueue.main.async {
                
                guard success else {
                    guard let error = error else {
                        print("Unexpected error!")
                        return
                    }
                    switch(error) {
                    case LAError.authenticationFailed:
                        print("There was a problem verifying your identity.")
                        successful?("2")
                        
                    case LAError.userCancel:
                        print("Authentication was canceled by user.")
                        
                        successful?("0")
                        
                        // Fallback button was pressed and an extra login step should be implemented for iOS 8 users.
                    // By the other hand, iOS 9+ users will use the pasccode verification implemented by the own system.
                    case LAError.userFallback:
                        print("The user tapped the fallback button (Fuu!)")
                    case LAError.systemCancel:
                        print("Authentication was canceled by system.")
                    case LAError.passcodeNotSet:
                        print("Passcode is not set on the device.")
                    case LAError.touchIDNotAvailable:
                        print("Touch ID is not available on the device.")
                    case LAError.touchIDNotEnrolled:
                        print("Touch ID has no enrolled fingers.")
                        // iOS 9+ functions
                        //case LAError.touchIDLockout:
                        //    print("There were too many failed Touch ID attempts and Touch ID is now locked.")
                        //case LAError.appCancel:
                        //    print("Authentication was canceled by application.")
                        // case LAError.invalidContext:
                        //    print("LAContext passed to this call has been previously invalidated.")
                    // MARK: IMPORTANT: There are more error states, take a look into the LAError struct
                    default:
                        print("Touch ID may not be configured")
                        
                        successful?("3")
                        
                        break
                    }
                    return
                }
                
                // Good news! Everything went fine
                
                successful?("1")
            }
        })
    }
    
    func showEnterPassCodeModalView(_ title:String = NSLocalizedString("title-enter-passcode", comment: ""), lockscreen:Bool = false, startApp:Bool = false , animated:Bool = true){
        
        self.LOCKSCREEN = lockscreen
        self.startApp = startApp
        
        self.statusPin { (lockPin , message) in
            
            let enterPasscode = PAPasscodeViewController(for: PasscodeActionEnter )
            enterPasscode!.centerPosition = true
            enterPasscode!.delegate = self
            enterPasscode!.title = title
            enterPasscode!.lockPin = lockPin
            enterPasscode!.lockPinMessage = message
            enterPasscode!.lockscreenMode = lockscreen
            
            self.passCodeController = enterPasscode
            self.loadingView?.mRootView = enterPasscode!.view
            
            let navController = UINavigationController(rootViewController: enterPasscode!)
            navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                                                               NSAttributedString.Key.font :  UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.TITLE )!]
            navController.navigationBar.tintColor = Constant.Colors.PRIMARY_COLOR
            
            let presenter: Presentr = {
                
                let customPresenter = Presentr(presentationType: .fullScreen)
                customPresenter.dismissOnTap = false
                
                return customPresenter
            }()
            self.customPresentViewController(presenter, viewController: navController, animated: animated, completion: nil)
            
            
            if !lockPin {
                if lockscreen {
                    let isFaceID = DataController.sharedInstance.getFaceID()
                    if isFaceID {
                        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.becomeTouchID), userInfo: nil, repeats: false)
                    }
                    
                }
                
            }
            
        }
            
        
        
       
    }
    
    private func statusPin(_ statusCallback:((_ status:Bool,_ message:String)->Void)?) {
        self.modelCtrl.statusPinCode(params: nil, true, succeeded: { (result) in
            statusCallback?(false , "")
            
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(mError)
                
                //pinlock
                statusCallback?(true , message)
            }
            
            
            
        }) { (messageError) in
            statusCallback?(false , "")
        }
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
    func showEditPenddingVerifyModalView(_ animated:Bool , dismissCallback:(()->Void)?){
        
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
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoldEditPenddingNav") as? GoldEditPenddingNav {
            
            vc.dismissCallback = {
                dismissCallback?()
            }
            customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
        }
        
    }
    
    
    
    
    func showSettingPassCodeModalView(_ title:String = NSLocalizedString("title-set-passcode", comment: ""), lockscreen:Bool = false){
        let enterPasscode = PAPasscodeViewController(for: PasscodeActionSet )
        enterPasscode!.centerPosition = true
        enterPasscode!.delegate = self
        enterPasscode!.title = title
        enterPasscode!.lockscreenMode = lockscreen
        
        
        self.passCodeController = enterPasscode
        self.loadingView?.mRootView = enterPasscode!.view
       
        let navController = UINavigationController(rootViewController: enterPasscode!)
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                                                           NSAttributedString.Key.font :  UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.TITLE )!]
        navController.navigationBar.tintColor = Constant.Colors.PRIMARY_COLOR
        
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
    func paPasscodeViewControllerDidCancel(_ controller: PAPasscodeViewController!) {
        print("paPasscodeViewControllerDidCancel")
        
        self.handlerDidCancel?()
        controller.dismiss(animated: true, completion: nil)
        
    }
    func paPasscodeViewControllerDidEnterPasscodeResult(_ controller: PAPasscodeViewController!, didEnterPassCode passcode: String!) {
        print("enter passcode: \(passcode ?? "unknow")")
        
        let params:Parameters = ["pin" : passcode!]
        self.modelCtrl.enterPinCode(params: params, true, succeeded: { (result) in
            controller.dismiss(animated: false, completion: { () in
                if !self.LOCKSCREEN {
                    self.handlerEnterSuccess?(passcode)
                }
                if self.startApp {
                    self.handlerEnterSuccess?("")
                }
                self.LOCKSCREEN = false
                self.startApp = false
                DataController.sharedInstance.setTimeLatest()
            })
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                let pin_status = mError["pin_status"] as? NSNumber ?? 0
                print(mError)
                
                controller.showFailedMessage(message)
                
                if !pin_status.boolValue {
                    controller.showLockPinCode()
                }
                
            }
        }) { (messageError) in
            self.handlerMessageError(messageError)
            controller.showFailedMessage("")
        }
        
    
    }
    func validateMobile(_ mobile:String)-> String{
        var errorMobile = 0
        var errorMessage = ""
        
        if !checkPrefixcellPhone(mobile) {
            errorMessage = NSLocalizedString("string-error-invalid-mobile", comment: "")
            errorMobile += 1
        }
        if mobile.count < 10 {
            errorMessage = NSLocalizedString("string-error-invalid-mobile1", comment: "")
            errorMobile += 1
        }
        if mobile.count > 10 {
            errorMessage = NSLocalizedString("string-error-invalid-mobile2", comment: "")
            errorMobile += 1
        }
        if errorMobile > 0 {
            return errorMessage
        }
        return errorMessage
    }
    func paPasscodeViewControllerDidResetEmail(_ controller: PAPasscodeViewController!, didResetEmailPinCode email: String!) {
        
        if email.isEmpty {
            let emptyEmail = NSLocalizedString("string-error-empty-username", comment: "")
            controller.showFailedMessage(emptyEmail)
            return
            
        }
        if isValidNumber(email){
            print("number")
            let message = validateMobile(email)
            if  !message.isEmpty {
                controller.showFailedMessage(message)
            }else{
                print("pass number")
                
                // forgorpin by mobile (API)
                // pass
                let mobile = email!
                let params:Parameters = ["mobile" : mobile]
                self.modelCtrl.forgotPinCodeMobile(params: params, true, succeeded: { (result) in
                    if let mResult = result as? [String:AnyObject] {
                        let ref_id = mResult["ref_id"] as? String ?? ""
                        
                        //let newText = String(mobile.filter({ $0 != "-" }).prefix(10))
                        //let mobileFormat = newText.chunkFormatted()
                        controller.showMobileOTP(mobile, refOTP: ref_id)
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
                
            }
        }else{
            
            if isValidEmail(email) {
                print("pass email")
                
                let params:Parameters = ["email" : email!]
                self.modelCtrl.forgotPinCode(params: params, true, succeeded: { (result) in
                    
                    self.showMessagePrompt2(NSLocalizedString("title-forgot-passcode-reset-email", comment: "")) {
                        //ok callback
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
    }
    func paPasscodeViewControllerDidLoadViewOTP(_ controller: PAPasscodeViewController!, resend resendBtn: UIButton!) {
        //show otp mode
        self.sendButtonResend = resendBtn
        self.updateButtonResend()
        self.removeCountDownLableResend()
        self.sendButtonResend?.isEnabled = false
        self.countDownResend(1.0)
        
    }
    func paPasscodeViewControllerResendOTP(_ controller: PAPasscodeViewController!, resend resendBtn: UIButton!, callbackMobileNumber mobileNumber: String!) {
        
        //print("mobile = \(mobileNumber)")
        
        let mobile = mobileNumber.replace(target: "-", withString: "")
        let params:Parameters = ["mobile" : mobile,
                                 "request_id": DataController.sharedInstance.getRequestId() ]
        
        modelCtrl.resendOTP(params: params, succeeded: { (result) in
            if let mResult = result as? [String:AnyObject]{
                print(mResult)
                
                if let mResult = result as? [String:AnyObject]{
                    print(mResult)
                    let ref_id = mResult["ref_id"] as? String ?? ""
                    
                    //let newText = String(mobile.filter({ $0 != "-" }).prefix(10))
                    //let mobileFormat = newText.chunkFormatted()
                    controller.actionResend(mobile, refOTP: ref_id)
                    
                    self.sendButtonResend = resendBtn
                    self.updateButtonResend()
                    self.removeCountDownLableResend()
                    self.sendButtonResend?.isEnabled = false
                    self.countDownResend(1.0)

                }
            }
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                print(mError)
                let message = mError["message"] as? String ?? ""
                //self.errorOTPlLabel = self.otpTextField.addBottomLabelErrorMessage(message, marginLeft: 15)
                self.showMessagePrompt2(message)
            }
        }, failure: { (messageError) in
            self.handlerMessageError(messageError , title: "")
        })
        
    }
    func paPasscodeViewControllerConfirmOTP(_ controller: PAPasscodeViewController!, didEnterOTP otp: String!, refOTP ref: String!, mobileNumber:String!) {
        print("Confirm OTP \(otp!)")
        print("Confirm REF \(ref)")
        
        if otp.trimmingCharacters(in: .whitespaces).isEmpty {
            self.showMessagePrompt2(NSLocalizedString("string-error-otp-empty", comment: "")) {
                //ok callback
            }
        }else{
            // pass otp
            //let mobile = mobileNumber.replace(target: "-", withString: "")
            let params:Parameters = ["ref_id" : ref ?? "",
                                     "otp" : otp ?? "",
                                     "app_os": "ios"]
            
            modelCtrl.verifyOTP(params: params, succeeded: { (result) in
                if let mResult = result as? [String:AnyObject]{
                    print(mResult)
                    
                    let reset_token  = result["reset_token"] as? String ?? ""
                    DataController.sharedInstance.setResetPinToken(reset_token)
                    
                    //let access_token  = result["access_token"] as? String ?? ""
                    //DataController.sharedInstance.setToken(access_token)
                    
                    controller.becomeSetPinCode()
                    
                    
                }
            }, error: { (error) in
                if let mError = error as? [String:AnyObject]{
                    print(mError)
                    let message = mError["message"] as? String ?? ""
                    //self.errorOTPlLabel = self.otpTextField.addBottomLabelErrorMessage(message, marginLeft: 15)
                    self.showMessagePrompt2(message)
                }
            }, failure: { (messageError) in
                self.handlerMessageError(messageError , title: "")
            })
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
                        self.hendleSetPasscodeSuccessWithStartApp?(passcode, controller)
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

        }else{
            var params:Parameters = [:]
            let oldPasscode = DataController.sharedInstance.getPasscode()
            if oldPasscode.isEmpty {
                params = ["new_pin" : Int(passcode)!]
            }else{
                params = ["old_pin" : Int(oldPasscode)!,
                          "new_pin" : Int(passcode)!]
            }
            
            self.modelCtrl.setPinCode(params: params, true, succeeded: { (result) in  
                self.hendleSetPasscodeSuccess?(passcode, controller)
                
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
    
    private var countDownResend:Int = 300
    private var timerResend:Timer?
    private var sendButtonResend: UIButton?
    
    private func updateButtonResend(){
        self.sendButtonResend?.borderLightGrayColorProperties(borderWidth: 1)
        self.sendButtonResend?.setTitle("\(prodTimeString(time: TimeInterval(countDownResend)))", for: .normal)
        //self.sendButtonResend?.setTitle("\(countDownResend)", for: .normal)
        self.sendButtonResend?.setTitleColor(UIColor.lightGray, for: .normal)
    }
    private  func resetButtonResend(){
        self.sendButtonResend?.borderGreen2ColorProperties(borderWidth: 1)
        self.sendButtonResend?.setTitle(NSLocalizedString("string-button-re-send", comment: ""), for: .normal)
        self.sendButtonResend?.setTitleColor(Constant.Colors.GREEN2, for: .normal)
        self.sendButtonResend?.isEnabled = true
    }
    private func countDownResend(_ time: Double){
        timerResend = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(updateCountDownResend), userInfo: nil, repeats: true)
        RunLoop.main.add(timerResend!, forMode: RunLoop.Mode.common)
    }
    private func prodTimeString(time: TimeInterval) -> String {
        let prodMinutes = Int(time) / 60 % 60
        let prodSeconds = Int(time) % 60
        
        return String(format: "%02d:%02d", prodMinutes, prodSeconds)
    }
    @objc func updateCountDownResend() {
        if(countDownResend > 0) {
            countDownResend -= 1
            self.updateButtonResend()
        } else {
            self.resetButtonResend()
            self.removeCountDownLableResend()
        }
    }
    private func removeCountDownLableResend() {
        //finish
        countDownResend = 300
        timerResend?.invalidate()
        timerResend = nil
       
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
    func showAddNameFavoritePopup(_ animated:Bool ,favName:String? = nil, mType:String, transaction_ref_id:String, amount:String, savedCallback:(()->Void)? = nil ){
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
            vc.mType = mType
            vc.favName = favName
            vc.amount = amount
            vc.transaction_ref_id = transaction_ref_id
            vc.didSave =  {
                savedCallback?()
            }
            
            self.viewPopup = vc.view
            customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
            
        }
    }
    
    func showPopupProfileInfomation(_ callback:(()->Void)? = nil){
        
        let alert = UIAlertController(title: NSLocalizedString("string-dailog-title-fill-firstname-lastname", comment: ""),
                                      message: "", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-ok", comment: ""), style: .default, handler: {
            (alert) in
            
            self.showPersonalPopup(true) {
                callback?() 
            }
            
            
        })
        
        let cancelButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-cancel", comment: ""), style: .default, handler: nil)
        
        
        
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion: nil)
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
    
    func showShippingAddressPopup(_ animated:Bool, selectCallback:((_ selectedAddress:AnyObject)->Void)? = nil, reloadDataCallback:(()->Void)? = nil ){
        let presenter: Presentr = {
            
            let w = self.view.frame.width * 0.9
            let h = CGFloat(400)
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
            
            vc.reloadDataCallback = {
                reloadDataCallback?()
            }
            
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
            let x = self.view.center.x
            let center = ModalCenterPosition.custom(centerPoint: CGPoint(x: x, y: 250))
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
  
    private func getPopup(_ avaliable:((_ model:[String:AnyObject])->Void)?  = nil){
     
        self.modelCtrl.getPopupPromotion(params: nil ,  true , succeeded: { (result) in
            if let mResult = result as? [[String:AnyObject]] {
                if let item = mResult.first {
                      avaliable?(item)
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
    func showPoPup(_ animated:Bool , dismissCallback:(()->Void)? = nil){
       
        self.getPopup(){ (model) in
            let presenter: Presentr = {
                
                let w = self.view.frame.width * 0.8
                let width = ModalSize.custom(size: Float(w))
                let height = ModalSize.custom(size: Float(w / 925 * 1105))
                
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
                vc.model = model
                vc.dismissView = {
                    dismissCallback?()
                }
                self.viewPopup = vc.view
                self.customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
                
            }
        }
        
        
    }
    
    func showPoPupChosenQRCode(_ animated:Bool , dismissCallback:((_ chooseType:String)->Void)? = nil){
        
        let presenter: Presentr = {
            
            let w = self.view.frame.width * 0.8
            let width = ModalSize.custom(size: Float(w))
            let height = ModalSize.custom(size: 160)
            
            let center = ModalCenterPosition.center
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 10
            customPresenter.dismissOnSwipe = true
            customPresenter.dismissOnTap = true
            
            return customPresenter
        }()
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupChosenQRcodeViewController") as? PopupChosenQRcodeViewController{
           
            vc.dismissCallback = { (chooseType) in
                dismissCallback?(chooseType)
            }
            self.customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
            
        }
        
    }
    
    
    func showInfoGoldPremiumPopup(_ animated:Bool , nextStepCallback:(()->Void)? = nil ){
        let presenter: Presentr = {
            
            let w = self.view.frame.width * 0.8
            let h = CGFloat(330)
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
    
    
    func showInfoLaserIdPopup(_ animated:Bool , nextStepCallback:(()->Void)? = nil ){
        let presenter: Presentr = {
            
            let w = self.view.frame.width * 0.8
            let h = w/260*205  //CGFloat(300)
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
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpInfoLaserIdViewController") as? PopUpInfoLaserIdViewController{
            
            self.viewPopup = vc.view
            
            customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
            
        }
    }
    
    func showInfoThaiPostPopup(_ animated:Bool , nextStepCallback:(()->Void)? = nil ){
        let presenter: Presentr = {
            
            let w = self.view.frame.width * 0.9
            let h = CGFloat(490)
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
    
    func showConfirmOrderViewController(_ animated:Bool,
                                        cart_id:String,
                                        invoice_id:String,
                                        shipping_id:String,
                                        tupleProduct:AnyObject?){
        
        if let vc:ConfirmOrderViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmOrderViewController") as? ConfirmOrderViewController {
            vc.tupleProduct = tupleProduct
            vc.cart_id = cart_id
            vc.invoice_id = invoice_id
            vc.shipping_id = shipping_id
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showCartViewController(_ animated:Bool){
        if let vc:CartViewController = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showPoPupAddToCart(_ animated:Bool,
                            cartTuple:(amount:Int,
                                        product: [String:AnyObject],
                                        brand: [String:AnyObject],
                                        product_images: [String:AnyObject])? ,
                            dismissCallback:(()->Void)? = nil){
        
        let presenter: Presentr = {
            
            let w = self.view.frame.width
            let width = ModalSize.custom(size: Float(w))
            let height = ModalSize.custom(size: Float(w / 300 * 260))
            
            let center = ModalCenterPosition.bottomCenter
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 10
            customPresenter.dismissOnSwipe = true
            customPresenter.dismissOnTap = true
            
            return customPresenter
        }()
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupAddToCartViewController") as? PopupAddToCartViewController{
            vc.dismissView = {
                dismissCallback?()
            }
            vc.cartTuple = cartTuple
            
            self.viewPopup = vc.view
            
            self.customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
            
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
        if messageError == "429"{
            self.AlertMessageDialogOK(NSLocalizedString("error-connect-server-to-many-request", comment: ""))
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
            DataController.sharedInstance.clearNotificationArrayOfObjectData()
            DataController.sharedInstance.setToken("")
             Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.reNewApplication), userInfo: nil, repeats: false)
            
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
        
        //self.present(alert, animated: true, completion: nil)
        alert.show()
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
            
            let params:Parameters = ["language"  : languageId]
            
            self.modelCtrl.memberSetting(params: params, true, succeeded: { (result) in
                print(result)
                L102Language.setAppleLAnguageTo(lang: languageId)
                self.refreshControl?.endRefreshing()
                //exit(EXIT_SUCCESS)
                Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.reNewApplication), userInfo: nil, repeats: false)
                
            }, error: { (error) in
                if let mError = error as? [String:AnyObject]{
                    let message = mError["message"] as? String ?? ""
                    print(message)
                    self.showMessagePrompt2(message)
                }
                self.refreshControl?.endRefreshing()
                print(error)
            }) { (messageError) in
                print("messageError")
                self.handlerMessageError(messageError)
                self.refreshControl?.endRefreshing()
            }

        }
        
        
        
        let cancelAction = UIAlertAction(title: cancel, style: .default, handler: nil)
        
        
        confirmAlertCtrl.addAction(cancelAction)
        confirmAlertCtrl.addAction(confirmAction)
        
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
    
    func addRefreshScrollViewController(_ scrollview:UIScrollView){
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        scrollview.isScrollEnabled = true
        scrollview.alwaysBounceVertical = true
        scrollview.addSubview(self.refreshControl!)
    }
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let y = textField.frame.origin.y + (textField.superview?.frame.origin.y)!;
        
        self.positionYTextField = y
    }
    
    
    
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
        
        
        
        alert.addAction(actionCancel)
        alert.addAction(actionSetting)
        
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
        
        
        alert.addAction(actionCancel)
        alert.addAction(actionSetting)
        
        self.present(alert, animated: true, completion: nil)
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
