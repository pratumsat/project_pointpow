//
//  Scanner2ViewController.swift
//  ABCPointCustomer
//
//  Created by thanawat pratumsat on 11/23/2560 BE.
//  Copyright © 2560 thanawat pratumsat. All rights reserved.
//

import AVFoundation
import UIKit
import ZBarSDK
import Photos

class Scanner2ViewController: ScannerViewController {

  
    
    override func viewDidLoad() {
        self.fromMember = true
        
        super.viewDidLoad()
    }
 
    override func setBackgroundDrakGrayScan() -> (left:UIView,top:UIView,bottom:UIView,right:UIView,scanLabel:UILabel) {
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        let background  = UIColor.darkGray
        
        if isQRCode {
            let top = UIView()
            let topHeight = height * 0.3
            top.frame = CGRect(x: 0, y: 0, width: width, height: topHeight)
            top.backgroundColor = background
            top.alpha = 0.5
            view.addSubview(top)
            
            let bottom = UIView()
            let bootomHeight = height * 0.35
            bottom.frame = CGRect(x: 0, y: height - bootomHeight, width: width, height: bootomHeight)
            bottom.backgroundColor = background
            bottom.alpha = 0.5
            view.addSubview(bottom)
            
            let left = UIView()
            let leftHeight = height - topHeight - bootomHeight
            let leftWidth = width * 0.2
            left.frame = CGRect(x: 0, y: topHeight, width: leftWidth, height: leftHeight)
            left.backgroundColor = background
            left.alpha = 0.5
            view.addSubview(left)
            
            let right = UIView()
            let rightHeight = height - topHeight - bootomHeight
            let rightWidth = width * 0.2
            right.frame = CGRect(x: width - rightWidth, y: topHeight, width: rightWidth, height: rightHeight)
            right.backgroundColor = background
            right.alpha = 0.5
            view.addSubview(right)
            
            let scanLabel = UILabel()
            let labelWidth = width / 2
            scanLabel.frame = CGRect(x: 0 , y: (height - bootomHeight) + 20, width: width, height: 30)
            scanLabel.textColor = UIColor.white
            scanLabel.numberOfLines = 0
            scanLabel.lineBreakMode = .byWordWrapping
            scanLabel.font = UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.CONTENT)!
            scanLabel.textAlignment = .center
            scanLabel.text = NSLocalizedString("string-line-up-qr", comment: "")
            scanLabel.sizeToFit()
            
            scanLabel.center.x =  labelWidth
            view.addSubview(scanLabel)
            
            
            return (left:left,top:top,bottom:bottom,right:right,scanLabel:scanLabel)
        }else{
            let top = UIView()
            let topHeight = height * 0.15
            top.frame = CGRect(x: 0, y: 0, width: width, height: topHeight)
            top.backgroundColor = background
            top.alpha = 0.5
            view.addSubview(top)
            
            let bottom = UIView()
            let bootomHeight = height * 0.25
            bottom.frame = CGRect(x: 0, y: height - bootomHeight, width: width, height: bootomHeight)
            bottom.backgroundColor = background
            bottom.alpha = 0.5
            view.addSubview(bottom)
            
            let left = UIView()
            let leftHeight = height - topHeight - bootomHeight
            let leftWidth = width * 0.3
            left.frame = CGRect(x: 0, y: topHeight, width: leftWidth, height: leftHeight)
            left.backgroundColor = background
            left.alpha = 0.5
            view.addSubview(left)
            
            let right = UIView()
            let rightHeight = height - topHeight - bootomHeight
            let rightWidth = width * 0.3
            right.frame = CGRect(x: width - rightWidth, y: topHeight, width: rightWidth, height: rightHeight)
            right.backgroundColor = background
            right.alpha = 0.5
            view.addSubview(right)
            
            let scanLabel = UILabel()
            
            scanLabel.frame = CGRect(x: 0 , y: 0, width: 0, height: 30)
            scanLabel.textColor = UIColor.white
            scanLabel.numberOfLines = 0
            scanLabel.lineBreakMode = .byWordWrapping
            scanLabel.font = UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.CONTENT)!
            scanLabel.textAlignment = .center
            scanLabel.text = NSLocalizedString("string-line-up-barcode", comment: "")
            scanLabel.sizeToFit()
            scanLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            scanLabel.center.x =  (width * 0.22)
            scanLabel.center.y =  left.center.y
            view.addSubview(scanLabel)
            
            
            return (left:left,top:top,bottom:bottom,right:right,scanLabel:scanLabel)
        }
        
        
    }
    
    
    override func setImageBorderViewScan() -> (leftBottom:UIImageView,leftTop:UIImageView,rightBottom:UIImageView,rightTop:UIImageView) {
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        var sizeImage = width*0.08
        var top =  height * 0.29
        var btop =  height * 0.34
        var left =  width * 0.182
        
        if !isQRCode {
            sizeImage = width*0.08
            top =  height * 0.14
            btop =  height * 0.24
            left =  width * 0.282
        }
        
        let bottomImage = height - btop - sizeImage
        let topImage = width - left - sizeImage
        
        
        let leftTopImage = UIImageView(image: UIImage(named: "ic_scan_border_left_top"))
        leftTopImage.frame = CGRect(x: left, y: top, width: sizeImage, height: sizeImage)
        leftTopImage.contentMode = .scaleToFill
        view.addSubview(leftTopImage)
        
        let leftBottomImage = UIImageView(image: UIImage(named: "ic_scan_border_left_bottom"))
        leftBottomImage.frame = CGRect(x: left, y: bottomImage, width: sizeImage, height: sizeImage)
        leftBottomImage.contentMode = .scaleToFill
        view.addSubview(leftBottomImage)
        
        let rightTopImage = UIImageView(image: UIImage(named: "ic_scan_border_right_top"))
        rightTopImage.frame = CGRect(x: topImage, y: top, width: sizeImage, height: sizeImage)
        rightTopImage.contentMode = .scaleToFill
        view.addSubview(rightTopImage)
        
        let rightBottomImage = UIImageView(image: UIImage(named: "ic_scan_border_right_bottom"))
        rightBottomImage.frame = CGRect(x: topImage, y: bottomImage, width: sizeImage, height: sizeImage)
        rightBottomImage.contentMode = .scaleToFill
        view.addSubview(rightBottomImage)
        
        return (leftBottom:leftBottomImage, leftTop:leftTopImage, rightBottom:rightBottomImage, rightTop:rightTopImage)
    }
    
}
