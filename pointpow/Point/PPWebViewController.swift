//
//  PPWebViewController.swift
//  pointpow
//
//  Created by thanawat on 16/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class PPWebViewController: BaseViewController , UIWebViewDelegate{

    var mTitle:String?
    var mUrl:String?
    
    @IBOutlet weak var mWeb: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = mTitle
        
        let backImage = UIImage(named: "ic-back-white")
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backViewTapped))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.mWeb.delegate = self
        self.mWeb.scalesPageToFit = false
        self.mWeb.contentMode = .scaleAspectFit
        
        if let url = self.mUrl {
            if let myURL = URL(string: url.replace(target: "https", withString: "http")) {
                let myURLRequest:URLRequest = URLRequest(url: myURL)
                self.mWeb.loadRequest(myURLRequest)
            }
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.loadingView?.showLoading()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loadingView?.hideLoading()
    }
    
    @objc func backViewTapped(){
        if self.mWeb.canGoBack {
            self.mWeb.goBack()
            return
        }
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
