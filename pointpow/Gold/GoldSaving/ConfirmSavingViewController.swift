//
//  ConfirmSavingViewController.swift
//  pointpow
//
//  Created by thanawat on 6/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ConfirmSavingViewController: BaseViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var summaryCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title =  NSLocalizedString("title-gold-pendding-confirm-saving", comment: "")
        self.setUp()
    }
    
    func setUp(){
        
        self.handlerEnterSuccess = {
            self.showGoldSavingResult(true) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        
        self.backgroundImage?.image = nil
        
        self.summaryCollectionView.delegate = self
        self.summaryCollectionView.dataSource = self
        
        
        self.addRefreshViewController(self.summaryCollectionView)
        
        self.registerNib(self.summaryCollectionView, "SavingConfirmCell")
        self.registerNib(self.summaryCollectionView, "SavingSummaryCell")
        self.registerNib(self.summaryCollectionView, "ConfirmButtonCell")
        self.registerNib(self.summaryCollectionView, "LogoGoldCell")
        
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
       
        if indexPath.section == 0 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "SavingConfirmCell", for: indexPath) as? SavingConfirmCell{
                cell = item
                
            }
        }else if indexPath.section == 1 {
            
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "SavingSummaryCell", for: indexPath) as? SavingSummaryCell{
                cell = item
            }
        } else if indexPath.section == 2 {
       
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "ConfirmButtonCell", for: indexPath) as? ConfirmButtonCell {
                cell = item
                
                item.confirmCallback = {
                    self.showEnterPassCodeModalView(NSLocalizedString("string-title-passcode-enter", comment: ""))
                }
            }
            
        } else if indexPath.section == 3 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "LogoGoldCell", for: indexPath) as? LogoGoldCell {
                cell = item
                
            }
        }
       
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        
        return CGSize(width: collectionView.frame.width, height: 20)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
     
        if indexPath.section == 0 {
          
            let width = collectionView.frame.width - 40
            let height = width/375*240
            return CGSize(width: width, height: height)
        }else if indexPath.section == 1 {
         
            let width = collectionView.frame.width - 40
            let height = width/375*180
            return CGSize(width: width, height: height)
        }else if indexPath.section == 2 {
          
            let height = CGFloat(40.0)
            let width = collectionView.frame.width - 40
            return CGSize(width: width, height: height)
            
        }else {
            let width = collectionView.frame.width
            let cheight = collectionView.frame.height
            let height = abs((cheight) - (((width/375*240))+((width/375*180))+100))
            
            return CGSize(width: width, height: height)
        }
        
    
        
    }


}
