//
//  FriendTransferViewController.swift
//  pointpow
//
//  Created by thanawat on 14/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class FriendTransferViewController: BaseViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var searchView: UIView!
   
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var friendCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = NSLocalizedString("string-title-freind-transfer", comment: "")
        
        let scanIcon = UIBarButtonItem(image: UIImage(named: "ic-qr-scan"), style: .plain, target: self, action: #selector(popupQRTapped))
        
        
        
        self.navigationItem.rightBarButtonItem = scanIcon
        
        
        self.setUp()
    }
    @objc func popupQRTapped(){
        self.showScanBarcodeForMember { (modelFriend, barcode) in
            
        }
    }
   
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.searchView.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }

    func setUp(){
        self.searchTextField.borderRedColorProperties(borderWidth: 1.0)
        self.searchTextField.setLeftPaddingPoints(20)
        self.searchTextField.setRightPaddingPoints(40)
        
        self.searchView.borderClearProperties(borderWidth: 1)
        
        self.backgroundImage?.image = nil
        self.friendCollectionView.backgroundColor = UIColor.white
        
        self.friendCollectionView.delegate = self
        self.friendCollectionView.dataSource = self
        self.friendCollectionView.showsVerticalScrollIndicator = false
        
        self.registerNib(self.friendCollectionView, "ItemFriendCell")
        self.registerHeaderNib(self.friendCollectionView, "HeadCell")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if indexPath.section == 0 {
            if let friendCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemFriendCell", for:  indexPath) as? ItemFriendCell {
                
                cell = friendCell
                friendCell.transferButton.setTitle(NSLocalizedString("string-point-friend-transfer", comment: ""), for: .normal)
                friendCell.coverImageView.image = UIImage(named: "bg-4")
                
                friendCell.didSelectImageView = {
                    self.showPointFriendTransferView(true)
                }
                friendCell.tappedCallback = {
                    self.showPointFriendTransferView(true)
                }
                
                let lineBottom = UIView(frame: CGRect(x: 0, y: friendCell.frame.height - 10 , width: friendCell.frame.width, height: 1 ))
                lineBottom.backgroundColor = Constant.Colors.LINE_PROFILE
                friendCell.addSubview(lineBottom)
            }
        }
        if indexPath.section == 1 {
            if let friendCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemFriendCell", for:  indexPath) as? ItemFriendCell {
                friendCell.recentMode = true
                
                friendCell.coverImageView.image = UIImage(named: "bg-\(indexPath.row+1)")
                
                cell = friendCell
            }
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            return CGSize.zero
            
        }
        return CGSize(width: collectionView.frame.width, height: CGFloat(30.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeadCell", for: indexPath) as! HeadCell
        header.nameLabel.text = NSLocalizedString("string-point-transfer-friend-header-recent", comment: "")
        header.nameLabel.font = UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.FRIEND_HEADER_RECENT)!
        header.backgroundColor = UIColor.white
        header.marginLeftConstrantLabel.constant = 35

        
        return header
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if indexPath.section == 0 {
            let width = collectionView.frame.width
            let height = width/155*125
            return CGSize(width: width, height: height)
        }
        let width = (collectionView.frame.width-40)/3
        let height = width/110*170
        return CGSize(width: width, height: height)
        
        
    }
    
}
