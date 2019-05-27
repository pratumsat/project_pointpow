//
//  FavoriteViewController.swift
//  pointpow
//
//  Created by thanawat on 15/12/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
import Alamofire

class FavoriteViewController: BaseViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var favCollectionView: UICollectionView!
    
    var mFavourites:[[String:AnyObject]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-favorite", comment: "")
        self.setUp()
    }
    
    func setUp(){
        self.favCollectionView.delegate = self
        self.favCollectionView.dataSource = self
        self.favCollectionView.showsVerticalScrollIndicator = false
        
        
        self.addRefreshViewController(self.favCollectionView)
        self.registerNib(self.favCollectionView, "FavorCell")
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if DataController.sharedInstance.isLogin() {
            self.getFavourite()
        }
    }
    override func reloadData() {
        self.getFavourite()
    }
    
    func getFavourite(){
        var isLoading:Bool = true
        if self.mFavourites != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        self.modelCtrl.getFavoriteTransferPoint(params: nil , isLoading , succeeded: { (result) in
            if let mResults =  result as? [[String:AnyObject]] {
               
                if mResults.count <= 0 {
                    self.mFavourites = nil
                    self.addViewNotfoundData()
                }else{
                    self.mFavourites = mResults
                    self.favCollectionView.backgroundView = nil
                    self.favCollectionView.reloadData()
                }
                
            }
            self.refreshControl?.endRefreshing()
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                self.showMessagePrompt(message)
            }
            self.refreshControl?.endRefreshing()
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
            self.refreshControl?.endRefreshing()
        }
    }
    
    func addViewNotfoundData(){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        var centerpoint = view.center
        centerpoint.y -= self.view.frame.height*0.2
        
        let sorry = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        sorry.center = centerpoint
        sorry.textAlignment = .center
        sorry.font = UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.CONTENT )
        sorry.text = NSLocalizedString("string-not-found-item-favourite", comment: "")
        sorry.textColor = UIColor.lightGray
        view.addSubview(sorry)
        
        self.favCollectionView.reloadData()
        self.favCollectionView.backgroundView = view
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.mFavourites?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
       
        if let favCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavorCell", for: indexPath) as?  FavorCell{
            
            
            if let itemData = self.mFavourites?[indexPath.row] {
                //let id = itemData["id"] as? NSNumber ?? 0
                let alias = itemData["alias"] as? String ?? ""
                //let amount = itemData["amount"] as? NSNumber ?? 0
                //let transaction_ref_id = itemData["transaction_ref_id"] as? String ?? ""
                //let mType = itemData["type"] as? String ?? ""
                
                favCell.nameLabel.text = alias
                
                
                favCell.editCallback = {
                    self.editName(itemData)
                    
                }
                favCell.deleteCallback = {
                    var title = NSLocalizedString("string-dailog-title-delete-item-favorite", comment: "")
                    title += "\(favCell.nameLabel.text!) ?"
                    let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
                    
                    let okButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-ok", comment: ""), style: .default, handler: {
                        (alert)  in
                        
                        
                        self.deleteFavourite(itemData)
                        
                        
                    })
                    let cancelButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-cancel", comment: ""), style: .default, handler: nil)
                    
                    
                    
                    alert.addAction(cancelButton)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
                
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
    
    
    
    func editName(_ itemData:[String:AnyObject]){
        //let id = itemData["id"] as? NSNumber ?? 0
        let alias = itemData["alias"] as? String ?? ""
        let amount = itemData["amount"] as? NSNumber ?? 0
        let transaction_ref_id = itemData["transaction_ref_id"] as? String ?? ""
        let mType = itemData["type"] as? String ?? ""
        
        self.showAddNameFavoritePopup(true, favName: alias, mType: mType,
                                      transaction_ref_id: transaction_ref_id, amount: amount.stringValue) {
            
            self.getFavourite()
        }
        
    }
    func deleteFavourite(_ itemData:[String:AnyObject]){
        
        let transaction_ref_id = itemData["id"] as? NSNumber ?? 0
        
        self.modelCtrl.deleteFavoriteTransferPointByTranssevtionID(transection_ref_id: transaction_ref_id.stringValue, true, succeeded: { (result) in
            
            self.getFavourite()
            
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                self.showMessagePrompt(message)
            }
         
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
       
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let itemData = self.mFavourites?[indexPath.row] {
            let transaction_ref_id = itemData["id"] as? NSNumber ?? 0
            
            self.modelCtrl.getFavoriteTransferPointByTranssevtionID(transection_ref_id: transaction_ref_id.stringValue, true, succeeded: { (result) in
                if let mResult = result as? [String : AnyObject] {
                    
                    let point = mResult["point"] as? [String:AnyObject] ?? [:]
                    let note = point["note"] as? String ?? ""
                    let pointAmount = point["point"] as? NSNumber ?? 0
                    
                    var receiver = mResult["receiver"] as? [String:AnyObject] ?? [:]
                    receiver["limit_pay"] = NSNumber(value: 13001)
                   
                    
                    self.showPointFriendTransferView(true, receiver as [String : AnyObject],
                                                     note: note ,
                                                     pointAmount: pointAmount.stringValue)
                }
            
                
                self.refreshControl?.endRefreshing()
            }, error: { (error) in
                if let mError = error as? [String:AnyObject]{
                    let message = mError["message"] as? String ?? ""
                    print(message)
                    self.showMessagePrompt(message)
                }
              
                print(error)
            }) { (messageError) in
                print("messageError")
                self.handlerMessageError(messageError)
                
            }
           
        
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let height = CGFloat(50)
        return CGSize(width: width, height: height)
    }
    
}
