//
//  LuckyDrawViewController.swift
//  pointpow
//
//  Created by thanawat on 1/4/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class LuckyDrawViewController: BaseViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var luckyDrawCollectionView: UICollectionView!
    
    let cd = DateCountDownTimer()
    
   
    
    var luckydrawModel:AnyObject?
    var banner:[[String:AnyObject]]?
    var schedule:[String:AnyObject]?
    
    var privilege  = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

 
        if (self.revealViewController() != nil) {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            //self.navigationItem.rightBarButtonItem?.target = revealViewController()
            
        }
        
        //self.navigationItem.rightBarButtonItem?.action = #selector(SWRevealViewController.rightRevealToggle(_:))
        
        self.title  = NSLocalizedString("string-title-gold-page-luckydraw", comment: "")
        
        self.handlerEnterSuccess  = {(pin) in
            // "Profile"
            if let profile = self.storyboard?.instantiateViewController(withIdentifier: "NavProfile") as? NavProfile {
                
                self.revealViewController()?.pushFrontViewController(profile, animated: true)
            }
        }
        
        
        
        self.setUp()
        
     

        
    }
    
    
    func setUp(){
        self.backgroundImage?.image = nil
        self.luckyDrawCollectionView.delegate = self
        self.luckyDrawCollectionView.dataSource = self
        self.luckyDrawCollectionView.showsVerticalScrollIndicator = false
        
        self.addRefreshViewController(self.luckyDrawCollectionView)
        self.registerNib(self.luckyDrawCollectionView, "LogoGoldCell")
        self.registerNib(self.luckyDrawCollectionView, "PromotionCampainCell")
        self.registerNib(self.luckyDrawCollectionView, "PrivilegeCell")
        self.registerNib(self.luckyDrawCollectionView, "ScheduleCell")
        self.registerNib(self.luckyDrawCollectionView, "CountDownCell")
        self.registerNib(self.luckyDrawCollectionView, "LuckyDrawPrivacyCell")
    }
    
    
    
    func getPrivilegeLuckyDraw(_ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.luckydrawModel != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        modelCtrl.getLuckyDraw(params: nil , isLoading , succeeded: { (result) in
            self.luckydrawModel = result
            
            if let data = result as? [String:AnyObject] {
                
                self.privilege = (data["privilege"] as? NSNumber)?.intValue ?? 0
                
                let scheduleModel = data["schedule"] as? [String:AnyObject] ?? [:]
                self.schedule = scheduleModel
                
                //let bannerModel = scheduleModel["banner"] as? [String:AnyObject] ?? [:]
                let path_mobile  = scheduleModel["path_mobile"] as? String ?? ""
                self.banner = []
                self.banner?.append(["path_mobile": path_mobile as AnyObject])
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
        self.getPrivilegeLuckyDraw() {
            self.luckyDrawCollectionView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(messageAlert), name: NSNotification.Name(rawValue: "messageAlert"), object: nil)
        
        self.getPrivilegeLuckyDraw() {
            self.luckyDrawCollectionView.reloadData()
        }
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "messageAlert"), object: nil)
    
        self.cd.endTimer()
    }
    
    
    @objc func messageAlert(notification: NSNotification){
        if let userInfo = notification.userInfo as? [String:AnyObject]{
            let profile = userInfo["profile"] as? String  ?? ""
            let showTransaction = userInfo["showTransaction"] as? String ?? ""
            
            if !showTransaction.isEmpty {
                if let vc:WithDrawResultNav  = self.storyboard?.instantiateViewController(withIdentifier: "WithDrawResultNav") as? WithDrawResultNav {
                    vc.hideFinishButton = true
                    vc.transactionId = showTransaction
                    
                    self.present(vc, animated: true, completion: nil)
                }
            }
            if !profile.isEmpty{
                self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
            }
            
        }
        
    }
    
    @IBAction func bViewTapped(_ sender: Any) {
        if let saving = self.storyboard?.instantiateViewController(withIdentifier: "NavGoldPage") as? NavGoldPage {
            self.revealViewController()?.pushFrontViewController(saving, animated: true)
        }
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if indexPath.section == 0 {
            if let promo = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCampainCell", for: indexPath) as? PromotionCampainCell{
                
                promo.itemBanner = self.banner
                promo.autoSlideImage = false
                
                cell = promo
            }
        }else if indexPath.section == 1 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleCell", for: indexPath) as? ScheduleCell {
                cell = item
                
                if let data = self.schedule {
                    let id = data["id"] as? NSNumber ?? 0
                    let end_at = data["end_at"] as? String ?? ""
                    
                    
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "th")
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    
                    if let d1 = dateFormatter.date(from: convertDateRegister(end_at, format: "yyyy-MM-dd HH:mm:ss")) {
                        
                        let formatter = DateFormatter()
                        formatter.locale = Locale(identifier: "th")
                        formatter.dateFormat = "d MMMM yyyy"
                        
                        var dataFormat = NSLocalizedString("string-date-format-announce-at", comment: "")
                        dataFormat = dataFormat.replacingOccurrences(of: "{id}", with: "\(id.intValue)", options: .literal, range: nil)
                        dataFormat = dataFormat.replacingOccurrences(of: "{date}", with: "\(formatter.string(from: d1))", options: .literal, range: nil)
                        item.dateLabel.text = dataFormat
                        
                        
                    }
                    
                }

            }
        }else if indexPath.section == 2 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "PrivilegeCell", for: indexPath) as? PrivilegeCell {
                cell = item
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                item.privilegeLabel.text =  numberFormatter.string(from: NSNumber(value: self.privilege))
                
            }
        }else if indexPath.section == 3 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "CountDownCell", for: indexPath) as? CountDownCell {
                cell = item
                
                
                if let data = self.schedule {
                    let end_at = data["end_at"] as? String ?? ""
                    let start_at = data["start_at"] as? String ?? ""
                    
                    if compareLiveTime(start_at) {
                        print("in time")
                        if !self.cd.running {
                            
                            cd.initializeTimer(end_at)
                            cd.startTimer(pUpdateActionHandler: { (timeString) in
                                
                                item.dayLabel.text = timeString.days
                                item.hoursLabel.text = timeString.hours
                                item.minLabel.text = timeString.minutes
                                item.secLabel.text = timeString.seconds
                                
                            }) {
                                
                                item.dayLabel.text = "0"
                                item.hoursLabel.text = "0"
                                item.minLabel.text = "0"
                                item.secLabel.text = "0"
                                
                            }
                        }
                    }else{
                        print("out time")
                        
                        item.dayLabel.text = "0"
                        item.hoursLabel.text = "0"
                        item.minLabel.text = "0"
                        item.secLabel.text = "0"
                    }
                   
                }
            }
            
        }else if indexPath.section == 4 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "LuckyDrawPrivacyCell", for: indexPath) as? LuckyDrawPrivacyCell {
                cell = item
                
                if let data = self.schedule {
                    let points_required = data["points_required"] as? NSNumber ?? 0
                    let mlink = data["link"] as? String ?? ""
                    
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    
                    let rquiredPP = numberFormatter.string(from: points_required) ?? "0"
                    item.required.text = rquiredPP
                    
                    var txtString = NSLocalizedString("string-date-format-required-point", comment: "")
                    txtString = txtString.replacingOccurrences(of: "{point}", with: "\(rquiredPP)", options: .literal, range: nil)
                    
                    item.requireTxtLabel.text  = txtString
                    
                    item.showWinnerCallback = {
                        self.showWinnerLuckyDraw(true)
                    }
                    item.showLinkFacebookCallback = {
                        print("link = \(mlink)")
                        guard let url = URL(string: mlink) else { return }
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                        
                    }
                }
                if let data = self.schedule {
                    let time_to_live = data["time_to_live"] as? String ?? ""
                    if compareLiveTime(time_to_live){
                        item.liveEnable()
                    }else{
                        item.liveDisable()
                    }
                }
            }
        } else {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "LogoGoldCell", for: indexPath) as? LogoGoldCell {
                cell = item
                
            }
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 3 {
            return CGSize(width: collectionView.frame.width, height: CGFloat(20))
        }
        return CGSize.zero
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 3 {
            return CGSize(width: collectionView.frame.width, height: CGFloat(20))
        }
        return CGSize.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if indexPath.section == 0 {
            let width = collectionView.frame.width
            let height = width/1799*720
            return CGSize(width: width, height: height)
        }else if indexPath.section == 1 {
            let width = collectionView.frame.width
            let height = CGFloat(100)
            return CGSize(width: width, height: height)
        }else if indexPath.section == 2 {
            let width = collectionView.frame.width
            let height = width/1126*611
            return CGSize(width: width, height: height)
        }else if indexPath.section == 3 {
            let width = collectionView.frame.width - 40
            let height = CGFloat(100)
            return CGSize(width: width, height: height)
        }else if indexPath.section == 4 {
            let width = collectionView.frame.width
            let height = CGFloat(600)
            return CGSize(width: width, height: height)
        } else{
            let width = collectionView.frame.width
            return CGSize(width: width, height: CGFloat(0))
        }
    }

}
