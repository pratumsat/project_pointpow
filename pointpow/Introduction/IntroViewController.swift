//
//  IntroViewController.swift
//  pointpow
//
//  Created by thanawat on 2/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class IntroViewController: BaseViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var topCollectionConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var introCollectionView: UICollectionView!
    
    var default_marginTopTitle = CGFloat(40)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
           self.setUp()
    }
    func setUp(){
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            
            self.topCollectionConstraint.constant -= topPadding ?? 0
        }
        
        self.backgroundImage?.image = nil
        
        self.pageControl.numberOfPages = 4
        self.introCollectionView.dataSource = self
        self.introCollectionView.delegate = self
        self.introCollectionView.showsHorizontalScrollIndicator = false
        self.registerNib(self.introCollectionView, "IntroCell1")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //self.loginButton.borderRedColorProperties(borderWidth: 0.5)
        self.loginButton.borderClearProperties(borderWidth: 1)
        self.registerButton.borderClearProperties(borderWidth: 1)
        self.registerButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.isHiddenStatusBar = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
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
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
        if let intro = collectionView.dequeueReusableCell(withReuseIdentifier: "IntroCell1", for: indexPath) as? IntroCell1 {
            
            
            switch indexPath.row {
            case 0:
                intro.imageView.image = UIImage(named: "bg-intro-1")
                intro.titleLabel.text = NSLocalizedString("string-title-intro-1", comment: "")
                intro.subTitleLabel.text = NSLocalizedString("string-sub-title-intro-1", comment: "")
                break
            case 1:
                intro.imageView.image = UIImage(named: "bg-intro-2")
                intro.titleLabel.text = NSLocalizedString("string-title-intro-2", comment: "")
                intro.subTitleLabel.text = NSLocalizedString("string-sub-title-intro-2", comment: "")
                break
            case 2:
                intro.imageView.image = UIImage(named: "bg-intro-3")
                intro.titleLabel.text = NSLocalizedString("string-title-intro-3", comment: "")
                intro.subTitleLabel.text = NSLocalizedString("string-sub-title-intro-3", comment: "")
                break
            case 3:
                intro.imageView.image = UIImage(named: "bg-intro-4")
                intro.titleLabel.text = NSLocalizedString("string-title-intro-4", comment: "")
                intro.subTitleLabel.text = NSLocalizedString("string-sub-title-intro-4", comment: "")
                break
            default:
                break
            }
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.keyWindow
                let topPadding = window?.safeAreaInsets.top
                
                intro.topTitleConstraint.constant = default_marginTopTitle + (topPadding ?? 0)
            }
            
            cell = intro
            
        }
      
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        var screenHeight = screenSize.height
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            
            screenHeight += topPadding ?? 0
        }
        
        let height = screenHeight
        return CGSize(width: screenWidth, height: height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
    }
  

}
