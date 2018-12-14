//
//  HomeViewController.swift
//  pointpow
//
//  Created by thanawat on 6/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var notiView: UIView!
    
    @IBOutlet weak var pointBalanceLabel: UILabel!
    @IBOutlet weak var pointBalanceConstraintHeight: NSLayoutConstraint!
  
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var shadowImageView:UIImageView?
    var isSetHeight = false
    
    var isFirst = false
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !DataController.sharedInstance.getDefaultLanguage() {
            UserDefaults.standard.set(["th"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            
            DataController.sharedInstance.setDefaultLanguage()
        }
        
        
        //self.showIntroduce(false)
        self.setUp()
        
        
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.isSetHeight {
            self.isSetHeight = true
            let height = self.view.frame.height
            self.pointBalanceConstraintHeight.constant = height*0.15
            
            
            
        }
     
        if !isFirst {
            self.showPoPup(true) {
                //dismissView
                self.isFirst = true
            }
            
        }
        
    }
    func setUp(){
        self.backgroundImage?.image = nil
       
        self.profileImageView.image = UIImage(named: "bg-profile-image")
        
        self.homeCollectionView.delegate = self
        self.homeCollectionView.dataSource = self
        
        self.registerNib(self.homeCollectionView, "PromotionCampainCell")
        self.registerNib(self.homeCollectionView, "ItemServiceCell")
        
        
        let tapProfile  = UITapGestureRecognizer(target: self, action: #selector(tapToProfile))
        self.profileImageView.isUserInteractionEnabled = true
        self.profileImageView.addGestureRecognizer(tapProfile)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToPointBalance))
        self.pointBalanceLabel.isUserInteractionEnabled = true
        self.pointBalanceLabel.addGestureRecognizer(tap)
    }
    
    @objc func tapToProfile(){
        self.tabBarController?.selectedIndex = 4
    }
    @objc func tapToPointBalance(){
        self.showPointManagement(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.profileImageView.ovalColorWhiteProperties(borderWidth: 2.0)
        self.notiView.ovalColorClearProperties()
        
        if shadowImageView == nil {
            shadowImageView = findShadowImage(under: navigationController!.navigationBar)
        }
        shadowImageView?.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
        
         shadowImageView?.isHidden = false
    }
   
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 5
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if indexPath.section == 0 {
            if let promo = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCampainCell", for: indexPath) as? PromotionCampainCell{
                
                
                cell = promo
            }
        }
        if indexPath.section == 1 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemServiceCell", for: indexPath) as? ItemServiceCell {
                cell = item
                
                switch indexPath.row {
                case 0:
                    item.itemImageView.image = UIImage(named: "ic-home-gift")
                    item.nameLabel.text = NSLocalizedString("string-item-gift", comment: "")
                case 1:
                    item.itemImageView.image = UIImage(named: "ic-home-gold")
                    item.nameLabel.text = NSLocalizedString("string-item-gold", comment: "")
                case 2:
                    item.itemImageView.image = UIImage(named: "ic-home-transfer-point")
                    item.nameLabel.text = NSLocalizedString("string-item-transfer-point", comment: "")
                case 3:
                    item.itemImageView.image = UIImage(named: "ic-home-transfer-friend")
                    item.nameLabel.text = NSLocalizedString("string-item-transfer-friend", comment: "")
                case 4:
                    item.itemImageView.image = UIImage(named: "ic-home-event")
                    item.nameLabel.text = NSLocalizedString("string-item-event", comment: "")
                default:
                    break
                    
                }
                if  indexPath.row % 3 == 1  {
                    let right = UIView(frame: CGRect(x: item.frame.width - 1, y: 0 ,
                                                     width: 1,
                                                     height: item.frame.height  ))
                    right.backgroundColor = Constant.Colors.LINE_COLOR
                    item.addSubview(right)
                    
                    let left = UIView(frame: CGRect(x: 0, y: 0 ,
                                                    width: 1,
                                                    height: item.frame.height  ))
                    left.backgroundColor = Constant.Colors.LINE_COLOR
                    item.addSubview(left)
                    
                }
                
                
                let lineBottom = UIView(frame: CGRect(x: 0, y: item.frame.height - 1 , width: collectionView.frame.width, height: 1 ))
                lineBottom.backgroundColor = Constant.Colors.LINE_COLOR
                item.addSubview(lineBottom)
            }
            
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let width = collectionView.frame.width
            let height = width/1799*720
            return CGSize(width: width, height: height)
        }
        let width = collectionView.frame.width / 3
        return CGSize(width: width, height: width)
    }

}
