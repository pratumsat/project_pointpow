//
//  L102Language.swift
//  pointpow
//
//  Created by thanawat on 6/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

// constants
let APPLE_LANGUAGE_KEY = "AppleLanguages"
/// L102Language
class L102Language {
    /// get current Apple language
    class func currentAppleLanguage() -> String{
        var langStr = "en"
        let saveLang = UserDefaults.standard.object(forKey: APPLE_LANGUAGE_KEY) as? [String] ?? nil
        if saveLang != nil {
            langStr = saveLang![0].substring(start: 0, end: 2)
        }else{
            langStr = Locale.current.languageCode!
        }
        return langStr.lowercased()
    }
    
    class func currentAppleLanguageFull() -> String{
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        return current
    }
    
    /// set @lang to be the first in Applelanguages list
    class func setAppleLAnguageTo(lang: String) {
        let userdef = UserDefaults.standard
        userdef.set([lang, currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
    }
    
}
