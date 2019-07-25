//
//  ShoppingHistory.swift
//  pointpow
//
//  Created by thanawat on 25/7/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import Foundation


class ShoppingHistory {
    var month:String = ""
    var items:[[String:AnyObject]]?
    
    init(month:String , items: [[String:AnyObject]]) {
        self.month = month
        self.items = items
    }
}
