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


class JSInterface : NSObject, MyExport
{
    func fail(_ transection: String) {
        print("fail /    transection_ref: \(transection)")
    }
    
    func success(_ transection: String) {
           print("success /   transection_ref: \(transection)")
    }
    
    func cancel() {
           print("cencel")
    }
    
    
}
