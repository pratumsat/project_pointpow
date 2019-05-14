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
        
        let editButton = UIBarButtonItem(image: UIImage(named: "ic_trash"), style: .plain, target: self, action: #selector(editCell))
        
        navigationItem.rightBarButtonItem = editButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupView()
    }
    
    func setupView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
        self.registerTableViewNib(self.tableView, "HeaderViewDateTableViewCell")
        //self.registerTableViewNib(self.tableView, "NotificationTableViewCell")
        
        
        
        if let notiStructHolder = DataController.sharedInstance.getNotificationArrayOfObjectData(){
            self.arrayOfObjectData = notiStructHolder.arrayNotification?.reversed()
            
            let count = notiStructHolder.arrayNotification?.count ?? 0
            if count <= 0 {
                print("not found notification data")
                
            }
        }else{
            print("not found notification data")
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let objects = self.arrayOfObjectData else { return 0 }
        
        if objects[indexPath.section].type.lowercased()  == "transfer"  {
            return 200
        }else if objects[indexPath.section].type.lowercased()  == "news" {
            return 400
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayOfObjectData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.arrayOfObjectData?.count , count > 0 else{ return 0 }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
//        if let objects = self.arrayOfObjectData  {
//            if objects[indexPath.section].type.lowercased()  == "transfer"  {
//
//            }
//
//        }
        if cell == nil {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell:HeaderViewDateTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HeaderViewDateTableViewCell") as! HeaderViewDateTableViewCell

//        if let objects = self.arrayOfObjectData  {
//            headerCell.headerLabel.text = "\(convertDateOfDay(objects[section].date))"
//        }
    
        return headerCell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.arrayOfObjectData?.remove(at: indexPath.section)
            DataController.sharedInstance.saveNewArraysStructHolder(arrayOfObjectData: arrayOfObjectData)
            
            tableView.reloadData()
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
