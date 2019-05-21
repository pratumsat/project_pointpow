//
//  TransactionFilterVIewController.swift
//  pointpow
//
//  Created by thanawat on 21/5/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class TransactionFilterViewController: BaseViewController {

    var filterCallback:((_ filter:String)->Void)?
    
    @IBOutlet weak var statusSuccessImageView: UIImageView!
    @IBOutlet weak var statusPendingImageView: UIImageView!
    @IBOutlet weak var statusFailImageView: UIImageView!
    @IBOutlet weak var statusContainView: UIView!
    @IBOutlet weak var serviceContainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-transection", comment: "")
        self.backgroundImage?.image = nil
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.statusContainView.borderDarkGrayColorProperties(borderWidth: 1, radius: 10)
        self.serviceContainView.borderDarkGrayColorProperties(borderWidth: 1, radius: 10)
    }

}
