//
//  RegisterGoldstep3ViewController.swift
//  pointpow
//
//  Created by thanawat on 11/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class RegisterGoldstep3ViewController: BaseViewController {

    @IBOutlet weak var backgroundPreviewView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var step1Label: UILabel!
    @IBOutlet weak var step2Label: UILabel!
    @IBOutlet weak var step3Label: UILabel!
    
     @IBOutlet weak var idcardTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    
     var upload:UploadRequest?
    
    @IBOutlet weak var previewImageView: UIImageView!
    var tupleModel:(image : UIImage?, firstname : String,lastname: String , email: String,mobile: String,idcard: String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-gold-register1", comment: "")
        self.setUp()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.upload?.cancel()
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
       
        if #available(iOS 10.0, *) {
            self.firstNameTextField.textContentType = UITextContentType(rawValue: "")
            self.lastNameTextField.textContentType = UITextContentType(rawValue: "")
            self.emailTextField.textContentType = UITextContentType(rawValue: "")
            self.mobileTextField.textContentType = UITextContentType(rawValue: "")
            self.idcardTextField.textContentType = UITextContentType(rawValue: "")
        }
        if #available(iOS 12.0, *) {
            self.firstNameTextField.textContentType = .oneTimeCode
            self.lastNameTextField.textContentType = .oneTimeCode
            self.emailTextField.textContentType = .oneTimeCode
            self.mobileTextField.textContentType = .oneTimeCode
            self.idcardTextField.textContentType = .oneTimeCode
        }
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.mobileTextField.delegate = self
        self.idcardTextField.delegate = self
        
        self.firstNameTextField.isEnabled = false
        self.lastNameTextField.isEnabled = false
        self.emailTextField.isEnabled = false
        self.mobileTextField.isEnabled = false
        self.idcardTextField.isEnabled = false
        
        
        self.firstNameTextField.autocorrectionType = .no
        self.lastNameTextField.autocorrectionType = .no
        self.emailTextField.autocorrectionType = .no
        self.mobileTextField.autocorrectionType = .no
        self.idcardTextField.autocorrectionType = .no
        
        self.firstNameTextField.setLeftPaddingPoints(40)
        self.lastNameTextField.setLeftPaddingPoints(10)
        self.emailTextField.setLeftPaddingPoints(40)
        self.mobileTextField.setLeftPaddingPoints(40)
        self.idcardTextField.setLeftPaddingPoints(40)
        
        self.previewImageView.contentMode = .scaleAspectFit
        
        let back1 = UITapGestureRecognizer(target: self, action: #selector(backToStep1Tapped))
        self.step1Label.isUserInteractionEnabled = true
        self.step1Label.addGestureRecognizer(back1)
        
        
        let back2 = UITapGestureRecognizer(target: self, action: #selector(backToStep2Tapped))
        self.step2Label.isUserInteractionEnabled = true
        self.step2Label.addGestureRecognizer(back2)
    
        
        if let tp = self.tupleModel {
            let newText = String((tp.idcard).filter({ $0 != "-" }).prefix(13))
            self.idcardTextField.text = newText.chunkFormattedPersonalID()
            
            let newMText = String((tp.mobile).filter({ $0 != "-" }).prefix(10))
            self.mobileTextField.text =  newMText.chunkFormatted()
            
            self.firstNameTextField.text = tp.firstname
            self.lastNameTextField.text = tp.lastname
            self.emailTextField.text = tp.email
            
            
            if tp.image != nil{
                self.previewImageView.image = tp.image
                self.previewImageView.isHidden = false
            }else{
                self.previewImageView.image = tp.image
                self.previewImageView.isHidden = true
            }

        }
    }
    
    @objc func backToStep1Tapped(){
        
        self.navigationController?.popToViewController(self.navigationController!.viewControllers[1], animated: true)
    }
    @objc func backToStep2Tapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        
        self.previewImageView.borderClearProperties(borderWidth: 0, radius: 10)
        self.backgroundPreviewView.borderClearProperties(borderWidth: 0, radius: 10)
        
        self.registerButton.borderClearProperties(borderWidth: 1)
        self.registerButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        self.step1Label.ovalColorClearProperties()
        self.step2Label.ovalColorClearProperties()
        self.step3Label.ovalColorClearProperties()
        
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        
        if let tp = self.tupleModel {
            let params:Parameters = [//"email" : tp.email,
                                     //"mobile": tp.mobile,
                                     "laser_id" : "asada",
                                     "firstname": tp.firstname,
                                     "lastname" : tp.lastname,
                                     "pid" : tp.idcard]
            
            
            modelCtrl.registerGoldMember(params, tp.image!, true, succeeded: { (result) in
                print("print")
                self.showPenddingVerifyModalView(true , dismissCallback: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }, error: { (error) in
                if let mError = error as? [String:AnyObject]{
                    let message = mError["message"] as? String ?? ""
                    print(message)
                    self.showMessagePrompt(message)
                }
            }, failure: { (messageError) in
                self.handlerMessageError(messageError)
                
            }, inprogress: { (progress) in
                if progress >= 1.0 {
                    //hide
                    //success
                   
                }
            }) { (upload) in
                self.upload = upload
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
