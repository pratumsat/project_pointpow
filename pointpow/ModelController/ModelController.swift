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


    func updateFCMToken(params:Parameters? ,
                         _ isLoading:Bool = true,
                         succeeded:( (_ result:AnyObject) ->Void)? = nil,
                         error:((_ errorObject:AnyObject)->Void)?,
                         failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        var path = Constant.PointPowAPI.addDeviceToken
        
        if token.isEmpty {
            path = Constant.PointPowAPI.addDeviceToken
        }else{
            path = Constant.PointPowAPI.updateDeviceToken
        }
        
        Alamofire.request(path , method: .post ,
                          parameters : params,
                          headers : header).validate().responseJSON { response in
            
            if isLoading {
                self.loadingFinish?()
            }
            switch response.result {
            case .success(let json):
                print(json)
                
                if let data = json as? [String:AnyObject] {
                    
                    let success = data["success"] as? NSNumber  ??  0
                    
                    if success.intValue == 1 {
                        succeeded?("" as AnyObject)
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
                            }else{
                                if let result = data["result"] as? [[String:AnyObject]] {
                                    succeeded?(result as AnyObject)
                                }
                            }
                        }
                        
                    }
                }
                
                break
                
            }
        }
    }
    
    
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
              
               if  response.response?.statusCode == 429 {
                    failure?("429")
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
                            }else{
                                if let result = data["result"] as? [[String:AnyObject]] {
                                    succeeded?(result as AnyObject)
                                }
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
                            }else{
                                if let result = data["result"] as? [[String:AnyObject]] {
                                    succeeded?(result as AnyObject)
                                }
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
                print("registerWithMobile")
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
                            }else{
                                if let result = data["result"] as? [[String:AnyObject]] {
                                    succeeded?(result as AnyObject)
                                }
                            }
                        }

                    }
                }
                
                break
                
            }
        }
    }
    
    func updateMemberProfile(params:Parameters? ,
                           _ isLoading:Bool = true,
                           succeeded:( (_ result:AnyObject) ->Void)? = nil,
                           error:((_ errorObject:AnyObject)->Void)?,
                           failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        Alamofire.request(Constant.PointPowAPI.updateMember , method: .post ,
                          parameters : params,
                          headers: header).validate().responseJSON { response in
            
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
                            }else{
                                if let result = data["result"] as? [[String:AnyObject]] {
                                    succeeded?(result as AnyObject)
                                }
                            }
                        }
                    }
                }
                
                break
                
            }
        }
    }
    
    func changePassword(params:Parameters? ,
                            _ isLoading:Bool = true,
                            succeeded:( (_ result:AnyObject) ->Void)? = nil,
                            error:((_ errorObject:AnyObject)->Void)?,
                            failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.changePassword , method: .post ,
                          parameters : params,
                          headers: header).validate().responseJSON { response in
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            switch response.result {
                            case .success(let json):
                                print(json)
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        
                                        succeeded?("success" as AnyObject)
                                        
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    func changeMobileNumber(params:Parameters? ,
                         _ isLoading:Bool = true,
                            succeeded:( (_ result:AnyObject) ->Void)? = nil,
                            error:((_ errorObject:AnyObject)->Void)?,
                            failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.changeMobile , method: .post ,
                          parameters : params,
                          headers: header).validate().responseJSON { response in
            
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
                            }else{
                                if let result = data["result"] as? [[String:AnyObject]] {
                                    succeeded?(result as AnyObject)
                                }
                            }
                        }
                        
                    }
                }
                
                break
                
            }
        }
    }
 
    func verifyOTPNewMobileNumber(params:Parameters? ,
                   _ isLoading:Bool = true,
                   succeeded:( (_ result:AnyObject) ->Void)? = nil,
                   error:((_ errorObject:AnyObject)->Void)?,
                   failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        
        Alamofire.request(Constant.PointPowAPI.verifyOTPNewMobileNumber , method: .post ,
                          parameters : params,
                          headers: header).validate().responseJSON { response in
            
            if isLoading {
                self.loadingFinish?()
            }
            switch response.result {
            case .success(let json):
                print("verifyOTP")
                print(json)
                
                if let data = json as? [String:AnyObject] {
                    
                    let success = data["success"] as? NSNumber  ??  0
                    
                    if success.intValue == 1 {
                         succeeded?("" as AnyObject)
                        
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
                            }else{
                                if let result = data["result"] as? [[String:AnyObject]] {
                                    succeeded?(result as AnyObject)
                                }
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
                print("verifyOTP")
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
                            }else{
                                if let result = data["result"] as? [[String:AnyObject]] {
                                    succeeded?(result as AnyObject)
                                }
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
                                let request_id  = result["request_id"] as? String ?? ""
                                DataController.sharedInstance.setRequestId(request_id)
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
                            }else{
                                if let result = data["result"] as? [[String:AnyObject]] {
                                    succeeded?(result as AnyObject)
                                }
                            }
                        }
                    }
                }
                
                break
                
            }
        }
    }
    
    func forgotPasswordMobile(params:Parameters? ,
                        _ isLoading:Bool = true,
                        succeeded:( (_ result:AnyObject) ->Void)? = nil,
                        error:((_ errorObject:AnyObject)->Void)?,
                        failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        Alamofire.request(Constant.PointPowAPI.forgotPasswordMobile , method: .post , parameters : params).validate().responseJSON { response in
            
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
                            let request_id  = result["request_id"] as? String ?? ""
                            DataController.sharedInstance.setRequestId(request_id)
                            
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
                            }else{
                                if let result = data["result"] as? [[String:AnyObject]] {
                                    succeeded?(result as AnyObject)
                                }
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
        Alamofire.request(Constant.PointPowAPI.forgotPasswordEmail , method: .post , parameters : params).validate().responseJSON { response in
            
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
                            }else{
                                if let result = data["result"] as? [[String:AnyObject]] {
                                    succeeded?(result as AnyObject)
                                }
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
                            }else{
                                if let result = data["result"] as? [[String:AnyObject]] {
                                    succeeded?(result as AnyObject)
                                }
                            }
                        }
                    }
                }
                
                break
                
            }
        }
    }
    
    
    func setPinCode(params:Parameters? ,
                     _ isLoading:Bool = true,
                     succeeded:( (_ result:AnyObject) ->Void)? = nil,
                     error:((_ errorObject:AnyObject)->Void)?,
                     failure:( (_ statusCode:String) ->Void)? = nil ){
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.setPinCode , method: .post ,
                          parameters : params,
                          headers: header).validate().responseJSON { response in
            
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
                            }else{
                                if let result = data["result"] as? [[String:AnyObject]] {
                                    succeeded?(result as AnyObject)
                                }
                            }
                        }
                    }
                }
                
                break
                
            }
        }
    }
    
    func statusPinCode(params:Parameters? ,
                    _ isLoading:Bool = true,
                    succeeded:( (_ result:AnyObject) ->Void)? = nil,
                    error:((_ errorObject:AnyObject)->Void)?,
                    failure:( (_ statusCode:String) ->Void)? = nil ){
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.statusPinCode , method: .get ,
                          parameters : params,
                          headers: header).validate().responseJSON { response in
                            
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    func resetPinCodeToken(params:Parameters? ,
                    _ isLoading:Bool = true,
                    succeeded:( (_ result:AnyObject) ->Void)? = nil,
                    error:((_ errorObject:AnyObject)->Void)?,
                    failure:( (_ statusCode:String) ->Void)? = nil ){
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.resetPinCode , method: .post ,
                          parameters : params,
                          headers: header).validate().responseJSON { response in
                            
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    func enterPinCode(params:Parameters? ,
                    _ isLoading:Bool = true,
                    succeeded:( (_ result:AnyObject) ->Void)? = nil,
                    error:((_ errorObject:AnyObject)->Void)?,
                    failure:( (_ statusCode:String) ->Void)? = nil ){
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.enterPinCode , method: .post ,
                          parameters : params,
                          headers: header).validate().responseJSON { response in
                            
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
                                            print("data error \(data)")
                                            let success = data["success"] as? NSNumber  ??  0
                                            
                                            if success.intValue == 0 {
                                                let messageError = data["message"] as? String  ??  ""
                                                let field = data["field"] as? String  ??  ""
                                                let result = data["result"] as? [String:AnyObject]  ??  [:]
                                                let pin_status = result["pin_status"] as? NSNumber  ??  0
                                                
                                                var errorObject:[String:AnyObject] = [:]
                                                errorObject["message"] = messageError as AnyObject
                                                errorObject["field"] = field as AnyObject
                                                errorObject["pin_status"] = pin_status as AnyObject
                                                error?(errorObject as AnyObject)
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    
    func forgotPinCodeMobile(params:Parameters? ,
                       _ isLoading:Bool = true,
                       succeeded:( (_ result:AnyObject) ->Void)? = nil,
                       error:((_ errorObject:AnyObject)->Void)?,
                       failure:( (_ statusCode:String) ->Void)? = nil ){
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.forgotPinCodeMobile , method: .post ,
                          parameters : params,
                          headers: header).validate().responseJSON { response in
                            
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
                                            let request_id  = result["request_id"] as? String ?? ""
                                            DataController.sharedInstance.setRequestId(request_id)
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    
    func forgotPinCode(params:Parameters? ,
                      _ isLoading:Bool = true,
                      succeeded:( (_ result:AnyObject) ->Void)? = nil,
                      error:((_ errorObject:AnyObject)->Void)?,
                      failure:( (_ statusCode:String) ->Void)? = nil ){
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.forgotPinCodeEmail , method: .post ,
                          parameters : params,
                          headers: header).validate().responseJSON { response in
                            
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
                                            DataController.sharedInstance.setResetPinToken(reset_token)
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
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
                            let pointBalance = result["member_point"]?["total"] as? NSNumber ?? 0
                            let picture_data = result["picture_data"] as? String ?? ""
                            let picture_background = result["picture_background"] as? String ?? ""
                            let id = result["id"] as? NSNumber ?? 0
                            
                            DataController.sharedInstance.setMemberId(id.intValue)
                            DataController.sharedInstance.setProfilPath(picture_data)
                            DataController.sharedInstance.setBgProfilPath(picture_background)
                            
                            DataController.sharedInstance.setCurrentPointBalance(pointBalance)
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
                            }else{
                                if let result = data["result"] as? [[String:AnyObject]] {
                                    succeeded?(result as AnyObject)
                                }
                            }
                        }
                    }
                }
                
                break
                
            }
        }
    }
    
    func memberSetting(params:Parameters? ,
                     _ isLoading:Bool = true,
                     succeeded:( (_ result:AnyObject) ->Void)? = nil,
                     error:((_ errorObject:AnyObject)->Void)?,
                     failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.memberSetting , method: .post ,
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }

    func getMemberSetting(params:Parameters? ,
                       _ isLoading:Bool = true,
                       succeeded:( (_ result:AnyObject) ->Void)? = nil,
                       error:((_ errorObject:AnyObject)->Void)?,
                       failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.memberSetting , method: .get ,
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
                                            let save_slip = (result["save_slip"] as? NSNumber)?.boolValue ?? false
                                            let limit_pay_left = result["limit_pay_left"] as? NSNumber ?? 0
                                            
                                            DataController.sharedInstance.setSaveSlip(save_slip)
                                            DataController.sharedInstance.setLimitPerDay(limit_pay_left)
                                            
                                           
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }

    func getHistory(params:Parameters? ,
                    parameter:String,
                     _ isLoading:Bool = true,
                     succeeded:( (_ result:AnyObject) ->Void)? = nil,
                     error:((_ errorObject:AnyObject)->Void)?,
                     failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        let path = "\(Constant.PointPowAPI.goldhistory)?\(parameter)"
        Alamofire.request(path , method: .get ,
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
                                        
                                        if let result = data["result"] as? [[String:AnyObject]] {
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    func getPointHistory(params:Parameters? ,
                    parameter:String? = nil,
                    _ isLoading:Bool = true,
                    succeeded:( (_ result:AnyObject) ->Void)? = nil,
                    error:((_ errorObject:AnyObject)->Void)?,
                    failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        //let path = "\(Constant.PointPowAPI.transectionHistory)?\(parameter)"
        Alamofire.request(Constant.PointPowAPI.transectionHistory , method: .get ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("Transaection History \n\(json)")
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        
                                        if let result = data["result"] as? [[String:AnyObject]] {
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }

    func getShippingList(params:Parameters? ,
                            parameter:String? = nil,
                            _ isLoading:Bool = true,
                            succeeded:( (_ result:AnyObject) ->Void)? = nil,
                            error:((_ errorObject:AnyObject)->Void)?,
                            failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.shipping_list , method: .get ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("Transaection History \n\(json)")
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        
                                        if let result = data["result"] as? [[String:AnyObject]] {
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    func getShoppingHistory(params:Parameters? ,
                         parameter:String? = nil,
                         _ isLoading:Bool = true,
                         succeeded:( (_ result:AnyObject) ->Void)? = nil,
                         error:((_ errorObject:AnyObject)->Void)?,
                         failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        

        Alamofire.request(Constant.PointPowAPI.ordersHistory , method: .get ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("Transaection History \n\(json)")
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        
                                        if let result = data["result"] as? [[String:AnyObject]] {
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }

    func detailShoppingHistory(transactionNumber:String ,
                                  _ isLoading:Bool = true,
                                  succeeded:( (_ result:AnyObject) ->Void)? = nil,
                                  error:((_ errorObject:AnyObject)->Void)?,
                                  failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        let path = "\(Constant.PointPowAPI.ordersHistory)/\(transactionNumber)"
        Alamofire.request(path, method: .get ,
                          parameters : nil,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("transection \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    func shoppingPromotionList(params:Parameters? ,
                       _ isLoading:Bool = true,
                       succeeded:( (_ result:AnyObject) ->Void)? = nil,
                       error:((_ errorObject:AnyObject)->Void)?,
                       failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.shopping_promostions , method: .get ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            switch response.result {
                            case .success(let json):
                                print("promotion: \n\(json)")
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        if let result = data["result"] as? [[String:AnyObject]] {
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                            }
        }
    }
    func shoppingPromotionById(id:String ,
                       _ isLoading:Bool = true,
                       succeeded:( (_ result:AnyObject) ->Void)? = nil,
                       error:((_ errorObject:AnyObject)->Void)?,
                       failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        let url = "\(Constant.PointPowAPI.shopping_promostionsById)"
        Alamofire.request(url.replace(target: "{{id}}", withString: id) , method: .get ,
                          parameters : nil,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            switch response.result {
                            case .success(let json):
                                print("promotion: \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                            }
        }
    }
    
    func getGoldPrice(params:Parameters? ,
                     _ isLoading:Bool = true,
                     succeeded:( (_ result:AnyObject) ->Void)? = nil,
                     error:((_ errorObject:AnyObject)->Void)?,
                     failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.goldPrice , method: .get ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("GoldPrice \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    func getLuckyDraw(params:Parameters? ,
                      _ isLoading:Bool = true,
                      succeeded:( (_ result:AnyObject) ->Void)? = nil,
                      error:((_ errorObject:AnyObject)->Void)?,
                      failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.privilegeLuckydraw , method: .get ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("GoldPrice \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    func getWinnerLuckyDraw(params:Parameters? ,
                      _ isLoading:Bool = true,
                      succeeded:( (_ result:AnyObject) ->Void)? = nil,
                      error:((_ errorObject:AnyObject)->Void)?,
                      failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.winnerLuckydraw , method: .get ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("winnerLuckydraw \n\(json)")
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        
                                        if let result = data["result"] as? [[String:AnyObject]] {
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    
    func getBanner(params:Parameters? ,
                      _ isLoading:Bool = true,
                      succeeded:( (_ result:AnyObject) ->Void)? = nil,
                      error:((_ errorObject:AnyObject)->Void)?,
                      failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        Alamofire.request(Constant.PointPowAPI.banners , method: .get ,
                          parameters : params
                           ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("GoldPrice \n\(json)")
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        
                                        if let result = data["result"] as? [[String:AnyObject]] {
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    /**SHOPPING**/
    func addOrder(params:Parameters? ,
                   _ isLoading:Bool = true,
                   succeeded:( (_ result:AnyObject) ->Void)? = nil,
                   error:((_ errorObject:AnyObject)->Void)?,
                   failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        let path = Constant.PointPowAPI.addOrders
        Alamofire.request(path , method: .post ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("addOrders \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    func addToCart(params:Parameters? ,
                    _ isLoading:Bool = true,
                    succeeded:( (_ result:AnyObject) ->Void)? = nil,
                    error:((_ errorObject:AnyObject)->Void)?,
                    failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        let path = Constant.PointPowAPI.addCarts
        Alamofire.request(path , method: .post ,
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    func delCart(params:Parameters? ,
                    _ isLoading:Bool = true,
                    succeeded:( (_ result:AnyObject) ->Void)? = nil,
                    error:((_ errorObject:AnyObject)->Void)?,
                    failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        let path = Constant.PointPowAPI.deleteCarts
        Alamofire.request(path , method: .post ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("updateCart \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    func updateCart(params:Parameters? ,
                   _ isLoading:Bool = true,
                   succeeded:( (_ result:AnyObject) ->Void)? = nil,
                   error:((_ errorObject:AnyObject)->Void)?,
                   failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        let path = Constant.PointPowAPI.updateCarts
        Alamofire.request(path , method: .post ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("updateCart \n\(json)")
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        succeeded?("" as AnyObject)
                                        //if let result = data["result"] as? [String:AnyObject] {
                                        //
                                        //}
                                        
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    func getCart(params:Parameters? ,
                   _ isLoading:Bool = true,
                   succeeded:( (_ result:AnyObject) ->Void)? = nil,
                   error:((_ errorObject:AnyObject)->Void)?,
                   failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        let parameter:Parameters = ["session_id" : DataController.sharedInstance.getToken(),
                                    "member_id" : DataController.sharedInstance.getMemberId(),
                                    "status" : "new"]
        
        Alamofire.request(Constant.PointPowAPI.getCarts , method: .get ,
                          parameters : parameter,
                          headers: header).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("getCart \n\(json)")
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        
                                        if let result = data["result"] as? [[String:AnyObject]] {
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    func getBannerShopping(params:Parameters? ,
                   _ isLoading:Bool = true,
                   succeeded:( (_ result:AnyObject) ->Void)? = nil,
                   error:((_ errorObject:AnyObject)->Void)?,
                   failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        Alamofire.request(Constant.PointPowAPI.shoppingBanner , method: .get ,
                          parameters : params,
                          headers: header
            ).validate().responseJSON { response in
                
                
                if isLoading {
                    self.loadingFinish?()
                }
                
                
                switch response.result {
                case .success(let json):
                    print("banner \n\(json)")
                    
                    if let data = json as? [String:AnyObject] {
                        
                        let success = data["success"] as? NSNumber  ??  0
                        
                        if success.intValue == 1 {
                            
                            if let result = data["result"] as? [[String:AnyObject]] {
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
                                }else{
                                    if let result = data["result"] as? [[String:AnyObject]] {
                                        succeeded?(result as AnyObject)
                                    }
                                }
                            }
                        }
                    }
                    
                    break
                    
                }
        }
    }
    
    func getSpecailDealShopping(params:Parameters? ,
                           _ isLoading:Bool = true,
                           succeeded:( (_ result:AnyObject) ->Void)? = nil,
                           error:((_ errorObject:AnyObject)->Void)?,
                           failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        Alamofire.request(Constant.PointPowAPI.specailDeal , method: .get ,
                          parameters : params,
                          headers: header
            ).validate().responseJSON { response in
                
                
                if isLoading {
                    self.loadingFinish?()
                }
                
                
                switch response.result {
                case .success(let json):
                    print("special deal \n\(json)")
                    
                    if let data = json as? [String:AnyObject] {
                        
                        let success = data["success"] as? NSNumber  ??  0
                        
                        if success.intValue == 1 {
                            
                            if let result = data["result"] as? [[String:AnyObject]] {
                                succeeded?(result as AnyObject)
                            }else if let resultObject = data["result"] as? [String:AnyObject] {
                                succeeded?(resultObject as AnyObject)
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
                                }else{
                                    if let result = data["result"] as? [[String:AnyObject]] {
                                        succeeded?(result as AnyObject)
                                    }
                                }
                            }
                        }
                    }
                    
                    break
                    
                }
        }
    }
    
    func getHotRedemptionShopping(params:Parameters? ,
                                _ isLoading:Bool = true,
                                succeeded:( (_ result:AnyObject) ->Void)? = nil,
                                error:((_ errorObject:AnyObject)->Void)?,
                                failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        Alamofire.request(Constant.PointPowAPI.hotRedemption , method: .get ,
                          parameters : params,
                          headers: header
            ).validate().responseJSON { response in
                
                
                if isLoading {
                    self.loadingFinish?()
                }
                
                
                switch response.result {
                case .success(let json):
                    print("hot redemp \n\(json)")
                    
                    if let data = json as? [String:AnyObject] {
                        
                        let success = data["success"] as? NSNumber  ??  0
                        
                        if success.intValue == 1 {
                            
                            if let result = data["result"] as? [[String:AnyObject]] {
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
                                }else{
                                    if let result = data["result"] as? [[String:AnyObject]] {
                                        succeeded?(result as AnyObject)
                                    }
                                }
                            }
                        }
                    }
                    
                    break
                    
                }
        }
    }
    
    
    func getReccommendByCateShopping(cateId:Int,
                                     limit:Int,
                                  _ isLoading:Bool = true,
                                  succeeded:( (_ result:AnyObject) ->Void)? = nil,
                                  error:((_ errorObject:AnyObject)->Void)?,
                                  failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        var url = Constant.PointPowAPI.recommend_all
        if cateId == 0 {
            url = Constant.PointPowAPI.recommend_all
        }else{
            url = Constant.PointPowAPI.recommend_byCate.replace(target: "{{cate}}", withString: "\(cateId)")
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        let parameter:Parameters = ["limit" : limit ]
        Alamofire.request("\(url)" , method: .get ,
                          parameters : parameter,
                          headers: header
            ).validate().responseJSON { response in
                
                
                if isLoading {
                    self.loadingFinish?()
                }
                
                
                switch response.result {
                case .success(let json):
                    print("hot redemp \n\(json)")
                    
                    if let data = json as? [String:AnyObject] {
                        
                        let success = data["success"] as? NSNumber  ??  0
                        
                        if success.intValue == 1 {
                            
                            if let result = data["result"] as? [[String:AnyObject]] {
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
                                }else{
                                    if let result = data["result"] as? [[String:AnyObject]] {
                                        succeeded?(result as AnyObject)
                                    }
                                }
                            }
                        }
                    }
                    
                    break
                    
                }
        }
    }
    
    
    func getSubCateByCateShopping(cateId:Int,
                                     _ isLoading:Bool = true,
                                     succeeded:( (_ result:AnyObject) ->Void)? = nil,
                                     error:((_ errorObject:AnyObject)->Void)?,
                                     failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        let url = Constant.PointPowAPI.subCateByCate.replace(target: "{{cate}}", withString: "\(cateId)")
        Alamofire.request("\(url)" , method: .get ,
                          parameters : nil,
                          headers: header
            ).validate().responseJSON { response in
                
                
                if isLoading {
                    self.loadingFinish?()
                }
                
                
                switch response.result {
                case .success(let json):
                    print("hot redemp \n\(json)")
                    
                    if let data = json as? [String:AnyObject] {
                        
                        let success = data["success"] as? NSNumber  ??  0
                        
                        if success.intValue == 1 {
                            
                            if let result = data["result"] as? [[String:AnyObject]] {
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
                                }else{
                                    if let result = data["result"] as? [[String:AnyObject]] {
                                        succeeded?(result as AnyObject)
                                    }
                                }
                            }
                        }
                    }
                    
                    break
                    
                }
        }
    }
    func searchProducts(word:String,
                          skip:Int,
                          type:String,
                          _ isLoading:Bool = true,
                          succeeded:( (_ result:AnyObject) ->Void)? = nil,
                          error:((_ errorObject:AnyObject)->Void)?,
                          failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let url = Constant.PointPowAPI.search_product
        
        let parameter:Parameters = ["keyword": word,
                                    "skip" : skip,
                                    "type" : type]
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        Alamofire.request("\(url)" , method: .get ,
                          parameters : parameter,
                          headers: header
            ).validate().responseJSON { response in
                
                
                if isLoading {
                    self.loadingFinish?()
                }
                
                
                switch response.result {
                case .success(let json):
                    print("hot redemp \n\(json)")
                    
                    if let data = json as? [String:AnyObject] {
                        
                        let success = data["success"] as? NSNumber  ??  0
                        
                        if success.intValue == 1 {
                            
                            if let result = data["result"] as? [[String:AnyObject]] {
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
                                }else{
                                    if let result = data["result"] as? [[String:AnyObject]] {
                                        succeeded?(result as AnyObject)
                                    }
                                }
                            }
                        }
                    }
                    
                    break
                    
                }
        }
    }
    func getProductByCate(cateId:Int,
                                     skip:Int,
                                     type:String,
                                     _ isLoading:Bool = true,
                                     succeeded:( (_ result:AnyObject) ->Void)? = nil,
                                     error:((_ errorObject:AnyObject)->Void)?,
                                     failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        var url = Constant.PointPowAPI.product_all
        if cateId == 0 {
            url = Constant.PointPowAPI.product_all
        }else{
            url = Constant.PointPowAPI.product_ByCate.replace(target: "{{cate}}", withString: "\(cateId)")
        }
        let parameter:Parameters = ["skip" : skip,
                                    "type" : type]
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        Alamofire.request("\(url)" , method: .get ,
                          parameters : parameter,
                          headers: header
            ).validate().responseJSON { response in
                
                
                if isLoading {
                    self.loadingFinish?()
                }
                
                
                switch response.result {
                case .success(let json):
                    print("hot redemp \n\(json)")
                    
                    if let data = json as? [String:AnyObject] {
                        
                        let success = data["success"] as? NSNumber  ??  0
                        
                        if success.intValue == 1 {
                            
//                            let total_amount = data["total_amount"] as? Int ?? 0
//                            let result = data["result"] as? [[String:AnyObject]] ?? []
                            //if let result = data["result"] as? [[String:AnyObject]] {
                                //succeeded?(result as AnyObject)
                            //}
                            
                            succeeded?(data as AnyObject)
                            
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
                                }else{
                                    if let result = data["result"] as? [[String:AnyObject]] {
                                        succeeded?(result as AnyObject)
                                    }
                                }
                            }
                        }
                    }
                    
                    break
                    
                }
        }
    }
    
    
    func getProductImageById(productId:Int,
                              _ isLoading:Bool = true,
                              succeeded:( (_ result:AnyObject) ->Void)? = nil,
                              error:((_ errorObject:AnyObject)->Void)?,
                              failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let url = Constant.PointPowAPI.productImageByID.replace(target: "{{productId}}", withString: "\(productId)")
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        Alamofire.request(url , method: .get ,
                          parameters : nil,
                          headers: header
            ).validate().responseJSON { response in
                
                
                if isLoading {
                    self.loadingFinish?()
                }
                
                
                switch response.result {
                case .success(let json):
                    print("hot redemp \n\(json)")
                    
                    if let data = json as? [String:AnyObject] {
                        
                        let success = data["success"] as? NSNumber  ??  0
                        
                        if success.intValue == 1 {
                            
                            if let result = data["result"] as? [[String:AnyObject]] {
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
                                }else{
                                    if let result = data["result"] as? [[String:AnyObject]] {
                                        succeeded?(result as AnyObject)
                                    }
                                }
                            }
                        }
                    }
                    
                    break
                    
                }
        }
    }
    func getProductDetailById(productId:Int,
                               _ isLoading:Bool = true,
                               succeeded:( (_ result:AnyObject) ->Void)? = nil,
                               error:((_ errorObject:AnyObject)->Void)?,
                               failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let url = Constant.PointPowAPI.productDetailByID.replace(target: "{{productId}}", withString: "\(productId)")
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        Alamofire.request(url , method: .get ,
                          parameters : nil,
                          headers: header
            ).validate().responseJSON { response in
                
                
                if isLoading {
                    self.loadingFinish?()
                }
                
                
                switch response.result {
                case .success(let json):
                    print("hot redemp \n\(json)")
                    
                    if let data = json as? [String:AnyObject] {
                        
                        let success = data["success"] as? NSNumber  ??  0
                        
                        if success.intValue == 1 {
                            
                            if let result = data["result"] as? [[String:AnyObject]] {
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
                                }else{
                                    if let result = data["result"] as? [[String:AnyObject]] {
                                        succeeded?(result as AnyObject)
                                    }
                                }
                            }
                        }
                    }
                    
                    break
                    
                }
        }
    }
    
    func getProductRelatedByID(productId:Int,
                          _ isLoading:Bool = true,
                          succeeded:( (_ result:AnyObject) ->Void)? = nil,
                          error:((_ errorObject:AnyObject)->Void)?,
                          failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let url = Constant.PointPowAPI.productRelatedByID.replace(target: "{{productId}}", withString: "\(productId)")
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        Alamofire.request(url , method: .get ,
                          parameters : nil,
                          headers: header
            ).validate().responseJSON { response in
                
                
                if isLoading {
                    self.loadingFinish?()
                }
                
                
                switch response.result {
                case .success(let json):
                    print("hot redemp \n\(json)")
                    
                    if let data = json as? [String:AnyObject] {
                        
                        let success = data["success"] as? NSNumber  ??  0
                        
                        if success.intValue == 1 {
                            
                            if let result = data["result"] as? [[String:AnyObject]] {
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
                                }else{
                                    if let result = data["result"] as? [[String:AnyObject]] {
                                        succeeded?(result as AnyObject)
                                    }
                                }
                            }
                        }
                    }
                    
                    break
                    
                }
        }
    }
    
    func getPremiumGoldPrice(params:Parameters? ,
                      _ isLoading:Bool = true,
                      succeeded:( (_ result:AnyObject) ->Void)? = nil,
                      error:((_ errorObject:AnyObject)->Void)?,
                      failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        Alamofire.request(Constant.PointPowAPI.goldPremiumPrice , method: .get ,
                          parameters : params
                          ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("GoldPrmium \n\(json)")
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        
                                        if let result = data["result"] as? [[String:AnyObject]] {
                                            
                                            DataController.sharedInstance.setDataGoldPremium(result as AnyObject)
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    func getServicePriceThaiPost(params:Parameters? ,
                             _ isLoading:Bool = true,
                             succeeded:( (_ result:AnyObject) ->Void)? = nil,
                             error:((_ errorObject:AnyObject)->Void)?,
                             failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.servicePriceThaiPost , method: .get ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("GoldPrmium \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    func getProvince(params:Parameters? ,
                      _ isLoading:Bool = true,
                      succeeded:( (_ result:AnyObject) ->Void)? = nil,
                      error:((_ errorObject:AnyObject)->Void)?,
                      failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.province , method: .get ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("GoldPrice \n\(json)")
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        
                                        if let result = data["result"] as? [[String:AnyObject]] {
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    func getDistrict(params:Parameters? ,
                     id:Int,
                     _ isLoading:Bool = true,
                     succeeded:( (_ result:AnyObject) ->Void)? = nil,
                     error:((_ errorObject:AnyObject)->Void)?,
                     failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        let path = "\(Constant.PointPowAPI.districts)/\(id)"
        Alamofire.request(path , method: .get ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("GoldPrice \n\(json)")
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        
                                        if let result = data["result"] as? [[String:AnyObject]] {
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    func getSubDistrict(params:Parameters? ,
                        id:Int,
                     _ isLoading:Bool = true,
                     succeeded:( (_ result:AnyObject) ->Void)? = nil,
                     error:((_ errorObject:AnyObject)->Void)?,
                     failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        let path = "\(Constant.PointPowAPI.subdistricts)/\(id)"
        Alamofire.request(path , method: .get ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("GoldPrice \n\(json)")
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        
                                        if let result = data["result"] as? [[String:AnyObject]] {
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    func savingGold(params:Parameters? ,
                      _ isLoading:Bool = true,
                      succeeded:( (_ result:AnyObject) ->Void)? = nil,
                      error:((_ errorObject:AnyObject)->Void)?,
                      failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.savingGold , method: .post ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("GoldPrice \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    func withdrawGold(params:Parameters? ,
                    _ isLoading:Bool = true,
                    succeeded:( (_ result:AnyObject) ->Void)? = nil,
                    error:((_ errorObject:AnyObject)->Void)?,
                    failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.withdrawGold , method: .post ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("GoldPrice \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    
    func updateMemberLatestAddress(params:Parameters? ,
                             _ isLoading:Bool = true,
                             succeeded:( (_ result:AnyObject) ->Void)? = nil,
                             error:((_ errorObject:AnyObject)->Void)?,
                             failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.memberUpdateLastestAddress , method: .post ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            switch response.result {
                            case .success(let json):
                                print("Update latest Address \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                            }
        }
    }
    func createMemberAddress(params:Parameters? ,
                      _ isLoading:Bool = true,
                      succeeded:( (_ result:AnyObject) ->Void)? = nil,
                      error:((_ errorObject:AnyObject)->Void)?,
                      failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.memberAddress , method: .post ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            switch response.result {
                            case .success(let json):
                                print("Address \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                            }
        }
    }
    
    func editMemberAddress(params:Parameters? ,
                           id: Int,
                             _ isLoading:Bool = true,
                             succeeded:( (_ result:AnyObject) ->Void)? = nil,
                             error:((_ errorObject:AnyObject)->Void)?,
                             failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        let path = "\(Constant.PointPowAPI.memberAddress)/\(id)"
        Alamofire.request(path, method: .post ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            switch response.result {
                            case .success(let json):
                                print("Address \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                            }
        }
    }
    
    func deleteMemberAddress(id: Int,
                           _ isLoading:Bool = true,
                           succeeded:( (_ result:AnyObject) ->Void)? = nil,
                           error:((_ errorObject:AnyObject)->Void)?,
                           failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        let path = "\(Constant.PointPowAPI.memberAddress)/del/\(id)"
        Alamofire.request(path, method: .post ,
                          parameters : nil,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            switch response.result {
                            case .success(let json):
                                print("Address \n\(json)")
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        
                                        succeeded?("" as AnyObject)
                                        
                                        
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                            }
        }
    }
    
    
    func scanQRCode(params:Parameters? ,
                      _ isLoading:Bool = true,
                      succeeded:( (_ result:AnyObject) ->Void)? = nil,
                      error:((_ errorObject:AnyObject)->Void)?,
                      failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.scanQRMember , method: .get ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            switch response.result {
                            case .success(let json):
                                print("search member: \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                            }
        }
    }
    
    func searchMember(params:Parameters? ,
                             _ isLoading:Bool = true,
                             succeeded:( (_ result:AnyObject) ->Void)? = nil,
                             error:((_ errorObject:AnyObject)->Void)?,
                             failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.searchMember , method: .get ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            switch response.result {
                            case .success(let json):
                                print("search member: \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                            }
        }
    }
    
    func recentFriendTransfer(params:Parameters? ,
                      _ isLoading:Bool = true,
                      succeeded:( (_ result:AnyObject) ->Void)? = nil,
                      error:((_ errorObject:AnyObject)->Void)?,
                      failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.recentMemberTransfer , method: .get ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            switch response.result {
                            case .success(let json):
                                print("recent member: \n\(json)")
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        
                                        if let result = data["result"] as? [[String:AnyObject]] {
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                            }
        }
    
    }
    
    func exchangeTransferPoint(params:Parameters? ,
                             _ isLoading:Bool = true,
                             succeeded:( (_ result:AnyObject) ->Void)? = nil,
                             error:((_ errorObject:AnyObject)->Void)?,
                             failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.memberExchange , method: .post ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            switch response.result {
                            case .success(let json):
                                print("transfer member: \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                            }
        }
    }
    
    func friendTransferPoint(params:Parameters? ,
                             _ isLoading:Bool = true,
                             succeeded:( (_ result:AnyObject) ->Void)? = nil,
                             error:((_ errorObject:AnyObject)->Void)?,
                             failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.memberTransfer , method: .post ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            switch response.result {
                            case .success(let json):
                                print("transfer member: \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                            }
        }
    }
    
    func favoriteTransferPoint(params:Parameters? ,
                             _ isLoading:Bool = true,
                             succeeded:( (_ result:AnyObject) ->Void)? = nil,
                             error:((_ errorObject:AnyObject)->Void)?,
                             failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.favouriteTransfer , method: .post ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            switch response.result {
                            case .success(let json):
                                print("transfer member: \n\(json)")
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        
                                        succeeded?("" as AnyObject)
                                        
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                            }
        }
    }
    
    func getFavoriteTransferPoint(params:Parameters? ,
                               _ isLoading:Bool = true,
                               succeeded:( (_ result:AnyObject) ->Void)? = nil,
                               error:((_ errorObject:AnyObject)->Void)?,
                               failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        let url = "\(Constant.PointPowAPI.favouriteTransfer)"
        Alamofire.request(url , method: .get ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            switch response.result {
                            case .success(let json):
                                print("transfer member: \n\(json)")
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        if let result = data["result"] as? [[String:AnyObject]] {
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                            }
        }
    }
    
    func getFavoriteTransferPointByTranssevtionID(transection_ref_id:String ,
                                  _ isLoading:Bool = true,
                                  succeeded:( (_ result:AnyObject) ->Void)? = nil,
                                  error:((_ errorObject:AnyObject)->Void)?,
                                  failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        let url = "\(Constant.PointPowAPI.favouriteTransfer)/\(transection_ref_id)"
        Alamofire.request(url , method: .get ,
                          parameters : nil,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            switch response.result {
                            case .success(let json):
                                print("favorite TranssevtionID: \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                            }
        }
    }
    
    func getProviders(params:Parameters? ,
                                  _ isLoading:Bool = true,
                                  succeeded:( (_ result:AnyObject) ->Void)? = nil,
                                  error:((_ errorObject:AnyObject)->Void)?,
                                  failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        let url = "\(Constant.PointPowAPI.providers)"
        Alamofire.request(url , method: .get ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            switch response.result {
                            case .success(let json):
                                print("transfer member: \n\(json)")
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        if let result = data["result"] as? [[String:AnyObject]] {
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                            }
        }
    }
    
    func deleteFavoriteTransferPointByTranssevtionID(transection_ref_id:String ,
                                                  _ isLoading:Bool = true,
                                                  succeeded:( (_ result:AnyObject) ->Void)? = nil,
                                                  error:((_ errorObject:AnyObject)->Void)?,
                                                  failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        let url = "\(Constant.PointPowAPI.favouriteTransfer)/del/\(transection_ref_id)"
        Alamofire.request(url , method: .post ,
                          parameters : nil,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            switch response.result {
                            case .success(let json):
                                print("transfer member: \n\(json)")
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        //if let result = data["result"] as? [String:AnyObject] {
                                        //}
                                        succeeded?("" as AnyObject)
                                        
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                            }
        }
    }
    
    func getPopupPromotion(params:Parameters? ,
                       _ isLoading:Bool = true,
                       succeeded:( (_ result:AnyObject) ->Void)? = nil,
                       error:((_ errorObject:AnyObject)->Void)?,
                       failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.popUpPromotion , method: .get ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            switch response.result {
                            case .success(let json):
                                print("promotion: \n\(json)")
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        if let result = data["result"] as? [[String:AnyObject]] {
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                            }
        }
    }
    
    func promotionList(params:Parameters? ,
                              _ isLoading:Bool = true,
                              succeeded:( (_ result:AnyObject) ->Void)? = nil,
                              error:((_ errorObject:AnyObject)->Void)?,
                              failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.promotion , method: .get ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            switch response.result {
                            case .success(let json):
                                print("promotion: \n\(json)")
                                
                                if let data = json as? [String:AnyObject] {
                                    
                                    let success = data["success"] as? NSNumber  ??  0
                                    
                                    if success.intValue == 1 {
                                        if let result = data["result"] as? [[String:AnyObject]] {
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                            }
        }
    }
    func promotionById(id:String ,
                       _ isLoading:Bool = true,
                       succeeded:( (_ result:AnyObject) ->Void)? = nil,
                       error:((_ errorObject:AnyObject)->Void)?,
                       failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        let url = "\(Constant.PointPowAPI.promotion)/\(id)"
        Alamofire.request(url , method: .get ,
                          parameters : nil,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            switch response.result {
                            case .success(let json):
                                print("promotion: \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                            }
        }
    }
    
    func detailTransactionGold(transactionNumber:String ,
                    _ isLoading:Bool = true,
                    succeeded:( (_ result:AnyObject) ->Void)? = nil,
                    error:((_ errorObject:AnyObject)->Void)?,
                    failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        let path = "\(Constant.PointPowAPI.transectionGold)/\(transactionNumber)"
        Alamofire.request(path, method: .get ,
                          parameters : nil,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("transection \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    
    func detailTransactionHistory(transactionNumber:String ,
                               _ isLoading:Bool = true,
                               succeeded:( (_ result:AnyObject) ->Void)? = nil,
                               error:((_ errorObject:AnyObject)->Void)?,
                               failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        let path = "\(Constant.PointPowAPI.transectionHistory)/\(transactionNumber)"
        Alamofire.request(path, method: .get ,
                          parameters : nil,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("transection \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
    
    
    func cancelTransactionGold(params:Parameters ,
                               _ isLoading:Bool = true,
                               succeeded:( (_ result:AnyObject) ->Void)? = nil,
                               error:((_ errorObject:AnyObject)->Void)?,
                               failure:( (_ statusCode:String) ->Void)? = nil ){
        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
    
        Alamofire.request(Constant.PointPowAPI.cancelTransectionGold, method: .post ,
                          parameters : params,
                          headers: header ).validate().responseJSON { response in
                            
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            
                            
                            switch response.result {
                            case .success(let json):
                                print("transection \n\(json)")
                                
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    }
    
  
    
    
    func uploadImageProfile(_ image:UIImage,
                            _ isLoading:Bool = true,
                            succeeded:( (_ result:AnyObject) ->Void)? = nil,
                            error:((_ errorObject:AnyObject)->Void)?,
                            failure:( (_ statusCode:String) ->Void)? = nil ,
                            inprogress:((_ progress:Double) ->Void)? = nil ,
                            uploadTask:((_ uploadtask:UploadRequest) ->Void)? = nil ){
    

        let imageData = image.pngData()!
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        if isLoading {
            self.loadingStart?()
        }
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "image", fileName: "avatar.png", mimeType: "image/png")
        },
            to: Constant.PointPowAPI.addImageProfile,
            headers : header,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    uploadTask?(upload)
                    upload.uploadProgress(closure: { (progress) in
                        print(progress.fractionCompleted)
                        if progress.fractionCompleted >= 1 {
                            if isLoading {
                                self.loadingFinish?()
                            }
                        }
                        
                        inprogress?(progress.fractionCompleted)
                    })
                    
                    upload.validate().responseJSON { response in
                        
                        switch response.result {
                        case .success(let json):
                            
                                if isLoading {
                                    self.loadingFinish?()
                                }
                            
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
                            
                                if isLoading {
                                    self.loadingFinish?()
                                }
                            
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
                                        }else{
                                            if let result = data["result"] as? [[String:AnyObject]] {
                                                succeeded?(result as AnyObject)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            break
                            
                        }
                        
                    }
                case .failure(let encodingError):
                    
                        if isLoading {
                            self.loadingFinish?()
                        }
                    
                    print(encodingError)
                }
        })
    }
    
    func uploadImageBackground(_ image:UIImage,
                            _ isLoading:Bool = true,
                            succeeded:( (_ result:AnyObject) ->Void)? = nil,
                            error:((_ errorObject:AnyObject)->Void)?,
                            failure:( (_ statusCode:String) ->Void)? = nil ,
                            inprogress:((_ progress:Double) ->Void)? = nil ,
                            uploadTask:((_ uploadtask:UploadRequest) ->Void)? = nil ){
        
        
        let imageData = image.pngData()!
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        if isLoading {
            self.loadingStart?()
        }
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "image", fileName: "avatar.png", mimeType: "image/png")
        },
            to: Constant.PointPowAPI.addBackgroundImageProfile,
            headers : header,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    uploadTask?(upload)
                    upload.uploadProgress(closure: { (progress) in
                        print(progress.fractionCompleted)
                        if progress.fractionCompleted >= 1 {
                            if isLoading {
                                self.loadingFinish?()
                            }
                        }
                        inprogress?(progress.fractionCompleted)
                    })
                    
                    upload.validate().responseJSON { response in
                        
                        switch response.result {
                        case .success(let json):
                            if isLoading {
                                self.loadingFinish?()
                            }
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
                            if isLoading {
                                self.loadingFinish?()
                            }
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
                                        }else{
                                            if let result = data["result"] as? [[String:AnyObject]] {
                                                succeeded?(result as AnyObject)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            break
                            
                        }
                        
                    }
                case .failure(let encodingError):
                    if isLoading {
                        self.loadingFinish?()
                    }
                    print(encodingError)
                }
        })
    }
    
    func loadImage(_ pathImage:String,_ defaultImage:String, result:( (_ image:UIImage) ->Void)? = nil){
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(pathImage, method: .get, parameters: nil , headers: header).responseData { (data) in
          
            if data.result.value != nil {
                let img = UIImage(data: data.result.value!)
                if img != nil {
                    result?(img!)
                }else{
                    result?(UIImage(named: defaultImage)!)
                }
                
            }else{
                result?(UIImage(named: defaultImage)!)
            }
        }
    }
    
    
    func registerGoldMember(_ params:Parameters?,
                            _ image:UIImage,
                            _ isLoading:Bool = true,
                            succeeded:( (_ result:AnyObject) ->Void)? = nil,
                            error:((_ errorObject:AnyObject)->Void)?,
                            failure:( (_ statusCode:String) ->Void)? = nil ,
                            inprogress:((_ progress:Double) ->Void)? = nil ,
                            uploadTask:((_ uploadtask:UploadRequest) ->Void)? = nil ){
        
        
        let imageData = image.pngData()!
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        if isLoading {
            self.loadingStart?()
        }
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "card_img", fileName: "avatar.png", mimeType: "image/png")
               
                if let param =  params {
                    for (key, value) in param {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                }
                
        },
            to: Constant.PointPowAPI.registerGoldMember,
            headers : header,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    uploadTask?(upload)
                    upload.uploadProgress(closure: { (progress) in
                        print(progress.fractionCompleted)
                        if progress.fractionCompleted >= 1 {
//                            if isLoading {
//                                self.loadingFinish?()
//                            }
                        }
                        inprogress?(progress.fractionCompleted)
                    })
                    
                    upload.validate().responseJSON { response in
                        
                        switch response.result {
                        case .success(let json):
                            if isLoading {
                                self.loadingFinish?()
                            }
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
                            if isLoading {
                                self.loadingFinish?()
                            }
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
                                        }else{
                                            if let result = data["result"] as? [[String:AnyObject]] {
                                                succeeded?(result as AnyObject)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            break
                            
                        }
                        
                    }
                case .failure(let encodingError):
                    if isLoading {
                        self.loadingFinish?()
                    }
                    print(encodingError)
                }
        })
    }
    
    
    func updateGoldMember(_ params:Parameters?,
                            _ image:UIImage?,
                            _ isLoading:Bool = true,
                            succeeded:( (_ result:AnyObject) ->Void)? = nil,
                            error:((_ errorObject:AnyObject)->Void)?,
                            failure:( (_ statusCode:String) ->Void)? = nil ,
                            inprogress:((_ progress:Double) ->Void)? = nil ,
                            uploadTask:((_ uploadtask:UploadRequest) ->Void)? = nil ){
        
        
        let imageData = image?.pngData() ?? nil
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        if isLoading {
            self.loadingStart?()
        }
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                if imageData != nil {
                    multipartFormData.append(imageData!, withName: "card_img", fileName: "avatar.png", mimeType: "image/png")
                }
                
                if let param =  params {
                    for (key, value) in param {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                }
                
        },
            to: Constant.PointPowAPI.updateGoldMember,
            headers : header,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    uploadTask?(upload)
                    upload.uploadProgress(closure: { (progress) in
                        print(progress.fractionCompleted)
                        if progress.fractionCompleted >= 1 {
                            if isLoading {
                                //self.loadingFinish?()
                            }
                        }
                        inprogress?(progress.fractionCompleted)
                    })
                    
                    upload.validate().responseJSON { response in
                        
                        switch response.result {
                        case .success(let json):
                            if isLoading {
                                self.loadingFinish?()
                            }
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
                            if isLoading {
                                self.loadingFinish?()
                            }
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
                                        }else{
                                            if let result = data["result"] as? [[String:AnyObject]] {
                                                succeeded?(result as AnyObject)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            break
                            
                        }
                        
                    }
                case .failure(let encodingError):
                    if isLoading {
                        self.loadingFinish?()
                    }
                    print(encodingError)
                }
        })
    }
    
    
    
    
    func logOut(params:Parameters? = nil,
                _ isLoading:Bool = true,
                succeeded:( (_ result:AnyObject) ->Void)?,
                error:((_ errorObject:AnyObject)->Void)? = nil,
                failure:( (_ statusCode:String) ->Void)? = nil ){
        

        
        if isLoading {
            self.loadingStart?()
        }
        
        let token = DataController.sharedInstance.getToken()
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        
        Alamofire.request(Constant.PointPowAPI.memberLogout , method: .get ,
                          parameters : params,
                          headers: header).validate().responseJSON { response in
                            
                            if isLoading {
                                self.loadingFinish?()
                            }
                            switch response.result {
                            case .success(let json):
                                print(json)
                                
                                if let data = json as? [String:AnyObject] {
                                    let success = data["success"] as? NSNumber  ??  0
                                   
                                    if success.intValue == 1 {
                                        DataController.sharedInstance.clearNotificationArrayOfObjectData()
                                        DataController.sharedInstance.setToken("")
                                        succeeded?("logut success" as AnyObject)
                                        
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
                                            }else{
                                                if let result = data["result"] as? [[String:AnyObject]] {
                                                    succeeded?(result as AnyObject)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                break
                                
                            }
        }
    
    }
    
    
}
