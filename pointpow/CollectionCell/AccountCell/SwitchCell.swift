//
//  SwitchCell.swift
//  pointpow
//
//  Created by thanawat on 14/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class SwitchCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    
    var toggleValueCallback:((_ toggleValue:Bool,_ typeValue:String)->Void)?
    var typeValue:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /*For off state*/
        self.toggleSwitch.tintColor = UIColor.groupTableViewBackground
        self.toggleSwitch.layer.cornerRadius = self.toggleSwitch.frame.height / 2
        self.toggleSwitch.backgroundColor = UIColor.groupTableViewBackground
        
        
    }
  
    @IBAction func toggleTapped(_ sender: Any) {
        self.toggleValueCallback?(toggleSwitch.isOn , self.typeValue ?? "")
    }
    
}
