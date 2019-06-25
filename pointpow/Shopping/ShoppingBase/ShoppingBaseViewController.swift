//
//  ShoppingBaseViewController.swift
//  pointpow
//
//  Created by thanawat on 25/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class ShoppingBaseViewController: BaseViewController ,UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var shadowImageView:UIImageView?
    var searchCallback:((_ keyword:String)->Void)?
    var searchTextField:ShoppingSearchCustomTextField?
    var searchView:UIView?
    var categoryView:UIView?
    var mainCategoryView:UIView?
    var subCategoryCollectionView:UICollectionView?
    
    var cateViews:[UIView]?
    var dataItemSubCates:[[String:AnyObject]]?
    
    var heightMainCategoryView:NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.backgroundImage?.image = nil
        self.hiddenShadowImageView()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (self.revealViewController() != nil) {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @objc func categoryTapped(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        print(tag)
        
        self.dataItemSubCates = [["name":"Mobiles"],
                                 ["name":"Tablets"],
                                 ["name":"Laptops"],
                                 ["name":"Desktops"],
                                 ["name":"Gaming Consoles"],
                                 ["name":"Car Cameras"],
                                 ["name":"Action/Video Cameras"],
                                 ["name":"Security Cameras"],
                                 ["name":"Digital Cameras"],
                                 ["name":"Gadgets"]] as [[String : AnyObject]]
      
        if tag == 1 {
            // all
            
            self.subCategoryCollectionView?.alpha = 1
            UIView.animate(withDuration: 0.5) {
                self.heightMainCategoryView?.constant = 80.0
                self.subCategoryCollectionView?.alpha = 0
                self.subCategoryCollectionView?.isHidden = true
            }
            
        }else{
            self.addSubCate()
            
            
            self.subCategoryCollectionView?.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.heightMainCategoryView?.constant = 110.0
                self.subCategoryCollectionView?.alpha = 1
                self.subCategoryCollectionView?.isHidden = false
            }
            
        }
        
        
        
    }
    
    @objc func searchByKeyword(){
        guard let searchTf = self.searchTextField else { return }
        let keyword = searchTf.text!
        if !keyword.trimmingCharacters(in: .whitespaces).isEmpty {
            self.searchCallback?(keyword)
        }else{
            self.showMessagePrompt2(NSLocalizedString("string-error-empty-search", comment: ""))
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == searchTextField {
            let keyword = textField.text!
            if !keyword.trimmingCharacters(in: .whitespaces).isEmpty {
                self.searchCallback?(textField.text!)
            }else{
                self.showMessagePrompt2(NSLocalizedString("string-error-empty-search", comment: ""))
            }
        }
        return true
    }
    
}

extension ShoppingBaseViewController {
    func hiddenShadowImageView(){
        if shadowImageView == nil {
            shadowImageView = findShadowImage(under: navigationController!.navigationBar)
        }
        shadowImageView?.isHidden = true
    }
    
    func showShadowImageView(){
        shadowImageView?.isHidden = false
    }
    
    func addSearchView(){
        //let vFrame  = self.view.frame
        searchView = UIView()
        searchView!.backgroundColor = Constant.Colors.PRIMARY_COLOR
        searchView!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchView!)
        
        searchView!.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        searchView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        searchView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        searchView!.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        searchTextField = ShoppingSearchCustomTextField()
        searchTextField!.placeholder = NSLocalizedString("Search...", comment: "")
        searchTextField!.delegate = self
        searchTextField!.borderStyle = .roundedRect
        searchTextField!.setLeftPaddingPoints(20)
        searchTextField!.setRightPaddingPoints(40)
        searchTextField!.translatesAutoresizingMaskIntoConstraints = false
        searchTextField!.autocorrectionType = .no
        searchTextField!.returnKeyType = .search
        searchView!.addSubview(searchTextField!)
        
        searchTextField!.centerXAnchor.constraint(equalTo: searchView!.centerXAnchor, constant: 0).isActive = true
        searchTextField!.topAnchor.constraint(equalTo: searchView!.topAnchor, constant: 0).isActive = true
        searchTextField!.widthAnchor.constraint(equalTo: searchView!.widthAnchor, multiplier: 0.9).isActive = true
        
        //ic-search
        let searchImageView = UIImageView(image: UIImage(named: "ic-search"))
        searchImageView.contentMode = .scaleAspectFit
        searchImageView.image = searchImageView.image!.withRenderingMode(.alwaysTemplate)
        searchImageView.tintColor = Constant.Colors.PRIMARY_COLOR
        searchImageView.translatesAutoresizingMaskIntoConstraints = false
        searchView!.addSubview(searchImageView)
        
        searchImageView.centerYAnchor.constraint(equalTo: searchView!.centerYAnchor, constant: 0).isActive = true
        searchImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        searchImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        searchImageView.trailingAnchor.constraint(equalTo: searchTextField!.trailingAnchor, constant: -20).isActive = true
        
        let tapSearch = UITapGestureRecognizer(target: self, action: #selector(searchByKeyword))
        searchImageView.isUserInteractionEnabled = true
        searchImageView.addGestureRecognizer(tapSearch)
        
    }
    
    func addCategoryView(){
        categoryView = UIView()
        categoryView!.translatesAutoresizingMaskIntoConstraints = false
        
        mainCategoryView = UIView()
        mainCategoryView!.backgroundColor = UIColor.groupTableViewBackground
        mainCategoryView!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mainCategoryView!)
        
        mainCategoryView!.topAnchor.constraint(equalTo: searchView!.bottomAnchor, constant: 0).isActive = true
        mainCategoryView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        mainCategoryView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.heightMainCategoryView = mainCategoryView!.heightAnchor.constraint(equalToConstant: 80.0)
        self.heightMainCategoryView!.isActive = true
        
       
        self.cateViews = []
        cateViews!.append(addCate("cate1", icon: UIImage(named: "ic-mobile")!, leftView:nil, tag: 1))
        cateViews!.append(addCate("cate22", icon: UIImage(named: "ic-mobile")!, leftView:cateViews![0], tag: 2))
        cateViews!.append(addCate("cate33", icon: UIImage(named: "ic-mobile")!, leftView:cateViews![1], tag: 3))
        cateViews!.append(addCate("cate44", icon: UIImage(named: "ic-mobile")!, leftView:cateViews![2], tag: 4))
        cateViews!.append(addCate("cate55", icon: UIImage(named: "ic-mobile")!, leftView:cateViews![3], tag: 5))
        cateViews!.append(addCate("cate66", icon: UIImage(named: "ic-mobile")!, leftView:cateViews![4], tag: 6))
        
        
        mainCategoryView!.addSubview(categoryView!)
        
        categoryView!.widthAnchor.constraint(equalTo: mainCategoryView!.widthAnchor, multiplier: 0.9).isActive = true
        categoryView!.centerXAnchor.constraint(equalTo: mainCategoryView!.centerXAnchor, constant: 0).isActive = true
        categoryView!.topAnchor.constraint(equalTo: mainCategoryView!.topAnchor, constant: 10).isActive = true

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        subCategoryCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        subCategoryCollectionView!.backgroundColor = UIColor.groupTableViewBackground
        subCategoryCollectionView!.translatesAutoresizingMaskIntoConstraints = false
        subCategoryCollectionView!.delegate = self
        subCategoryCollectionView!.dataSource = self
        self.registerNib(subCategoryCollectionView!, "SubCateShoppingCell")
        
        
        self.mainCategoryView!.addSubview(subCategoryCollectionView!)
        
        subCategoryCollectionView!.leadingAnchor.constraint(equalTo: mainCategoryView!.leadingAnchor, constant: 5).isActive = true
        subCategoryCollectionView!.trailingAnchor.constraint(equalTo: mainCategoryView!.trailingAnchor, constant: -5).isActive = true
        
        subCategoryCollectionView!.topAnchor.constraint(equalTo: categoryView!.bottomAnchor, constant: 5).isActive = true
        subCategoryCollectionView!.bottomAnchor.constraint(equalTo: mainCategoryView!.bottomAnchor, constant: -10).isActive = true
        subCategoryCollectionView!.isHidden = true
    }

    private func addSubCate(){
        //add show
        self.subCategoryCollectionView?.reloadData()
    }
    
    private func addCate(_ name:String , icon:UIImage, leftView:UIView?, tag:Int) -> UIView {
        let view = UIView()
        
        let image = UIImageView(image: icon)
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        image.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        image.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        let title = UILabel()
        title.text = name
        title.textAlignment = .center
        title.font = UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.CATE_SHOPPING)
        title.textColor = UIColor.darkGray
        title.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(title)
        
        title.centerXAnchor.constraint(equalTo: image.centerXAnchor, constant: 0).isActive = true
        title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 0).isActive = true
        title.widthAnchor.constraint(equalTo: image.widthAnchor, constant: 0).isActive = true
        
        
        view.translatesAutoresizingMaskIntoConstraints = false
        categoryView!.addSubview(view)
        
        view.topAnchor.constraint(equalTo: categoryView!.topAnchor, constant: 0).isActive = true
        view.widthAnchor.constraint(equalTo: categoryView!.widthAnchor, multiplier: 0.166).isActive = true
        view.heightAnchor.constraint(equalTo: categoryView!.heightAnchor, constant: 0).isActive = true
        
        
        if leftView == nil {
            view.leftAnchor.constraint(equalTo: categoryView!.leftAnchor, constant: 0).isActive = true
        
            categoryView!.bottomAnchor.constraint(equalTo: title.bottomAnchor, constant: 0).isActive = true
        }else{
            view.leftAnchor.constraint(equalTo: leftView!.rightAnchor, constant: 0).isActive = true
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        view.tag = tag
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        
        
        return view
    }
}
extension ShoppingBaseViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataItemSubCates?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCateShoppingCell", for: indexPath) as? SubCateShoppingCell {
            cell = itemCell
           
            if let array = self.dataItemSubCates {
                  let name = array[indexPath.row]["name"] as? String ?? ""
                itemCell.nameLabel.text = name
            }
        
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let array = self.dataItemSubCates {
            let name = array[indexPath.row]["name"] as? String ?? ""
            
            var width = widthForView(text: name, font: UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: 15)!)
            width += 20.0
            return CGSize(width: width, height: 30.0)
        }
    
        return CGSize(width: 60.0, height: 30.0)
    }
}


class ShoppingSearchCustomTextField : UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    func setup(){
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
