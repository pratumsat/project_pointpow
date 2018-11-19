//
//  PointFriendSummaryViewController.swift
//  pointpow
//
//  Created by thanawat on 19/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class PointFriendSummaryViewController: BaseViewController  , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-freind-transfer", comment: "")
        self.setUp()
    }
    func setUp(){
        self.handlerEnterSuccess = {
            //result
            self.showTransferSuccessPopup(true)
        }
        self.resultCollectionView.dataSource = self
        self.resultCollectionView.delegate = self
        
        self.registerNib(self.resultCollectionView, "ItemListResultCell")
        self.registerNib(self.resultCollectionView, "ItemFriendSummaryCell")
        self.registerNib(self.resultCollectionView, "ItemConfirmSummaryCell")
        self.registerHeaderNib(self.resultCollectionView, "HeadCell")
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 2 {
            return 1
        }
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
        if indexPath.section == 2 {
            if let confirmCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemConfirmSummaryCell", for: indexPath) as? ItemConfirmSummaryCell {
                
                
                confirmCell.backCallback = {
                    self.navigationController?.popViewController(animated: true)
                }
                confirmCell.confirmCallback = {
                     self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
                }
                
                cell = confirmCell
            }
        }
        if indexPath.section == 0 {
            if let statusCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemFriendSummaryCell", for: indexPath) as? ItemFriendSummaryCell {

                statusCell.roundCorners(corners: [.topLeft, .topRight], radius: 10)
                cell = statusCell
                
            }
        }
        if indexPath.section == 1 {
            if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemListResultCell", for: indexPath) as? ItemListResultCell {
                

                switch indexPath.row {
                case 0:
                    itemCell.keyLabel.text = NSLocalizedString("string-point-friend-result-transfer", comment: "")
                    itemCell.valueLabel.text = "50.00 Point Pow"
                    
                case 1:
                    itemCell.keyLabel.text = NSLocalizedString("string-point-friend-result-to", comment: "")
                    itemCell.valueLabel.text = "pinny"
                case 2:
                    itemCell.keyLabel.text = NSLocalizedString("string-point-friend-result-balance", comment: "")
                    itemCell.valueLabel.text = "100.00 Point Pow"
                    
                case 3:
                    itemCell.keyLabel.text = ""
                    itemCell.valueLabel.text = ""
                    
                    let lineBottom = UIView(frame: CGRect(x: 20, y: itemCell.frame.height/2 , width: itemCell.frame.width - 40 , height: 1 ))
                    lineBottom.backgroundColor = Constant.Colors.LINE_PROFILE
                    itemCell.addSubview(lineBottom)
                    
                case 4:
                    itemCell.keyLabel.text = NSLocalizedString("string-point-friend-result-create-time", comment: "")
                    itemCell.valueLabel.text = "31-12-2018 01:00"
                case 5:
                    itemCell.keyLabel.text = NSLocalizedString("string-point-friend-result-transfer-time", comment: "")
                    itemCell.valueLabel.text = "31-12-2018 01:30"
                case 6:
                    itemCell.keyLabel.text = ""
                    itemCell.valueLabel.text = ""
                    
                    itemCell.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
                default:
                    break
                }
                
                
                cell = itemCell
                
            }
        }
        
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.frame.width, height: 30)
        }
        if section == 2 {
            return CGSize(width: collectionView.frame.width, height: 10)
        }
       
        
        return CGSize.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeadCell", for: indexPath) as! HeadCell
        header.backgroundColor = UIColor.clear
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let width = collectionView.frame.width - 40
            let height = width/410*150
            return CGSize(width: width, height: height)
            
        }else if indexPath.section == 1{
            
            if indexPath.row == 3 {
                let width = collectionView.frame.width - 40
                let height = CGFloat(10)
                return CGSize(width: width, height: height)
            }
            let width = collectionView.frame.width - 40
            let height = CGFloat(40)
            return CGSize(width: width, height: height)
            
        }else if indexPath .section == 2 {
            let width = collectionView.frame.width  - 40
            let height = CGFloat(50)
            return CGSize(width: width, height: height)
        }
        return CGSize.zero
    }


}
