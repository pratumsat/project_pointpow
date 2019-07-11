//
//  DataController.swift
//  pointpow
//
//  Created by thanawat on 11/12/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import Foundation


class DataController {
    
    static let sharedInstance : DataController = {
        let instance = DataController(data: [:] )
        return instance
    }()
    
    //MARK: Local Variable
    var data : [String:AnyObject]
    
    //MARK: Init
    init( data : [String:AnyObject]) {
        self.data = data
    }
    func retrieveToken(){
        if let token = UserDefaults.standard.object(forKey: Constant.CacheNotification.USER_TOKEN_CACHE) as? String {
            if !token.isEmpty {
                data["token"] = token as AnyObject
            }
        }
    }
    
    func getProfilPath() -> String{
        return self.data["profilPath"] as? String ?? ""
    }
    
    func setProfilPath(_ url:String ){
         self.data["profilPath"] = url as AnyObject
    }
    
    func countTimeLockScreen() -> Bool{
        
        let latest = self.data["timeStemp"] as? String ?? ""
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en")
        
        guard let targedDate = dateFormatter.date(from: latest) else {return true}
        guard let current = dateFormatter.date(from: getCurrentTimeStamp(dateToConvert: Date())) else {return true}
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.second, .minute, .hour, .day, .month, .year]
        let component = calendar.dateComponents(unitFlags, from: targedDate, to: current)
        
        let minutes = component.minute!
        
        
        if minutes >= 2 {
            return true
        }else{
            return false
        }
    }
    func setTimeLatest(){
        let timeStemp = getCurrentTimeStamp(dateToConvert: Date())
        self.data["timeStemp"] = timeStemp as AnyObject
    }
    
    func getCurrentTimeStamp(dateToConvert: Date) -> String {
        let objDateformat: DateFormatter = DateFormatter()
        objDateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        objDateformat.locale = Locale(identifier: "en")
        let strTime: String = objDateformat.string(from: dateToConvert as Date) 
        return strTime
    }
    
    func setDataGoldPremium(_ data:AnyObject){
        UserDefaults.standard.set(data, forKey: "dataGoldPremiumPrice")
        UserDefaults.standard.synchronize()
    }
    func getDataGoldPremium() -> AnyObject? {
        return UserDefaults.standard.object(forKey: "dataGoldPremiumPrice") as AnyObject
    }
    func getDefaultLanguage() -> Bool{
        let defaultLanguage = UserDefaults.standard.object(forKey: "defaultAppLanguage") as? Bool ?? false
        return defaultLanguage
    }
    func setDefaultLanguage(){
        UserDefaults.standard.set(true, forKey: "defaultAppLanguage")
        UserDefaults.standard.synchronize()
    }
    
    func setToken(_ token:String){
        UserDefaults.standard.set(token, forKey: Constant.CacheNotification.USER_TOKEN_CACHE)
        UserDefaults.standard.synchronize()
        
        data["token"] = token as AnyObject
    }
    func getToken() -> String {
        return data["token"] as? String ?? ""
    }
    
    func setSaveSlip(_ token:Bool){
        data["save_slip"] = token as AnyObject
    }
   
    func getSaveSlip() -> Bool {
        return data["save_slip"] as? Bool ?? false
    }
    func setCurrentPointBalance(_ value:NSNumber){
        data["current_point_balance"] = value
    }
    func getCurrentPointBalance()-> NSNumber{
        return data["current_point_balance"] as? NSNumber ?? 0
    }
    
    func setFaceID(_ faceID:Bool){
        UserDefaults.standard.set(faceID, forKey: Constant.CacheNotification.USER_FACE_ID_CACHE)
        UserDefaults.standard.synchronize()
    }
    
    func getFaceID() -> Bool {
        return UserDefaults.standard.object(forKey: Constant.CacheNotification.USER_FACE_ID_CACHE) as? Bool ?? false
    }
    
    
    func setPasscode(_ passcode:String){
        UserDefaults.standard.set(passcode, forKey: Constant.CacheNotification.USER_PINCODE_CACHE)
        UserDefaults.standard.synchronize()
        
    }
    func getPasscode() -> String{
        if let passcode = UserDefaults.standard.object(forKey: Constant.CacheNotification.USER_PINCODE_CACHE) as? String {  
            return passcode
        }
        return ""
    }
    
    func setActivateToken(_ token:String){
        UserDefaults.standard.set(token, forKey: Constant.CacheNotification.USER_ACTIVATE_TOKEN_CACHE)
        UserDefaults.standard.synchronize()
    }
    func getActivateToken() -> String{
        let token = UserDefaults.standard.object(forKey: Constant.CacheNotification.USER_ACTIVATE_TOKEN_CACHE) as? String ?? ""
        return token
    }
    func setResetPasswordToken(_ token:String){
        UserDefaults.standard.set(token, forKey: Constant.CacheNotification.USER_RESET_PASSWORD_TOKEN_CACHE)
        UserDefaults.standard.synchronize()
    }
    func getResetPasswordToken() -> String{
        let token = UserDefaults.standard.object(forKey: Constant.CacheNotification.USER_RESET_PASSWORD_TOKEN_CACHE) as? String ?? ""
        return token
    }
    
    func setResetPinToken(_ token:String){
        UserDefaults.standard.set(token, forKey: Constant.CacheNotification.USER_RESET_PIN_TOKEN_CACHE)
        UserDefaults.standard.synchronize()
    }
    func getResetPinToken() -> String{
        let token = UserDefaults.standard.object(forKey: Constant.CacheNotification.USER_RESET_PIN_TOKEN_CACHE) as? String ?? ""
        return token
    }
    
    func setRequestId(_ request_id:String){
        data["request_id"] = request_id as AnyObject
    }
    func getRequestId() -> String{
        return data["request_id"] as? String ?? ""
    }
    
    
    func isLogin() -> Bool {
        let token = data["token"] as? String ?? ""
        if token != "" {
            return true
        }
        return false
    }

    
    
    func getVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as? String ?? "Unknown"
        //let build = dictionary["CFBundleVersion"] as! String
        return version
    }
    
    
    
    func saveNotifiacationArrayOfObjectData(newNoti: NotificationStruct){

        var myObject:NotificationStructHolder
        if let  cacheVersion = getNotificationArrayOfObjectData() {
            myObject = cacheVersion
        }else{
            myObject = NotificationStructHolder()
        }

        myObject.addToArray(item: newNoti)

        let arrrayOfObjectData = NSKeyedArchiver.archivedData(withRootObject: myObject)
        UserDefaults.standard.set(arrrayOfObjectData, forKey: Constant.CacheNotification.NAME_CACHE)
        UserDefaults.standard.synchronize()

    }

    func saveNewArraysStructHolder(arrayOfObjectData:[NotificationStruct]? = nil) {
        if arrayOfObjectData == nil{
            return
        }
        let  myObject = NotificationStructHolder()
        myObject.setArray(array: (arrayOfObjectData!.reversed()))

        let arrrayOfObjectData = NSKeyedArchiver.archivedData(withRootObject: myObject)
        UserDefaults.standard.set(arrrayOfObjectData, forKey: Constant.CacheNotification.NAME_CACHE)
        UserDefaults.standard.synchronize()
    }
    func getNotificationArrayOfObjectData() -> NotificationStructHolder? {
        //check nil
        if nil == UserDefaults.standard.object(forKey: Constant.CacheNotification.NAME_CACHE){
            return nil
        }
        guard let cacheVersion:NotificationStructHolder = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: Constant.CacheNotification.NAME_CACHE) as! Data)  as? NotificationStructHolder
            else{
                return nil
        }
        return cacheVersion
    }
    func clearNotificationArrayOfObjectData() {
        UserDefaults.standard.set(nil, forKey: Constant.CacheNotification.NAME_CACHE)
        UserDefaults.standard.synchronize()
    }
    
}
