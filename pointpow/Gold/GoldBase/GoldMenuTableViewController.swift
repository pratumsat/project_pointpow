//
//  GoldMenuTableViewController.swift
//  pointpow
//
//  Created by thanawat on 5/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class GoldMenuTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource  {

    var userData:AnyObject?
    @IBOutlet weak var menuTableView: UITableView!
    var memberGoldData:AnyObject?
    
    var isTapped = false
    var timer:Timer?
    
    var statusMemberGold = ""
    var inprogress_withdraw:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isTapped = false
        
        self.getUserInfo() {
            self.menuTableView.reloadData()
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
            
            if let data  = self.userData as? [String:AnyObject] {
                let _ = data["gold_saving_acc"] as? NSNumber ?? 0
                let status = data["goldsaving_member"]?["status"] as? String ?? ""
                let inprogress_withdraw = data["goldsaving_member"]?["inprogress_withdraw"] as? String ?? ""
                
                self.inprogress_withdraw = inprogress_withdraw
                self.statusMemberGold = status
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
   
    func setUp(){
        
        self.backgroundImage?.image = nil
        
        self.menuTableView.dataSource = self
        self.menuTableView.delegate = self
        
       
        self.menuTableView.separatorInset = .zero
        self.menuTableView.tableFooterView = UIView()
        self.registerTableViewNib(self.menuTableView, "NameTableViewCell")
        self.registerTableViewNib(self.menuTableView, "ProfileTableViewCell")
    }
   
   
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CGFloat(200)
        }
        return CGFloat(50)
        
    }
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        if indexPath.section == 0 {
            if let head = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell {
                cell = head
               
                if let data  = self.userData as? [String:AnyObject] {
                    let first_name = data["first_name"] as? String ?? ""
                    let last_name = data["last_name"] as? String ?? ""
                    let account_id = data["goldsaving_member"]?["account_id"] as? String ?? ""
                    let status = data["goldsaving_member"]?["status"] as? String ?? ""
                    let picture_data = data["picture_data"] as? String ?? ""
                    
                    if let url = URL(string: picture_data) {
                        head.profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                    }else{
                        head.profileImageView.image = UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER)
                    }
                    
                    head.nameLabel.text = "\(first_name) \(last_name)"
                    head.goldIdLabel.text = "\(account_id)"

                    switch status {
                    case "waiting", "edit":
                        head.statusLabel.text = NSLocalizedString("string-dailog-gold-profile-status-waitting", comment: "")
                        
                        break
                    case "approve" :
                        head.statusLabel.text = NSLocalizedString("string-dailog-gold-profile-status-approve", comment: "")
                        
                        break
                    case "fail" :
                        head.statusLabel.text = NSLocalizedString("string-dailog-gold-profile-status-fail", comment: "")
                       
                        break
                    default:
                        head.statusLabel.text = ""
                        break
                    }
                }
            }
        }else{
            if let item = tableView.dequeueReusableCell(withIdentifier: "NameTableViewCell", for: indexPath) as? NameTableViewCell{
                cell = item
                
             
                if indexPath.row == 0 {
                    item.nameLabel.text = NSLocalizedString("string-dailog-gold-profile-saving", comment: "")
                }
                if indexPath.row == 1 {
                    item.nameLabel.text = NSLocalizedString("string-dailog-gold-profile-withdraw", comment: "")
                }
                if indexPath.row == 2 {
                    item.nameLabel.text = NSLocalizedString("string-dailog-gold-profile-lucky-draw", comment: "")
                }
                if indexPath.row == 3 {
                    item.nameLabel.text = NSLocalizedString("string-dailog-gold-profile-history", comment: "")
                }
            }
        }
        
        
        if cell == nil {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
        return cell!
    }
    
    @objc func disableCountDown(){
        isTapped = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if isTapped {
            
            return
        }else{
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(disableCountDown), userInfo: nil, repeats: false)
            
            isTapped = true
        }
       
       
        if indexPath.section == 0 {
            // "Profile"
            let userInfo = ["profile":"showEnterPassCode"]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageAlert"), object: nil, userInfo: userInfo as [String:AnyObject])
            return
        }
        
        if self.statusMemberGold == "waiting"{
            if let saving = self.storyboard?.instantiateViewController(withIdentifier: "NavGoldPage") as? NavGoldPage {
                
                let userInfo = ["message":NSLocalizedString("string-dailog-gold-profile-status-waitting", comment: "")]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageAlert"), object: nil, userInfo: userInfo as [String:AnyObject])

                self.revealViewController()?.pushFrontViewController(saving, animated: true)
                
                
            }
            return
            
        }
        
        if self.statusMemberGold == "fail"{
            if let saving = self.storyboard?.instantiateViewController(withIdentifier: "NavGoldPage") as? NavGoldPage {
                
                
                let userInfo = ["message":NSLocalizedString("string-dailog-gold-profile-status-fail", comment: "")]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageAlert"), object: nil, userInfo: userInfo as [String:AnyObject])
                
                self.revealViewController()?.pushFrontViewController(saving, animated: true)
                
            }
            return
            
        }
        
        if self.statusMemberGold == "edit"{
            if let saving = self.storyboard?.instantiateViewController(withIdentifier: "NavGoldPage") as? NavGoldPage {
                
                
                let userInfo = ["message":NSLocalizedString("string-dailog-gold-profile-status-waitting", comment: "")]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageAlert"), object: nil, userInfo: userInfo as [String:AnyObject])
                
                
                self.revealViewController()?.pushFrontViewController(saving, animated: true)
                
            }
            return
            
        }
        
        
      
        
       
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                // "Saving"
                if let saving = self.storyboard?.instantiateViewController(withIdentifier: "NavGoldPage") as? NavGoldPage {
                    
                    self.revealViewController()?.pushFrontViewController(saving, animated: true)
                    
                }
            }
            if indexPath.row == 1 {
                // "Withdraw"
                //if self.inprogress_withdraw != nil  && !(self.inprogress_withdraw!.isEmpty) {
                //
                //    let userInfo = ["showTransaction": inprogress_withdraw]
                //    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageAlert"), object: nil, userInfo: userInfo as [String:AnyObject])
                //    return
                //}
                if let withdraw = self.storyboard?.instantiateViewController(withIdentifier: "NavWithdraw") as? NavWithdraw {
                    
                    self.revealViewController()?.pushFrontViewController(withdraw, animated: true)
                }
            }
            if indexPath.row == 2 {
                // "Lucky draw"
                if let withdraw = self.storyboard?.instantiateViewController(withIdentifier: "NavLuckyDraw") as? NavLuckyDraw {
                    
                    self.revealViewController()?.pushFrontViewController(withdraw, animated: true)
                }
            }
            if indexPath.row == 3 {
                // "History"
                if let history = self.storyboard?.instantiateViewController(withIdentifier: "NavHistory") as? NavHistory {
                    self.revealViewController()?.pushFrontViewController(history, animated: true)
                }
             
            }
        }
        
    }

    
    


}
