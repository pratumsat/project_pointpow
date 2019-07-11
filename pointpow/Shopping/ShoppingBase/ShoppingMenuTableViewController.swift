//
//  ShoppingMenuTableViewController.swift
//  pointpow
//
//  Created by thanawat on 25/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ShoppingMenuTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource  {
    
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
        
      
    }
    
    func setUp(){
        
        self.backgroundImage?.image = nil
        
        self.menuTableView.dataSource = self
        self.menuTableView.delegate = self
        
        
        self.menuTableView.separatorInset = .zero
        self.menuTableView.tableFooterView = UIView()
        self.registerTableViewNib(self.menuTableView, "NameTableViewCell")
        //self.registerTableViewNib(self.menuTableView, "ProfileTableViewCell")
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return CGFloat(200)
//        }
        return CGFloat(50)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
       
        if let item = tableView.dequeueReusableCell(withIdentifier: "NameTableViewCell", for: indexPath) as? NameTableViewCell{
            cell = item
            
            
            if indexPath.row == 0 {
                item.nameLabel.text = "home"
                 item.menuImageView.image = UIImage(named: "ic-gold-menu-saving")
            }
            if indexPath.row == 1 {
                item.nameLabel.text = "product"
                 item.menuImageView.image = UIImage(named: "ic-gold-menu-saving")
            }
            if indexPath.row == 2 {
                item.nameLabel.text = "How to"
                 item.menuImageView.image = UIImage(named: "ic-gold-menu-saving")
            }
            if indexPath.row == 3 {
                item.nameLabel.text = "Q/A"
                 item.menuImageView.image = UIImage(named: "ic-gold-menu-saving")
            }
            if indexPath.row == 4 {
                item.nameLabel.text = "term and condition"
                 item.menuImageView.image = UIImage(named: "ic-gold-menu-saving")
            }
            
            if indexPath.row == 5 {
                item.nameLabel.text = "privacy"
                 item.menuImageView.image = UIImage(named: "ic-gold-menu-saving")
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
       
    }
    

}
