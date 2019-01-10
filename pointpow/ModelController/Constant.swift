//
//  Constant.swift
//  ShopSi
//
//  Created by thanawat on 11/9/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    func setCustomTitleView(_ title:String){
        let titleView = UILabel()
        titleView.font = UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.TITLE)
        titleView.textColor = UIColor.white
        titleView.text = title
        titleView.addSpacingCharacters(2.0)
        titleView.sizeToFit()
        self.navigationItem.titleView = titleView
        
    }
}
extension UILabel{
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // (Swift 4.2 and above) Line spacing attribute
        //attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        
        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
extension UIButton{
    func addSpacingCharacters(_ spacing:CGFloat, underline:Bool = false, title:String? = nil , color:UIColor? = nil){
        
        let attributedString = NSMutableAttributedString(string: title ?? (self.titleLabel?.text!)!)
        attributedString.addAttribute(NSAttributedString.Key.kern,
                                      value: spacing,
                                      range: NSRange(location: 0, length: title?.count ?? (self.titleLabel?.text!.count)!))

        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: color ?? self.titleColor(for: .normal)!,
                                      range: NSRange(location: 0, length: title?.count ?? (self.titleLabel?.text!.count)!))

        
        if underline {
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: title?.count ?? (self.titleLabel?.text!.count)!))
        }
        UIView.setAnimationsEnabled(false)
        self.setAttributedTitle(attributedString, for: .normal)
        layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
        
        
    }
    
}
extension UILabel{
    func addSpacingCharacters(_ spacing:CGFloat){
    
        let attributedString = NSMutableAttributedString(string: self.text!)
        // Character spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.kern,
                                      value: spacing,
                                      range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
        
        
    }
}

extension UITextField {
    
    func addBottomLabelErrorMessage(_ errorMessage:String, marginLeft:CGFloat = 0 , marginBottom:CGFloat = 25) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.UNDER_TEXTFIELD)
        label.textColor = UIColor.red
        label.text = errorMessage
        label.sizeToFit()
        self.addSubview(label)
        
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: marginBottom).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: marginLeft).isActive = true
        
        
        
        return label
    }
    func addRightButton(_ image:UIImage) -> UIImageView {
        let width = self.frame.height*0.4
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        self.rightView = imageView
        self.rightViewMode = UITextField.ViewMode.always
        
        return imageView
        
    }
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIView {
    func animationTapped(_ completed:(()->Void)? = nil){
        self.alpha = 0
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1
            completed?()
        }
    }
    
    func drawLightningView(){
        let height = self.frame.height
        let width = self.frame.width
        //draw crop
        let path = UIBezierPath()
        let linePath = UIBezierPath()
        //draw line
        let layer = CAShapeLayer()
        let linelayer = CAShapeLayer()
        
        path.move(to: CGPoint(x: width, y: -2))
        path.addLine(to: CGPoint(x: -20, y: -2))
        
        linePath.move(to: CGPoint(x: -20, y: -2))
        
        var scaleX = CGFloat(0)
        var scaleY = CGFloat(12)
        
        
        for i in 0..<35 {
            if i % 2 == 0 {
                scaleY = 12
            }else{
                scaleY = 1
            }
            linePath.addLine(to: CGPoint(x: width*scaleX, y: height - scaleY))
            path.addLine(to: CGPoint(x: width*scaleX, y: height - scaleY))
            scaleX += 0.03
        }
        //crop
        layer.path = path.cgPath
        
        //draw line
        linelayer.path = linePath.cgPath
        linelayer.strokeColor = UIColor.clear.cgColor
        linelayer.fillColor = UIColor.clear.cgColor
        
        self.layer.mask = layer
        self.layer.addSublayer(linelayer)
        
    }

    public func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage
    }
    public func snapshotView() -> UIView? {
        if let snapshotImage = snapshotImage() {
            return UIImageView(image: snapshotImage)
        } else {
            return nil
        }
    }
    func blurImage(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours, locations: nil)
    }
    
    func applyGradient(_ colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func borderRedColorProperties(borderWidth:CGFloat = 1.0){
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = Constant.Colors.PRIMARY_COLOR.cgColor
        self.layer.masksToBounds = true
    }
    func borderLightGroupTableColorProperties(borderWidth:CGFloat = 1.0){
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.layer.masksToBounds = true
    }
    func borderLightGrayColorProperties(borderWidth:CGFloat = 1.0){
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds = true
    }
    func borderDarkGrayColorProperties(borderWidth:CGFloat = 1.0){
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.masksToBounds = true
    }
    func borderWhiteProperties(borderWidth:CGFloat = 1.0){
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.masksToBounds = true
    }
    func borderProperties(borderWidth:CGFloat = 1.0){
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = self.backgroundColor?.cgColor
        self.layer.masksToBounds = true
    }
    func borderClearProperties(borderWidth:CGFloat = 1.0 , radius:CGFloat? = nil){
        self.layer.cornerRadius = radius ?? self.frame.size.height/2;
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
    }
    func shadowCellProperties() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3
        self.layer.masksToBounds = false
    }
    func updateLayerCornerRadiusProperties(){
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
    }
    func ovalColorWhiteProperties(borderWidth:CGFloat = 1.0){
        self.layer.cornerRadius = self.frame.size.width/2;
        self.layer.borderColor =  UIColor.white.cgColor
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true;
    }
    func ovalColorClearProperties(){
        self.layer.cornerRadius = self.frame.size.width/2;
        self.clipsToBounds = true;
    }
    func ovalColoLightGrayProperties(borderWidth:CGFloat = 1.0){
        self.layer.cornerRadius = self.frame.size.width/2;
        self.layer.borderColor =  Constant.Colors.LINE_PROFILE.cgColor
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true;
    }
    
}

public extension UIWindow {
    
    func capture() -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.isOpaque, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
      
        return image
    }
}



extension UIImage{
    class func colorForNavBar(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        //    Or if you need a thinner border :
        //    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    func resizeUIImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0, width:newSize.width, height:newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return  cropToBounds(image: newImage!, size: CGSize(width: targetSize.width/2, height: targetSize.height/2))
    }
    private func cropToBounds(image: UIImage, size: CGSize) -> UIImage {
        guard let cgimage = image.cgImage else { return image }
        
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        
        var cropWidth: CGFloat = size.width
        var cropHeight: CGFloat = size.height
        
        if (image.size.height < size.height || image.size.width < size.width){
            return image
        }
        
        let heightPercentage = image.size.height/size.height
        let widthPercentage = image.size.width/size.width
        
        if (heightPercentage < widthPercentage) {
            cropHeight = size.height*heightPercentage
            cropWidth = size.width*heightPercentage
        } else {
            cropHeight = size.height*widthPercentage
            cropWidth = size.width*widthPercentage
        }
        
        let posX: CGFloat = (image.size.width - cropWidth)/2
        let posY: CGFloat = (image.size.height - cropHeight)/2
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let cropped: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return cropped
        
    }
    

}
extension Collection {
    public func chunk(n: Int) -> [SubSequence] {
        var res: [SubSequence] = []
        var i = startIndex
        var j: Index
        while i != endIndex {
            var na = n
            if res.count == 2 {
                na = n + 1
            }
            j = index(i, offsetBy: na, limitedBy: endIndex) ?? endIndex
            res.append(self[i..<j])
            i = j
           
        }
        return res
    }
    public func chunkP(n: Int) -> [SubSequence] {
        var res: [SubSequence] = []
        var i = startIndex
        var j: Index
        while i != endIndex {
            var na = n
            if res.count == 1 {
                na = n + 3
            }
            if res.count == 2 {
                na = n + 4
            }
            if res.count == 3 {
                na = n + 1
            }
            j = index(i, offsetBy: na, limitedBy: endIndex) ?? endIndex
            res.append(self[i..<j])
            i = j
            
        }
        return res
    }
}
extension URL {
    var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil}
        
        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {
            
            let key = pair.components(separatedBy: "=")[0]
            
            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            
            queryStrings[key] = value
        }
        return queryStrings
    }
}
extension String {
    func chunkFormatted(withChunkSize chunkSize: Int = 3, withSeparator separator: Character = "-") -> String {
        return self.filter { $0 != separator }.chunk(n: chunkSize).map{ String($0) }.joined(separator: String(separator))
    }
    func chunkFormattedPersonalID(withChunkSize chunkSize: Int = 1, withSeparator separator: Character = "-") -> String {
        return self.filter { $0 != separator }.chunkP(n: chunkSize).map{ String($0) }.joined(separator: String(separator))
    }
    
    func replace(target: String, withString: String) -> String{
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    
    func substring(start: Int, end: Int) -> String{
        if (start < 0 || start > self.count){
            print("start index \(start) out of bounds")
            return ""
        }
        else if end < 0 || end > self.count{
            print("end index \(end) out of bounds")
            return ""
        }
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: end)
        let range = startIndex..<endIndex
        
        return String(self[range])
    }
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

struct Constant {
    struct PointPowAPI {
        static let HOST = "http://192.168.1.43/pointpow-api/public/api/"
        static let loginWithEmailORMobile  = "\(HOST)v1/login"
        static let registerWithEmail  = "\(HOST)v1/register-email"
        static let registerWithMobile  = "\(HOST)v1/register-mobile"
        static let loginWithSocial  = "\(HOST)v1/social-login"
        static let verifyOTP  = "\(HOST)v1/otp-verify"
        
    }
    struct TopViewController{
        static var top: UIViewController? {
            get {
                return topViewController()
            }
        }
        static func topViewController(from viewController: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
            if let tabBarViewController = viewController as? UITabBarController {
                return topViewController(from: tabBarViewController.selectedViewController)
            } else if let navigationController = viewController as? UINavigationController {
                return topViewController(from: navigationController.visibleViewController)
            } else if let presentedViewController = viewController?.presentedViewController {
                return topViewController(from: presentedViewController)
            } else {
                return viewController
            }
        }
    }
    struct CacheNotification {
        static let USER_ACTIVATE_TOKEN_CACHE = "USER_ACTIVATE_TOKEN_CACHE"
        static let USER_TOKEN_CACHE = "USER_TOKEN"
        static let NAME_CACHE = "NotiStructHolder"
        static let NAME_CACHE_OBJECT = "NotiStructObject"
        
    }
    enum ViewBorder: String {
        case left, right, top, bottom
    }
    struct DefaultConstansts {
        static let RESET_PASSWORD = "RESET_PASSWORD"
        static let VERIFI_EMAIL_REGISTER = "VERIFI_EMAIL_REGISTER"
        static let NOTIFICATION_SELECTED_PAGE = "NOTIFICATION_SELECTED_PAGE"
        static let NotificationGoogleSigInSuccess = "NotificationGoogleSigInSuccess"
        static let NotificationGoogleSigInFailure = "NotificationGoogleSigInFailure"
    }
    struct Colors {
        static let PRIMARY_COLOR = UIColor(rgb: 0xFF002F)
        static let LINE_COLOR = UIColor.groupTableViewBackground
        static let LINE_PROFILE = UIColor(rgb: 0xCCCCCC)
        static let GRADIENT_1 = UIColor(rgb: 0xFF2158) //top
        static let GRADIENT_2 = UIColor(rgb: 0xFE2222) //bottom
    }
    struct Fonts {
        struct Size {
            static let BIG_TITLE = CGFloat(28.0)
            static let TITLE = CGFloat(23.0)
            static let ITEM_TITLE = CGFloat(20.0)
            static let BUTTON = CGFloat(22.0)
            static let TEXTFIELD = CGFloat(20.0)
            static let UNDER_TEXTFIELD = CGFloat(15.0)
            static let CONTENT = CGFloat(22.0)
            static let TAB = CGFloat(12.0)
            static let FREIND_RECENT = CGFloat(15.0)
            static let FRIEND_HEADER_RECENT = CGFloat(20.0)
            
        }
        static let THAI_SANS_BOLD = "ThaiSansNeue-Bold"
        static let THAI_SANS_REGULAR = "ThaiSansNeue-Regular"
    }
    struct ApiMain {
        //
    }
}



func checkPrefixcellPhone(_ mobile:String) ->Bool {
    let prefixZero = mobile.hasPrefix("0")
    if  prefixZero  {
        return true
    }else{
        return false
    }
}

func fontList(){
    for family: String in UIFont.familyNames
    {
        print("\(family)")
        for names: String in UIFont.fontNames(forFamilyName: family)
        {
            print("== \(names)")
        }
    }
}

func validPassword(_ password:String) ->Bool {
    if password.count < 6 {
        return false
    }
    let array = Array(password)
    
    
    var str = 0
    var digi = 0
    for each in array {
        if isValidNumber(each.description){
            digi += 1
        }else{
            str += 1
        }
    }
    print(array)
    print("str = \(str)")
    print("digi = \(digi)")
    
    if str != 0 && digi != 0{
        return true
    }else{
        return false
    }
    
}

func isValidEmail(_ email:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
}

func isValidString(_ str:String) -> Bool{
    let alphaSet = NSCharacterSet.alphanumerics
    
    let valid = str.trimmingCharacters(in: alphaSet)
    if valid == "" {
        return true
    }else{
        return false
    }
}

func isValidNumber(_ str:String) -> Bool{
    let alphaSet = NSCharacterSet.decimalDigits
    
    let valid = str.trimmingCharacters(in: alphaSet)
    if valid == "" {
        return true
    }else{
        return false
    }
}


func isValidIDCard(_ idCard:String) -> Bool{
    if idCard.count != 13  { return false }
    var sum:Int = 0
    for i in 0..<12 {
        let pos = Array(idCard)[i].description
        sum += Int(pos)! * Int(13 - i)
    }
    let mod = (11 - (sum % 11)) % 10
    let lastdigi = Array(idCard)[12].description
    if mod == Int(lastdigi) {
        return true
        
    }
    return false
}

func heightForView(text:String, font:UIFont, width:CGFloat, lineHeight:Bool = false) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    if lineHeight {
        label.setLineSpacing(lineSpacing: 0, lineHeightMultiple: 0.7)
    }
    label.sizeToFit()
    
    return label.frame.height
}



func convertDateOfDay(_ dateString:String) -> String {
    //2017-03-29 20:15:25.000+00:00
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSz"
    if let d1 = dateFormatter.date(from: dateString){
        
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let components = calendar.dateComponents(unitFlags, from: d1)
        
        
        var newStringDate = String(format: "%02d", components.day!)
        newStringDate += "-\(String(format: "%02d", components.month!))"
        newStringDate += "-\(String(format: "%02d", components.year!))"
        
        print("\(newStringDate)")
        return newStringDate
        
    }
    
    return "-"
}
func convertDate(_ dateString:String , pattern:String = "haveSecond") -> String {
    //2017-03-29 20:15:25.000+00:00
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSz"
    if let d1 = dateFormatter.date(from: dateString){
        
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let components = calendar.dateComponents(unitFlags, from: d1)
        
        
        var newStringDate = String(format: "%02d", components.day!)
        newStringDate += "-\(String(format: "%02d", components.month!))"
        newStringDate += "-\(String(format: "%02d", components.year!))"
        newStringDate += " \(String(format: "%02d", components.hour!))"
        newStringDate += ":\(String(format: "%02d", components.minute!))"
        
        if pattern == "haveSecond" {
            newStringDate += ":\(String(format: "%02d", components.second!))"
        }
        
        
        print("\(newStringDate)")
        return newStringDate
        
    }
    
    return "-"
}
func dateNow() -> String {
    let d1 = Date()
    
    let calendar = NSCalendar.current
    let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
    let components = calendar.dateComponents(unitFlags, from: d1)
    
    
    var newStringDate = String(format: "%02d", components.day!)
    newStringDate += "-\(String(format: "%02d", components.month!))"
    newStringDate += "-\(String(format: "%02d", components.year!))"
    //    newStringDate += " \(String(format: "%02d", components.hour!))"
    //    newStringDate += ":\(String(format: "%02d", components.minute!))"
    //    newStringDate += ":\(String(format: "%02d", components.second!))"
    //
    print("\(newStringDate)")
    return newStringDate
    
}










