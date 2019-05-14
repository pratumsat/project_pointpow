//
//  NotificationStructHolder.swift
//  pointpow
//
//  Created by thanawat on 14/5/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import Foundation

import Foundation

class NotificationStructHolder:NSObject , NSCoding {
    
    var arrayNotification:[NotificationStruct]?
    
    override init() {
        self.arrayNotification = []
    }
    
    required init(coder aDecoder: NSCoder) {
        if let array = aDecoder.decodeObject(forKey: Constant.CacheNotification.NAME_CACHE_OBJECT) as? [NotificationStruct] {
            self.arrayNotification = array
        }
    }
    
    func encode(with aCoder: NSCoder) {
        if let array = self.arrayNotification {
            aCoder.encode(array, forKey: Constant.CacheNotification.NAME_CACHE_OBJECT)
            
            
        }
    }
    
    
    func setArray(array:[NotificationStruct])  {
        self.arrayNotification = array
    }
    func addToArray(item:NotificationStruct)  {
        if self.arrayNotification != nil{
            self.arrayNotification!.append(item)
        }
    }
}
