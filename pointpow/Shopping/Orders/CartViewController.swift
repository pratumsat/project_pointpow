//
//  CartViewController.swift
//  pointpow
//
//  Created by thanawat on 3/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class CartViewController: BaseViewController  , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIWebViewDelegate {

    @IBOutlet weak var cartCollectionView: UICollectionView!
    var userData:AnyObject?
    var currentPointBalance:String? {
        didSet{
            self.cartCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.title = NSLocalizedString("string-title-cart-product", comment: "")
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        self.currentPointBalance = numberFormatter.string(from: DataController.sharedInstance.getCurrentPointBalance() )
        
        
    }
    
    override func reloadData() {
        getUserInfo()
    }
    
    func setUp(){
        self.cartCollectionView.delegate = self
        self.cartCollectionView.dataSource = self
        
        self.addRefreshViewController(self.cartCollectionView)
        
        self.registerNib(self.cartCollectionView, "CartPointBalanceCell")
        self.registerNib(self.cartCollectionView, "ItenCartProductSelectAllCell")
        self.registerNib(self.cartCollectionView, "ItemCartProductCell")
        self.registerNib(self.cartCollectionView, "CartSummaryCell")
        self.registerNib(self.cartCollectionView, "CartHowtoSummary")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            avaliable?()
            if let userData = self.userData as? [String:AnyObject] {
                let pointBalance = userData["member_point"]?["total"] as? NSNumber ?? 0
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 2

                self.currentPointBalance = numberFormatter.string(from: pointBalance )
            }
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
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 2 {
            return 4
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if indexPath.section == 0 {
            if let pointCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartPointBalanceCell", for: indexPath) as? CartPointBalanceCell {
                cell = pointCell
                
                let unit = NSLocalizedString("string-unit-pointpow", comment: "")
                if let current = self.currentPointBalance {
                    pointCell.pointBalanceLabel.text = "\(current)\(unit)"
                }
                
            }
        }
        if indexPath.section == 1 {
            if let selectCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItenCartProductSelectAllCell", for: indexPath) as? ItenCartProductSelectAllCell {
                cell = selectCell
                
                selectCell.backgroundColor = UIColor.lightGray
            }
        }
        if indexPath.section == 2 {
            if let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCartProductCell", for: indexPath) as? ItemCartProductCell {
                cell = productCell
                
                productCell.backgroundColor = UIColor.cyan
            }
        }
        if indexPath.section == 3 {
            if let sumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartSummaryCell", for: indexPath) as? CartSummaryCell {
                cell = sumCell
                
                sumCell.backgroundColor = UIColor.brown
            }
        }
        if indexPath.section == 4 {
            if let howtoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartHowtoSummary", for: indexPath) as? CartHowtoSummary {
                cell = howtoCell
                
                howtoCell.backgroundColor = UIColor.cyan
            }
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let height = CGFloat(50.0)
            return CGSize(width: collectionView.frame.width, height: height)
        }
        if indexPath.section == 1 {
            let height = CGFloat(50.0)
            return CGSize(width: collectionView.frame.width, height: height)
        }
        if indexPath.section == 2 {
            let height = CGFloat(120.0)
            return CGSize(width: collectionView.frame.width, height: height)
        }
        if indexPath.section == 3 {
            let height = CGFloat(120.0)
            return CGSize(width: collectionView.frame.width, height: height)
        }
        if indexPath.section == 4 {
            let height = CGFloat(120.0)
            return CGSize(width: collectionView.frame.width, height: height)
        }
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
}
