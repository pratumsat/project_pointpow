//
//  RegisterGoldViewController.swift
//  pointpow
//
//  Created by thanawat on 5/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class RegisterGoldViewController: BaseViewController {

    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var checkBok: CheckBox!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()
    }
    func setUp(){
        self.backgroundImage?.image = nil
        self.checkBok.isChecked = true
    }


}
