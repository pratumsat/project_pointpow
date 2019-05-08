//
//  FavoriteViewController.swift
//  pointpow
//
//  Created by thanawat on 15/12/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class FavoriteViewController: BaseViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var favCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-favorite", comment: "")
        self.setUp()
    }
    
    func setUp(){
        self.favCollectionView.delegate = self
        self.favCollectionView.dataSource = self
        self.favCollectionView.showsVerticalScrollIndicator = false
        
        self.registerNib(self.favCollectionView, "FavorCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
       
        if let favCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavorCell", for: indexPath) as?  FavorCell{
            
            favCell.nameLabel.text = "item \(indexPath.row)"
            
            favCell.editCallback = {
                self.showAddNameFavoritePopup(true, favName: favCell.nameLabel.text!, savedCallback: {
                    print("saved")
                })
            }
            favCell.deleteCallback = {
                var title = NSLocalizedString("string-dailog-title-delete-item-favorite", comment: "")
                title += "\(favCell.nameLabel.text!) ?"
                let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
                
                let okButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-ok", comment: ""), style: .default, handler: {
                    (alert)  in 
                    
                    
                    print("delete")
                    
                })
                let cancelButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-cancel", comment: ""), style: .default, handler: nil)
                
                
                
                alert.addAction(cancelButton)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            
            
            let lineBottom = UIView(frame: CGRect(x: 0, y: favCell.frame.height - 1 , width: collectionView.frame.width, height: 1 ))
            lineBottom.backgroundColor = Constant.Colors.LINE_PROFILE
            favCell.addSubview(lineBottom)
            
            cell = favCell
        }
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let height = CGFloat(50)
        return CGSize(width: width, height: height)
    }
    
}
