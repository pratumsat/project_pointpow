//
//  NotificationStruct.swift
//  pointpow
//
//  Created by thanawat on 14/5/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import Foundation

import Foundation

class NotificationStruct:NSObject, NSCoding {
    var id = "0"
    var image_url = ""
    var title = ""
    var detail = ""
    var type = ""
    var ref_id = ""
    var amount = ""
    var date = ""
    var transfer_from = ""
    
    init(id:String, image_url:String , title:String, detail:String, type:String , ref_id:String, amount:String, date:String, transfer_from:String) {
        self.id = id
        self.image_url = image_url
        self.title = title
        self.detail = detail
        self.type = type
        self.ref_id = ref_id
        self.amount = amount
        self.date = date
        self.transfer_from = transfer_from
        
    }
    
    
    required init(coder decoder: NSCoder) {
        self.id = decoder.decodeObject(forKey: "id") as? String ?? "0"
        self.image_url = decoder.decodeObject(forKey: "image_url") as? String ?? ""
        self.title = decoder.decodeObject(forKey: "title") as? String ?? ""
        self.detail = decoder.decodeObject(forKey: "detail") as? String ?? ""
        self.type = decoder.decodeObject(forKey: "type") as? String ?? ""
        self.ref_id = decoder.decodeObject(forKey: "ref_id") as? String ?? ""
        self.amount = decoder.decodeObject(forKey: "amount") as? String ?? ""
        self.date = decoder.decodeObject(forKey: "date") as? String ?? ""
        self.transfer_from = decoder.decodeObject(forKey: "transfer_from") as? String ?? ""
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: "id")
        coder.encode(self.image_url, forKey: "image_url")
        coder.encode(self.title, forKey: "title")
        coder.encode(self.detail, forKey: "detail")
        coder.encode(self.type, forKey: "type")
        coder.encode(self.ref_id, forKey: "ref_id")
        coder.encode(self.amount, forKey: "amount")
        coder.encode(self.date, forKey: "date")
        coder.encode(self.transfer_from, forKey: "transfer_from")
        
        
    }
    
}
