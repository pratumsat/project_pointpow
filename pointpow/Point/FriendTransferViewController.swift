//
//  FriendTransferViewController.swift
//  pointpow
//
//  Created by thanawat on 14/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class FriendTransferViewController: BaseViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var friendCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("string-title-freind-transfer", comment: "")
        self.setUp()
    }
    

    func setUp(){
        self.backgroundImage?.image = nil
        
        self.friendCollectionView.delegate = self
        self.friendCollectionView.dataSource = self
        
        self.registerNib(self.friendCollectionView, "ItemFriendCell")
        self.registerNib(self.friendCollectionView, "FriendCollectionCell")
        self.registerHeaderNib(self.friendCollectionView, "HeadCell")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if indexPath.section == 0 {
            if let friendCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemFriendCell", for:  indexPath) as? ItemFriendCell {
                
                cell = friendCell
            }
        }
        if indexPath.section == 1 {
//            if let friendList = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCollectionCell", for: indexPath) as? FriendCollectionCell{
//
//                cell = friendList
//            }
            if let friendCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemFriendCell", for:  indexPath) as? ItemFriendCell {
                
                cell = friendCell
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
            return CGSize.zero
            
        }
        return CGSize(width: collectionView.frame.width, height: CGFloat(5.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeadCell", for: indexPath) as! HeadCell
        
//        let lineBottom = UIView(frame: CGRect(x: 0, y: header.frame.height - 1 , width: collectionView.frame.width, height: 1 ))
//        lineBottom.backgroundColor = Constant.Colors.LINE_PROFILE
//        header.addSubview(lineBottom)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        let width = collectionView.frame.width/3
        let height = width
        return CGSize(width: width, height: height)
        
        
//        else   if indexPath.section == 1 {
//            let width = collectionView.frame.width
//            let height = width/3
//            return CGSize(width: width, height: height)
//        }
        return CGSize.zero
    }
    
}
