//
//  AboutViewController.swift
//  pointpow
//
//  Created by thanawat on 14/5/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController  , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var aboutCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-about-pointpow", comment: "")
        self.setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
   
    
    func setUp(){
       self.backgroundImage?.image = nil
        
       
        self.aboutCollectionView.dataSource = self
        self.aboutCollectionView.delegate = self
        self.aboutCollectionView.showsVerticalScrollIndicator = false
        
        self.registerNib(self.aboutCollectionView, "ItemProfileCell")
 
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemProfileCell", for: indexPath) as? ItemProfileCell{
            cell = itemCell
          
            if indexPath.row == 0 {
                itemCell.nameLabel.text = NSLocalizedString("string-item-about-pointpow", comment: "")
                itemCell.trailLabel.text = ""
                
            }else if indexPath.row == 1{
                itemCell.nameLabel.text = NSLocalizedString("string-item-about-term", comment: "")
                itemCell.trailLabel.text = ""
                
            }else if indexPath.row == 2{
                itemCell.nameLabel.text = NSLocalizedString("string-item-about-privacy", comment: "")
                
                itemCell.trailLabel.text = ""
                
            }else if indexPath.row == 3{
                itemCell.nameLabel.text = NSLocalizedString("string-item-about-faq", comment: "")
                itemCell.trailLabel.text = ""
                
            }else if indexPath.row == 4{
                itemCell.nameLabel.text = NSLocalizedString("string-item-about-howto", comment: "")
                itemCell.trailLabel.text = ""
            }
            
            let lineBottom = UIView(frame: CGRect(x: 0, y: itemCell.frame.height - 1 , width: collectionView.frame.width, height: 1 ))
            lineBottom.backgroundColor = Constant.Colors.LINE_PROFILE
            itemCell.addSubview(lineBottom)
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.showAboutPointPow(true)
            
        }else if indexPath.row == 1{
            self.showTermAndConPointPow(true)
            
        }else if indexPath.row == 2{
            self.showPrivacyPolicyPointPow(true)
            
        }else if indexPath.row == 3{
            let title = NSLocalizedString("string-item-about-faq", comment: "")
            self.showPPWebViewURL(true, title, url: "")
            
        }else if indexPath.row == 4{
            let title = NSLocalizedString("string-item-about-howto", comment: "")
            self.showPPWebViewURL(true, title, url: "")
            
           
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let height = CGFloat(50)
        return CGSize(width: width, height: height)
    }
    

}
