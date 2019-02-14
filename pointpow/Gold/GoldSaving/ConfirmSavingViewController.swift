//
//  ConfirmSavingViewController.swift
//  pointpow
//
//  Created by thanawat on 6/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ConfirmSavingViewController: BaseViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var summaryCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title =  "Confirm Saving Page"
        self.setUp()
    }
    
    func setUp(){
        
        self.backgroundImage?.image = nil
        
        self.summaryCollectionView.delegate = self
        self.summaryCollectionView.dataSource = self
        
        
        self.addRefreshViewController(self.summaryCollectionView)
        
        self.registerNib(self.summaryCollectionView, "GoldPriceCell")
        self.registerNib(self.summaryCollectionView, "MyGoldCell")
        self.registerNib(self.summaryCollectionView, "SavingCell")
        self.registerNib(self.summaryCollectionView, "RegisterGoldCell")
        self.registerNib(self.summaryCollectionView, "LogoGoldCell")
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
       
      
        if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "GoldPriceCell", for: indexPath) as? GoldPriceCell{
            cell = item
            
            
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        
        return CGSize(width: collectionView.frame.width, height: 20)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
     
        
        let width = collectionView.frame.width - 40
        let height = width/375*260
        return CGSize(width: width, height: height)
        
    }


}
