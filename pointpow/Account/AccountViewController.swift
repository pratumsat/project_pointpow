//
//  AccountViewController.swift
//  pointpow
//
//  Created by thanawat on 6/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class AccountViewController: BaseViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var profileCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()
    }
    
    func setUp(){
        self.profileCollectionView.dataSource = self
        self.profileCollectionView.delegate = self
        
        self.registerNib(self.profileCollectionView, "ProfileCell")
        self.registerNib(self.profileCollectionView, "ItemProfileCell")
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 2
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if indexPath.section == 0 {
            if let profileCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as? ProfileCell{
                
                
                cell = profileCell
                
                let lineBottom = UIView(frame: CGRect(x: 0, y: profileCell.frame.height - 0.5 , width: collectionView.frame.width, height: 0.5 ))
                lineBottom.backgroundColor = Constant.Colors.LINE_COLOR
                profileCell.addSubview(lineBottom)
            }
        }
        if indexPath.section == 1 {
            if let itemName = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemProfileCell", for: indexPath) as? ItemProfileCell{
                
                
                cell = itemName
                
                let lineBottom = UIView(frame: CGRect(x: 0, y: itemName.frame.height - 0.5 , width: collectionView.frame.width, height: 0.5 ))
                lineBottom.backgroundColor = Constant.Colors.LINE_COLOR
                itemName.addSubview(lineBottom)
            }
        }

        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let width = collectionView.frame.width
            let height = width/3*2
            return CGSize(width: width, height: height)
        }
        let width = collectionView.frame.width
        let height = CGFloat(60)
       
        return CGSize(width: width, height: height)
    }


}
