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
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        if let item = tableView.dequeueReusableCell(withIdentifier: "NameTableViewCell", for: indexPath) as? NameTableViewCell{
            cell = item
            
            if indexPath.row == 0 {
                item.nameLabel.text = "Saving"
            }
            if indexPath.row == 1 {
                item.nameLabel.text = "Withdraw"
            }
            if indexPath.row == 2 {
                item.nameLabel.text = "History"
            }
            if indexPath.row == 3 {
                item.nameLabel.text = "Profile"
            }
        }
        
        if cell == nil {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // "Saving"
            if let saving = self.storyboard?.instantiateViewController(withIdentifier: "GoldPageNav") as? UINavigationController {
                
                self.revealViewController()?.pushFrontViewController(saving, animated: true)
                
            }
        }
        if indexPath.row == 1 {
            // "Withdraw"
        }
        if indexPath.row == 2 {
            // "History"
        }
        if indexPath.row == 3 {
            // "Profile"
            
        }
    }

    
    


}
