//
//  ShoppingMenuTableViewController.swift
//  pointpow
//
//  Created by thanawat on 25/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ShoppingMenuTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var bgProfileImageView: UIImageView!
    
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
        self.bgProfileImageView.blurImage()
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
                
                let picture_background = data["picture_background"] as? String ?? ""
                
                
                if DataController.sharedInstance.getBgProfilPath().isEmpty {
                    if let url = URL(string: picture_background) {
                        self.bgProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                    }else{
                        self.bgProfileImageView.image = UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER)
                    }
                    
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
    
    func setUp(){
        self.bgProfileImageView.contentMode = .scaleAspectFill
        
        
        self.menuTableView.contentInset = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0);
        if let url = URL(string: DataController.sharedInstance.getBgProfilPath()) {
            self.bgProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
            
        }else{
            self.bgProfileImageView.image = UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER)
        }
        
        self.backgroundImage?.image = nil
        
        self.menuTableView.dataSource = self
        self.menuTableView.delegate = self
        
        self.menuTableView.separatorStyle = .none
        self.menuTableView.separatorInset = .zero
        self.menuTableView.tableFooterView = UIView()
        self.registerTableViewNib(self.menuTableView, "NameTableViewCell")
        self.registerTableViewNib(self.menuTableView, "ProfileShoppingTableViewCell")
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CGFloat(210)
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
        return 6
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        if indexPath.section == 0 {
            if let head = tableView.dequeueReusableCell(withIdentifier: "ProfileShoppingTableViewCell", for: indexPath) as? ProfileShoppingTableViewCell {
                cell = head
                
                if !DataController.sharedInstance.getProfilPath().isEmpty {
                    if let url = URL(string: DataController.sharedInstance.getProfilPath()) {
                        head.profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                        
                    }else{
                        head.profileImageView.image = UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER)
                    }
                }
                
                if let data  = self.userData as? [String:AnyObject] {
                    let first_name = data["first_name"] as? String ?? ""
                    let last_name = data["last_name"] as? String ?? ""
                    let picture_data = data["picture_data"] as? String ?? ""
                    let pointBalance = data["member_point"]?["total"] as? NSNumber ?? 0
                    let pointpowId = data["pointpow_id"] as? String ?? "-"
                    
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    numberFormatter.minimumFractionDigits = 2

                    if DataController.sharedInstance.getProfilPath().isEmpty {
                        if let url = URL(string: picture_data) {
                            head.profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                            
                        }else{
                            head.profileImageView.image = UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER)
                        }
                    }
                    
                    
                    head.nameLabel.text = "\(first_name) \(last_name)"
                    head.pointbalanceLabel.text = numberFormatter.string(from: pointBalance )
                    head.idLabel.text = pointpowId
                }
            }
        }else{
            if let item = tableView.dequeueReusableCell(withIdentifier: "NameTableViewCell", for: indexPath) as? NameTableViewCell{
                cell = item
                
                
                if indexPath.row == 0 {
                    item.nameLabel.text = NSLocalizedString("string-item-shopping-menu-1", comment: "")
                    item.menuImageView.image = UIImage(named: "ic-shopping-menu-1")
                }
                if indexPath.row == 1 {
                    item.nameLabel.text = NSLocalizedString("string-item-shopping-menu-2", comment: "")
                    item.menuImageView.image = UIImage(named: "ic-shopping-menu-2")
                }
                if indexPath.row == 2 {
                    item.nameLabel.text = NSLocalizedString("string-item-shopping-menu-3", comment: "")
                    item.menuImageView.image = UIImage(named: "ic-shopping-menu-3")
                }
                if indexPath.row == 3 {
                    item.nameLabel.text = NSLocalizedString("string-item-shopping-menu-4", comment: "")
                    item.menuImageView.image = UIImage(named: "ic-shopping-menu-4")
                }
                if indexPath.row == 4 {
                    item.nameLabel.text = NSLocalizedString("string-item-shopping-menu-5", comment: "")
                    item.menuImageView.image = UIImage(named: "ic-shopping-menu-5")
                }
                if indexPath.row == 5 {
                    item.nameLabel.text = NSLocalizedString("string-item-shopping-menu-6", comment: "")
                    item.menuImageView.image = UIImage(named: "ic-shopping-menu-6")
                }
                
                switch indexPath.row {
                case 0,1,2,3,4:
                    let lineBottom = UIView(frame: CGRect(x: 20, y: item.frame.height - 1 ,
                                                          width: tableView.frame.width - 80, height: 1 ))
                    lineBottom.backgroundColor = UIColor.lightGray
                    item.addSubview(lineBottom)
                    break
                case 5:
                    let lineBottom = UIView(frame: CGRect(x: 0, y: item.frame.height - 1 ,
                                                          width: tableView.frame.width, height: 1 ))
                    lineBottom.backgroundColor = UIColor.lightGray
                    item.addSubview(lineBottom)
                    break
                default:break
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
        
        
        //pass
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0 :
//                if let withdraw = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingNavViewController") as? ShoppingNavViewController {
//                    self.revealViewController()?.pushFrontViewController(withdraw, animated: true)
//                }
                
                self.revealViewController()?.revealToggle(self)
                let userInfo = ["action" : "home"]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "shopping-action-menu"), object: nil, userInfo: userInfo as [String:AnyObject])

                
                break
            case 1 :
                
                self.revealViewController()?.revealToggle(self)
                let userInfo = ["action" : "product"]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "shopping-action-menu"), object: nil, userInfo: userInfo as [String:AnyObject])
                break
            case 2 :
                self.revealViewController()?.revealToggle(self)
                let userInfo = ["action" : "howto"]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "shopping-action-menu"), object: nil, userInfo: userInfo as [String:AnyObject])
                break
            case 3 :
                self.revealViewController()?.revealToggle(self)
                let userInfo = ["action" : "question"]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "shopping-action-menu"), object: nil, userInfo: userInfo as [String:AnyObject])
                break
            case 4 :
                self.revealViewController()?.revealToggle(self)
                let userInfo = ["action" : "term"]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "shopping-action-menu"), object: nil, userInfo: userInfo as [String:AnyObject])
                break
            case 5 :
                self.revealViewController()?.revealToggle(self)
                let userInfo = ["action" : "privacy"]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "shopping-action-menu"), object: nil, userInfo: userInfo as [String:AnyObject])
                break
            default:break
            }
          
        }
        
    }
    

}
