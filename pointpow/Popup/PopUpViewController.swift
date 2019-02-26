//
//  PopUpViewController.swift
//  pointpow
//
//  Created by thanawat on 30/10/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class PopUpViewController: BaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var dismissView:(()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = UIImage(named: "ic-bg-popup")
        
    }
    
    override func dismissPoPup() {
        super.dismissPoPup()
        self.dismiss(animated: true, completion: {
            self.dismissView?()
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCloseWhiteView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismissPoPup()
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
