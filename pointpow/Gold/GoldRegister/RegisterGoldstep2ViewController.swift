//
//  RegisterGoldstep2ViewController.swift
//  pointpow
//
//  Created by thanawat on 11/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Photos
import Alamofire

class RegisterGoldstep2ViewController: BaseViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var step1Label: UILabel!
    @IBOutlet weak var step2Label: UILabel!
    @IBOutlet weak var step3Label: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var checkBox: CheckBox!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var icCardPhotoImageView: UIImageView!
    @IBOutlet weak var backgroundIdCardPhotoImageView: UIView!
    
    @IBOutlet weak var hiddenIdCardPhotoImageView: UIImageView!
    let vborder = CAShapeLayer()
    
    var idCardPhoto:UIImage?
    var picker:UIImagePickerController?
    var upload:UploadRequest?
    
    var tupleModel:(image : UIImage?, firstname : String,lastname: String , email: String,mobile: String,idcard: String , birthdate:String, laserId:String, isCheck:Bool)?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backImage = UIImage(named: "ic-back-white")
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backViewTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 2, left: -10, bottom: -2, right: 10)

        self.title = NSLocalizedString("string-title-gold-register1", comment: "")
        self.setUp()
        
       
    }
   
    func setUp(){
        self.backgroundImage?.image = nil
        
        self.checkBox.toggle  = { (isCheck) in
            self.validateData()
            self.tupleModel?.isCheck = isCheck
        }
        
        
        
        self.hiddenIdCardPhotoImageView.contentMode = .scaleAspectFit
      
        self.backgroundIdCardPhotoImageView.layer.cornerRadius = 10
        vborder.strokeColor = UIColor.lightGray.cgColor
        vborder.lineDashPattern = [4, 2]
        vborder.fillColor = nil
        self.backgroundIdCardPhotoImageView.layer.addSublayer(vborder)
        
        
        let browse = UITapGestureRecognizer(target: self, action: #selector(browseTapped))
        self.backgroundIdCardPhotoImageView.isUserInteractionEnabled = true
        self.backgroundIdCardPhotoImageView.addGestureRecognizer(browse)
        
        let browse2 = UITapGestureRecognizer(target: self, action: #selector(browseTapped))
        self.uploadView.isUserInteractionEnabled = true
        self.uploadView.addGestureRecognizer(browse2)
        
        let back = UITapGestureRecognizer(target: self, action: #selector(backToStep1Tapped))
        self.step1Label.isUserInteractionEnabled = true
        self.step1Label.addGestureRecognizer(back)
        
        
        let term = UITapGestureRecognizer(target: self, action: #selector(termTapped))
        self.termLabel.isUserInteractionEnabled =  true
        self.termLabel.addGestureRecognizer(term)
        
        if let tp = self.tupleModel {
            if tp.image != nil{
                self.hiddenIdCardPhotoImageView.image = tp.image
                self.icCardPhotoImageView.isHidden = true
                self.idCardPhoto = tp.image
            }
            self.checkBox.isChecked = tp.isCheck
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        

    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        
        // dash 
        vborder.path = UIBezierPath(roundedRect: self.backgroundIdCardPhotoImageView.bounds,
                                    cornerRadius: 10).cgPath
        vborder.frame = self.backgroundIdCardPhotoImageView.bounds
        
        self.hiddenIdCardPhotoImageView.borderClearProperties(borderWidth: 0, radius: 10)
        self.containerView.borderLightGrayColorProperties(borderWidth: 0.5, radius: 10)
        self.uploadView.borderRedColorProperties(borderWidth: 1.0)
        //self.nextButton.borderClearProperties(borderWidth: 1)
        //self.nextButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        self.step1Label.ovalColorClearProperties()
        self.step2Label.ovalColorClearProperties()
        self.step3Label.ovalColorClearProperties()
        
        
      
    }
    @objc func termTapped(){
        self.showTermAndConGold(true)
    }
    
    @objc func backToStep1Tapped(){
        if let formViewController = self.navigationController?.viewControllers[1] as? RegisterGoldViewController {
            formViewController.tupleModel = self.tupleModel
            self.navigationController?.popToViewController(formViewController, animated: true)
        }
    }
    @objc func backViewTapped() {
        if let formViewController = self.navigationController?.viewControllers[1] as? RegisterGoldViewController {
            formViewController.tupleModel = self.tupleModel
            self.navigationController?.popToViewController(formViewController, animated: true)
        }
    }
   
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
       
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
       
            if let imageData = chosenImage.pngData() {
                let bytes = imageData.count
                let KB = Double(bytes) / 1024.0 // Note the difference
                print("size of image in KB: \(KB)")
            }
            
            // square for profile
            let resizeImage = chosenImage.resizeUIImage2(targetSize: CGSize(width: 400.0, height: 400.0))
            self.idCardPhoto = resizeImage
            self.tupleModel?.image = self.idCardPhoto
            
            if let imageData = resizeImage.pngData() {
                let bytes = imageData.count
                let KB = Double(bytes) / 1024.0 // Note the difference
                print("size of image in KB: \(KB)")
            }
            
            //reload data
            self.hiddenIdCardPhotoImageView.image = resizeImage
            self.icCardPhotoImageView.isHidden = true
            
            self.validateData()
        }
    }
    
    @objc func browseTapped(){
        self.addFileTapped()
    }
    
    func addFileTapped() {
        //Gallery
        var style:UIAlertController.Style = .alert
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            style = .alert
        }else{
            style = .actionSheet
        }
        let actionSheetController: UIAlertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle:  style)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("string-take-cancel", comment: ""), style: .destructive) { action -> Void in
            //Just dismiss the action sheet
        }
        let takePictureAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("string-take-option1", comment: ""), style: .default) { action -> Void in
            self.photoFromCamera()
        }
        let choosePictureAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("string-take-option2", comment: ""), style: .default) { action -> Void in
            self.photoFromGallery()
        }
        
        actionSheetController.addAction(takePictureAction)
        actionSheetController.addAction(choosePictureAction)
        actionSheetController.addAction(cancelAction)
        
        self.present(actionSheetController, animated: true)
    
    }
    
    
    func photoFromGallery() {
        
        let status = PHPhotoLibrary.authorizationStatus()
        if (status != PHAuthorizationStatus.denied) {
            
            picker = UIImagePickerController()
            picker!.allowsEditing = false
            picker!.sourceType = .photoLibrary
            picker!.delegate = self
            picker!.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            present(picker!, animated: true, completion: nil)
            
        }else{
            self.cannotAccessPhoto()
        }
    }
    
    func photoFromCamera(){
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) !=  AVAuthorizationStatus.denied {
            picker = UIImagePickerController()
            picker!.allowsEditing = false
            picker!.sourceType = .camera
            picker!.delegate = self
            present(picker!, animated: true, completion: nil)
        } else {
            self.cannotAccessCamera()
        }
        
    }
    

    @IBAction func nextStepTapped(_ sender: Any) {
        guard  self.checkBox.isChecked  else {
            showMessagePrompt(NSLocalizedString("string-message-alert-please-check-box", comment: ""))
            return
        }
        if  self.idCardPhoto != nil {
            self.showRegisterGoldStep3Saving(true , tupleModel: tupleModel)
        }else{
            showMessagePrompt(NSLocalizedString("string-message-alert-please-choose-image", comment: ""))
        }
    }
    
    func validateData(){
        if self.idCardPhoto == nil || !self.checkBox.isChecked {
            self.disableButton()
            return
        }
      
        self.enableButton()
    }
    
    func enableButton(){
        if let count = self.nextButton?.layer.sublayers?.count {
            if count > 1 {
                self.nextButton?.layer.sublayers?.removeFirst()
            }
        }
        
        
        self.nextButton?.borderClearProperties(borderWidth: 1)
        self.nextButton?.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        self.nextButton?.isEnabled = true
    }
    func disableButton(){
        if let count = self.nextButton?.layer.sublayers?.count {
            if count > 1 {
                self.nextButton?.layer.sublayers?.removeFirst()
            }
        }
        
        
        
        self.nextButton?.borderClearProperties(borderWidth: 1)
        self.nextButton?.applyGradient(colours: [UIColor.lightGray, UIColor.lightGray])
        
        self.nextButton?.isEnabled = false
    }
}
