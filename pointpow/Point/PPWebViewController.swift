//
//  PPWebViewController.swift
//  pointpow
//
//  Created by thanawat on 16/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class PPWebViewController: BaseViewController {

    var mTitle:String?
    var mUrl:String?
    
    @IBOutlet weak var mWeb: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = mTitle
        // Do any additional setup after loading the view.
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
