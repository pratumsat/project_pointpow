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
        let finishButton = UIBarButtonItem(title: NSLocalizedString("string-title-finish-transfer", comment: ""), style: .plain, target: self, action: #selector(dismissTapped))
        finishButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                             NSAttributedString.Key.font :  UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.ITEM_TITLE )!]
            , for: .normal)
        
        self.navigationItem.rightBarButtonItem = finishButton
        
        self.setUp()
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
     
    }
    @objc func dismissTapped(){
        self.dismiss(animated: true) {
            (self.navigationController as? PointFreindSummaryNav)?.callbackFinish?()
        }
        
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        self.resultCollectionView.dataSource = self
        self.resultCollectionView.delegate = self
        self.resultCollectionView.showsVerticalScrollIndicator = false
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
                
                //self.slipView = statusCell.mView
             
               
                cell = statusCell
                
                
            }
        }
        
        if indexPath.section == 1 {
            if let confirmCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemConfirmSummaryCell", for: indexPath) as? ItemConfirmSummaryCell {
                
                confirmCell.shareCallback = {
//                    if let snapImage = self.snapView?.snapshotImage() {
//                        let imageShare = [ snapImage ]
//                        let activityViewController = UIActivityViewController(activityItems: imageShare, applicationActivities: nil)
//                        activityViewController.popoverPresentationController?.sourceView = self.view
//                        self.present(activityViewController, animated: true, completion: nil)
//                    }
                }
                confirmCell.favorCallback = {
                    //add favorit
                    self.showAddNameFavoritePopup(true, savedCallback: {
                        print("saved")
                    })
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
            return CGSize(width: collectionView.frame.width, height: 20)
        }
       
        
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.frame.width, height: 20)
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
            let height = (width/280*360) + addOnHeightModelDevice()
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
