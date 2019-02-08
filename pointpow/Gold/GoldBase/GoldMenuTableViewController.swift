//
//  GoldMenuTableViewController.swift
//  pointpow
//
//  Created by thanawat on 5/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class GoldMenuTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var menuTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

     
        self.setUp()
    }

    func setUp(){
        
        self.backgroundImage?.image = nil
        
        self.menuTableView.dataSource = self
        self.menuTableView.delegate = self
        
    
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
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        if indexPath.section == 0 {
            if let head = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell {
                cell = head
               
        
            }
        }else{
            if let item = tableView.dequeueReusableCell(withIdentifier: "NameTableViewCell", for: indexPath) as? NameTableViewCell{
                cell = item
                
                if indexPath.row == 0 {
                    item.nameLabel.text = "ออมทอง"
                }
                if indexPath.row == 1 {
                    item.nameLabel.text = "ถอนทอง"
                }
                if indexPath.row == 2 {
                    item.nameLabel.text = "ประวัติการทำรายการ"
                }
            }
        }
        
        
        if cell == nil {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // "Profile"
            if let profile = self.storyboard?.instantiateViewController(withIdentifier: "GoldAccount") as? UINavigationController {
                self.revealViewController()?.pushFrontViewController(profile, animated: true)
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
