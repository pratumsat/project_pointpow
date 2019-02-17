//
//  WithdrawCell.swift
//  pointpow
//
//  Created by thanawat on 17/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class WithdrawCell: UICollectionViewCell ,UIPickerViewDelegate , UIPickerViewDataSource, UIGestureRecognizerDelegate {
   
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var result2saluengLabel: UILabel!
    
    @IBOutlet weak var result1saluengLabel: UILabel!
    
    @IBOutlet weak var result10bahtLabel: UILabel!
    @IBOutlet weak var result5bahtLabel: UILabel!
    @IBOutlet weak var result2bahtLabel: UILabel!
    @IBOutlet weak var result1bahtLabel: UILabel!
    
    @IBOutlet weak var result2salueng1View: UIView!
    @IBOutlet weak var result2salueng2View: UIView!
    
    @IBOutlet weak var result1salueng1View: UIView!
    @IBOutlet weak var result1salueng2View: UIView!
    
    @IBOutlet weak var result10baht1View: UIView!
    @IBOutlet weak var result10baht2View: UIView!
    
    @IBOutlet weak var result5baht1View: UIView!
    @IBOutlet weak var result5baht2View: UIView!
    
    @IBOutlet weak var result2baht1View: UIView!
    @IBOutlet weak var result2baht2View: UIView!
    
    @IBOutlet weak var result1baht1View: UIView!
    @IBOutlet weak var result1baht2View: UIView!
    
    
    @IBOutlet weak var height2saluengConstraint: NSLayoutConstraint!
    @IBOutlet weak var height1saluengConstraint: NSLayoutConstraint!
    @IBOutlet weak var height10bahtConstraint: NSLayoutConstraint!
    @IBOutlet weak var height5bahtConstraint: NSLayoutConstraint!
    @IBOutlet weak var height2bahtConstraint: NSLayoutConstraint!
    @IBOutlet weak var height1bahtConstraint: NSLayoutConstraint!
    @IBOutlet weak var _2saluengView: UIView!
    @IBOutlet weak var _1saluengView: UIView!
    @IBOutlet weak var _10bahtView: UIView!
    @IBOutlet weak var _5bahtView: UIView!
    @IBOutlet weak var _2bahtView: UIView!
    @IBOutlet weak var _1bahtView: UIView!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    
    var defaultHeight = 30
    
     var pickerView:UIPickerView?
    var units = [NSLocalizedString("unit-salueng", comment: ""),NSLocalizedString("unit-baht", comment: "")]
    var selectedUnits:Int = 0 {
        didSet{
            unitCallback?(selectedUnits)
        }
    }
    var unitCallback:((_ unit:Int)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.updateLayerCornerRadiusProperties()
        self.contentView.updateLayerCornerRadiusProperties()
        self.shadowCellProperties()
        
        self.setUpPicker()
        self.updateView()
    }
    func updateView(){
        //height defau
        //height2saluengConstraint.constant = 0
        //height1saluengConstraint.constant = 0
    }
    
    func setUpPicker(){
        
        pickerView = UIPickerView()
        pickerView!.delegate = self
        pickerView!.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickerTapped))
        tap.delegate = self
        pickerView!.addGestureRecognizer(tap)
   
        
        self.unitTextField.tintColor = UIColor.clear
        self.unitTextField.isUserInteractionEnabled = true
        self.unitTextField.inputView = pickerView
        
        self.unitTextField.text = self.units[0]
        self.selectedUnits = 0
        
        
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
                self.unitTextField.text = "\(self.units[selectedRow])"
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.units.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.selectedUnits = row
        self.unitTextField.text = "\(self.units[row])"
        
        return "\(self.units[row])"
    }
    
    
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.amountTextField.borderRedColorProperties(borderWidth: 1)
        self.amountTextField.setRightPaddingPoints(10)
        
        self.unitTextField.borderRedColorProperties(borderWidth: 1)
        self.unitTextField.setRightPaddingPoints(40)
        
        
        premiumView.borderClearProperties(borderWidth: 1)
        
        result2salueng1View.borderClearProperties(borderWidth: 1)
        result2salueng2View.borderClearProperties(borderWidth: 1)
        
        result1salueng1View.borderClearProperties(borderWidth: 1)
        result1salueng2View.borderClearProperties(borderWidth: 1)
        
        result10baht1View.borderClearProperties(borderWidth: 1)
        result10baht2View.borderClearProperties(borderWidth: 1)
        
        result5baht1View.borderClearProperties(borderWidth: 1)
        result5baht2View.borderClearProperties(borderWidth: 1)
        
        result2baht1View.borderClearProperties(borderWidth: 1)
        result2baht2View.borderClearProperties(borderWidth: 1)
        
        result1baht1View.borderClearProperties(borderWidth: 1)
        result1baht2View.borderClearProperties(borderWidth: 1)

    }
}
