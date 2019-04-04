//
//  GoldProfileViewController.swift
//  pointpow
//
//  Created by thanawat on 4/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Photos
import Alamofire

class GoldProfileViewController: BaseViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var calendarImageView: UIImageView!
    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var laserIdTextField: UITextField!
    
    @IBOutlet weak var birthdateView: UIView!
    @IBOutlet weak var lasetIdView: UIView!
    
    
    @IBOutlet weak var iconCameraImageView: UIImageView!
    
    @IBOutlet weak var goldIdLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    
    @IBOutlet weak var fview: UIView!
    @IBOutlet weak var lview: UIView!
    @IBOutlet weak var eview: UIView!
    @IBOutlet weak var mview: UIView!
    @IBOutlet weak var idview: UIView!
    
    @IBOutlet weak var idcardTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
  
    @IBOutlet weak var uploadView: UIView!
    
    @IBOutlet weak var backgroundIdCardPhotoImageView: UIView!
    
    @IBOutlet weak var hiddenIdCardPhotoImageView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    var clearImageView:UIImageView?
    var clearImageView2:UIImageView?
    var clearImageView3:UIImageView?
    var clearImageView4:UIImageView?
    var clearImageView5:UIImageView?
     var clearImageView6:UIImageView?
    
    var errorLastnamelLabel:UILabel?
    var errorFirstNameLabel:UILabel?
    var errorPersonalIDLabel:UILabel?
    var errorEmailLabel:UILabel?
    var errorMobileLabel:UILabel?
    var errorLaserIdLabel:UILabel?
    var errorBirthdateLabel:UILabel?
    
    let vborder = CAShapeLayer()
    
    var idCardPhoto:UIImage?
    var picker:UIImagePickerController?
    var upload:UploadRequest?
    var pickerView:UIDatePicker?
    
    var currentBirthdate = ""
    var userData:AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.revealViewController() != nil) {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.navigationItem.rightBarButtonItem?.target = revealViewController()
            
        }
        
        
        self.navigationItem.rightBarButtonItem?.action = #selector(SWRevealViewController.rightRevealToggle(_:))
        
        self.title = NSLocalizedString("string-title-profile", comment: "")
        self.setUp()
        
        self.getUserInfo(){
            self.updateView()
        }
    }
    
    func getUserInfo(_ avaliable:(()->Void)?  = nil){
        
        var isLoading:Bool = true
        if self.userData != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        modelCtrl.getUserData(params: nil , isLoading , succeeded: { (result) in
            self.userData = result
            avaliable?()
            
            self.refreshControl?.endRefreshing()
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                //self.showMessagePrompt(message)
            }
            self.refreshControl?.endRefreshing()
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @IBAction func bViewTapped(_ sender: Any) {
        if self.saveButton.isEnabled {
            let alert = UIAlertController(title:
                NSLocalizedString("string-dailog-back-view-profile", comment: ""),
                                          message: "", preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: NSLocalizedString("string-dailog-gold-button-confirm", comment: ""), style: .default, handler: {
                (alert) in
                
                
                if let saving = self.storyboard?.instantiateViewController(withIdentifier: "NavGoldPage") as? NavGoldPage {
                    self.revealViewController()?.pushFrontViewController(saving, animated: true)
                    
                }
                
            })
            let cancelButton = UIAlertAction(title: NSLocalizedString("string-dailog-gold-button-cancel", comment: ""), style: .default, handler: nil)
            
            
            alert.addAction(cancelButton)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }else{
            if let saving = self.storyboard?.instantiateViewController(withIdentifier: "NavGoldPage") as? NavGoldPage {
                self.revealViewController()?.pushFrontViewController(saving, animated: true)
                
            }
        }
        
    }
    
    func updateView(){
        self.currentBirthdate = ""
        //Fill Data
        if let data  = self.userData as? [String:AnyObject] {
            let first_name = data["goldsaving_member"]?["firstname"] as? String ?? ""
            let last_name = data["goldsaving_member"]?["lastname"]as? String ?? ""
            let email = data["goldsaving_member"]?["email"]as? String ?? ""
            let mobile = data["goldsaving_member"]?["mobile"]as? String ?? ""
            let pid = data["goldsaving_member"]?["citizen_id"]as? String ?? ""
            let status = data["goldsaving_member"]?["status"] as? String ?? ""
            let account_id = data["goldsaving_member"]?["account_id"] as? String ?? ""
            let laser_id = data["goldsaving_member"]?["laser_id"] as? String ?? ""
            let birthdate = data["goldsaving_member"]?["birthdate"] as? String ?? ""
            
            self.goldIdLabel.text = "\(account_id)"
            self.firstNameTextField.text = first_name
            self.lastNameTextField.text = last_name
            self.emailTextField.text = email
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "th")
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            if let d1 = dateFormatter.date(from: convertDateRegister(birthdate, format: "yyyy-MM-dd")) {
                self.pickerView?.date = d1
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "th")
                formatter.dateFormat = "dd MMMM yyyy"
                
                self.birthdateTextField.text = formatter.string(from: d1)
                self.currentBirthdate = self.birthdateTextField.text!
            }
            
            
            let newText = String((pid).filter({ $0 != "-" }).prefix(13))
            self.idcardTextField.text = newText.chunkFormattedPersonalID()
            
            let newMText = String((mobile).filter({ $0 != "-" }).prefix(10))
            self.mobileTextField.text =  newMText.chunkFormatted()
        
            let newLText = String((laser_id).filter({ $0 != "-" }).prefix(12))
            self.laserIdTextField.text =  newLText.chunkFormattedLaserID()
            
            
            //self.hiddenIdCardPhotoImageView.sd_setImage(with: URL(string: idCardPhoto)!, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.PROFILE_PLACEHOLDER))
            
            self.hiddenIdCardPhotoImageView.image = UIImage(named: "ic-img-placeholder-verify-idcard")
            
            
            switch status {
            case "waiting", "edit":
                self.statusLabel.text = NSLocalizedString("string-dailog-gold-profile-status-waitting", comment: "")
                self.statusView.backgroundColor = Constant.Colors.ORANGE
                self.emailTextField.isEnabled = false
                self.mobileTextField.isEnabled = false
                self.firstNameTextField.isEnabled = false
                self.lastNameTextField.isEnabled = false
                self.idcardTextField.isEnabled = false
                self.laserIdTextField.isEnabled = false
                self.birthdateTextField.isEnabled = false
                
                self.emailTextField.textColor = UIColor.lightGray
                self.mobileTextField.textColor = UIColor.lightGray
                self.firstNameTextField.textColor = UIColor.lightGray
                self.lastNameTextField.textColor = UIColor.lightGray
                self.idcardTextField.textColor = UIColor.lightGray
                self.laserIdTextField.textColor = UIColor.lightGray
                self.birthdateTextField.textColor = UIColor.lightGray
                
                self.uploadView.isUserInteractionEnabled = false
                self.uploadView.borderLightGrayColorProperties()
                self.backgroundIdCardPhotoImageView.isUserInteractionEnabled = false
                self.iconCameraImageView.image = UIImage(named: "ic-camera")
                
                self.calendarImageView.image = self.calendarImageView.image!.withRenderingMode(.alwaysTemplate)
                self.calendarImageView.tintColor = UIColor.lightGray
                
                break
            case "approve" :
                self.statusLabel.text = NSLocalizedString("string-dailog-gold-profile-status-approve", comment: "")
                self.statusView.backgroundColor = Constant.Colors.GREEN
                self.emailTextField.isEnabled = false
                self.mobileTextField.isEnabled = false
                self.firstNameTextField.isEnabled = true
                self.lastNameTextField.isEnabled = true
                self.idcardTextField.isEnabled = false
                self.laserIdTextField.isEnabled = false
                self.birthdateTextField.isEnabled = false
                
                self.emailTextField.textColor = UIColor.lightGray
                self.mobileTextField.textColor = UIColor.lightGray
                self.firstNameTextField.textColor = UIColor.black
                self.lastNameTextField.textColor = UIColor.black
                self.idcardTextField.textColor = UIColor.lightGray
                self.laserIdTextField.textColor = UIColor.lightGray
                self.birthdateTextField.textColor = UIColor.lightGray
                
                self.uploadView.isUserInteractionEnabled = true
                self.uploadView.borderRedColorProperties(borderWidth: 1.0)
                self.iconCameraImageView.image = UIImage(named: "ic-camera-1")
                
                self.calendarImageView.image = self.calendarImageView.image!.withRenderingMode(.alwaysTemplate)
                self.calendarImageView.tintColor = UIColor.lightGray
                
                break
            case "fail" :
                self.statusLabel.text = NSLocalizedString("string-dailog-gold-profile-status-fail", comment: "")
                self.statusView.backgroundColor = Constant.Colors.PRIMARY_COLOR
                self.emailTextField.isEnabled = false
                self.mobileTextField.isEnabled = false
                self.firstNameTextField.isEnabled = true
                self.lastNameTextField.isEnabled = true
                self.idcardTextField.isEnabled = true
                self.laserIdTextField.isEnabled = true
                self.birthdateTextField.isEnabled = true
                
                self.emailTextField.textColor = UIColor.lightGray
                self.mobileTextField.textColor = UIColor.lightGray
                self.firstNameTextField.textColor = UIColor.black
                self.lastNameTextField.textColor = UIColor.black
                self.idcardTextField.textColor = UIColor.black
                self.laserIdTextField.textColor = UIColor.black
                self.birthdateTextField.textColor = UIColor.black
                
                self.uploadView.isUserInteractionEnabled = true
                self.uploadView.borderRedColorProperties(borderWidth: 1.0)
                self.iconCameraImageView.image = UIImage(named: "ic-camera-1")
                
                self.calendarImageView.image = self.calendarImageView.image!.withRenderingMode(.alwaysTemplate)
                self.calendarImageView.tintColor = UIColor.black
                
                break
            default:
                break
            }
        }
    }
    
    
    func setUp(){
        self.backgroundImage?.image = nil
       
        self.mobileTextField.addDoneButtonToKeyboard()
        
        self.idcardTextField.addDoneButtonToKeyboard()
        
        self.birthdateTextField.addDoneButtonToKeyboard()
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.mobileTextField.delegate = self
        self.idcardTextField.delegate = self
        self.laserIdTextField.delegate = self
        self.birthdateTextField.delegate = self
        
        self.firstNameTextField.autocorrectionType = .no
        self.lastNameTextField.autocorrectionType = .no
        self.emailTextField.autocorrectionType = .no
        self.mobileTextField.autocorrectionType = .no
        self.idcardTextField.autocorrectionType = .no
        self.laserIdTextField.autocorrectionType = .no
        self.birthdateTextField.autocorrectionType = .no
        
        
        self.firstNameTextField.setLeftPaddingPoints(40)
        self.lastNameTextField.setLeftPaddingPoints(10)
        self.emailTextField.setLeftPaddingPoints(40)
        self.mobileTextField.setLeftPaddingPoints(40)
        self.idcardTextField.setLeftPaddingPoints(40)
        self.laserIdTextField.setLeftPaddingPoints(40)
        self.birthdateTextField.setLeftPaddingPoints(40)
        
        
        self.clearImageView = self.firstNameTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearFirstNameTapped))
        self.clearImageView?.isUserInteractionEnabled = true
        self.clearImageView?.addGestureRecognizer(tap)
        self.clearImageView?.isHidden = true
        
        self.clearImageView2 = self.lastNameTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(clearLastNameTapped))
        self.clearImageView2?.isUserInteractionEnabled = true
        self.clearImageView2?.addGestureRecognizer(tap2)
        self.clearImageView2?.isHidden = true
        
        self.clearImageView3 = self.idcardTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(clearPersanalTapped))
        self.clearImageView3?.isUserInteractionEnabled = true
        self.clearImageView3?.addGestureRecognizer(tap3)
        self.clearImageView3?.isHidden = true
        
        self.clearImageView4 = self.mobileTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(clearMobileTapped))
        self.clearImageView4?.isUserInteractionEnabled = true
        self.clearImageView4?.addGestureRecognizer(tap4)
        self.clearImageView4?.isHidden = true
        
        self.clearImageView5 = self.emailTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(clearEmailTapped))
        self.clearImageView5?.isUserInteractionEnabled = true
        self.clearImageView5?.addGestureRecognizer(tap5)
        self.clearImageView5?.isHidden = true
        
        self.clearImageView6 = self.laserIdTextField.addRightButton(UIImage(named: "ic-x")!)
        let tap6 = UITapGestureRecognizer(target: self, action: #selector(clearLaserIdTapped))
        self.clearImageView6?.isUserInteractionEnabled = true
        self.clearImageView6?.addGestureRecognizer(tap6)
        self.clearImageView6?.isHidden = true
        
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
        
        
        
        
        pickerView = UIDatePicker()
        pickerView!.datePickerMode = .date
        pickerView!.calendar = Calendar(identifier: .buddhist)
        pickerView!.maximumDate = Date()
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self,
                                         action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                          target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self,
                                           action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        self.birthdateTextField.tintColor = UIColor.clear
        self.birthdateTextField.isUserInteractionEnabled = true
        self.birthdateTextField.inputView = pickerView
        self.birthdateTextField.inputAccessoryView = toolbar
        
       //disable
        self.disableButton()
        
      
        let info = UITapGestureRecognizer(target: self, action: #selector(infoLaserId))
        self.infoImageView.isUserInteractionEnabled = true
        self.infoImageView.addGestureRecognizer(info)
        
    }
    
    @objc func  infoLaserId(){
        self.showInfoLaserIdPopup(true)
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "th")
        formatter.dateFormat = "dd MMMM yyyy"
        self.birthdateTextField.text = formatter.string(from: pickerView!.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == self.firstNameTextField {
            if let data  = self.userData as? [String:AnyObject] {
                let first_name = data["goldsaving_member"]?["firstname"] as? String ?? ""
                //let last_name = data["goldsaving_member"]?["lastname"]as? String ?? ""
                
                
                if (textField.text!) != first_name || (self.idCardPhoto != nil) {
                    self.enableButton()
                }else{
                    self.disableButton()
                }
            }
        }
        if textField == self.lastNameTextField {
            
            if let data  = self.userData as? [String:AnyObject] {
                let last_name = data["goldsaving_member"]?["lastname"]as? String ?? ""
                
                if (textField.text!) != last_name || (self.idCardPhoto != nil) {
                    self.enableButton()
                }else{
                    self.disableButton()
                }
            }
        }
        
        if textField == self.idcardTextField {
            if let data  = self.userData as? [String:AnyObject] {
                let citizen_id = data["goldsaving_member"]?["citizen_id"]as? String ?? ""
                
                if (textField.text!) != citizen_id || (self.idCardPhoto != nil) {
                    self.enableButton()
                }else{
                    self.disableButton()
                }
            }
        }
        
        if textField == self.laserIdTextField {
            if let data  = self.userData as? [String:AnyObject] {
                let laser_id = data["goldsaving_member"]?["laser_id"]as? String ?? ""
                
                let cutdash = textField.text!.replace(target: "-", withString: "")
                if cutdash != laser_id || (self.idCardPhoto != nil) {
                    self.enableButton()
                }else{
                    self.disableButton()
                }
            }
        }
        
        if textField == self.birthdateTextField {
            if (textField.text!) != self.currentBirthdate || (self.idCardPhoto != nil) {
                self.enableButton()
            }else{
                self.disableButton()
            }
        }
        
    }
   override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        self.addColorLineView(textField)
    }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField  == self.firstNameTextField {
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //return newLength <= 20
            
          
            
            if newLength == 0 {
                self.clearImageView?.isHidden = true
            }else{
                self.clearImageView?.isHidden = false
            }
            
            if isValidName(string) {
                return true
            }else{
                return false
            }

        }
        if textField  == self.lastNameTextField {
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //return newLength <= 20
            
            if newLength == 0 {
                self.clearImageView2?.isHidden = true
            }else{
                self.clearImageView2?.isHidden = false
            }
           
            if isValidName(string) {
                return true
            }else{
                return false
            }
        }
        if textField  == self.idcardTextField {
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //return newLength <= 20
            
            if newLength == 0 {
                self.clearImageView3?.isHidden = true
            }else{
                self.clearImageView3?.isHidden = false
            }
            

            
            let text = textField.text ?? ""
            
            if string.count == 0 {
                textField.text = String(text.dropLast()).chunkFormattedPersonalID()
            }  else {
                let newText = String((text + string).filter({ $0 != "-" }).prefix(13))
                textField.text = newText.chunkFormattedPersonalID()
            }
            
            
            return false
            
        }
        if textField  == self.mobileTextField {
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //return newLength <= 20
            
            if newLength == 0 {
                self.clearImageView4?.isHidden = true
            }else{
                self.clearImageView4?.isHidden = false
            }
            
            //Mobile
            let text = textField.text ?? ""
            
            if string.count == 0 {
                textField.text = String(text.dropLast()).chunkFormatted()
            }  else {
                let newText = String((text + string).filter({ $0 != "-" }).prefix(10))
                textField.text = newText.chunkFormatted()
            }
            return false
            
        }
        if textField  == self.emailTextField {
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //return newLength <= 20
            
            if newLength == 0 {
                self.clearImageView5?.isHidden = true
            }else{
                self.clearImageView5?.isHidden = false
            }
            
        }
        if textField  == self.laserIdTextField {
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //return newLength <= 20
            
            if newLength == 0 {
                self.clearImageView6?.isHidden = true
            }else{
                self.clearImageView6?.isHidden = false
            }
            
            //validate laserId
            let text = textField.text ?? ""
            if string.count == 0 {
                textField.text = String(text.dropLast()).chunkFormattedLaserID()
            }  else {
                let newText = String((text + string).filter({ $0 != "-" }).prefix(12))
                textField.text = newText.chunkFormattedLaserID()
            }
            return false
            
        }
        
        return true
        
    }
    func clearColorLineView(){
        fview.backgroundColor = UIColor.groupTableViewBackground
        lview.backgroundColor = UIColor.groupTableViewBackground
        eview.backgroundColor = UIColor.groupTableViewBackground
        mview.backgroundColor = UIColor.groupTableViewBackground
        idview.backgroundColor = UIColor.groupTableViewBackground
        lasetIdView.backgroundColor = UIColor.groupTableViewBackground
        birthdateView.backgroundColor = UIColor.groupTableViewBackground
        
    }
    func addColorLineView(_ textField:UITextField){
        switch textField {
        case firstNameTextField:
            fview.backgroundColor = UIColor.darkGray
            lview.backgroundColor = UIColor.groupTableViewBackground
            eview.backgroundColor = UIColor.groupTableViewBackground
            mview.backgroundColor = UIColor.groupTableViewBackground
            idview.backgroundColor = UIColor.groupTableViewBackground
            lasetIdView.backgroundColor = UIColor.groupTableViewBackground
            birthdateView.backgroundColor = UIColor.groupTableViewBackground
            break
        case lastNameTextField:
            fview.backgroundColor = UIColor.groupTableViewBackground
            lview.backgroundColor = UIColor.darkGray
            eview.backgroundColor = UIColor.groupTableViewBackground
            mview.backgroundColor = UIColor.groupTableViewBackground
            idview.backgroundColor = UIColor.groupTableViewBackground
            lasetIdView.backgroundColor = UIColor.groupTableViewBackground
            birthdateView.backgroundColor = UIColor.groupTableViewBackground
            break
        case emailTextField:
            fview.backgroundColor = UIColor.groupTableViewBackground
            lview.backgroundColor = UIColor.groupTableViewBackground
            eview.backgroundColor = UIColor.darkText
            mview.backgroundColor = UIColor.groupTableViewBackground
            idview.backgroundColor = UIColor.groupTableViewBackground
            lasetIdView.backgroundColor = UIColor.groupTableViewBackground
            birthdateView.backgroundColor = UIColor.groupTableViewBackground
            break
        case mobileTextField:
            fview.backgroundColor = UIColor.groupTableViewBackground
            lview.backgroundColor = UIColor.groupTableViewBackground
            eview.backgroundColor = UIColor.groupTableViewBackground
            mview.backgroundColor = UIColor.darkText
            idview.backgroundColor = UIColor.groupTableViewBackground
            lasetIdView.backgroundColor = UIColor.groupTableViewBackground
            birthdateView.backgroundColor = UIColor.groupTableViewBackground
            break
        case idcardTextField:
            fview.backgroundColor = UIColor.groupTableViewBackground
            lview.backgroundColor = UIColor.groupTableViewBackground
            eview.backgroundColor = UIColor.groupTableViewBackground
            mview.backgroundColor = UIColor.groupTableViewBackground
            idview.backgroundColor = UIColor.darkText
            lasetIdView.backgroundColor = UIColor.groupTableViewBackground
            birthdateView.backgroundColor = UIColor.groupTableViewBackground
            break
        case laserIdTextField:
            fview.backgroundColor = UIColor.groupTableViewBackground
            lview.backgroundColor = UIColor.groupTableViewBackground
            eview.backgroundColor = UIColor.groupTableViewBackground
            mview.backgroundColor = UIColor.groupTableViewBackground
            idview.backgroundColor = UIColor.groupTableViewBackground
            lasetIdView.backgroundColor = UIColor.darkText
            birthdateView.backgroundColor = UIColor.groupTableViewBackground
            break
        case birthdateTextField:
            fview.backgroundColor = UIColor.groupTableViewBackground
            lview.backgroundColor = UIColor.groupTableViewBackground
            eview.backgroundColor = UIColor.groupTableViewBackground
            mview.backgroundColor = UIColor.groupTableViewBackground
            idview.backgroundColor = UIColor.groupTableViewBackground
            lasetIdView.backgroundColor = UIColor.groupTableViewBackground
            birthdateView.backgroundColor = UIColor.darkText
            break
            
        default:
            break
        }
    }
    
    
    func clearImageViewTextField(){
        self.clearImageView?.isHidden = true
        self.clearImageView2?.isHidden = true
        self.clearImageView3?.isHidden = true
        self.clearImageView4?.isHidden = true
        self.clearImageView5?.isHidden = true
    }
    @objc func clearFirstNameTapped(){
        self.clearImageView?.animationTapped({
            self.firstNameTextField.text = ""
            self.clearImageView?.isHidden = true
            self.enableButton()
        })
    }
    @objc func clearLastNameTapped(){
        self.clearImageView2?.animationTapped({
            self.lastNameTextField.text = ""
            self.clearImageView2?.isHidden = true
            self.enableButton()
        })
        
    }
    @objc func clearPersanalTapped(){
        self.clearImageView3?.animationTapped({
            self.idcardTextField.text = ""
            self.clearImageView3?.isHidden = true
            self.enableButton()
        })
    }
    @objc func clearMobileTapped(){
        self.clearImageView4?.animationTapped({
            self.mobileTextField.text = ""
            self.clearImageView4?.isHidden = true
        })
        
    }
    @objc func clearEmailTapped(){
        self.clearImageView5?.animationTapped({
            self.emailTextField.text = ""
            self.clearImageView5?.isHidden = true
        })
        
    }
    @objc func clearLaserIdTapped(){
        self.clearImageView6?.animationTapped({
            self.laserIdTextField.text = ""
            self.clearImageView5?.isHidden = true
        })
        
    }
    func enableButton(){
        if let count = self.saveButton.layer.sublayers?.count {
            if count > 1 {
                self.saveButton.layer.sublayers?.removeFirst()
            }
        }
        
        self.saveButton.borderClearProperties(borderWidth: 1)
        self.saveButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        self.saveButton.isEnabled = true
    }
    func disableButton(){
        if let count = self.saveButton.layer.sublayers?.count {
            if count > 1 {
                self.saveButton.layer.sublayers?.removeFirst()
            }
        }
        self.saveButton.borderClearProperties(borderWidth: 1)
        self.saveButton.applyGradient(colours: [UIColor.lightGray, UIColor.lightGray])
        
        self.saveButton.isEnabled = false
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        
        self.statusView.ovalColorClearProperties()
        // dash
        vborder.path = UIBezierPath(roundedRect: self.backgroundIdCardPhotoImageView.bounds,
                                    cornerRadius: 10).cgPath
        vborder.frame = self.backgroundIdCardPhotoImageView.bounds
        
        self.hiddenIdCardPhotoImageView.borderClearProperties(borderWidth: 0, radius: 10)
        self.containerView.borderLightGrayColorProperties(borderWidth: 0.5, radius: 10)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        
        if let imageData = chosenImage.pngData() {
            let bytes = imageData.count
            let KB = Double(bytes) / 1024.0 // Note the difference
            print("size of image in KB: \(KB)")
        }
        
        // square for profile
        let resizeImage = chosenImage.resizeUIImage(targetSize: CGSize(width: 400.0, height: 400.0))
        self.idCardPhoto = resizeImage
        
        if let imageData = resizeImage.pngData() {
            let bytes = imageData.count
            let KB = Double(bytes) / 1024.0 // Note the difference
            print("size of image in KB: \(KB)")
        }
        
        
        //reload data
        self.hiddenIdCardPhotoImageView.image = resizeImage
        
        self.enableButton()
        
    }
    
    @objc func browseTapped(){
        self.addFileTapped()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == self.firstNameTextField {
            self.lastNameTextField.becomeFirstResponder()
        }
        if textField == self.lastNameTextField {
            self.emailTextField.becomeFirstResponder()
        }
        if textField == self.emailTextField {
            self.mobileTextField.becomeFirstResponder()
        }
        if textField == self.mobileTextField {
            self.idcardTextField.becomeFirstResponder()
        }
        if textField == self.idcardTextField {
            self.laserIdTextField.becomeFirstResponder()
        }
        if textField == self.laserIdTextField {
            self.birthdateTextField.becomeFirstResponder()
        }
        return true
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
    @IBAction func saveStepTapped(_ sender: Any) {
        
        
        errorLastnamelLabel?.removeFromSuperview()
        errorFirstNameLabel?.removeFromSuperview()
        errorPersonalIDLabel?.removeFromSuperview()
        errorEmailLabel?.removeFromSuperview()
        errorMobileLabel?.removeFromSuperview()
        errorLaserIdLabel?.removeFromSuperview()
        errorBirthdateLabel?.removeFromSuperview()
        
        
        let firstName = self.firstNameTextField.text!
        let lastName = self.lastNameTextField.text!
        let personalID  = self.idcardTextField.text!
        let mobile = self.mobileTextField.text!
        let email = self.emailTextField.text!
        let laserId = self.laserIdTextField.text!
        let birthdate = self.birthdateTextField.text!
        
        var errorEmpty = 0
        var emptyMessage = ""
        
        if birthdate.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-birth-date", comment: "")
            self.errorBirthdateLabel =  self.birthdateTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 15 )
            errorEmpty += 1
            
        }
        if laserId.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-laser-id", comment: "")
            self.errorLaserIdLabel =  self.laserIdTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 15 )
            errorEmpty += 1
            
        }
        if personalID.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-personal-id", comment: "")
            self.errorPersonalIDLabel =  self.idcardTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 15 )
            errorEmpty += 1
            
        }
        if mobile.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-mobile", comment: "")
            self.errorMobileLabel =  self.mobileTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 15 )
            errorEmpty += 1
            
        }
        if email.isEmpty{
            emptyMessage = NSLocalizedString("string-error-empty-email", comment: "")
            self.errorEmailLabel =  self.emailTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 15 )
            errorEmpty += 1
        }
        if lastName.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-lastname", comment: "")
            self.errorLastnamelLabel =  self.lastNameTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 10 )
            errorEmpty += 1
            
        }
        if firstName.isEmpty {
            emptyMessage = NSLocalizedString("string-error-empty-firstname", comment: "")
            self.errorFirstNameLabel =  self.firstNameTextField.addBottomLabelErrorMessage(emptyMessage, marginLeft: 15 )
            errorEmpty += 1
        }
        
        
        if errorEmpty > 0 {
            self.showMessagePrompt(NSLocalizedString("string-error-empty-fill", comment: ""))
            return
        }
        
       
        
        guard validateLaserId(laserId) else { return }
        guard validateIDcard(personalID) else { return }
        guard validateMobile(mobile) else { return }
        
        guard (self.idCardPhoto != nil) else {
            showMessagePrompt(NSLocalizedString("string-message-alert-please-choose-image", comment: ""))
            return
        }
       
        
        if isValidEmail(email) {
            //pass
            let alert = UIAlertController(title:
                NSLocalizedString("string-dailog-change-data-confirm", comment: ""),
                                          message: "", preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: NSLocalizedString("string-dailog-gold-button-confirm", comment: ""), style: .default, handler: {
                (alert) in
                
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                
                let date = convertBuddhaToChris(formatter.string(from: self.pickerView!.date))
                
                
                let params:Parameters = ["firstname": firstName,
                                         "lastname" : lastName,
                                         "pid" : personalID.replace(target: "-", withString: ""),
                                         "laser_id": laserId.replace(target: "-", withString: ""),
                                         "birthdate":date]
                print(params)
             
                var image = self.idCardPhoto
                if self.idCardPhoto != nil {
                    image = self.idCardPhoto
                }else{
                    image = self.hiddenIdCardPhotoImageView.image
                }
                
               
                
                self.modelCtrl.updateGoldMember(params, image, true, succeeded: { (result) in
                    print("print")
                    self.clearColorLineView()
                    self.disableButton()
                    self.clearImageViewTextField()
                    
                    self.showEditPenddingVerifyModalView(true , dismissCallback: {
                        self.getUserInfo(){
                            self.updateView()
                        }
                    })
                }, error: { (error) in
                    if let mError = error as? [String:AnyObject]{
                        let message = mError["message"] as? String ?? ""
                        print(message)
                        self.showMessagePrompt(message)
                        
                    }
                    
                    
                }, failure: { (messageError) in
                    self.handlerMessageError(messageError)
                    self.refreshControl?.endRefreshing()
                }, inprogress: { (progress) in
                    if progress >= 1.0 {
                        //hide
                        //success
                        self.clearColorLineView()
                        self.disableButton()
                        self.clearImageViewTextField()
                        
                    }
                }) { (upload) in
                    self.upload = upload
                }

               
            })
 
            let cancelButton = UIAlertAction(title: NSLocalizedString("string-dailog-gold-button-cancel", comment: ""), style: .default, handler: nil)
            
            
            alert.addAction(cancelButton)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }else{
            let emailNotValid = NSLocalizedString("string-error-invalid-email", comment: "")
            self.showMessagePrompt(emailNotValid)
            self.errorEmailLabel =  self.emailTextField.addBottomLabelErrorMessage(emailNotValid, marginLeft: 0 )
        }
        
        
        
    }
    
    func validateLaserId(_ id:String)->Bool {
        var errorMobile = 0
        var errorMessage = ""
        let nID = id.replace(target: "-", withString: "")
        
        print("laserId = \(nID)")
        if !isValidLaserIdCard(nID) {
            errorMessage = NSLocalizedString("string-error-invalid-laser-id", comment: "")
            errorMobile += 1
        }
        if nID.count < 12 {
            errorMessage = NSLocalizedString("string-error-invalid-laser-id1", comment: "")
            errorMobile += 1
        }
        
        if errorMobile > 0 {
            self.showMessagePrompt(errorMessage)
            self.errorLaserIdLabel =  self.laserIdTextField.addBottomLabelErrorMessage(errorMessage , marginLeft: 15)
            return false
        }
        return true
    }
    
    func validateIDcard(_ id:String)-> Bool{
        var errorMobile = 0
        var errorMessage = ""
        let nID = id.replace(target: "-", withString: "")
        if !isValidIDCard(nID) {
            errorMessage = NSLocalizedString("string-error-invalid-personal-id", comment: "")
            errorMobile += 1
        }
        if nID.count < 13 {
            errorMessage = NSLocalizedString("string-error-invalid-personal-id1", comment: "")
            errorMobile += 1
        }
        
        if errorMobile > 0 {
            self.showMessagePrompt(errorMessage)
            self.errorPersonalIDLabel =  self.idcardTextField.addBottomLabelErrorMessage(errorMessage , marginLeft: 15)
            return false
        }
        return true
    }
    
    func validateMobile(_ mobile:String)-> Bool{
        var errorMobile = 0
        var errorMessage = ""
        let nMobile = mobile.replace(target: "-", withString: "")
        if nMobile.count != 10 {
            errorMobile += 1
        }
        if !checkPrefixcellPhone(nMobile) {
            errorMessage = NSLocalizedString("string-error-invalid-mobile", comment: "")
            errorMobile += 1
        }
        if nMobile.count < 10 {
            errorMessage = NSLocalizedString("string-error-invalid-mobile1", comment: "")
            errorMobile += 1
        }
        if nMobile.count > 10 {
            errorMessage = NSLocalizedString("string-error-invalid-mobile2", comment: "")
            errorMobile += 1
        }
        if errorMobile > 0 {
            
            self.showMessagePrompt(errorMessage)
            self.errorMobileLabel =  self.mobileTextField.addBottomLabelErrorMessage(errorMessage , marginLeft: 15)
            return false
        }
        return true
    }
   

}
