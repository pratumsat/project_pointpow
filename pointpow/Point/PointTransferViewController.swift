//
//  PointTransferViewController.swift
//  pointpow
//
//  Created by thanawat on 14/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class PointTransferViewController: BaseViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var pointCollectionView: UICollectionView!
    var mProviders:[[String:AnyObject]]?
    var userData:AnyObject?
    var isProfile = false
    var indexSelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("string-title-point-transfer", comment: "")
        self.setUp()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setUp(){
        self.backgroundImage?.image = nil
        
        self.pointCollectionView.dataSource = self
        self.pointCollectionView.delegate = self
        self.pointCollectionView.showsVerticalScrollIndicator = false
        
        self.addRefreshViewController(self.pointCollectionView)
        self.registerNib(self.pointCollectionView, "ItemBankCell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if DataController.sharedInstance.isLogin() {
            self.loadAPIProvider()
        }
    }
    override func reloadData() {
        self.loadAPIProvider()
    }
    
    func loadAPIProvider(){
        var isLoading:Bool = true
        if self.mProviders != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        
        self.modelCtrl.getProviders(params: nil , isLoading , succeeded: { (result) in
            if let mResults =  result as? [[String:AnyObject]] {
                
                if mResults.count <= 0 {
                    self.mProviders = nil
                    self.addViewNotfoundData()
                }else{
                    self.mProviders = mResults
                    self.pointCollectionView.backgroundView = nil
                    self.pointCollectionView.reloadData()
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
    
    func getUserInfo(_ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.userData != nil {
            isLoading = false
        }else{
            isLoading = true
        }
        modelCtrl.getUserData(params: nil , isLoading , succeeded: { (result) in
            self.userData = result
            
            if let data  = self.userData as? [String:AnyObject] {
                let is_profile = data["is_profile"] as? NSNumber ?? 0
                
                self.isProfile = is_profile.boolValue
            }
            
            avaliable?()
         
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
        
        self.pointCollectionView.reloadData()
        self.pointCollectionView.backgroundView = view
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return self.mProviders?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemBankCell", for: indexPath) as? ItemBankCell {
                cell = item
                
                if let itemData = self.mProviders?[indexPath.row]{
                    let provider_image = itemData["provider_image_url"] as? String ?? ""
                    let name = itemData["name"] as? String ?? ""
                    let point_name = itemData["point_name"] as? String ?? ""
                    
                    item.providerLabel.text = point_name
                    
                    if let url = URL(string: provider_image) {
                        item.coverImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER))
                    }else{
                        item.coverImageView.image = UIImage(named: Constant.DefaultConstansts.DefaultImaege.RECT_PLACEHOLDER)
                    }
                }
               
                
                
                item.providerLabel.setLineSpacing(lineSpacing: 0, lineHeightMultiple: 0.9)   // for thai sans
                item.providerLabel.textAlignment = .center
        }

        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        
        return cell!
    }
    func openProviderPage(_ indexSelected:Int){
        if let itemData = self.mProviders?[indexSelected]{
            let show_form = itemData["show_form"] as? String ?? ""
            let name = itemData["name"] as? String ?? ""
            let description = itemData["description"] as? String ?? ""
            
            if show_form.lowercased() == "n" {
                //offline
                self.showPPWebView(true, name, htmlString: description)
            }else{
                //online
                self.showBankTransferView(true, itemData : itemData)
               
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isProfile {
            self.indexSelected = indexPath.row
            
            self.showPopupProfileInfomation(){
                print("//callback saved profile")
                
                self.getUserInfo(){
                    self.openProviderPage(self.indexSelected)
                }
                
            }
            return
        }
        self.openProviderPage(indexPath.row)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let width = collectionView.frame.width / 3
        let height = width
        return CGSize(width: width, height: height)
    }
}
