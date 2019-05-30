//
//  JSInterface.swift
//  JSInterface
//
//  Created by Kem on 9/12/15.
//  Copyright © 2015 Kem. All rights reserved.
//

import Foundation
import JavaScriptCore
import UIKit

@objc protocol MyExport : JSExport{
    func fail(_ transection: String)
    func success(_ transection: String)
    func cancel()
   
}


class JSInterface : NSObject, MyExport {
    
    
    func success(_ transection: String) {
        print("success /   transection_ref: \(transection)")
        
        let userInfo:[String:AnyObject] =  ["status": "success" as AnyObject,
                                            "transection_ref_id": transection as AnyObject]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.DefaultConstansts.TRANSECTION_SUCCESS), object: nil, userInfo: userInfo)
        
    }
    
    
    func fail(_ transection: String) {
        print("fail /    transection_ref: \(transection)")
        
        let userInfo:[String:AnyObject] =  ["status": "fail" as AnyObject,
                                            "transection_ref_id": transection as AnyObject]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.DefaultConstansts.TRANSECTION_FAIL), object: nil, userInfo: userInfo)
    }

    func cancel() {
        print("cencel")
        
        let userInfo:[String:AnyObject] =  ["status": "cancel" as AnyObject]
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.DefaultConstansts.TRANSECTION_CANCEL), object: nil, userInfo: userInfo)
    }
    
    
}
