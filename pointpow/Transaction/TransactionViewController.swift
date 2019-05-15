//
//  TransactionViewController.swift
//  pointpow
//
//  Created by thanawat on 6/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class TransactionViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.title = NSLocalizedString("string-title-transection", comment: "")
        self.backgroundImage?.image = nil
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var id = "1"
        var image_url = ""
        var type = "transfer"
        var transfer_from = "KTC"
        var title = "โอนพ้อยมา Point Pow"
        var detail = ""
        var ref_id = "120101010"
        var amount = "3000"
        var date = "15-05-2562 11:22"
        
        var newNotiModel = NotificationStruct(id: id,
                                              image_url: image_url,
                                              title: title,
                                              detail: detail,
                                              type: type ,
                                              ref_id: ref_id,
                                              amount:amount,
                                              date:date,
                                              transfer_from:transfer_from)
        
        DataController.sharedInstance.saveNotifiacationArrayOfObjectData(newNoti: newNotiModel)
        
         id = "2"
         image_url = ""
         type = "adverties"
         transfer_from = ""
         title = "Point Pow ช่วยจ่ายเพิ่ม 70%"
         detail = "Point Pow ช่วยจ่ายเพิ่ม 70% Point Pow ช่วยจ่ายเพิ่ม 70%"
         ref_id = "2222233322"
         amount = ""
         date = "14-05-2562 14:22"
        
         newNotiModel = NotificationStruct(id: id,
                                              image_url: image_url,
                                              title: title,
                                              detail: detail,
                                              type: type ,
                                              ref_id: ref_id,
                                              amount:amount,
                                              date:date,
                                              transfer_from:transfer_from)
        
        DataController.sharedInstance.saveNotifiacationArrayOfObjectData(newNoti: newNotiModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
