//
//  Constant.swift
//  ShopSi
//
//  Created by thanawat on 11/9/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import Foundation
import UIKit


extension UIAlertController {
    
    func show() {
        present(true, completion: nil)
    }
    
    func present(_ animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }
    
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if  let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            presentFromController(controller: visibleVC, animated: animated, completion: completion)
        } else {
            if  let tabVC = controller as? UITabBarController,
                let selectedVC = tabVC.selectedViewController {
                presentFromController(controller: selectedVC, animated: animated, completion: completion)
            } else {
                controller.present(self, animated: animated, completion: completion)
            }
        }
    }
}

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
    func copyView<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
    func subViews<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        for view in self.subviews {
            if let aView = view as? T{
                all.append(aView)
            }
        }
        return all
    }
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
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
    
    func drawLightningView(width:CGFloat, height:CGFloat){
        let height = height
        let width = width
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
        blurEffectView.alpha = 0.8
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
    
    func borderRedColorProperties(borderWidth:CGFloat = 1.0, radius:CGFloat? = nil){
        self.layer.cornerRadius = radius ?? self.frame.size.height/2
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
    func borderLightGrayColorProperties(borderWidth:CGFloat = 1.0 ,  radius:CGFloat? = nil){
        self.layer.cornerRadius = radius ?? self.frame.size.height/2;
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds = true
    }
    func borderBlackolorProperties(borderWidth:CGFloat = 1.0 ,  radius:CGFloat? = nil){
        self.layer.cornerRadius = radius ?? self.frame.size.height/2;
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.black.cgColor
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


extension UITextField{
    func addDoneButtonToKeyboard(doneButton:UIBarButtonItem? = nil){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        var done : UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        
        if doneButton != nil {
            done = doneButton!
        }
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction(){
        self.resignFirstResponder()
        
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
        
        return  newImage!
        //cropToBounds(image: newImage!, size: CGSize(width: targetSize.width/2, height: targetSize.height/2))
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
    public func chunkL(n: Int) -> [SubSequence] {
        var res: [SubSequence] = []
        var i = startIndex
        var j: Index
        while i != endIndex {
            var na = n
            if res.count == 1 {
                na = n + 4
            }
            if res.count == 2 {
                na = n + 2
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
    func chunkFormattedLaserID(withChunkSize chunkSize: Int = 3, withSeparator separator: Character = "-") -> String {
        return self.filter { $0 != separator }.chunkL(n: chunkSize).map{ String($0) }.joined(separator: String(separator))
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
func addOnHeightModelDevice() -> CGFloat {
    let model = UIDevice().modelName
    switch model.lowercased() {
    case "iphone 4", "iphone 4s":
        return 100.0
    
    case "iphone 5" , "iphone 5s", "iphone 5c":
        return 60.0
        
    default:
        return 0.0
    }
   
}
public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

struct Constant {
    struct PointPowAPI {
        
        static let HOST = "http://103.27.201.106/dev-pointpow/api/public/api/"
        static let POINTPOW_VERSION1 = "v1/"
        static let updateDeviceToken  = "\(HOST)\(POINTPOW_VERSION1)member/update-device-token"
        static let addDeviceToken = "\(HOST)\(POINTPOW_VERSION1)device-token"
        static let loginWithEmailORMobile  = "\(HOST)\(POINTPOW_VERSION1)login"
        static let registerWithEmail  = "\(HOST)\(POINTPOW_VERSION1)register-email"
        static let registerWithMobile  = "\(HOST)\(POINTPOW_VERSION1)register-mobile"
        static let loginWithSocial  = "\(HOST)\(POINTPOW_VERSION1)social-login"
        static let verifyOTP  = "\(HOST)\(POINTPOW_VERSION1)otp-verify"
        static let resendOTP  = "\(HOST)\(POINTPOW_VERSION1)otp-resend"
        static let forgotPassword  = "\(HOST)\(POINTPOW_VERSION1)reset-password"
        static let setNewPassword = "\(HOST)\(POINTPOW_VERSION1)set-new-password"
        static let userData = "\(HOST)\(POINTPOW_VERSION1)member/get"
        static let addImageProfile = "\(HOST)\(POINTPOW_VERSION1)member/upload-profile-image"
        static let addBackgroundImageProfile = "\(HOST)\(POINTPOW_VERSION1)member/upload-background-image"
        static let memberAddress = "\(HOST)\(POINTPOW_VERSION1)member/address"
        
        static let setPinCode = "\(HOST)\(POINTPOW_VERSION1)member/set-pin"
        static let resetPinCode = "\(HOST)\(POINTPOW_VERSION1)member/set-reset-pin"
        static let enterPinCode = "\(HOST)\(POINTPOW_VERSION1)member/check-pin"
        static let forgotPinCode = "\(HOST)\(POINTPOW_VERSION1)member/reset-pin"
        static let statusPinCode = "\(HOST)\(POINTPOW_VERSION1)member/check-pin-status"
        
        static let registerGoldMember = "\(HOST)\(POINTPOW_VERSION1)gold-saving/register"
        static let updateGoldMember = "\(HOST)\(POINTPOW_VERSION1)gold-saving/update"
        static let goldPrice = "\(HOST)\(POINTPOW_VERSION1)gold-saving/get/gold-price"
        static let savingGold = "\(HOST)\(POINTPOW_VERSION1)gold-saving/saving"
        static let withdrawGold = "\(HOST)\(POINTPOW_VERSION1)gold-saving/withdraw"
        static let goldPremiumPrice = "\(HOST)\(POINTPOW_VERSION1)gold-saving/get/premium-price"
        static let servicePriceThaiPost = "\(HOST)\(POINTPOW_VERSION1)gold-saving/get/shipping-price"
        static let transectionGold = "\(HOST)\(POINTPOW_VERSION1)gold-saving/get/history"
        static let goldhistory = "\(HOST)\(POINTPOW_VERSION1)gold-saving/get/history"
        static let cancelTransectionGold = "\(HOST)\(POINTPOW_VERSION1)gold-saving/withdraw/cancel"
        static let privilegeLuckydraw = "\(HOST)\(POINTPOW_VERSION1)gold-saving/luckydraw/privilege"
        static let winnerLuckydraw = "\(HOST)\(POINTPOW_VERSION1)gold-saving/luckydraw/winner"
        
        
        static let banners = "\(HOST)\(POINTPOW_VERSION1)banners"
        
        static let province = "\(HOST)\(POINTPOW_VERSION1)provinces"
        static let districts = "\(HOST)\(POINTPOW_VERSION1)districts"
        static let subdistricts = "\(HOST)\(POINTPOW_VERSION1)subdistricts"
        
    }
    struct PathImages {
        static let profile = "\(PointPowAPI.HOST)\(PointPowAPI.POINTPOW_VERSION1)member/image/profile"
        static let background = "\(PointPowAPI.HOST)\(PointPowAPI.POINTPOW_VERSION1)member/image/profile-background"
        static let idCard = "\(PointPowAPI.HOST)\(PointPowAPI.POINTPOW_VERSION1)gold-saving/get/id-card"
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
        static let USER_RESET_PIN_TOKEN_CACHE = "USER_RESET_PIN_TOKEN_CACHE"
        static let USER_RESET_PASSWORD_TOKEN_CACHE = "USER_RESET_PASSWORD_TOKEN_CACHE"
        static let USER_ACTIVATE_TOKEN_CACHE = "USER_ACTIVATE_TOKEN_CACHE"
        static let USER_TOKEN_CACHE = "USER_TOKEN"
        static let NAME_CACHE = "NotiStructHolder"
        static let NAME_CACHE_OBJECT = "NotiStructObject"
        
    }
    enum ViewBorder: String {
        case left, right, top, bottom
    }
    struct DefaultConstansts {
        static let RESET_PIN = "RESET_PIN"
        static let RESET_PASSWORD = "RESET_PASSWORD"
        static let VERIFI_EMAIL_REGISTER = "VERIFI_EMAIL_REGISTER"
        static let NOTIFICATION_SELECTED_PAGE = "NOTIFICATION_SELECTED_PAGE"
        static let NotificationGoogleSigInSuccess = "NotificationGoogleSigInSuccess"
        static let NotificationGoogleSigInFailure = "NotificationGoogleSigInFailure"
        
            struct DefaultImaege{
                static let PROFILE_PLACEHOLDER = "ic-gold-profile"
                static let PROFILE_BACKGROUND_PLACEHOLDER = "bg-profile-image"
        }
    }
    struct Colors {
        static let SELECTED_RED = UIColor(rgb: 0xFCE2E6)
        static let PRIMARY_COLOR = UIColor(rgb: 0xFF002F)
        static let LINE_COLOR = UIColor.groupTableViewBackground
        static let LINE_PROFILE = UIColor(rgb: 0xCCCCCC)
        static let GRADIENT_1 = UIColor(rgb: 0xFF2158) //top
        static let GRADIENT_2 = UIColor(rgb: 0xFE2222) //bottom
        static let GREEN = UIColor(rgb: 0x43922B)
        static let ORANGE = UIColor(rgb: 0xF4B55A)
        static let COLOR_LLGRAY = UIColor(rgb: 0xEEEEEE)
    }
    struct Fonts {
        struct Size {
//            static let TITLE = CGFloat(19.0)
//            static let ITEM_TITLE = CGFloat(16.0)
//            static let BUTTON = CGFloat(18.0)
//            static let TEXTFIELD = CGFloat(16.0)
//            static let UNDER_TEXTFIELD = CGFloat(11.0)
//            static let CONTENT = CGFloat(18.0)
//            static let TAB = CGFloat(8.0)
//            static let FREIND_RECENT = CGFloat(11.0)
//            static let FRIEND_HEADER_RECENT = CGFloat(16.0)
            
            static let TITLE = CGFloat(23.0)
            static let ITEM_TITLE = CGFloat(20.0)
            static let BUTTON = CGFloat(22.0)
            static let TEXTFIELD = CGFloat(20.0)
            static let UNDER_TEXTFIELD = CGFloat(15.0)
            static let CONTENT = CGFloat(22.0)
            static let TAB = CGFloat(13.0)
            static let FREIND_RECENT = CGFloat(15.0)
            static let FRIEND_HEADER_RECENT = CGFloat(20.0)
            static let SEGMENT = CGFloat(18.0)
            static let VALUE_EXPEND = CGFloat(18.0)
            static let VALUE_EXPEND2 = CGFloat(22.0)
        }
       
        //Noto Sans Thai
        //== NotoSansThai-Bold
        //== NotoSansThai-SemiBold
        //== NotoSansThai-Regular
        //static let NOTO_SANS_BOLD = "NotoSansThai-SemiBold"
        //static let NOTO_SANS_REGULAR = "NotoSansThai-Regular"
        
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

func isValidName(_ str:String) -> Bool{
    if str.isEmpty {
        return true
    }
    guard !isValidNumber(str) else {return false}
    guard isValidString(str) else {return false}
    
    return true
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

func isValidLaserIdCard(_ idCard:String) -> Bool{
    if idCard.count != 12  { return false }
    
    let fString = idCard.substring(start: 0, end: 2)
    let sString = idCard.substring(start: 2, end: idCard.count)
    
    guard !isValidNumber(fString) else {return false}
    guard isValidString(fString) else { return false }
    guard isValidNumber(sString) else {return false}
    return true
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
func heightForViewWithDraw(_ countViewResult:Int, width:CGFloat  ,height:CGFloat = 250, rowHeight:CGFloat = CGFloat(40)) -> CGFloat{
    
    var sumheight = CGFloat(0)
    for _ in 0..<countViewResult {
        sumheight += rowHeight
    }
    
    return height + sumheight
}


func base64Convert(base64String: String?) -> UIImage?{
    if (base64String?.isEmpty)! {
        return nil
    }else {
        // !!! Separation part is optional, depends on your Base64String !!!
        let temp = base64String?.components(separatedBy: ",")
        let dataDecoded : Data = Data(base64Encoded: temp![1], options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        return decodedimage!
    }
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
func convertDateRegister(_ dateString:String , format:String = "dd-MM-yyyy HH:mm") -> String {
    //2017-03-29 20:15:25.000+00:00
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    if let d1 = dateFormatter.date(from: dateString){
        
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let components = calendar.dateComponents(unitFlags, from: d1)
        
        
        var newStringDate = String(format: "%02d", components.day!)
        newStringDate += "-\(String(format: "%02d", components.month!))"
        newStringDate += "-\(String(format: "%02d", components.year! + 543))"
        //newStringDate += " \(String(format: "%02d", components.hour!))"
        //newStringDate += ":\(String(format: "%02d", components.minute!))"
        
        
        print("\(newStringDate)")
        return newStringDate
        
    }
    
    return "-"
}

func convertDate(_ dateString:String , format:String = "dd-MM-yyyy HH:mm") -> String {
    //2017-03-29 20:15:25.000+00:00
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    if let d1 = dateFormatter.date(from: dateString){
        
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let components = calendar.dateComponents(unitFlags, from: d1)
        
        
        var newStringDate = String(format: "%02d", components.day!)
        newStringDate += "-\(String(format: "%02d", components.month!))"
        newStringDate += "-\(String(format: "%02d", components.year! - 543))"
        newStringDate += " \(String(format: "%02d", components.hour!))"
        newStringDate += ":\(String(format: "%02d", components.minute!))"
        
        
        print("\(newStringDate)")
        return newStringDate
        
    }
    
    return "-"
}


func convertBuddhaToChris(_ dateString:String, _ format:String = "dd-MM-yyyy HH:mm") -> String {
    let dateFormatter = DateFormatter()
    //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "dd-MM-yyyy"
    
    if let d1 = dateFormatter.date(from: dateString){
        print(d1)
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.day, .month, .year, .hour, .minute]
        let components = calendar.dateComponents(unitFlags, from: d1)
        
        let year  = components.year! - 543
        let dateString = "\(String(format: "%02d", components.day!))-\(String(format: "%02d", components.month!))-\(year)"
        return dateString
    }
    
    return ""
}

func compareLiveTime(_ destinationDate:String) -> Bool{
    var totalTime = 0
    // Setting Today's Date
    let currentDate = Date()
    
    // Setting TargetDate
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.locale = Locale(identifier: "en")
    if let targedDate = dateFormatter.date(from: destinationDate) {
        // Calculating the difference of dates for timer
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let component = calendar.dateComponents(unitFlags, from: currentDate, to: targedDate)
        let days = component.day!
        let hours = component.hour!
        let minutes = component.minute!
        let seconds = component.second!
        totalTime = hours * 60 * 60 + minutes * 60 + seconds
        totalTime = days * 60 * 60 * 24 + totalTime
        
        print(totalTime)
        if totalTime > 0 {
            return false
        }else{
            //end
            return true
        }
    }
    return false
}
func validateTransactionTime(_ dateString:String) -> Bool {
    //2017-03-29 20:15
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en")
    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
    let nDate = convertDate(dateString)
    if let d1 = dateFormatter.date(from: nDate){
        
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let components = calendar.dateComponents(unitFlags, from: d1)
        
        
        let minnute = components.minute! + (components.hour!*60)
        let difminute = abs(1440 - minnute)
        let diffTime = "\(Int(difminute/60)):\(Int(difminute%60)):00"
        
        let diffT1 = parseDuration(timeString: diffTime)
        let timeInter = d1.timeIntervalSinceReferenceDate
        let diff24 =  timeInter + diffT1
        
        
        let diffDate =  Date(timeIntervalSinceReferenceDate: diff24)
        print(diffDate)
        
        
        let currentDate = Date()
        let currentTime = currentDate.timeIntervalSinceReferenceDate
        print(currentDate)
        
        if diff24 > currentTime {
            return true
        }else{
            return false
        }
        
        //let difference = calendar.dateComponents(unitFlags, from: diffDate)
        
        //var str2 = "\(String(format: "%02d", difference.hour!))"
        //str2 += ":\(String(format: "%02d", difference.minute!))"
        //str2 += ":\(String(format: "%02d", difference.second!))"
        
        //print(str2)
        
       
        
    }
    
    return false
}

func parseDuration(timeString:String) -> TimeInterval {
    guard !timeString.isEmpty else {
        return 0
    }
    
    var interval:Double = 0
    
    let parts = timeString.components(separatedBy: ":")
    for (index, part) in parts.reversed().enumerated() {
        interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
    }
    
    return interval
}
func stringFromTimeInterval(_ timeInterval:TimeInterval) -> String {
    
    let time = NSInteger(timeInterval)
    let seconds = time % 60
    let minutes = (time / 60) % 60
    let hours = (time / 3600)
    
    return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    
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










