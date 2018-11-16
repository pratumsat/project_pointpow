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

class BaseViewController: UIViewController ,  PAPasscodeViewControllerDelegate{

    var positionYTextField:CGFloat = 0
    var isShowKeyBoard = false
    var loadingView:Loading?
   
    var windowSubview:UIImageView?
    var socialLoginSucces:Bool?
    let modelCtrl:ModelController = ModelController()
    private var popUpViewController:PopUpViewController?  // for dismiss
    private var personalViewController:PersonalPopupViewController?  // for dismiss
    
    
    var handlerDidCancel: (()->Void)?
    var handlerEnterSuccess: (()->Void)?
    var hendleSetPasscodeSuccess: ((_ passcode:String)->Void)?
    
    private var searchImageView:UIImageView?
    private var cartImageView:UIImageView?
    private var moreImageView:UIImageView?
    
    var backgroundImage:UIImageView?
    
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
        
        //keyboard show / hide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
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
    
    
    @objc func GoogleSigInSuccess(notification: NSNotification){
        if let userInfo = notification.userInfo as? [String:AnyObject]{
            
            print(userInfo)
            
            //when after call api success
            self.socialLoginSucces = true
            
            
            GIDSignIn.sharedInstance()?.signOut()
        }
        
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
        
        print("positionTextField y \(self.positionYTextField)")
        print("half height \(hH)")
        
        if self.positionYTextField == 0 {
            return
        }
        if let _ = self.windowSubview {
            self.positionYTextField += 100
        }
        if self.positionYTextField < hH {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.bounds.origin.y == 0 {
                if !self.isShowKeyBoard {
                    self.isShowKeyBoard = true
                    //self.view.frame.origin.y -= (keyboardSize.height - self.positionYTextField)
                    print((keyboardSize.height - self.positionYTextField))
                    self.view.frame.origin.y -= (keyboardSize.height)
                    self.windowSubview?.isHidden = true
                }
                //self.view.frame.origin.y -= (keyboardSize.height)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y < 0 {
                if  self.isShowKeyBoard {
                    self.isShowKeyBoard = false
                    
                    print((keyboardSize.height - self.positionYTextField))
                    self.view.frame.origin.y += (keyboardSize.height)
                    self.windowSubview?.isHidden = false
                }
                //self.view.frame.origin.y += (keyboardSize.height)
            }
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
    func showVerify(_ animated:Bool){
        if let vc:VerifyViewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController") as? VerifyViewController {
            
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func showRegister(_ animated:Bool){
        if let vc:RegisterViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
            
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
    
    func showEnterPassCodeModalView(_ title:String = NSLocalizedString("title-enter-passcode", comment: "")){
        let enterPasscode = PAPasscodeViewController(for: PasscodeActionEnter )
        enterPasscode!.delegate = self
        enterPasscode?.title = title
        
        let navController = UINavigationController(rootViewController: enterPasscode!)
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                           NSAttributedString.Key.font :  UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.TITLE )!]
        
        
        
        let presenter: Presentr = {
            let w = self.view.frame.width
            
            let width = ModalSize.custom(size: Float(w))
            let height = ModalSize.custom(size: Float(w / 300 * 360))
            
            let center = ModalCenterPosition.bottomCenter
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.dismissOnTap = false
            
            return customPresenter
        }()
        
        customPresentViewController(presenter, viewController: navController, animated: true, completion: nil)
    }
    func showSettingPassCodeModalView(_ title:String = NSLocalizedString("title-set-passcode", comment: "")){
        let enterPasscode = PAPasscodeViewController(for: PasscodeActionSet )
        enterPasscode!.delegate = self
        enterPasscode?.title = title
        
        let navController = UINavigationController(rootViewController: enterPasscode!)
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                           NSAttributedString.Key.font :  UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.TITLE )!]
        
        
        
        let presenter: Presentr = {
            let w = self.view.frame.width
            //let h = self.view.frame.height
            
            let width = ModalSize.custom(size: Float(w))
            let height = ModalSize.custom(size: Float(w / 300 * 500))
            //let height = ModalSize.custom(size: Float(h))
            
            let center = ModalCenterPosition.bottomCenter
            //let center = ModalCenterPosition.center
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
        
        controller.dismiss(animated: false, completion: { () in
            self.handlerEnterSuccess?()
        })
        //controller.showFailedMessage("")
    }
    func paPasscodeViewControllerDidSetPasscode(_ controller: PAPasscodeViewController!, didSetPassCode passcode: String!) {
        
        print("set passcode: \(passcode ?? "unknow")")
    
        controller.dismiss(animated: false, completion: { () in
            self.hendleSetPasscodeSuccess?(passcode)
        })
        
        
        
    }
    
    func showPersonalPopup(_ animated:Bool , nextStepCallback:(()->Void)? = nil ){
        let presenter: Presentr = {
            
            let w = self.view.frame.width * 0.8
            let h = w/275*360
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
            
            self.personalViewController = vc
            
            
            
            customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
            
        }
    }
    
  /*
    
    func showPoPup(_ animated:Bool){
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
            customPresenter.dismissOnSwipeDirection = .top
            customPresenter.dismissOnTap = false
            
            let customview = UIView()
            customview.frame = self.view.frame
          
            
            let centerPoint = self.view.center
            let popWidth = self.view.frame.width * 0.8
            let popHeight = popWidth / 925 * 1105
            let x = centerPoint.x + popWidth/2
            let y = centerPoint.y - popHeight/2 - 20
            
            let image = UIImageView()
            image.frame = CGRect(x: x, y: y, width: 20, height: 20)
            image.image = UIImage(named: "ic-x-black")
            image.contentMode = .scaleAspectFit
            customview.addSubview(image)
            
            
            image.isUserInteractionEnabled = true
            let dismiss = UITapGestureRecognizer(target: self, action: #selector(dismissPoPup))
            image.addGestureRecognizer(dismiss)
            
            
            customPresenter.customBackgroundView = customview
            
            return customPresenter
        }()
    
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController{
            self.popUpViewController = vc
            customPresentViewController(presenter, viewController: vc, animated: animated, completion: nil)
            
        }
    }
    */
    
    
    func showMessagePrompt(_ message:String){
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: NSLocalizedString("string-button-ok", comment: ""), style: .cancel, handler: nil)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
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
    
    @objc func dismissPoPup(){
        self.windowSubview?.removeFromSuperview()
        self.windowSubview = nil
    }
    @objc func dismissPersonalPoPup(){
        self.windowSubview?.removeFromSuperview()
        self.windowSubview = nil
       
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension BaseViewController {
    
    func addCloseBlackView(){
        let x = CGFloat(self.view.frame.maxX) - 15
        let y = CGFloat(self.view.frame.minY) - 15
        windowSubview = UIImageView()
        windowSubview!.frame = CGRect(x: x, y: y, width: 30, height: 30)
        windowSubview!.image = UIImage(named: "ic-x-red")
        windowSubview!.contentMode = .scaleAspectFit
        windowSubview!.isUserInteractionEnabled = true
        let dismiss = UITapGestureRecognizer(target: self, action: #selector(dismissPersonalPoPup))
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
        self.searchImageView?.alpha = 0
        UIView.animate(withDuration: 0.1) {
            self.searchImageView?.alpha = 1
        }
    }
    @objc func cartTapped(){
        self.cartImageView?.alpha = 0
        UIView.animate(withDuration: 0.1) {
            self.cartImageView?.alpha = 1
        }
    }
    @objc func moreTapped(){
        self.moreImageView?.alpha = 0
        UIView.animate(withDuration: 0.1) {
            self.moreImageView?.alpha = 1
        }
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
                                print(item["email"])
                                print(item["first_name"])
                                print(item["last_name"])
                                print(item["id"])
                            }
                            self.socialLoginSucces = true
                            
                            //test
//                            self.fbLoginManager.logOut()
//                            if((FBSDKAccessToken.current()) == nil){
//                                print("logout success")
//                            }else{
//                                print("logout i not success")
//                            }
                        }
                    })
            }
        }
    }
