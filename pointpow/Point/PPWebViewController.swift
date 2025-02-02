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
    var htmlString:String?
    var mUrl:String?
    
    @IBOutlet weak var mWeb: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = mTitle
        
        let backImage = UIImage(named: "ic-back-white")
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backViewTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 2, left: -10, bottom: -2, right: 10)
        
        self.mWeb.delegate = self
        self.mWeb.scalesPageToFit = false
        self.mWeb.contentMode = .scaleAspectFit
        
        if let url = self.mUrl {
            if let myURL = URL(string: url) {
                let myURLRequest:URLRequest = URLRequest(url: myURL)
                self.mWeb.loadRequest(myURLRequest)
            }
        }
        if let html = self.htmlString {
            var htmlCode = "<html><head><style> body { font-family:\"\(Constant.Fonts.THAI_SANS_BOLD)\"; font-size: \(Constant.Fonts.Size.CONTENT_HTML);} </style></head><body>"
            
            
            htmlCode += html
            
            htmlCode += "</body></html>"
            self.mWeb.loadHTMLString(htmlCode, baseURL: nil)
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
