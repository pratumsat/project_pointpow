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

    func loginWithEmail(params:Parameters ,
                        succeeded:( (_ result:AnyObject) ->Void)? = nil,
                        error:((_ errorObject:AnyObject)->Void)?,
                        failure:( (_ statusCode:String) ->Void)? = nil ){
        
        self.loadingStart?()
        
        Alamofire.request(Constant.PointPowAPI.loginWithEmail , method: .post , parameters : params).validate().responseJSON { response in
            
            self.loadingFinish?()
            
            switch response.result {
            case .success(let json):
                print(json)
                
                if let data = json as? [String:AnyObject] {
                    
                    let success = data["success"] as? NSNumber  ??  0
                  
                    if success.intValue == 0 {
                        let messageError = data["message"] as? String  ??  ""
                        let field = data["field"] as? String  ??  ""
                        var errorObject:[String:AnyObject] = [:]
                        errorObject["message"] = messageError as AnyObject
                        errorObject["field"] = field as AnyObject
                        error?(errorObject as AnyObject)
                    }else{
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
                if code == -1009 || code == -1001 || code == -1004 {
                    failure?("-1009")
                    return
                }
                
                if  response.response?.statusCode == 401 {
                    //failure?("401")
                    do {
                        let jsonResponse =  try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments )
                        
                        print(jsonResponse)
                        
                        if let data = jsonResponse as? [String:AnyObject] {
                            
                            let success = data["success"] as? NSNumber  ??  0
                            
                            if success.intValue == 0 {
                                let messageError = data["message"] as? String  ??  ""
                                let field = data["field"] as? String  ??  ""
                                var errorObject:[String:AnyObject] = [:]
                                errorObject["message"] = messageError as AnyObject
                                errorObject["field"] = field as AnyObject
                                error?(errorObject as AnyObject)
                            }else{
                                if let result = data["result"] as? [String:AnyObject] {
                                    succeeded?(result as AnyObject)
                                }
                            }
                        }
                    }catch {
                        print("\(error)")
                    }
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
                            let message = data["message"] as? String  ??  ""
                            let message_en = data["message_en"] as? String  ??  ""
                            let message_th = data["message_th"] as? String  ??  ""
                            
                            var messageError = ""
                            if DataController.sharedInstance.getLanguage() == "en" {
                                messageError = message_en
                            }else{
                                messageError = message_th
                            }
                            
                            if messageError == "" {
                                messageError = message
                            }
                            
                            if success.intValue == 0 {
                                failure?(messageError)
                            }
                        }
                    }
                }
                
                break
                
            }
        }
    }
}
