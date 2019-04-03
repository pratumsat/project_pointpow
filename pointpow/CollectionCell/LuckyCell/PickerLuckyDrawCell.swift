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
    
    var selectedId:Int!
    
    @IBOutlet weak var scheduleTextField: UITextField!
    
    var memberCallback:((_ id:Int, _ linkLive:String ,_ member:[[String:AnyObject]], _ banners:[[String:AnyObject]])->Void)?
    
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
    @objc func doneButtonAction(){
        if let data = self.schedule?[selectedUnits] {
            let winner = data["winners"] as? [[String:AnyObject]] ?? [[:]]
            let schedule = data["schedule"] as? [String:AnyObject] ?? [:]
            let id = data["id"] as? NSNumber ?? 0
            let link = schedule["link"] as? String ?? ""
            
            var banners:[[String:AnyObject]] = []
            banners.append(schedule)
            self.memberCallback?(id.intValue, link,  winner, banners)
        }
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
        
        let doneBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        self.scheduleTextField.addDoneButtonToKeyboard(doneButton: doneBtn)
        
        self.scheduleTextField.borderRedColorProperties(borderWidth: 1)
        self.scheduleTextField.isEnabled = true
        
        self.scheduleTextField.textColor = UIColor.black
        self.selectedUnits = 0
        
        if let data = self.schedule {
        
            for itemData in  data {
                let id = itemData["id"] as? NSNumber ?? 0
                if self.selectedId == id.intValue {
                    let schedule = itemData["schedule"] as? [String:AnyObject] ?? [:]
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
                        
                    }

                }
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
                        
                        let schedule = data["schedule"] as? [String:AnyObject] ?? [:]
                        let id = data["id"] as? NSNumber ?? 0
                        let link = schedule["link"] as? String ?? ""
                        
                        var banners:[[String:AnyObject]] = []
                        banners.append(schedule)
                        self.memberCallback?(id.intValue, link,  winner, banners)
                        
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
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedUnits = row
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if let data = self.schedule?[row] {
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
