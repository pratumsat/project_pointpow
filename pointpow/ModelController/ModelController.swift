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
import FBSDKLoginKit
import GoogleSignIn
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
    private var _fbLoginManager: FBSDKLoginManager?
    var fbLoginManager: FBSDKLoginManager {
        get {
            if _fbLoginManager == nil {
                _fbLoginManager = FBSDKLoginManager()
            }
            return _fbLoginManager!
        }
    }
    
    var loadingStart:(()->Void)?
    var loadingFinish:(()->Void)?

    func loginWithEmailORMobile(params:Parameters? ,
                                _ isLoading:Bool = true,
                        succeeded:( (_ result:AnyObject) ->Void)? = nil,
                        error:((_ errorObject:AnyObject)->Void)?,
                        failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        Alamofire.request(Constant.PointPowAPI.loginWithEmailORMobile , method: .post , parameters : params).validate().responseJSON { response in
            
            if isLoading {
                self.loadingFinish?()
            }
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
                    }else{
                        let messageError = data["message"] as? String  ??  ""
                        let field = data["field"] as? String  ??  ""
                        var errorObject:[String:AnyObject] = [:]
                        errorObject["message"] = messageError as AnyObject
                        errorObject["field"] = field as AnyObject
                        error?(errorObject as AnyObject)
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
    
    
    func registerWithEmail(params:Parameters? ,
                           _ isLoading:Bool = true,
                                succeeded:( (_ result:AnyObject) ->Void)? = nil,
                                error:((_ errorObject:AnyObject)->Void)?,
                                failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        Alamofire.request(Constant.PointPowAPI.registerWithEmail , method: .post , parameters : params).validate().responseJSON { response in
            
            if isLoading {
                self.loadingFinish?()
            }
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
                    }else{
                        let messageError = data["message"] as? String  ??  ""
                        let field = data["field"] as? String  ??  ""
                        var errorObject:[String:AnyObject] = [:]
                        errorObject["message"] = messageError as AnyObject
                        errorObject["field"] = field as AnyObject
                        error?(errorObject as AnyObject)
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
    
    func registerWithMobile(params:Parameters? ,
                            _ isLoading:Bool = true,
                           succeeded:( (_ result:AnyObject) ->Void)? = nil,
                           error:((_ errorObject:AnyObject)->Void)?,
                           failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        Alamofire.request(Constant.PointPowAPI.registerWithMobile , method: .post , parameters : params).validate().responseJSON { response in
            
            if isLoading {
                self.loadingFinish?()
            }
            switch response.result {
            case .success(let json):
                print(json)
                
                if let data = json as? [String:AnyObject] {
                    
                    let success = data["success"] as? NSNumber  ??  0
                    
                    if success.intValue == 1 {
                        
                        if let result = data["result"] as? [String:AnyObject] {
                            succeeded?(result as AnyObject)
                        }
                    }else{
                        let messageError = data["message"] as? String  ??  ""
                        let field = data["field"] as? String  ??  ""
                        var errorObject:[String:AnyObject] = [:]
                        errorObject["message"] = messageError as AnyObject
                        errorObject["field"] = field as AnyObject
                        error?(errorObject as AnyObject)
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
    
    func loginWithSocial(params:Parameters? ,
                         _ isLoading:Bool = true,
                            succeeded:( (_ result:AnyObject) ->Void)? = nil,
                            error:((_ errorObject:AnyObject)->Void)?,
                            failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        Alamofire.request(Constant.PointPowAPI.loginWithSocial , method: .post , parameters : params).validate().responseJSON { response in
            
            if isLoading {
                self.loadingFinish?()
            }
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
                    }else{
                        let messageError = data["message"] as? String  ??  ""
                        let field = data["field"] as? String  ??  ""
                        var errorObject:[String:AnyObject] = [:]
                        errorObject["message"] = messageError as AnyObject
                        errorObject["field"] = field as AnyObject
                        error?(errorObject as AnyObject)
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
    
    func verifyOTP(params:Parameters? ,
                            _ isLoading:Bool = true,
                            succeeded:( (_ result:AnyObject) ->Void)? = nil,
                            error:((_ errorObject:AnyObject)->Void)?,
                            failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        Alamofire.request(Constant.PointPowAPI.verifyOTP , method: .post , parameters : params).validate().responseJSON { response in
            
            if isLoading {
                self.loadingFinish?()
            }
            switch response.result {
            case .success(let json):
                print(json)
                
                if let data = json as? [String:AnyObject] {
                    
                    let success = data["success"] as? NSNumber  ??  0
                    
                    if success.intValue == 1 {
                        
                        succeeded?([:] as AnyObject)
                    
                    }else{
                        let messageError = data["message"] as? String  ??  ""
                        let field = data["field"] as? String  ??  ""
                        var errorObject:[String:AnyObject] = [:]
                        errorObject["message"] = messageError as AnyObject
                        errorObject["field"] = field as AnyObject
                        error?(errorObject as AnyObject)
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
    
    func resendOTP(params:Parameters? ,
                   _ isLoading:Bool = true,
                   succeeded:( (_ result:AnyObject) ->Void)? = nil,
                   error:((_ errorObject:AnyObject)->Void)?,
                   failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        Alamofire.request(Constant.PointPowAPI.resendOTP , method: .post , parameters : params).validate().responseJSON { response in
            
            if isLoading {
                self.loadingFinish?()
            }
            switch response.result {
            case .success(let json):
                print(json)
                
                if let data = json as? [String:AnyObject] {
                    
                    let success = data["success"] as? NSNumber  ??  0
                    
                    if success.intValue == 1 {
                        
                        if let result = data["result"] as? [String:AnyObject] {
                            succeeded?(result as AnyObject)
                        }
                    }else{
                        let messageError = data["message"] as? String  ??  ""
                        let field = data["field"] as? String  ??  ""
                        var errorObject:[String:AnyObject] = [:]
                        errorObject["message"] = messageError as AnyObject
                        errorObject["field"] = field as AnyObject
                        error?(errorObject as AnyObject)
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
    
    
    func forgotPassword(params:Parameters? ,
                        _ isLoading:Bool = true,
                   succeeded:( (_ result:AnyObject) ->Void)? = nil,
                   error:((_ errorObject:AnyObject)->Void)?,
                   failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        Alamofire.request(Constant.PointPowAPI.forgotPassword , method: .post , parameters : params).validate().responseJSON { response in
            
            if isLoading {
                self.loadingFinish?()
            }
            switch response.result {
            case .success(let json):
                print(json)
                
                if let data = json as? [String:AnyObject] {
                    
                    let success = data["success"] as? NSNumber  ??  0
                    
                    if success.intValue == 1 {
                        
                        if let result = data["result"] as? [String:AnyObject] {
                            let reset_token  = result["reset_token"] as? String ?? ""
                            DataController.sharedInstance.setResetPasswordToken(reset_token)
                            succeeded?(result as AnyObject)
                        }
                    }else{
                        let messageError = data["message"] as? String  ??  ""
                        let field = data["field"] as? String  ??  ""
                        var errorObject:[String:AnyObject] = [:]
                        errorObject["message"] = messageError as AnyObject
                        errorObject["field"] = field as AnyObject
                        error?(errorObject as AnyObject)
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
    
    func setPassword(params:Parameters? ,
                        _ isLoading:Bool = true,
                        succeeded:( (_ result:AnyObject) ->Void)? = nil,
                        error:((_ errorObject:AnyObject)->Void)?,
                        failure:( (_ statusCode:String) ->Void)? = nil ){
        if isLoading {
            self.loadingStart?()
        }
        Alamofire.request(Constant.PointPowAPI.setNewPassword , method: .post , parameters : params).validate().responseJSON { response in
            
            if isLoading {
                self.loadingFinish?()
            }
            switch response.result {
            case .success(let json):
                print(json)
                
                if let data = json as? [String:AnyObject] {
                    
                    let success = data["success"] as? NSNumber  ??  0
                    
                    if success.intValue == 1 {
                        
                        succeeded?([:] as AnyObject)
                        
                    }else{
                        let messageError = data["message"] as? String  ??  ""
                        let field = data["field"] as? String  ??  ""
                        var errorObject:[String:AnyObject] = [:]
                        errorObject["message"] = messageError as AnyObject
                        errorObject["field"] = field as AnyObject
                        error?(errorObject as AnyObject)
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
    
    
    
    
    func getUserData(params:Parameters? ,
                     _ isLoading:Bool = true,
                     succeeded:( (_ result:AnyObject) ->Void)? = nil,
                     error:((_ errorObject:AnyObject)->Void)?,
                     failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
   
        
        Alamofire.request(Constant.PointPowAPI.userData , method: .get ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
            
                            
            if isLoading {
                self.loadingFinish?()
            }
            
            
            switch response.result {
            case .success(let json):
                print("UserData \n\(json)")
                
                if let data = json as? [String:AnyObject] {
                    
                    let success = data["success"] as? NSNumber  ??  0
                    
                    if success.intValue == 1 {
                        
                        if let result = data["result"] as? [String:AnyObject] {
                            succeeded?(result as AnyObject)
                        }
                        
                    }else{
                        let messageError = data["message"] as? String  ??  ""
                        let field = data["field"] as? String  ??  ""
                        var errorObject:[String:AnyObject] = [:]
                        errorObject["message"] = messageError as AnyObject
                        errorObject["field"] = field as AnyObject
                        error?(errorObject as AnyObject)
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
    
    
    func logOut(){
        GIDSignIn.sharedInstance()?.signOut()
        self.fbLoginManager.logOut()
        
        /*
        if((FBSDKAccessToken.current()) == nil){
            print("logout success")
        }else{
            print("logout i not success")
        }
         */
    }
    
    
}
