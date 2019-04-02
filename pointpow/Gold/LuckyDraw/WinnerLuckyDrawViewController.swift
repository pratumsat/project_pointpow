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
            //few
        }
    }
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
                    let winner = data.first?["winners"] as? [[String:AnyObject]] ?? [[:]]
                    let schedule = data.first?["schedule"] as? [String:AnyObject] ?? [:]
                    
                    let link = schedule["link"] as? String ?? ""
                    
                    
                    self.selectLinkFacebook = link
                    
                    self.selectBanner = []
                    self.selectBanner?.append(schedule)
                    
                }
                
                
            }
            
            avaliable?()
            
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
    override func reloadData() {
        self.getWinnerLuckyDraw() {
            self.winnerLuckyDrawCollectionView.reloadData()
        }
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
                
                item.memberCallback = {(winner) in
                    for item in winner {
                        print(item)
                        
                        
                    }
                    self.winnerModel = winner
                }
                item.schedule = self.winnerLuckyModel
                
            
                
                cell = item
            }
        }else if indexPath.section == 2 {
            if let item  = collectionView.dequeueReusableCell(withReuseIdentifier: "WinnerCollectionViewCell", for: indexPath) as? WinnerCollectionViewCell {
                
                cell =  item
            }
            
        }else if indexPath.section == 3 {
            
            
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
            return CGSize(width: collectionView.frame.width, height: CGFloat(40))
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
            let height = width/1799*720
            return CGSize(width: width, height: height)
        }else if indexPath.section == 1 {
            let width = collectionView.frame.width
            let height = CGFloat(120)
            return CGSize(width: width, height: height)
        }else if indexPath.section == 2 {
            let width = collectionView.frame.width
            let height = CGFloat(100)
            return CGSize(width: width, height: height)
        }else if indexPath.section == 3 {
            let width = collectionView.frame.width - 40
            let height = CGFloat(100)
            return CGSize(width: width, height: height)
        }else{
            let width = collectionView.frame.width
            return CGSize(width: width, height: CGFloat(60))
        }
    }
}
