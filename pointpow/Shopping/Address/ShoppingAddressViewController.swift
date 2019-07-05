//
//  ShoppingAddressViewController.swift
//  pointpow
//
//  Created by thanawat on 5/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ShoppingAddressViewController: BaseViewController {

    @IBOutlet weak var addressCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("string-title-shopping-address", comment: "")
        let addAddress = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAddressTapped))
        self.navigationItem.rightBarButtonItem = addAddress
        
    }
    
    @objc func addAddressTapped(){
        
    }
    


}
