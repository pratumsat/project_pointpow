//
//  FriendCollectionCell.swift
//  pointpow
//
//  Created by thanawat on 14/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class FriendCollectionCell: UICollectionViewCell , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var friendCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUp()
    }

    func setUp(){
        self.friendCollectionView.delegate = self
        self.friendCollectionView.dataSource = self
        
        let nibName = "ItemFriendCell"
        let nib = UINib(nibName: nibName, bundle: nil)
        self.friendCollectionView.register(nib, forCellWithReuseIdentifier: nibName)
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
        if let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemFriendCell", for: indexPath) as? ItemFriendCell {
            cell = imageCell
            
         
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let width = collectionView.frame.width/3
        let height = width
        return CGSize(width: width, height: height)
    }
    
    
}
