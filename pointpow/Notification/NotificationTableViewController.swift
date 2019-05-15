//
//  NotificationTableViewController.swift
//  pointpow
//
//  Created by thanawat on 14/5/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class NotificationTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var arrayOfObjectData:[NotificationStruct]?
    var isedit: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("nav-notification-title", comment: "")
        
        let editButton = UIBarButtonItem(image: UIImage(named: "ic_trash"), style: .plain, target: self, action: #selector(editCell))
        
        navigationItem.rightBarButtonItem = editButton
        
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupView()
    }
    
    func addViewNotfoundData(){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        var centerpoint = view.center
        centerpoint.y -= self.view.frame.height*0.2
        
        let sorry = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        sorry.center = centerpoint
        sorry.textAlignment = .center
        sorry.font = UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.CONTENT )
        sorry.text = NSLocalizedString("string-not-found-item-transaction", comment: "")
        sorry.textColor = UIColor.lightGray
        view.addSubview(sorry)
        
        self.tableView.reloadData()
        self.tableView.backgroundView = view
    }
    func setupView(){
        self.tableView.contentInset = UIEdgeInsets(top: -16, left: 0, bottom: -16, right: 0);
        self.tableView.sectionHeaderHeight = 0;
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
        //self.registerTableViewNib(self.tableView, "HeaderViewDateTableViewCell")
        self.registerTableViewNib(self.tableView, "NotificationTableViewCell")
        self.registerTableViewNib(self.tableView, "NotificationAdvertiesCell")
        
        
        if let notiStructHolder = DataController.sharedInstance.getNotificationArrayOfObjectData(){
            self.arrayOfObjectData = notiStructHolder.arrayNotification?.reversed()
            
            let count = notiStructHolder.arrayNotification?.count ?? 0
            if count <= 0 {
                print("not found notification data")
                self.addViewNotfoundData()
            }else{
                self.tableView.reloadData()
            }
        }else{
            print("not found notification data")
            self.addViewNotfoundData()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let objects = self.arrayOfObjectData else { return 0 }
        
        if objects[indexPath.section].type.lowercased()  == "transfer"  {
            return 130
        }else if objects[indexPath.section].type.lowercased()  == "adverties" {
            let width = tableView.frame.width - 50
            let heightImage = (width)/950*300
            let height = heightImage + 140
            return height
            
        }else if objects[indexPath.section].type.lowercased()  == "gold" {
            return 150
        }else{
            return 0
        }
    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 0
//        }
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let headerCell:HeaderViewDateTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HeaderViewDateTableViewCell") as! HeaderViewDateTableViewCell
//
//
//        return headerCell
//
//    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayOfObjectData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.arrayOfObjectData?.count , count > 0 else{ return 0 }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        if let objects = self.arrayOfObjectData  {
            if objects[indexPath.section].type.lowercased()  == "transfer"  {
                if let itemCell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as? NotificationTableViewCell{
                    itemCell.selectionStyle = .none
                    itemCell.separatorInset = UIEdgeInsets.zero
                    
                    cell = itemCell
                }
                
            }else if objects[indexPath.section].type.lowercased()  == "adverties"  {
                if let itemCell = tableView.dequeueReusableCell(withIdentifier: "NotificationAdvertiesCell", for: indexPath) as? NotificationAdvertiesCell{
                    itemCell.selectionStyle = .none
                    itemCell.separatorInset = UIEdgeInsets.zero
                    
                    cell = itemCell
                }
                
            }else if objects[indexPath.section].type.lowercased()  == "gold"  {
                //if gold_unit.lowercased() == "salueng" {
                //    transCell.unitLabel.text = NSLocalizedString("unit-salueng", comment: "")
                //}else{
                //    transCell.unitLabel.text = NSLocalizedString("unit-baht", comment: "")
                //}
            }
            
        }
        
        
        if cell == nil {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.arrayOfObjectData?.remove(at: indexPath.section)
            DataController.sharedInstance.saveNewArraysStructHolder(arrayOfObjectData: arrayOfObjectData)
            

            let count = self.arrayOfObjectData?.count ?? 0
            if count <= 0 {
                print("not found notification data")
                self.addViewNotfoundData()
            }else{
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if let itemData = self.arrayOfObjectData?[indexPath.section] {
            //if itemData.type.lowercased()  == "transfer"  {
            //
            //}else{
            //
            //}
        //}
        print(indexPath.row)
    }
    
    @objc func editCell(){
        setEditing(isedit, animated: true)
        
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        guard let _ = DataController.sharedInstance.getNotificationArrayOfObjectData() else {
            return
        }
        
        self.tableView.setEditing(!editing, animated: true)
        self.isedit  = !editing
        
        
        if editing {
            let editButton = UIBarButtonItem(image: UIImage(named: "ic_trash"), style: .plain, target: self, action: #selector(editCell))
            navigationItem.rightBarButtonItem = editButton
            
        }else {
            let editButton = UIBarButtonItem(image: UIImage(named: "ic_open_trash"), style: .plain, target: self, action: #selector(editCell))
            navigationItem.rightBarButtonItem = editButton
            
        }
        
    }

}
