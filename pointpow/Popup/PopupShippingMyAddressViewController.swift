//
//  PopupShippingMyAddressViewController.swift
//  pointpow
//
//  Created by thanawat on 24/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PopupShippingMyAddressViewController: BaseViewController  , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    var modelAddreses:[[String:AnyObject]]?
    var selectedAddressCallback:((_ selectedAddress:AnyObject)->Void)?
    @IBOutlet weak var addressCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()
    }
    override func dismissPoPup() {
        super.dismissPoPup()
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCloseBlackView()
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        
        self.addressCollectionView.dataSource = self
        self.addressCollectionView.delegate = self
        
        self.registerNib(self.addressCollectionView, "AddressViewCell")
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
        if indexPath.section == 0 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "AddressViewCell", for: indexPath) as? AddressViewCell {
                
                
                cell = item
            }
            
        } else if indexPath.section == 1 {
            
        }
        
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.zero
        //return CGSize(width: collectionView.frame.width, height: 20)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if indexPath.section == 0 {
            
            let width = collectionView.frame.width
            let height = width/360*110
            return CGSize(width: width, height: height)
        }else if indexPath.section == 1 {
            
            let width = collectionView.frame.width
            let height = width/360*210
            return CGSize(width: width, height: height)
            
        }
        
    return CGSize.zero
        
    }
}
