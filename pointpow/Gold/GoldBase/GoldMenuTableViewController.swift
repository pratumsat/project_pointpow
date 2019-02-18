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
   
    func setUp(){
        
        self.backgroundImage?.image = nil
        
        self.menuTableView.dataSource = self
        self.menuTableView.delegate = self
        
        self.addRefreshTableViewController(self.menuTableView)
        
        self.menuTableView.tableFooterView = UIView()
        self.registerTableViewNib(self.menuTableView, "NameTableViewCell")
        self.registerTableViewNib(self.menuTableView, "ProfileTableViewCell")
    }
    
    override func reloadData() {
        self.getUserInfo() {
            self.menuTableView.reloadData()
        }
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
        return 3
        
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
                    
                     let parthProfileImage = "\(Constant.PathImages.profile)"
                    
                    modelCtrl.loadImage(parthProfileImage , Constant.DefaultConstansts.DefaultImaege.PROFILE_PLACEHOLDER) { (image) in
                        
                        head.profileImageView.image = image
                    }
                    
                    head.nameLabel.text = "\(first_name) \(last_name)"
                    head.goldIdLabel.text = "\(account_id)"

                    
                    switch status {
                    case "waiting":
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
             timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(disableCountDown), userInfo: nil, repeats: false)
            
            return
        }
        isTapped = true
        
        if indexPath.section == 0 {
            // "Profile"
            if let data  = self.userData as? [String:AnyObject] {
                //let pointBalance = data["member_point"]?["total"] as? String ?? "0.00"
                //let profileImage = data["picture_data"] as? String ?? ""
                let registerGold = data["gold_saving_acc"] as? NSNumber ?? 0
                
                if registerGold.boolValue {
                    if let profile = self.storyboard?.instantiateViewController(withIdentifier: "GoldAccount") as? UINavigationController {
                        
                        self.revealViewController()?.pushFrontViewController(profile, animated: true)
                    }
                }else{
                    self.showMessagePrompt(NSLocalizedString("string-dailog-gold-profile-no-register", comment: ""))
                }
            
            }
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                // "Saving"
                if let saving = self.storyboard?.instantiateViewController(withIdentifier: "GoldPageNav") as? UINavigationController {
                    
                    self.revealViewController()?.pushFrontViewController(saving, animated: true)
                    
                }
            }
            if indexPath.row == 1 {
                // "Withdraw"
                if let withdraw = self.storyboard?.instantiateViewController(withIdentifier: "GoldWithdraw") as? UINavigationController {
                    
                    self.revealViewController()?.pushFrontViewController(withdraw, animated: true)
                }
            }
            if indexPath.row == 2 {
                // "History"
                
                if let history = self.storyboard?.instantiateViewController(withIdentifier: "GoldHistory") as? UINavigationController {
                    self.revealViewController()?.pushFrontViewController(history, animated: true)
                }
                
            }
        }
        
    }

    
    


}
