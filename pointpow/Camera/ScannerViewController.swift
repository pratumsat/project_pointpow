//
//  ScannerViewController.swift
//  ABCPointAdmin
//
//  Created by thanawat pratumsat on 3/17/2560 BE.
//  Copyright © 2560 thanawat pratumsat. All rights reserved.
//
import AVFoundation
import UIKit
import ZBarSDK
import Photos

extension ZBarSymbolSet: Sequence {
    
    public typealias Iterator = NSFastEnumerationIterator
    
    public func makeIterator() -> NSFastEnumerationIterator {
        return NSFastEnumerationIterator(self)
    }
    
}

class ScannerViewController: BaseViewController ,AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate , ZBarReaderDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var barcode_imageview: UIImageView!
    @IBOutlet weak var myQR_imageview: UIImageView!
    @IBOutlet weak var browse_imageview: UIImageView!
    
    @IBOutlet weak var close_imageview: UIImageView!
    @IBOutlet weak var flash_imageview: UIImageView!
    @IBOutlet weak var contaiView: UIView!
   
    @IBOutlet weak var contaiQRLabel: UILabel!
    @IBOutlet weak var contaiLineLabel: UIView!
    
    @IBOutlet weak var contaiLibraryLabel: UILabel!
    
    var squareView:UIView?
    
    var barcodeCallback : ( (_ result:AnyObject, _ barcode:String) -> Void )?
   
    var fromMember = false
    
    var isQRCode = true
    var metadataOutput:AVCaptureMetadataOutput?
    
    var backgroundView:(left:UIView,top:UIView,bottom:UIView,right:UIView,scanLabel:UILabel)?
    var imageBorder:(leftBottom:UIImageView,leftTop:UIImageView,rightBottom:UIImageView,rightTop:UIImageView)?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        
        let close = UITapGestureRecognizer(target: self, action: #selector(dismissTapped))
        self.close_imageview.isUserInteractionEnabled = true
        self.close_imageview.addGestureRecognizer(close)
        
        let flash = UITapGestureRecognizer(target: self, action: #selector(flashTapped))
        self.flash_imageview.isUserInteractionEnabled = true
        self.flash_imageview.addGestureRecognizer(flash)
        
        
        let browse = UITapGestureRecognizer(target: self, action: #selector(browseTapped))
        self.browse_imageview.isUserInteractionEnabled = true
        self.browse_imageview.addGestureRecognizer(browse)
        
        
        if !self.fromMember {
            //ignored
            let qr = UITapGestureRecognizer(target: self, action: #selector(qrcodeTapped))
            self.myQR_imageview.isUserInteractionEnabled = true
            self.myQR_imageview.addGestureRecognizer(qr)
            
            let barcode = UITapGestureRecognizer(target: self, action: #selector(barcodeTapped))
            self.barcode_imageview.isUserInteractionEnabled = true
            self.barcode_imageview.addGestureRecognizer(barcode)
        }
        

        captureSession = AVCaptureSession()
        
        if let videoCaptureDevice = AVCaptureDevice.default(for: .video) {
            
            let videoInput: AVCaptureDeviceInput
            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return
            }
            
            if (captureSession.canAddInput(videoInput)) {
                captureSession.addInput(videoInput)
            } else {
                self.failed();
                return;
            }
            
            //setUpView
            self.swicthBarcode()
            
        }
       
        
    }
    
    func swicthBarcode(){
        if metadataOutput != nil {
            captureSession.removeOutput(metadataOutput!)
        }
        self.metadataOutput = AVCaptureMetadataOutput()
        
        if self.isQRCode {
            if (captureSession.canAddOutput(metadataOutput!)) {
                captureSession.addOutput(metadataOutput!)
                self.metadataOutput?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                self.metadataOutput?.metadataObjectTypes = [.qr]
                
                if !self.fromMember {
                    self.myQR_imageview.isUserInteractionEnabled = false
                    self.barcode_imageview.isUserInteractionEnabled = true
                }
            }
        }else{
            if (captureSession.canAddOutput(metadataOutput!)) {
                captureSession.addOutput(metadataOutput!)
                self.metadataOutput?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                self.metadataOutput?.metadataObjectTypes = [.code128]
                
                 if !self.fromMember {
                    self.myQR_imageview.isUserInteractionEnabled = true
                    self.barcode_imageview.isUserInteractionEnabled = false
                }
            }
        }
        if let bv = self.backgroundView {
            bv.top.removeFromSuperview()
            bv.left.removeFromSuperview()
            bv.bottom.removeFromSuperview()
            bv.right.removeFromSuperview()
            bv.scanLabel.removeFromSuperview()
        }
        if let border = self.imageBorder {
            border.leftBottom.removeFromSuperview()
            border.leftTop.removeFromSuperview()
            border.rightBottom.removeFromSuperview()
            border.rightTop.removeFromSuperview()
        }

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
        }
        //start
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;
        view.layer.addSublayer(previewLayer);
        captureSession.startRunning();
        
        
        self.backgroundView = self.setBackgroundDrakGrayScan()
        self.imageBorder = self.setImageBorderViewScan()
        self.setUpView()
        
        
        
    }
    
    func setUpView(){
        
        self.squareView = UIView()
        squareView!.layer.borderColor = UIColor.green.cgColor
        squareView!.layer.borderWidth = 2.0
        view.addSubview(squareView!)
        view.bringSubviewToFront(squareView!)
        
        
        view.bringSubviewToFront(self.close_imageview)
        view.bringSubviewToFront(self.flash_imageview)
        view.bringSubviewToFront(self.browse_imageview)
        
         if !self.fromMember {
            view.bringSubviewToFront(self.myQR_imageview)
            view.bringSubviewToFront(self.barcode_imageview)
            
            view.bringSubviewToFront(self.contaiView)
            view.bringSubviewToFront(self.contaiQRLabel)
            view.bringSubviewToFront(self.contaiLineLabel)
            view.bringSubviewToFront(self.contaiLibraryLabel)
        }
        
    }
    
    func setBackgroundDrakGrayScan() -> (left:UIView,top:UIView,bottom:UIView,right:UIView,scanLabel:UILabel) {
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        let background  = UIColor.darkGray
        
        if isQRCode {
            let top = UIView()
            let topHeight = height * 0.25
            top.frame = CGRect(x: 0, y: 0, width: width, height: topHeight)
            top.backgroundColor = background
            top.alpha = 0.5
            view.addSubview(top)
            
            let bottom = UIView()
            let bootomHeight = height * 0.4
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
    
    
    func setImageBorderViewScan() -> (leftBottom:UIImageView,leftTop:UIImageView,rightBottom:UIImageView,rightTop:UIImageView) {
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        var sizeImage = width*0.08
        var top =  height * 0.24
        var btop =  height * 0.39
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
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated:true, completion:  nil)
        
        if let results: NSFastEnumeration = info[UIImagePickerController.InfoKey.init(rawValue: ZBarReaderControllerResults)] as? NSFastEnumeration {
            
            var symbolFound : ZBarSymbol?
            var resultCode:String = ""
            
            if let rs  = results as? NSArray {
                
                for symbol in rs {
                    symbolFound = symbol as? ZBarSymbol
                    break
                }
                
                resultCode  = symbolFound?.data ?? ""
                
            }
            if resultCode != "" {
                if symbolFound?.typeName == "QR-Code" {
                    self.found(code: resultCode, barcode: false)
                }else{
                    self.found(code: resultCode, barcode: true)
                }
                
            }else{
                self.showMessage()
            }
        }
    }
   
    func readerControllerDidFail(toRead reader: ZBarReaderController!, withRetry retry: Bool) {
        dismiss(animated: true, completion: { () in
            self.showMessage()
        })
    }
    
    func showMessage(){
        let title = NSLocalizedString("string-title-invalid-qr", comment: "")
        let message = NSLocalizedString("string-message-invalid-qr", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("alert-confirm-phone", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
   
    @objc func dismissTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func photoFromGallery(){
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        if (status != PHAuthorizationStatus.denied) {
            // Access has been granted.
            let imageReader = ZBarReaderController()
            //barcode
                 
            imageReader.readerDelegate   = self
            imageReader.showsHelpOnFail = false
            imageReader.sourceType = .photoLibrary
            
            let scanner: ZBarImageScanner = imageReader.scanner
            
            scanner.setSymbology(zbar_symbol_type_t(rawValue: 0), config: ZBAR_CFG_ENABLE, to: 1 )
//            scanner.setSymbology(ZBAR_CODE128, config: ZBAR_CFG_ENABLE, to: 1 )
//            scanner.setSymbology(ZBAR_EAN13, config: ZBAR_CFG_ENABLE, to: 1 )
//            scanner.setSymbology(ZBAR_UPCA, config: ZBAR_CFG_ENABLE, to: 1 )
//            scanner.setSymbology(ZBAR_QRCODE, config: ZBAR_CFG_ENABLE, to: 1 )
            
            
            present(imageReader, animated: true, completion: nil)
        
        }else{
            self.cannotAccessPhoto()
        }
        
       
    }
    @objc func browseTapped(){
        self.photoFromGallery()
    }
    func myQRTapped(){
        //self.showMyQRCode()
    }
    @objc func qrcodeTapped(){
        self.isQRCode = true
        self.swicthBarcode()
    }
    @objc func barcodeTapped(){
        self.isQRCode = false
        self.swicthBarcode()
    }
    
    @objc func flashTapped(){
        let device = AVCaptureDevice.default(for: .video)
        if device?.hasTorch == nil {
            return
        }
        if (device?.hasTorch)! {
            do {
                try device?.lockForConfiguration()
                if (device?.torchMode == AVCaptureDevice.TorchMode.on) {
                    device?.torchMode = AVCaptureDevice.TorchMode.off
                    
                    self.flash_imageview.image = UIImage(named: "ic_camera_close_flash")
                } else {
                    self.flash_imageview.image = UIImage(named: "ic_camera_open_flash")
                    do {
                        try device?.setTorchModeOn(level: 1.0)
                    } catch {
                        print(error)
                    }
                }
                device?.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
    
    
    func failed() {
        let title = NSLocalizedString("string-title-scan-fail", comment: "")
        let message = NSLocalizedString("string-message-scan-fail", comment: "")
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: NSLocalizedString("alert-confirm-phone", comment: ""), style: .default))
        self.present(ac, animated: true, completion: nil)
        captureSession = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            squareView?.frame = CGRect.zero
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
         captureSession.stopRunning()
        
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            if readableObject.type == AVMetadataObject.ObjectType.qr {
                let barCodeObject = previewLayer?.transformedMetadataObject(for: readableObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
                
                squareView?.frame = barCodeObject.bounds;
                
                if readableObject.stringValue != nil {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    found(code: readableObject.stringValue!, barcode: false);
                    
                }
                
            }
            if readableObject.type == AVMetadataObject.ObjectType.code128 {
                let barCodeObject = previewLayer?.transformedMetadataObject(for: readableObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
                
                squareView?.frame = barCodeObject.bounds;
                
                if readableObject.stringValue != nil {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    found(code: readableObject.stringValue! ,barcode: true);
                    
                }
            }
        }
    }
    
    func found(code: String , barcode:Bool) {
        print("code = \(code)")
        if barcode {
            print("is Barcode")
        }else{
            print("is QRCode")
        }
        self.dismiss(animated: false, completion: nil)
        
//        if !barcode {
//            self.modelCtrl.qrScan(qr_key: code, succeeded: { (result) in
//
//                self.dismiss(animated: false) {
//                    self.barcodeCallback?(result as AnyObject, code)
//                }
//
//            }, failure: { (messageError) in
//                self.handlerMessageError(messageError)
//
//                if (self.captureSession?.isRunning == false) {
//                    self.squareView?.frame = CGRect.zero
//                    self.captureSession.startRunning();
//                }
//            })
//        }else{
//            self.modelCtrl.barcodeScan(qr_key: code, succeeded: { (result) in
//                print(result)
//
//                self.dismiss(animated: false) {
//                    self.barcodeCallback?(result as AnyObject , code)
//                }
//
//            }, failure: { (messageError) in
//                self.handlerMessageError(messageError)
//
//                if (self.captureSession?.isRunning == false) {
//                    self.squareView?.frame = CGRect.zero
//                    self.captureSession.startRunning();
//                }
//            })
//        }
        
    }
    
   
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}
