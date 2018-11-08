//
//  IntroViewController.swift
//  pointpow
//
//  Created by thanawat on 2/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class IntroViewController: BaseViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var introCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.setUp()
    }
    func setUp(){
        
        
        self.pageControl.numberOfPages = 5
        self.introCollectionView.dataSource = self
        self.introCollectionView.delegate = self
        self.registerNib(self.introCollectionView, "IntroCell1")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
         (self.navigationController as! IntroNav).hideStatusBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = nil
        (self.navigationController as! IntroNav).showStatusBar()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        self.showLogin(true)
    }
    @IBAction func registerTapped(_ sender: Any) {
        self.showRegister(true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
        if let intro = collectionView.dequeueReusableCell(withReuseIdentifier: "IntroCell1", for: indexPath) as? IntroCell1 {
                cell = intro
            }
      
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var topSafeArea: CGFloat
       // var bottomSafeArea: CGFloat
        
        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
      //      bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            topSafeArea = topLayoutGuide.length
      //      bottomSafeArea = bottomLayoutGuide.length
        }
        let height = collectionView.frame.height + topSafeArea
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
    }
  

}
