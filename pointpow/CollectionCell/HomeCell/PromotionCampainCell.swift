//
//  PromotionCampainCell.swift
//  pointpow
//
//  Created by thanawat on 8/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class PromotionCampainCell: UICollectionViewCell , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var slideCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var timer:Timer? = nil
    var x = 0
    var count = 0
    
    var itemBanner:[[String:AnyObject]]?{
        didSet{
            print(itemBanner ?? "no item")
            self.count = itemBanner?.count ?? 0
            if count > 1 {
                self.pageControl.numberOfPages = count
            }
            self.slideCollectionView.reloadData()
        }
    }
    
    var luckyDrawCallback:(()->Void)?
    
    var autoSlideImage = false {
        didSet{
            if autoSlideImage {
                setTimer()
            }
        }
    }
    func setTimer() {
        if self.x < count {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(autoScroll), userInfo: nil,  repeats: true)
        }
        
    }
    @objc func autoScroll(){
        self.pageControl.currentPage = x
        if self.x < count {
            let indexPath = IndexPath(item: x, section: 0)
            self.slideCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.x += 1
        } else {
            
            self.x = 0
            
            self.pageControl.currentPage = x
            self.slideCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.pageControl.numberOfPages = 0
        self.slideCollectionView.delegate = self
        self.slideCollectionView.dataSource = self
        
        
        let nibName = "ImageCell"
        let nib = UINib(nibName: nibName, bundle: nil)
        self.slideCollectionView.register(nib, forCellWithReuseIdentifier: nibName)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
        if let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell {
            cell = imageCell
            
            if let itemData = self.itemBanner?[indexPath.row] {
                let path = itemData["path_mobile"] as? String ?? ""
                
                if let url = URL(string: path) {
                    imageCell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.BANNER_HOME_PLACEHOLDER))
                }
                
            }
           
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = self.itemBanner?[indexPath.row] {
            let type = item["type"] as? String ?? ""
            if type == "luckydraw" {
                self.luckyDrawCallback?()
            }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
    }
}
