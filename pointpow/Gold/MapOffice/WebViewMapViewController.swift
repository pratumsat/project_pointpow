//
//  WebViewMapViewController.swift
//  pointpow
//
//  Created by thanawat on 26/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class WebViewMapViewController: BaseViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = NSLocalizedString("title-map-office", comment: "")
        self.backgroundImage?.image = nil
        
        //3. Load local html file into web view
        let myProjectBundle:Bundle = Bundle.main
        
        let filePath:String = myProjectBundle.path(forResource: "map", ofType: "html")!
        
        let myURL = URL(string: filePath);
        let myURLRequest:URLRequest = URLRequest(url: myURL!)
        
        self.webView.loadRequest(myURLRequest)
        
        
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
