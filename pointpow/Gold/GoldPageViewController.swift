//
//  GoldPageViewController.swift
//  pointpow
//
//  Created by thanawat on 4/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit


class GoldPageViewController: GoldBaseViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    
    let arrayItem = ["goldprice","goldbalance","saving","register", "logo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.setUp()
    }
    func setUp(){
        self.backgroundImage?.image = nil
    
        self.homeCollectionView.delegate = self
        self.homeCollectionView.dataSource = self
        
        
        self.addRefreshViewController(self.homeCollectionView)
        
        self.registerNib(self.homeCollectionView, "GoldPriceCell")
        self.registerNib(self.homeCollectionView, "MyGoldCell")
        self.registerNib(self.homeCollectionView, "SavingCell")
        self.registerNib(self.homeCollectionView, "RegisterGoldCell")
        self.registerNib(self.homeCollectionView, "LogoGoldCell")
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arrayItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        let menu = self.arrayItem[indexPath.section]
        //["goldprice","goldbalance","saving","register"]
        if menu == "goldprice" {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "GoldPriceCell", for: indexPath) as? GoldPriceCell{
                cell = item
                
                item.backgroundColor = UIColor.red
            }
        }
        if menu == "goldbalance" {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "MyGoldCell", for: indexPath) as? MyGoldCell {
                cell = item
               
                item.backgroundColor = UIColor.green
            }
            
        }
        if menu == "saving" {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "SavingCell", for: indexPath) as? SavingCell {
                cell = item
                
                item.backgroundColor = UIColor.blue
            }
            
        }
        if menu == "register" {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "RegisterGoldCell", for: indexPath) as? RegisterGoldCell {
                cell = item
                
                item.registerCallback = {
                    self.showRegisterGoldSaving(true)
                }
               
            }
        }
        if menu == "logo" {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "LogoGoldCell", for: indexPath) as? RegisterGoldCell {
                cell = item
                
                item.registerCallback = {
                    self.showRegisterGoldSaving(true)
                }
                
            }
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let menu = self.arrayItem[indexPath.section]
        if menu == "register" {
            let width = collectionView.frame.width
            let height = CGFloat(100.0)
            return CGSize(width: width, height: height)
        }
        if menu == "logo" {
            let width = collectionView.frame.width
            let height = CGFloat(100.0)
            return CGSize(width: width, height: height)
        }
       
        let width = collectionView.frame.width
        let height = CGFloat(300.0)
        return CGSize(width: width, height: height)
    }

 
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
