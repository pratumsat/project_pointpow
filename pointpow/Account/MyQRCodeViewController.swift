//
//  MyQRCodeViewController.swift
//  pointpow
//
//  Created by thanawat on 24/5/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import SDWebImage

class MyQRCodeViewController: BaseViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var qrImageView: UIImageView!
    
    var userData:AnyObject?
    
    var imageQR:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-my-qr-code", comment: "")
        self.setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.saveButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if DataController.sharedInstance.isLogin() {
            self.getUserInfo()
        }
    }
    
    override func reloadData() {
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
            
            
            if let mResult = result as? [String:AnyObject] {
                let qr_code  = mResult["qr_code"] as? String ?? ""
                self.imageQR = base64Convert(base64String: qr_code)
                self.qrImageView.image  = self.imageQR
            }
           
          
            avaliable?()
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
    func setUp(){
        self.backgroundImage?.image = nil
        self.saveButton.borderClearProperties(borderWidth: 1)
    }
    
    
    func saveImage(_ finishCallback:(()->Void)? = nil){
        if let img = imageQR {
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
            finishCallback?()
        }
    }

    @IBAction func saveTapped(_ sender: Any) {
        self.saveImage() {
            self.showMessagePrompt2(NSLocalizedString("string-message-success-save-qrcode", comment: ""), okCallback: {
                //ignored
            })
            
        }
    }
    
}
