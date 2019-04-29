//
//  SecuritySettingViewController.swift
//  pointpow
//
//  Created by thanawat on 29/4/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class SecuritySettingViewController: BaseViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var settingCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-security-setting", comment: "")
        self.setUp()
    }
    func setUp(){
        self.backgroundImage?.image = nil
        
        self.settingCollectionView.dataSource = self
        self.settingCollectionView.delegate = self
        self.settingCollectionView.showsVerticalScrollIndicator = false
        
        self.registerHeaderNib(self.settingCollectionView, "HeadCell")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
      
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeadCell", for: indexPath) as! HeadCell
        
       
        
        let lineBottom = UIView(frame: CGRect(x: 0, y: header.frame.height - 1 , width: collectionView.frame.width, height: 1 ))
        lineBottom.backgroundColor = Constant.Colors.LINE_PROFILE
        header.addSubview(lineBottom)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let height = CGFloat(50)
        return CGSize(width: width, height: height)
    }

}
