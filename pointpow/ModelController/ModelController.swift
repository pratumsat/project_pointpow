//
//  ModelController.swift
//  ABCAssetAgent
//
//  Created by thanawat pratumsat on 3/26/2561 BE.
//  Copyright © 2561 thanawat pratumsat. All rights reserved.
//
import Alamofire
import Foundation
import FirebaseMessaging

/*
 
 let urlStr: String = "maps://"
 let url = URL(string: urlStr)
 if UIApplication.shared.canOpenURL(url!) {
 print("can open")
 if #available(iOS 10.0, *) {
 UIApplication.shared.open(url!, options: [:], completionHandler: nil)
 } else {
 UIApplication.shared.openURL(url!)
 }
 }else{
 print("no app")
 }
 
 */
class ModelController {
    
    var loadingStart:(()->Void)?
    var loadingFinish:(()->Void)?

    func loginWithEmailORMobile(params:Parameters ,
                        succeeded:( (_ result:AnyObject) ->Void)? = nil,
                        error:((_ errorObject:AnyObject)->Void)?,
                        failure:( (_ statusCode:String) ->Void)? = nil ){
        
        self.loadingStart?()
        
        Alamofire.request(Constant.PointPowAPI.loginWithEmailORMobile , method: .post , parameters : params).validate().responseJSON { response in
            
            self.loadingFinish?()
            
            switch response.result {
            case .success(let json):
                print(json)
                
                if let data = json as? [String:AnyObject] {
                    
                    let success = data["success"] as? NSNumber  ??  0
                  
                    if success.intValue == 1 {
                        if let result = data["result"] as? [String:AnyObject] {
                            let access_token  = result["access_token"] as? String ?? ""
                            DataController.sharedInstance.setToken(access_token)
                            succeeded?(result as AnyObject)
                        }
                    }
                }
                break
                
            case .failure(let mError):
               let code = (mError as NSError).code
                if code == -1009 || code == -1001 || code == -1004 || code == -1005 {
                    failure?("-1009")
                    return
                }
                
                if  response.response?.statusCode == 401 {
                    //failure?("401")
                    //return
                    
                }
                if  response.response?.statusCode == 500 {
                    failure?("500")
                    return
                    
                }
                if let data = response.data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        
                        if let data = json as? [String:AnyObject] {
                            
                            let success = data["success"] as? NSNumber  ??  0
                            
                            if success.intValue == 0 {
                                let messageError = data["message"] as? String  ??  ""
                                let field = data["field"] as? String  ??  ""
                                var errorObject:[String:AnyObject] = [:]
                                errorObject["message"] = messageError as AnyObject
                                errorObject["field"] = field as AnyObject
                                error?(errorObject as AnyObject)
                            }
                        }
                    }
                }
                
                break
                
            }
        }
    }
    
    
    func registerWithEmail(params:Parameters ,
                                succeeded:( (_ result:AnyObject) ->Void)? = nil,
                                error:((_ errorObject:AnyObject)->Void)?,
                                failure:( (_ statusCode:String) ->Void)? = nil ){
        
        self.loadingStart?()
        
        Alamofire.request(Constant.PointPowAPI.registerWithEmail , method: .post , parameters : params).validate().responseJSON { response in
            
            self.loadingFinish?()
            
            switch response.result {
            case .success(let json):
                print(json)
                
                if let data = json as? [String:AnyObject] {
                    
                    let success = data["success"] as? NSNumber  ??  0
                    
                    if success.intValue == 1 {
                        if let result = data["result"] as? [String:AnyObject] {
                            let activate_token = result["activate_token"] as? String ?? ""
                            DataController.sharedInstance.setActivateToken(activate_token)
                            succeeded?(result as AnyObject)
                        }
                    }
                }
                break
                
            case .failure(let mError):
                let code = (mError as NSError).code
                if code == -1009 || code == -1001 || code == -1004 || code == -1005 {
                    failure?("-1009")
                    return
                }
                
                if  response.response?.statusCode == 401 {
                    failure?("401")
                    return
                    
                }
                if  response.response?.statusCode == 500 {
                    failure?("500")
                    return
                    
                }
                if let data = response.data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        if let data = json as? [String:AnyObject] {
                            
                            let success = data["success"] as? NSNumber  ??  0
                            
                            if success.intValue == 0 {
                                let messageError = data["message"] as? String  ??  ""
                                let field = data["field"] as? String  ??  ""
                                var errorObject:[String:AnyObject] = [:]
                                errorObject["message"] = messageError as AnyObject
                                errorObject["field"] = field as AnyObject
                                error?(errorObject as AnyObject)
                            }
                        }
                    }
                }
                
                break
                
            }
        }
    }
    
    func registerWithMobile(params:Parameters ,
                           succeeded:( (_ result:AnyObject) ->Void)? = nil,
                           error:((_ errorObject:AnyObject)->Void)?,
                           failure:( (_ statusCode:String) ->Void)? = nil ){
        
        self.loadingStart?()
        
        Alamofire.request(Constant.PointPowAPI.registerWithMobile , method: .post , parameters : params).validate().responseJSON { response in
            
            self.loadingFinish?()
            
            switch response.result {
            case .success(let json):
                print(json)
                
                if let data = json as? [String:AnyObject] {
                    
                    let success = data["success"] as? NSNumber  ??  0
                    
                    if success.intValue == 1 {
                        
                        if let result = data["result"] as? [String:AnyObject] {
                            succeeded?(result as AnyObject)
                        }
                    }
                }
                break
                
            case .failure(let mError):
                let code = (mError as NSError).code
                if code == -1009 || code == -1001 || code == -1004 || code == -1005 {
                    failure?("-1009")
                    return
                }
                
                if  response.response?.statusCode == 401 {
                    failure?("401")
                    return
                    
                }
                if  response.response?.statusCode == 500 {
                    failure?("500")
                    return
                    
                }
                if let data = response.data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        if let data = json as? [String:AnyObject] {
                            
                            let success = data["success"] as? NSNumber  ??  0
                            
                            if success.intValue == 0 {
                                let messageError = data["message"] as? String  ??  ""
                                let field = data["field"] as? String  ??  ""
                                var errorObject:[String:AnyObject] = [:]
                                errorObject["message"] = messageError as AnyObject
                                errorObject["field"] = field as AnyObject
                                error?(errorObject as AnyObject)
                            }
                        }

                    }
                }
                
                break
                
            }
        }
    }
    
    func verifyOTP(params:Parameters ,
                            succeeded:( (_ result:AnyObject) ->Void)? = nil,
                            error:((_ errorObject:AnyObject)->Void)?,
                            failure:( (_ statusCode:String) ->Void)? = nil ){
        
        self.loadingStart?()
        
        Alamofire.request(Constant.PointPowAPI.verifyOTP , method: .post , parameters : params).validate().responseJSON { response in
            
            self.loadingFinish?()
            
            switch response.result {
            case .success(let json):
                print(json)
                
                if let data = json as? [String:AnyObject] {
                    
                    let success = data["success"] as? NSNumber  ??  0
                    
                    if success.intValue == 1 {
                        
                        succeeded?([:] as AnyObject)
                    }
                }
                break
                
            case .failure(let mError):
                print(response.response?.statusCode)
                let code = (mError as NSError).code
                if code == -1009 || code == -1001 || code == -1004 || code == -1005 {
                    failure?("-1009")
                    return
                }
                
                if  response.response?.statusCode == 401 {
                    failure?("401")
                    return
                    
                }
                if  response.response?.statusCode == 500 {
                    failure?("500")
                    return
                    
                }
                if let data = response.data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        if let data = json as? [String:AnyObject] {
                            
                            let success = data["success"] as? NSNumber  ??  0
                            
                            if success.intValue == 0 {
                                let messageError = data["message"] as? String  ??  ""
                                let field = data["field"] as? String  ??  ""
                                var errorObject:[String:AnyObject] = [:]
                                errorObject["message"] = messageError as AnyObject
                                errorObject["field"] = field as AnyObject
                                error?(errorObject as AnyObject)
                            }
                        }
                    }
                }
                
                break
                
            }
        }
    }
    
    
    
}
