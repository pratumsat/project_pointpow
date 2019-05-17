//
//  PromotionViewController.swift
//  pointpow
//
//  Created by thanawat on 6/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class PromotionViewController: BaseViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    
    var userData:AnyObject?
    
    @IBOutlet weak var promotionCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = NSLocalizedString("string-title-promotion", comment: "")
        self.setUp()
    }
    
    
    func setUp(){
        
        self.backgroundImage?.image = nil
        
        self.promotionCollectionView.dataSource = self
        self.promotionCollectionView.delegate = self
        self.promotionCollectionView.showsVerticalScrollIndicator = false
        self.addRefreshViewController(self.promotionCollectionView)
        
        self.registerNib(promotionCollectionView, "PromoCell")
    }
    
    
    override func reloadData() {
        self.getPromotion()
    }
    
    func getPromotion(_ avaliable:(()->Void)?  = nil){
        /*
        var isLoading:Bool = true
        if self.userData != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        modelCtrl.getUserData(params: nil , isLoading , succeeded: { (result) in
            self.userData = result
            avaliable?()
            
            self.promotionCollectionView.reloadData()
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
        */
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
       
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromoCell", for: indexPath) as? PromoCell{
            cell = itemCell



        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showPromotionDetail("1", true)
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
       
        return CGSize(width: collectionView.frame.width, height: 20)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if section == 4 {
            return CGSize(width: collectionView.frame.width, height: 60)
        }
        return CGSize.zero
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 20
        
        let heightImage = (width-20)/950*300
        
        let height = heightImage + 120
        return CGSize(width: width, height: height)
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
}
