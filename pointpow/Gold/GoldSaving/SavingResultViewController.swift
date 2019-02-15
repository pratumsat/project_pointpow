//
//  SavingResultViewController.swift
//  pointpow
//
//  Created by thanawat on 15/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class SavingResultViewController: BaseViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.title = NSLocalizedString("string-title-gold-page", comment: "")
        let finishButton = UIBarButtonItem(title: NSLocalizedString("string-title-finish-transfer", comment: ""), style: .plain, target: self, action: #selector(dismissTapped))
        finishButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                             NSAttributedString.Key.font :  UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.ITEM_TITLE )!]
            , for: .normal)
        
        self.navigationItem.rightBarButtonItem = finishButton
        
        self.setUp()
    }
    func setUp(){
        self.backgroundImage?.image = nil
        self.resultCollectionView.dataSource = self
        self.resultCollectionView.delegate = self
        
        self.registerNib(self.resultCollectionView, "SavingResultCell")
        self.registerNib(self.resultCollectionView, "LogoGoldCell")
       
    }
    
    @objc func dismissTapped(){
        self.dismiss(animated: true) {
            (self.navigationController as? SavingResultNav)?.callbackFinish?()
        }
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
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "SavingResultCell", for: indexPath) as? SavingResultCell {
                
                cell = item
            }
        }else{
            
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "LogoGoldCell", for: indexPath) as? LogoGoldCell {
                cell = item
                
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
       
        
        return CGSize.zero
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let width = collectionView.frame.width - 40
            let height = width/360*330
            return CGSize(width: width, height: height)
        }else{
            let width = collectionView.frame.width
            let cheight = collectionView.frame.height
            let height = abs((cheight) - (((width/360*330))+30))
            
            return CGSize(width: width, height: height)
        }
        
    }

    
    
}
