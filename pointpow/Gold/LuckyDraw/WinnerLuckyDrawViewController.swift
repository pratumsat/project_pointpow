//
//  WinnerLuckyDrawViewController.swift
//  pointpow
//
//  Created by thanawat on 2/4/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class WinnerLuckyDrawViewController: BaseViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var winnerLuckyDrawCollectionView: UICollectionView!
    
    var winnerModel:[[String:AnyObject]]?{
        didSet{
            self.winnerLuckyDrawCollectionView.reloadData()
        }
    }
    var selectId:Int?
    var selectBanner:[[String:AnyObject]]?
    var selectLinkFacebook:String?
    var selectWinner:[[String:AnyObject]]?
    var winnerLuckyModel:[[String:AnyObject]]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-winner-lucky-draw", comment: "")
        
        self.setUp()
        self.getWinnerLuckyDraw {
            self.winnerLuckyDrawCollectionView.reloadData()
        }
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        self.winnerLuckyDrawCollectionView.delegate = self
        self.winnerLuckyDrawCollectionView.dataSource = self
        self.winnerLuckyDrawCollectionView.showsVerticalScrollIndicator = false
        
        self.addRefreshViewController(self.winnerLuckyDrawCollectionView)
        self.registerNib(self.winnerLuckyDrawCollectionView, "LogoGoldCell")
        self.registerNib(self.winnerLuckyDrawCollectionView, "PromotionCampainCell")
        self.registerNib(self.winnerLuckyDrawCollectionView, "PickerLuckyDrawCell")
        self.registerHeaderNib(self.winnerLuckyDrawCollectionView, "HeadWinnerCollectionViewCell")
        self.registerNib(self.winnerLuckyDrawCollectionView, "WinnerCollectionViewCell")
        self.registerNib(self.winnerLuckyDrawCollectionView, "WinnerHistoryLinkCell")
        
    }
    func getWinnerLuckyDraw(_ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.winnerLuckyModel != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        modelCtrl.getWinnerLuckyDraw(params: nil , isLoading , succeeded: { (result) in
            
            
            if let data = result as? [[String:AnyObject]] {
                self.winnerLuckyModel = data
            
                if data.count > 0 {
                    let schedule = data.first?["schedule"] as? [String:AnyObject] ?? [:]
                    let winners = data.first?["winners"] as? [[String:AnyObject]] ?? [[:]]
                    let link = schedule["link"] as? String ?? ""
                    let id = schedule["id"] as? NSNumber ?? 0
                    
                    self.selectId = id.intValue
                    
                    self.winnerModel = winners
                    self.selectLinkFacebook = link
                    
                    self.selectBanner = []
                    //self.selectBanner?.append(schedule)
                    let path_mobile = schedule["path_mobile"] as? String ?? ""
                    self.selectBanner?.append(["path_mobile": path_mobile as AnyObject])
                    
                }
                
                
            }
            
            avaliable?()
            
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
    override func reloadData() {
        self.getWinnerLuckyDraw() {
            self.winnerLuckyDrawCollectionView.reloadData()
        }
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 2 {
            return self.winnerModel?.count ?? 0
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if indexPath.section == 0 {
            if let promo = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCampainCell", for: indexPath) as? PromotionCampainCell{
                
                promo.itemBanner = self.selectBanner
                promo.autoSlideImage = false
                
                cell = promo
            }
        }else if indexPath.section == 1 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "PickerLuckyDrawCell", for: indexPath) as? PickerLuckyDrawCell {
                
                item.memberCallback = {(id, link, winner , banners) in
                    self.selectId = id
                    self.selectBanner = banners
                    self.winnerModel = winner
                    self.selectLinkFacebook = link
                   
                }
                item.selectedId = self.selectId
                item.schedule = self.winnerLuckyModel
                
            
                
                cell = item
            }
        }else if indexPath.section == 2 {
            if let item  = collectionView.dequeueReusableCell(withReuseIdentifier: "WinnerCollectionViewCell", for: indexPath) as? WinnerCollectionViewCell {
            
                cell =  item
                
                if let itemData = self.winnerModel?[indexPath.row] {
                    let  firstname = itemData["firstname"] as? String ?? ""
                    let  lastname = itemData["lastname"] as? String ?? ""
                    let  mobile = itemData["mobile"] as? String ?? ""
                    
                    item.fnameLabel.text = firstname
                    item.lnameLabel.text = lastname
                    item.telLabel.text = mobile
                }
                
                
                if indexPath.row%2 == 0 {
                    item.backgroundColor = UIColor.white
                }else{
                    item.backgroundColor = UIColor.groupTableViewBackground
                }
                
            }
            
        }else if indexPath.section == 3 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "WinnerHistoryLinkCell", for: indexPath) as? WinnerHistoryLinkCell {
                
                item.showSavingHomeCallback = {
                    if let saving = self.storyboard?.instantiateViewController(withIdentifier: "NavGoldPage") as? NavGoldPage {
                        self.revealViewController()?.pushFrontViewController(saving, animated: true)
                        
                    }
                }
                item.showLinkFacebookCallback = {
                    if let mlink  =  self.selectLinkFacebook {
                        guard let url = URL(string: mlink) else { return }
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                   
                }
                
                cell = item
            }
            
            
        }else {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "LogoGoldCell", for: indexPath) as? LogoGoldCell {
                cell = item
                
            }
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header  = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeadWinnerCollectionViewCell", for: indexPath) as! HeadWinnerCollectionViewCell
    
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 2 {
            return CGSize(width: collectionView.frame.width, height: CGFloat(30))
        }
        return CGSize.zero
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        if section == 1 {
//            return CGSize(width: collectionView.frame.width, height: CGFloat(20))
//        }
        return CGSize.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if indexPath.section == 0 {
            let width = collectionView.frame.width
            let height = width/950*400
            return CGSize(width: width, height: height)
        }else if indexPath.section == 1 {
            let width = collectionView.frame.width
            let height = CGFloat(112)
            return CGSize(width: width, height: height)
        }else if indexPath.section == 2 {
        
            let width = collectionView.frame.width
            let height = CGFloat(30)
            return CGSize(width: width, height: height)
        }else if indexPath.section == 3 {
            let width = collectionView.frame.width 
            let height = CGFloat(190)
            return CGSize(width: width, height: height)
        }else{
            let width = collectionView.frame.width
            return CGSize(width: width, height: CGFloat(60))
        }
    }
}
