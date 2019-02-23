//
//  PopupGoldHistoryFilterViewController.swift
//  pointpow
//
//  Created by thanawat on 21/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PopupGoldHistoryFilterViewController: BaseViewController  ,UIPickerViewDelegate , UIPickerViewDataSource{
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var statusDropdownImageView: UIImageView!
    var tupleFilter:(startDate:String , endDate:String, status:String)?
    var nextStep:((_ data:AnyObject)->Void)?
    var editData:AnyObject?
    @IBOutlet weak var searchButton: UIButton!
    
    var pickerView:UIDatePicker?
    var pickerView2:UIDatePicker?
    var statusPickerView:UIPickerView?

    var slectedStatus:String = ""
    let status = ["all","success","cancel"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundImage?.image = nil
        self.statusTextField.delegate = self
        self.setUpPicker()
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "th")
        formatter.dateFormat = "dd-MM-yyyy"
        self.startDateTextField.text = formatter.string(from: pickerView!.date)
        
        if pickerView!.date.timeIntervalSinceReferenceDate > pickerView2!.date.timeIntervalSinceReferenceDate {
            self.endDateTextField.text = formatter.string(from: pickerView!.date)
        }
        pickerView2?.minimumDate = pickerView!.date
        
        self.view.endEditing(true)
    }
    @objc func donedatePicker2(){
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "th")
        formatter.dateFormat = "dd-MM-yyyy"
        self.endDateTextField.text = formatter.string(from: pickerView2!.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    func setUpPicker(){
        self.searchButton.borderClearProperties(borderWidth: 1)
        
        pickerView = UIDatePicker()
        pickerView!.datePickerMode = .date
        pickerView!.calendar = Calendar(identifier: .buddhist)
        
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self,
                                         action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                          target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self,
                                           action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        self.startDateTextField.tintColor = UIColor.clear
        self.startDateTextField.isUserInteractionEnabled = true
        self.startDateTextField.inputView = pickerView
        self.startDateTextField.inputAccessoryView = toolbar
        
        
        
        let toolbar2 = UIToolbar();
        toolbar2.sizeToFit()
        let doneButton2 = UIBarButtonItem(title: "Done", style: .plain, target: self,
                                         action: #selector(donedatePicker2));
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                          target: nil, action: nil)
        let cancelButton2 = UIBarButtonItem(title: "Cancel", style: .plain, target: self,
                                           action: #selector(cancelDatePicker));
        toolbar2.setItems([doneButton2,spaceButton2,cancelButton2], animated: false)
        
        pickerView2 = UIDatePicker()
        pickerView2!.datePickerMode = .date
        pickerView2!.calendar = Calendar(identifier: .buddhist)
        
  
        self.endDateTextField.tintColor = UIColor.clear
        self.endDateTextField.isUserInteractionEnabled = true
        self.endDateTextField.inputView = pickerView2
        self.endDateTextField.inputAccessoryView = toolbar2
        
        self.statusPickerView = UIPickerView()
        self.statusPickerView!.delegate = self
        self.statusPickerView!.dataSource = self
        
        self.statusTextField.tintColor = UIColor.clear
        self.statusTextField.isUserInteractionEnabled = true
        self.statusTextField.inputView = self.statusPickerView
        
        
        if let data:(startDate:String , endDate:String, status:String) = self.editData as? (startDate:String , endDate:String, status:String){
            
            self.startDateTextField.text = data.startDate
            self.endDateTextField.text = data.endDate
            
            self.pickerView?.date = convertToDate(data.startDate, "dd-MM-yyyy")
            self.pickerView2?.date = convertToDate(data.endDate, "dd-MM-yyyy")
            
            if data.status == "all"{
                self.slectedStatus = "all"
                self.statusTextField.text = NSLocalizedString("string-status-gold-history-all", comment: "")
            }
            if data.status == "cancel" {
                self.slectedStatus = "cancel"
                self.statusTextField.text = NSLocalizedString("string-status-gold-history-cancel", comment: "")
            }
            if data.status == "success" {
                self.slectedStatus = "success"
                self.statusTextField.text = NSLocalizedString("string-status-gold-history-success", comment: "")
            }
        }else{
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "th")
            formatter.dateFormat = "dd-MM-yyyy"
            
            self.startDateTextField.text = formatter.string(from: Date())
            self.endDateTextField.text = formatter.string(from: Date())
            
            
            
            
            self.slectedStatus = "all"
            self.statusTextField.text = NSLocalizedString("string-status-gold-history-all", comment: "")
        }
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.status.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.statusPickerView{
            if status[row] == "all"{
                return NSLocalizedString("string-status-gold-history-all", comment: "")
            }
            if status[row] == "cancel" {
                return NSLocalizedString("string-status-gold-history-cancel", comment: "")
            }
            if status[row] == "success" {
                return NSLocalizedString("string-status-gold-history-success", comment: "")
            }
            
        }
        
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.statusPickerView{
            if status[row] == "all"{
                self.slectedStatus = "all"
                self.statusTextField.text = NSLocalizedString("string-status-gold-history-all", comment: "")
            }
            if status[row] == "cancel" {
                self.slectedStatus = "cancel"
                self.statusTextField.text = NSLocalizedString("string-status-gold-history-cancel", comment: "")
            }
            if status[row] == "success" {
                self.slectedStatus = "success"
                self.statusTextField.text = NSLocalizedString("string-status-gold-history-success", comment: "")
            }
            
        }
    }
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        //super.textFieldDidBeginEditing(textField)
        
        if textField  == self.statusTextField {
            if textField.text!.isEmpty {
               
                self.slectedStatus = "all"
                self.statusTextField.text = NSLocalizedString("string-status-gold-history-all", comment: "")
                
               
                
            }
        }
    }
    @IBAction func filterTapped(_ sender: Any) {
        self.tupleFilter = (startDate:self.startDateTextField.text! , endDate:self.endDateTextField.text!, status:self.slectedStatus)
        
        self.dismiss(animated: true) {
            self.windowSubview?.removeFromSuperview()
            self.windowSubview = nil
            self.nextStep?((self.tupleFilter as AnyObject))
        }
    }
    override func dismissPoPup() {
        super.dismissPoPup()
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCloseBlackView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.searchButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
        self.startDateTextField.borderRedColorProperties(borderWidth: 0.5)
        self.endDateTextField.borderRedColorProperties(borderWidth: 0.5)
        self.statusTextField.borderRedColorProperties(borderWidth: 0.5)
        
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
