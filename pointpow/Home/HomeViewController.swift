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
    
    var userData:AnyObject?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !DataController.sharedInstance.getDefaultLanguage() {
            UserDefaults.standard.set(["th"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            DataController.sharedInstance.setDefaultLanguage()
        }
        
        self.setUp()
        self.getGoldPremiumPrice()
        
        fontList()
        
    }
   
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.isSetHeight {
            self.isSetHeight = true
            let height = self.view.frame.height
            self.pointBalanceConstraintHeight.constant = height*0.15
        }
        
        if DataController.sharedInstance.isLogin() {
            print("isLogin")

            self.getUserInfo() { //validate
                if !self.isFirst {
                    self.showPoPup(true) {   //dismissView
                        self.isFirst = true
                    }
                }
            }
        }else{
            print("notLogin")
            self.showIntroduce(false)
        }
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
       
        
        
        self.homeCollectionView.delegate = self
        self.homeCollectionView.dataSource = self
        self.homeCollectionView.showsVerticalScrollIndicator = false
        
        self.addRefreshViewController(self.homeCollectionView)
        
        self.registerNib(self.homeCollectionView, "PromotionCampainCell")
        self.registerNib(self.homeCollectionView, "ItemServiceCell")
        
        
        let tapProfile  = UITapGestureRecognizer(target: self, action: #selector(tapToProfile))
        self.profileImageView.isUserInteractionEnabled = true
        self.profileImageView.addGestureRecognizer(tapProfile)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToPointBalance))
        self.pointBalanceLabel.isUserInteractionEnabled = true
        self.pointBalanceLabel.addGestureRecognizer(tap)
    }
    
    override func reloadData() {
        self.getUserInfo()
    }
    func getGoldPremiumPrice(_ avaliable:(()->Void)?  = nil){
        modelCtrl.getPremiumGoldPrice(params: nil , false , succeeded: { (result) in
            print("get premium success")
            avaliable?()
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                //self.showMessagePrompt(message)
            }
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
            
        }
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
            if let data  = result as? [String:AnyObject] {
              
                let picture_data = data["picture_data"] as? String ?? ""
                
                self.profileImageView.sd_setImage(with: URL(string: picture_data)!, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.PROFILE_PLACEHOLDER))
                
                
                
            }
            
            self.refreshControl?.endRefreshing()
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                //self.showMessagePrompt(message)
            }
            self.refreshControl?.endRefreshing()
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
            self.refreshControl?.endRefreshing()
        }
    }
    
    @objc func tapToProfile(){
        self.tabBarController?.selectedIndex = 4
    }
    @objc func tapToPointBalance(){
        self.showPointManagement(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if shadowImageView == nil {
            shadowImageView = findShadowImage(under: navigationController!.navigationBar)
        }
        shadowImageView?.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        shadowImageView?.isHidden = false
    }
   
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.profileImageView.ovalColorWhiteProperties(borderWidth: 2.0)
        self.notiView.ovalColorClearProperties()
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                print("gold saving")
                self.showGoldPage(true)
            }
        }
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
