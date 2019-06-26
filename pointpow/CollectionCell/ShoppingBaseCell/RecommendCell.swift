//
//  RecommendCell.swift
//  pointpow
//
//  Created by thanawat on 26/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class RecommendCell: UICollectionViewCell , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var recommendCollectionView: UICollectionView!
    
    var recomendItems:[String:AnyObject]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp()
    }

    func setUp(){
        self.recommendCollectionView.delegate = self
        self.recommendCollectionView.dataSource = self
        self.recommendCollectionView.showsHorizontalScrollIndicator = false

        let nibName = "ShoppingProductCell"
        let nib = UINib(nibName: nibName, bundle: nil)
        self.recommendCollectionView.register(nib, forCellWithReuseIdentifier: nibName)
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
        if let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingProductCell", for: indexPath) as? ShoppingProductCell {
            cell = productCell


            productCell.disCountValue = "1200 Point Pow"
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.height
        let width = collectionView.frame.width/2.5
        
        return CGSize(width: width, height: height)
    }
    
}
