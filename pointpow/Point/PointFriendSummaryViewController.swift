//
//  PointFriendSummaryViewController.swift
//  pointpow
//
//  Created by thanawat on 19/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class PointFriendSummaryViewController: BaseViewController  , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
   
    var addSlipSuccess = false
    
    func  addSlipImageView() {
        
        if let snap = self.snapView {
            let backgroundImage = UIImageView(image: bgSlip)
            backgroundImage.contentMode = .scaleAspectFill
            backgroundImage.clipsToBounds = true
            backgroundImage.translatesAutoresizingMaskIntoConstraints = false
            snap.addSubview(backgroundImage)
            snap.sendSubviewToBack(backgroundImage)
            
            backgroundImage.leftAnchor.constraint(equalTo: snap.leftAnchor).isActive = true
            backgroundImage.rightAnchor.constraint(equalTo: snap.rightAnchor).isActive = true
            backgroundImage.topAnchor.constraint(equalTo: snap.topAnchor).isActive = true
            backgroundImage.bottomAnchor.constraint(equalTo: snap.bottomAnchor).isActive = true
            
            
            slipView!.updateLayerCornerRadiusProperties()
            
            slipView!.translatesAutoresizingMaskIntoConstraints = false
            snap.addSubview(slipView!)
            
            
            slipView!.centerXAnchor.constraint(equalTo: snap.centerXAnchor, constant: 0).isActive = true
            slipView!.centerYAnchor.constraint(equalTo: snap.centerYAnchor, constant: 0).isActive = true
            slipView!.widthAnchor.constraint(equalToConstant: 450).isActive = true
            slipView!.heightAnchor.constraint(equalToConstant: 770).isActive = true
            
            let logo = UIImageView(image: UIImage(named: "ic-logo"))
            logo.contentMode = .scaleAspectFit
            logo.translatesAutoresizingMaskIntoConstraints = false
            snap.addSubview(logo)
            
            logo.centerXAnchor.constraint(equalTo: snap.centerXAnchor, constant: 0).isActive = true
            logo.widthAnchor.constraint(equalTo: snap.widthAnchor, multiplier: 0.5).isActive = true
            logo.bottomAnchor.constraint(equalTo: slipView!.topAnchor, constant: 0).isActive = true
            
            
            slipView!.drawLightningView(width : CGFloat(450), height: CGFloat(770))
            print("add image slip")
            
            self.addSlipSuccess =  true
            self.countDownForSnapShot(1)
        }
        
    }
    
    func countDownForSnapShot(_ time: Double){
        timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: false)
    }
    
    @objc func updateCountDown() {
        if let snapImage = self.snapView?.snapshotImage() {
            UIImageWriteToSavedPhotosAlbum(snapImage, nil, nil, nil)
            print("created slip")
            self.removeCountDown()
        }
    }
    
    func removeCountDown() {
        timer?.invalidate()
        timer = nil
    }
    
    var slipView:UIView?
    var snapView:UIView?
    
    var countDown:Int = 3
    var timer:Timer?
    
    var bgSlip:UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load background image from api
        self.bgSlip = UIImage(named: "bg-slip")
        
        
        snapView = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 1200))
        snapView!.backgroundColor = UIColor.clear
        
        self.view.addSubview(snapView!)
        self.view.sendSubviewToBack(snapView!)
        
        
        self.title = NSLocalizedString("string-title-freind-transfer", comment: "")
        let finishButton = UIBarButtonItem(title: NSLocalizedString("string-title-finish-transfer", comment: ""), style: .plain, target: self, action: #selector(dismissTapped))
        finishButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                             NSAttributedString.Key.font :  UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.ITEM_TITLE )!]
            , for: .normal)
        
        self.navigationItem.rightBarButtonItem = finishButton
        
        self.setUp()
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
     
    }
    @objc func dismissTapped(){
        self.dismiss(animated: false) {
            (self.navigationController as? PointFreindSummaryNav)?.callbackFinish?()
        }
        
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        self.resultCollectionView.dataSource = self
        self.resultCollectionView.delegate = self
        self.resultCollectionView.showsVerticalScrollIndicator = false
        self.registerNib(self.resultCollectionView, "ItemFriendSummaryCell")
        self.registerNib(self.resultCollectionView, "ItemConfirmSummaryCell")
        self.registerNib(self.resultCollectionView, "LogoGoldCell")
        self.registerHeaderNib(self.resultCollectionView, "HeadCell")
    
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if indexPath.section == 0 {
            if let statusCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemFriendSummaryCell", for: indexPath) as? ItemFriendSummaryCell {
                
                //self.slipView = statusCell.mView
             
               
                cell = statusCell
                
                self.slipView = statusCell.mView.copyView()
                let allSubView = slipView!.allSubViewsOf(type: UIView.self)
                
                for itemView  in  allSubView {
                    if let itemTag = itemView.viewWithTag(1) {
                        itemTag.isHidden = true
                    }
                }
                if !self.addSlipSuccess {
                    self.addSlipImageView()
                }
                
            }
        } else if indexPath.section == 1 {
            if let confirmCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemConfirmSummaryCell", for: indexPath) as? ItemConfirmSummaryCell {
                
                confirmCell.shareCallback = {
                    if let snapImage = self.snapView?.snapshotImage() {
                        let imageShare = [ snapImage ]
                        let activityViewController = UIActivityViewController(activityItems: imageShare, applicationActivities: nil)
                        activityViewController.popoverPresentationController?.sourceView = self.view
                        self.present(activityViewController, animated: true, completion: nil)
                    }
                }
                confirmCell.favorCallback = {
                    //add favorit
                    self.showAddNameFavoritePopup(true, savedCallback: {
                        print("saved")
                    })
                }
                
                cell = confirmCell
            }
        }else{
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "LogoGoldCell", for: indexPath) as? LogoGoldCell {
                cell = item
                
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
            return CGSize(width: collectionView.frame.width, height: 30)
        }
        if section == 1 {
            return CGSize(width: collectionView.frame.width, height: 20)
        }
       
        
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.frame.width, height: 20)
        }
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeadCell", for: indexPath) as! HeadCell
        header.backgroundColor = UIColor.clear
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let width = collectionView.frame.width - 40
            let height = CGFloat(420) //(width/280*360) + addOnHeightModelDevice()
            return CGSize(width: width, height: height)
            
        }else if indexPath.section == 1 {
            
            let width = collectionView.frame.width - 40
            let height = CGFloat(40)
            return CGSize(width: width, height: height)
            
        }else{
            let width = collectionView.frame.width
            let height = CGFloat(60)
            return CGSize(width: width, height: height)
        }
      
    }


}
/*
 
 if let img  = captureView.snapshotImage()  {
    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
 
 }
 
 */
