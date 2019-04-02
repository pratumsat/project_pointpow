//
//  PickerLuckyDrawCell.swift
//  pointpow
//
//  Created by thanawat on 2/4/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PickerLuckyDrawCell: UICollectionViewCell, UIPickerViewDelegate , UIPickerViewDataSource, UIGestureRecognizerDelegate {
   
    
    @IBOutlet weak var unitView: UIImageView!
    
    
    var pickerView:UIPickerView?
    var schedule:[[String:AnyObject]]?{
        didSet{
            setUpPicker()
        }
    }
    var selectedUnits = 0
    
    @IBOutlet weak var scheduleTextField: UITextField!
    
    var memberCallback:((_ member:[[String:AnyObject]])->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.scheduleTextField.setRightPaddingPoints(20)
        self.scheduleTextField.setLeftPaddingPoints(20)
        
        let dropdownTap = UITapGestureRecognizer(target: self, action: #selector(dropdownTapped))
        self.unitView.isUserInteractionEnabled = true
        self.unitView.addGestureRecognizer(dropdownTap)
        
        
    }
    
    @objc func dropdownTapped(){
        self.scheduleTextField.becomeFirstResponder()
    }
    
    func setUpPicker(){
        
        pickerView = UIPickerView()
        pickerView!.delegate = self
        pickerView!.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickerTapped))
        tap.delegate = self
        pickerView!.addGestureRecognizer(tap)
        
        
        self.scheduleTextField.tintColor = UIColor.clear
        self.scheduleTextField.isUserInteractionEnabled = true
        self.scheduleTextField.inputView = pickerView
        self.scheduleTextField.addDoneButtonToKeyboard()
        
        self.scheduleTextField.borderRedColorProperties(borderWidth: 1)
        self.scheduleTextField.isEnabled = true
        
        self.scheduleTextField.textColor = UIColor.black
        self.selectedUnits = 0
        
        if let data = self.schedule {
            let winner = data.first?["winners"] as? [[String:AnyObject]] ?? [[:]]
            let id = data.first?["id"] as? NSNumber ?? 0
            let schedule = data.first?["schedule"] as? [String:AnyObject] ?? [:]
            let announce_at = schedule["announce_at"] as? String ?? ""
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "th")
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            if let d1 = dateFormatter.date(from: convertDateRegister(announce_at, format: "yyyy-MM-dd HH:mm:ss")) {
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "th")
                formatter.dateFormat = "d MMMM yyyy"
                
                var dataFormat = NSLocalizedString("string-date-format-announce-at", comment: "")
                dataFormat = dataFormat.replacingOccurrences(of: "{id}", with: "\(id.intValue)", options: .literal, range: nil)
                dataFormat = dataFormat.replacingOccurrences(of: "{date}", with: "\(formatter.string(from: d1))", options: .literal, range: nil)
                
                self.scheduleTextField.text = dataFormat
                
                self.memberCallback?(winner)
            }
        }
      
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
       
    @objc func pickerTapped(_ tapRecognizer:UITapGestureRecognizer){
        if tapRecognizer.state == .ended {
            let rowHeight = self.pickerView!.rowSize(forComponent: 0).height
            let selectedRowFrame = self.pickerView!.bounds.insetBy(dx: 0, dy: (self.pickerView!.frame.height - rowHeight) / 2)
            let userTappedOnSelectedRow = selectedRowFrame.contains(tapRecognizer.location(in: self.pickerView))
            if userTappedOnSelectedRow {
                let selectedRow = self.pickerView!.selectedRow(inComponent: 0)
                
                self.selectedUnits = selectedRow
                self.scheduleTextField.resignFirstResponder()
                
               // self.scheduleTextField.text = "\(self.units[selectedRow])"
                //self.schedule?.first["announce_at"] ?? ""
                //self.scheduleTextField.text =
                
                if let data = self.schedule?[selectedRow] {
                    let winner = data["winners"] as? [[String:AnyObject]] ?? [[:]]
                    let id = data["id"] as? NSNumber ?? 0
                    let schedule = data["schedule"] as? [String:AnyObject] ?? [:]
                    let announce_at = schedule["announce_at"] as? String ?? ""
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "th")
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    
                    if let d1 = dateFormatter.date(from: convertDateRegister(announce_at, format: "yyyy-MM-dd HH:mm:ss")) {
                        
                        let formatter = DateFormatter()
                        formatter.locale = Locale(identifier: "th")
                        formatter.dateFormat = "d MMMM yyyy"
                        
                        var dataFormat = NSLocalizedString("string-date-format-announce-at", comment: "")
                        dataFormat = dataFormat.replacingOccurrences(of: "{id}", with: "\(id.intValue)", options: .literal, range: nil)
                        dataFormat = dataFormat.replacingOccurrences(of: "{date}", with: "\(formatter.string(from: d1))", options: .literal, range: nil)
                        
                        self.scheduleTextField.text = dataFormat
                        
                        self.memberCallback?(winner)
                    }
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.schedule?.count ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.selectedUnits = row
        //self.scheduleTextField.text = "\(self.units[row])"
        
        if let data = self.schedule?[row] {
            let winner = data["winners"] as? [[String:AnyObject]] ?? [[:]]
            let id = data["id"] as? NSNumber ?? 0
            let schedule = data["schedule"] as? [String:AnyObject] ?? [:]
            let announce_at = schedule["announce_at"] as? String ?? ""
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "th")
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            if let d1 = dateFormatter.date(from: convertDateRegister(announce_at, format: "yyyy-MM-dd HH:mm:ss")) {
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "th")
                formatter.dateFormat = "d MMMM yyyy"
                
                var dataFormat = NSLocalizedString("string-date-format-announce-at", comment: "")
                dataFormat = dataFormat.replacingOccurrences(of: "{id}", with: "\(id.intValue)", options: .literal, range: nil)
                dataFormat = dataFormat.replacingOccurrences(of: "{date}", with: "\(formatter.string(from: d1))", options: .literal, range: nil)
                
                self.scheduleTextField.text = dataFormat
                self.memberCallback?(winner)
                return  dataFormat
            }
        }
        
        return  ""
    }
    
    
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.scheduleTextField.borderRedColorProperties()
    }
}
