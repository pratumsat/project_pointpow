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
        
        self.registerNib(self.resultCollectionView, "ItemFriendSummaryCell")
        self.registerNib(self.resultCollectionView, "ItemConfirmSummaryCell")
        self.registerHeaderNib(self.resultCollectionView, "HeadCell")
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if indexPath.section == 0 {
            if let statusCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemFriendSummaryCell", for: indexPath) as? ItemFriendSummaryCell {
                
                statusCell.roundCorners(corners: [.topLeft, .topRight , .bottomLeft , .bottomRight], radius: 10)
                cell = statusCell
                
            }
        }
        
        if indexPath.section == 1 {
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
        if section == 1 {
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
            let height = width/360*400
            return CGSize(width: width, height: height)
            
        }else if indexPath.section == 1 {
            
            let width = collectionView.frame.width - 40
            let height = CGFloat(40)
            return CGSize(width: width, height: height)
            
        }
        return CGSize.zero
    }


}
/*
 
 if let img  = captureView.snapshotImage()  {
    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
 
 }
 
 */
