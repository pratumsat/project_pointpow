//
//  PopupShippingMyAddressViewController.swift
//  pointpow
//
//  Created by thanawat on 24/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PopupShippingMyAddressViewController: BaseViewController  , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    
    var userData:AnyObject?
    var modelAddreses:[[String:AnyObject]]?
    var selectedAddressCallback:((_ selectedAddress:AnyObject)->Void)?
    var addAddressCallback:(()->Void)?
    @IBOutlet weak var addressCollectionView: UICollectionView!
    
    
    var name:String = ""
    var mobile:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()
        
        self.getUserInfo(){
            self.addressCollectionView.reloadData()
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
                let first_name = data["goldsaving_member"]?["firstname"] as? String ?? ""
                let last_name = data["goldsaving_member"]?["lastname"]as? String ?? ""
                let mobile = data["goldsaving_member"]?["mobile"]as? String ?? ""
                
                self.name = "\(first_name) \(last_name)"
                self.mobile = mobile
                
                let member_addresses = data["member_addresses"] as? [[String:AnyObject]] ?? [[:]]
                self.modelAddreses = member_addresses
            }
            avaliable?()
            
            
        }, error: { (error) in
            if let mError = error as? [String:AnyObject]{
                let message = mError["message"] as? String ?? ""
                print(message)
                //self.showMessagePrompt(message)
            }
            
            print(error)
        }) { (messageError) in
            print("messageError")
            self.handlerMessageError(messageError)
        }
    }
    
    
    override func dismissPoPup() {
        super.dismissPoPup()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCloseBlackView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.submitButton.applyGradient(colours: [Constant.Colors.GRADIENT_1, Constant.Colors.GRADIENT_2])
        
    }
    func setUp(){
        self.backgroundImage?.image = nil
        
        self.submitButton.borderClearProperties(borderWidth: 1)
        
        
        self.addressCollectionView.dataSource = self
        self.addressCollectionView.delegate = self
        
        self.registerNib(self.addressCollectionView, "AddressViewCell")
        
        //add
        let add = UITapGestureRecognizer(target: self, action: #selector(addTapped))
        self.addView.isUserInteractionEnabled = true
        self.addView.addGestureRecognizer(add)
        

    }
    
    @IBAction func submitTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            self.windowSubview?.removeFromSuperview()
            self.windowSubview = nil
            self.selectedAddressCallback?([(address:"test addeess")] as AnyObject)
        }
    }
    
    @objc func addTapped(){
        self.dismiss(animated: false) {
            self.windowSubview?.removeFromSuperview()
            self.windowSubview = nil
            self.addAddressCallback?()
        }
        
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return modelAddreses?.count ?? 0
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        
        if indexPath.section == 0 {
            if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "AddressViewCell", for: indexPath) as? AddressViewCell {
                
                if let data = modelAddreses?[indexPath.row] {
                    //let address = data["address"] as? String ?? ""
                    
                    var rawAddress = "\(self.name)"
                    rawAddress += " xxxxxx xxxxx xxxxxx xxxx xxxx  xxxxxx xxxxx xxxxxx xxxx xxxx  xxxxxx xxxxx xxxxxx xxxx xxxx"
                    rawAddress += " \(self.mobile)"

                   
                    
                    item.addressLabel.text = rawAddress
                    
                    
                    if indexPath.row == 0 {
                        item.selectedAddress = true
                    }else{
                        item.selectedAddress = false
                    }
                }
                
                
                item.editCallback = {
                    print("edit address")
                }
                item.deleteCallback = {
                    let alert = UIAlertController(title: NSLocalizedString("string-dailog-title-delete-address", comment: ""),
                                                  message: "", preferredStyle: .alert)
                    
                    let okButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-ok", comment: ""), style: .default, handler: {
                        (alert) in
                        
// call cancel api
//                        let params:Parameters = ["transaction_ref_id": self.transactionId ?? ""]
//
//                        self.modelCtrl.cancelTransactionGold(params: params, true, succeeded: { (result) in
//                            print(result)
//                            self.getDetail()
//                        }, error: { (error) in
//                            if let mError = error as? [String:AnyObject]{
//                                let message = mError["message"] as? String ?? ""
//                                print(message)
//                                self.showMessagePrompt(message)
//                            }
//
//                            print(error)
//                        }) { (messageError) in
//                            print("messageError")
//                            self.handlerMessageError(messageError)
//
//                        }
                        
                    })
                    let cancelButton = UIAlertAction(title: NSLocalizedString("string-dailog-button-cancel", comment: ""), style: .default, handler: nil)
                    
                    
                    
                    alert.addAction(cancelButton)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
                
                
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
        
        return CGSize.zero
        //return CGSize(width: collectionView.frame.width, height: 20)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if indexPath.section == 0 {
            
            let width = collectionView.frame.width
            if let data = modelAddreses?[indexPath.row] {
                //let address = data["address"] as? String ?? ""
                var rawAddress = "\(self.name)"
                rawAddress += " xxxxxx xxxxx xxxxxx xxxx xxxx  xxxxxx xxxxx xxxxxx xxxx xxxx  xxxxxx xxxxx xxxxxx xxxx xxxx"
                rawAddress += " \(self.mobile)"
                
                let height = heightForView(text: rawAddress, font: UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: 16)!, width: width) +  50
                
                return CGSize(width: width, height: height)
            }
            
        }
        
        return CGSize.zero
        
    }
}
