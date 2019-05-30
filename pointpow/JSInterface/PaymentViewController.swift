//
//  PaymentViewController.swift
//  pointpow
//
//  Created by thanawat on 29/5/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PaymentViewController: BaseViewController , UIWebViewDelegate{

    
    @IBOutlet weak var webView: UIWebView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-point-transfer", comment: "")
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(successTransection), name: NSNotification.Name(rawValue: Constant.DefaultConstansts.TRANSECTION_SUCCESS), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(failTransection), name: NSNotification.Name(rawValue: Constant.DefaultConstansts.TRANSECTION_FAIL), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(cancelTransection), name: NSNotification.Name(rawValue: Constant.DefaultConstansts.TRANSECTION_CANCEL), object: nil)
        
        
//        let backImage = UIImage(named: "ic-back-white")
//        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backViewTapped))
//        self.navigationItem.leftBarButtonItem = backButton
        
        self.webView.delegate = self
        self.webView.scalesPageToFit = false
        self.webView.contentMode = .scaleAspectFit
        
        
        //TEST Load local html file into web view
        let myProjectBundle:Bundle = Bundle.main
        
        let filePath:String = myProjectBundle.path(forResource: "index", ofType: "html")!
        
        let myURL = URL(string: filePath);
        let myURLRequest:URLRequest = URLRequest(url: myURL!)
        
        self.webView.addJavascriptInterface(JSInterface(), forKey: "PointPowNative");
        self.webView.loadRequest(myURLRequest)
        
        
       
    }
   
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.loadingView?.showLoading()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loadingView?.hideLoading()
    }
    @objc func successTransection(_ notification:NSNotification){
        self.dismiss(animated: false, completion: {
            //success
            if let userInfo = notification.userInfo as? [String:AnyObject]{
                (self.navigationController as! NavPaymentViewController).callbackResult?(userInfo as AnyObject)
            }
            
            
        })
    }
    @objc func failTransection(_ notification:NSNotification){
        self.dismiss(animated: false, completion: {
            //fail
            if let userInfo = notification.userInfo as? [String:AnyObject]{
                (self.navigationController as! NavPaymentViewController).callbackResult?(userInfo as AnyObject)
            }
        })
    }
    @objc func cancelTransection(_ notification:NSNotification){
        self.dismiss(animated: true, completion: {
            if let userInfo = notification.userInfo as? [String:AnyObject]{
                (self.navigationController as! NavPaymentViewController).callbackResult?(userInfo as AnyObject)
            }
        })
    }
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            //
        })
    }
    
//    @objc func backViewTapped(){
//        if self.webView.canGoBack {
//            self.webView.goBack()
//            return
//        }
//        self.navigationController?.popViewController(animated: true)
//    }
    
}
