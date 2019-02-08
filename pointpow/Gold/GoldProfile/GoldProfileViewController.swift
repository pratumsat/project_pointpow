//
//  GoldProfileViewController.swift
//  pointpow
//
//  Created by thanawat on 4/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class GoldProfileViewController: GoldBaseViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var profileCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Gold Profile"
        self.setUp()
    }
    
    func setUp(){
        self.profileCollectionView.delegate = self
        self.profileCollectionView.dataSource = self
        
        self.backgroundImage?.image = nil
        
        self.addRefreshViewController(self.profileCollectionView)
        
        self.registerNib(self.profileCollectionView, "GoldItemCell")
        self.registerNib(self.profileCollectionView, "BrowseImageCell")
        self.registerNib(self.profileCollectionView, "SaveButtonProfileCell")
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 10
            
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
     
        if indexPath.section  == 0 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "GoldItemCell", for: indexPath) as? GoldItemCell {
                
                cell = item
            }
        }
        if indexPath.section  == 1 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowseImageCell", for: indexPath) as? BrowseImageCell {
                cell = item
            }
        }
        if indexPath.section == 2 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "SaveButtonProfileCell", for: indexPath) as? SaveButtonProfileCell {
                cell = item
            }
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        
        return CGSize.zero
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        if indexPath.section == 1 {
            return  CGSize(width: collectionView.frame.width - 40 , height: CGFloat(120))
        }
        
        return CGSize(width: collectionView.frame.width - 40 , height: CGFloat(60))
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
