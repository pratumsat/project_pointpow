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
    var collapseCallback:((_ collapse:Bool)->Void)?
    
    var searchTextField:ShoppingSearchCustomTextField?
    //var searchView:UIView?
    var categoryView:UIView?
    //var mainCategoryView:UIView?
    var subCategoryCollectionView:UICollectionView?
    
    var cateViews:[UIView]?
    var dataItemSubCates:[[String:AnyObject]]?
    
    var sizeOfViewCate = CGFloat(0)
    var sizeOfViewCateInit = CGFloat(0) {
        didSet{
            print(sizeOfViewCateInit)
        }
    }
    
    
    
    var selectCateItem:Int = 0
    var selectSubcate:Int?
    

    var cate1Items = [["color" : Constant.Colors.CATE1,
                       "image": UIImage(named: "ic-shopping-cate-r-1-active")!],
                      ["color" : UIColor.black,
                       "image": UIImage(named: "ic-shopping-cate-r-1")!]]
    var cate2Items = [["color" : Constant.Colors.CATE2,
                       "image": UIImage(named: "ic-shopping-cate-r-2-active")!],
                      ["color" : UIColor.black,
                       "image": UIImage(named: "ic-shopping-cate-r-2")!]]
    var cate3Items = [["color" : Constant.Colors.CATE3,
                       "image": UIImage(named: "ic-shopping-cate-r-3-active")!],
                      ["color" : UIColor.black,
                       "image": UIImage(named: "ic-shopping-cate-r-3")!]]
    var cate4Items = [["color" : Constant.Colors.CATE4,
                       "image": UIImage(named: "ic-shopping-cate-r-4-active")!],
                      ["color" : UIColor.black,
                       "image": UIImage(named: "ic-shopping-cate-r-4")!]]
    var cate5Items = [["color" : Constant.Colors.CATE5,
                       "image": UIImage(named: "ic-shopping-cate-r-5-active")!],
                      ["color" : UIColor.black,
                       "image": UIImage(named: "ic-shopping-cate-r-5")!]]
    var cate6Items = [["color" : Constant.Colors.CATE6,
                       "image": UIImage(named: "ic-shopping-cate-r-6-active")!],
                      ["color" : UIColor.black,
                       "image": UIImage(named: "ic-shopping-cate-r-6")!]]
    
    var colorCateLists = [["color1" : Constant.Colors.ALL_GRADIENT_1,
                           "color2" : Constant.Colors.ALL_GRADIENT_2],
                          ["color1" : Constant.Colors.FASHION_GRADIENT_1,
                           "color2" : Constant.Colors.FASHION_GRADIENT_2],
                          ["color1" : Constant.Colors.GADGET_GRADIENT_1,
                           "color2" : Constant.Colors.GADGET_GRADIENT_2],
                          ["color1" : Constant.Colors.LIFESTYLE_GRADIENT_1,
                           "color2" : Constant.Colors.LIFESTYLE_GRADIENT_2],
                          ["color1" : Constant.Colors.TRAVEL_GRADIENT_1,
                           "color2" : Constant.Colors.TRAVEL_GRADIENT_2],
                          ["color1" : Constant.Colors.COUPON_GRADIENT_1,
                           "color2" : Constant.Colors.COUPON_GRADIENT_2,]]
    
    
    var cateLists = [["name": NSLocalizedString("string-item-shopping-cate-1", comment: ""),
                      "image" : UIImage(named: "ic-shopping-cate-r-1")!],
                     ["name": NSLocalizedString("string-item-shopping-cate-2", comment: ""),
                      "image" : UIImage(named: "ic-shopping-cate-r-2")!],
                     ["name": NSLocalizedString("string-item-shopping-cate-3", comment: ""),
                      "image" : UIImage(named: "ic-shopping-cate-r-3")!],
                     ["name": NSLocalizedString("string-item-shopping-cate-4", comment: ""),
                      "image" : UIImage(named: "ic-shopping-cate-r-4")!],
                     ["name": NSLocalizedString("string-item-shopping-cate-5", comment: ""),
                      "image" : UIImage(named: "ic-shopping-cate-r-5")!],
                     ["name": NSLocalizedString("string-item-shopping-cate-6", comment: ""),
                      "image" : UIImage(named: "ic-shopping-cate-r-6")!]]
    
    var heightMainCategoryView:NSLayoutConstraint?
    
    var selectUnderLine:UIView?
    var underlineView:UIView?
    var mainCategoryView:UIView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.backgroundImage?.image = nil
        self.hiddenShadowImageView()
        
        
        let widthCate = self.view.frame.width*0.9
        self.sizeOfViewCate = (widthCate*0.166) * 0.5 - 10
        
        self.sizeOfViewCateInit = self.sizeOfViewCate/2 - 20
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (self.revealViewController() != nil) {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    private func getItemSelectedByCate(_ position:Int) -> [[String:AnyObject]]{
        switch position {
        case 0:
            return  cate1Items
        case 1:
            return  cate2Items
            
        case 2:
            return  cate3Items
            
        case 3:
            return  cate4Items
            
        case 4:
            return  cate5Items
            
        case 5:
            return cate6Items
        default:
            return  cate1Items
        }
    }
    
    func updateUnderLineView2(_ position:Int){
        
        if selectUnderLine == nil {
            selectUnderLine = UIView()
            selectUnderLine!.translatesAutoresizingMaskIntoConstraints = false
            mainCategoryView!.addSubview(selectUnderLine!)
            
            selectUnderLine?.centerYAnchor.constraint(equalTo: underlineView!.centerYAnchor, constant: 0).isActive = true
            selectUnderLine?.heightAnchor.constraint(equalToConstant: 2).isActive = true
            
            selectUnderLine?.backgroundColor = cate1Items[0]["color"] as? UIColor ?? nil
            
            selectUnderLine?.leadingAnchor.constraint(equalTo: self.cateViews![0].leadingAnchor, constant: 0).isActive = true
            selectUnderLine?.trailingAnchor.constraint(equalTo: self.cateViews![0].trailingAnchor, constant: 0).isActive = true
            
            return
        }
      
        
        
        var widthForView = CGFloat(0)
        selectUnderLine?.backgroundColor = getItemSelectedByCate(position)[0]["color"] as? UIColor ?? nil
        widthForView = self.cateViews?[position].frame.origin.x ?? CGFloat(0)
        
        UIView.animate(withDuration: 0.2,  delay: 0, options:.beginFromCurrentState,animations: {
            //start animation
            if let frame = self.selectUnderLine?.frame {
                var x = frame.origin.x
                let y = frame.origin.y
                if y > 0 {
                    x = CGFloat(widthForView)
                    print(x)
                    self.selectUnderLine?.frame.origin.x = x
                }
            }
        }) { (completed) in
            //completed
           
        }
    
     
        
    }
    
    func selectedCategory(_ position:Int){
        updateUnderLineView2(position)
        
        if let mArray = self.cateViews {
            var i = 0
            for mViews in mArray {
                if position == i {
                    //select
                    var active = getItemSelectedByCate(position)
                    
                    let allSubView = mViews.allSubViewsOf(type: UIView.self)
                    for itemView  in  allSubView {
                        if let imageView = itemView as? UIImageView {
                            imageView.image = active[0]["image"] as? UIImage ?? nil
                        }
                        if let label = itemView as? UILabel {
                            label.textColor = active[0]["color"] as? UIColor ?? nil
                        }
                    }
                }else{
                    var inActive = getItemSelectedByCate(i)
                    
                    let allSubView = mViews.allSubViewsOf(type: UIView.self)
                    for itemView  in  allSubView {
                        if let imageView = itemView as? UIImageView {
                            imageView.image = inActive[1]["image"] as? UIImage ?? nil
                        }
                        if let label = itemView as? UILabel {
                            label.textColor = inActive[1]["color"] as? UIColor ?? nil
                        }
                    }
                }
              
                i += 1
            }
        }
        
        
        
 
 
    }
    
    func getSubCateByCate(_ cateId:Int ,_ avaliable:(()->Void)?  = nil){
        var isLoading:Bool = true
        if self.dataItemSubCates != nil {
            isLoading = true
        }else{
            isLoading = true
        }
        
        
        modelCtrl.getSubCateByCateShopping(cateId:cateId,  isLoading , succeeded: { (result) in

            if let mResult = result as? [[String:AnyObject]] {
                self.dataItemSubCates = mResult

            }
            avaliable?()


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
    
    @objc func categoryTapped(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag ?? 0
        
        if tag == 0 {
            self.collapseCallback?(true)
            self.heightMainCategoryView?.constant = 95.0 + self.sizeOfViewCateInit
            self.subCategoryCollectionView?.isHidden = true
            
            
            
        }else{
            self.collapseCallback?(false)

            
            self.heightMainCategoryView?.constant = 95.0 + self.sizeOfViewCate
            self.mainCategoryView?.layoutIfNeeded()
            self.subCategoryCollectionView?.isHidden = false
            
           
            self.getSubCateByCate(tag) {
                self.addSubCate()
            }
        }
        
        self.selectCateItem = tag
        self.selectedCategory(tag)
        
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
    func hideView(){
        //for override
    }
    func showView(){
        //for override
    }
    var lastContentOffset = CGFloat(0)
}
extension ShoppingBaseViewController {
   
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        
        print("offsetY \(translation.y)")
        if translation.y > 0 {
            // swipes from top to bottom of screen -> down
            showView()
        } else {
            // swipes from bottom to top of screen -> up
            hideView()
        }
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
    
    func addSearchView() -> UIView {
        //let vFrame  = self.view.frame
        let searchView = UIView()
        searchView.backgroundColor = Constant.Colors.PRIMARY_COLOR
        searchView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchView)
        
        searchView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        searchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        searchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        searchView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        searchTextField = ShoppingSearchCustomTextField()
        searchTextField!.placeholder = NSLocalizedString("string-item-shopping-search-placeholder", comment: "")
        searchTextField!.font = UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.SEARCH_SHOPPING)
        searchTextField!.delegate = self
        searchTextField!.borderStyle = .roundedRect
        searchTextField!.setLeftPaddingPoints(20)
        searchTextField!.setRightPaddingPoints(40)
        searchTextField!.translatesAutoresizingMaskIntoConstraints = false
        searchTextField!.autocorrectionType = .no
        searchTextField!.returnKeyType = .search
        searchView.addSubview(searchTextField!)
        
        searchTextField!.centerXAnchor.constraint(equalTo: searchView.centerXAnchor, constant: 0).isActive = true
        searchTextField!.topAnchor.constraint(equalTo: searchView.topAnchor, constant: 0).isActive = true
        searchTextField!.widthAnchor.constraint(equalTo: searchView.widthAnchor, multiplier: 0.9).isActive = true
        
        //ic-search
        let searchImageView = UIImageView(image: UIImage(named: "ic-search"))
        searchImageView.contentMode = .scaleAspectFit
        searchImageView.image = searchImageView.image!.withRenderingMode(.alwaysTemplate)
        searchImageView.tintColor = Constant.Colors.PRIMARY_COLOR
        searchImageView.translatesAutoresizingMaskIntoConstraints = false
        searchView.addSubview(searchImageView)
        
        searchImageView.centerYAnchor.constraint(equalTo: searchTextField!.centerYAnchor, constant: 0).isActive = true
        searchImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        searchImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        searchImageView.trailingAnchor.constraint(equalTo: searchTextField!.trailingAnchor, constant: -20).isActive = true
        
        let tapSearch = UITapGestureRecognizer(target: self, action: #selector(searchByKeyword))
        searchImageView.isUserInteractionEnabled = true
        searchImageView.addGestureRecognizer(tapSearch)
        
        return searchView
    }
    
    func addCategoryView(_ searchView:UIView, allProduct:Bool = false) -> UIView{
        categoryView = UIView()
        categoryView!.translatesAutoresizingMaskIntoConstraints = false
        
        let mainCategoryView = UIView()
        //mainCategoryView.backgroundColor = UIColor.cyan
        mainCategoryView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mainCategoryView)
        
        mainCategoryView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 0).isActive = true
        mainCategoryView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        mainCategoryView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        
        
        if allProduct {
            self.heightMainCategoryView = mainCategoryView.heightAnchor.constraint(equalToConstant: (95.0 + self.sizeOfViewCateInit))
            self.heightMainCategoryView!.isActive = true
        }else{
            self.heightMainCategoryView = mainCategoryView.heightAnchor.constraint(equalToConstant: (90.0 + self.sizeOfViewCateInit))
            self.heightMainCategoryView!.isActive = true
        }
        
        
        self.cateViews = []
        var index = 0
        for itemCate in cateLists {
            let name = itemCate["name"] as? String ?? ""
            let image = itemCate["image"] as? UIImage ?? UIImage(named: Constant.DefaultConstansts.DefaultImaege.BACKGROUND_PROFILE_PLACEHOLDER)!
            
            if index == 0 {
                cateViews!.append(addCate(name, icon: image, leftView:nil, tag: index))
            }else{
                cateViews!.append(addCate(name, icon: image, leftView: cateViews![index-1], tag: index))
            }
          
            
            index += 1
        }
        mainCategoryView.addSubview(categoryView!)
        
        categoryView!.leadingAnchor.constraint(equalTo: mainCategoryView.leadingAnchor, constant: 0).isActive = true
        categoryView!.trailingAnchor.constraint(equalTo: mainCategoryView.trailingAnchor, constant: 0).isActive = true
        categoryView!.topAnchor.constraint(equalTo: mainCategoryView.topAnchor, constant: 5).isActive = true
        
        let widthCate = self.view.frame.width*0.9
        let height = (widthCate*0.166)
        categoryView!.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        subCategoryCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        subCategoryCollectionView!.translatesAutoresizingMaskIntoConstraints = false
        subCategoryCollectionView!.delegate = self
        subCategoryCollectionView!.dataSource = self
        subCategoryCollectionView!.showsHorizontalScrollIndicator = false
        subCategoryCollectionView!.backgroundColor = UIColor.white
    
        self.registerHeaderNib(subCategoryCollectionView!, "HeaderSectionCell")
        self.registerNib(subCategoryCollectionView!, "SubCateShoppingCell")
        
        
        mainCategoryView.addSubview(subCategoryCollectionView!)
        
        
        subCategoryCollectionView!.leadingAnchor.constraint(equalTo: mainCategoryView.leadingAnchor, constant: 0).isActive = true
        subCategoryCollectionView!.trailingAnchor.constraint(equalTo: mainCategoryView.trailingAnchor, constant: 0).isActive = true
        
        subCategoryCollectionView!.topAnchor.constraint(equalTo: categoryView!.bottomAnchor, constant: 15).isActive = true
       
        subCategoryCollectionView!.bottomAnchor.constraint(equalTo: mainCategoryView.bottomAnchor, constant: 0).isActive = true
       
        subCategoryCollectionView!.isHidden = true
        
        
        
        self.mainCategoryView = mainCategoryView
        
        if allProduct {
            underlineView = UIView()
            underlineView!.translatesAutoresizingMaskIntoConstraints = false
            underlineView!.backgroundColor = UIColor.groupTableViewBackground
            mainCategoryView.addSubview(underlineView!)
            
            underlineView!.topAnchor.constraint(equalTo: categoryView!.bottomAnchor, constant: 10).isActive = true
            underlineView!.leadingAnchor.constraint(equalTo: mainCategoryView.leadingAnchor, constant: 0).isActive = true
            underlineView!.trailingAnchor.constraint(equalTo: mainCategoryView.trailingAnchor, constant: 0).isActive = true
            underlineView!.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            self.selectedCategory(0)
        }
        return mainCategoryView
    }

    func addSubCate(){
        //add show
        self.selectSubcate = nil
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
        image.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        image.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        let title = UILabel()
        title.text = name
        title.textAlignment = .center
        title.font = UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.CATE_SHOPPING)
        title.textColor = UIColor.black
        title.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(title)
        
        title.centerXAnchor.constraint(equalTo: image.centerXAnchor, constant: 0).isActive = true
        title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 0).isActive = true
        title.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        
        
        view.translatesAutoresizingMaskIntoConstraints = false
        categoryView!.addSubview(view)
        
        view.topAnchor.constraint(equalTo: categoryView!.topAnchor, constant: 0).isActive = true
        view.widthAnchor.constraint(equalTo: categoryView!.widthAnchor, multiplier: 0.166).isActive = true
        view.bottomAnchor.constraint(equalTo: title.bottomAnchor, constant: 0).isActive = true
        
        
        if leftView == nil {
            view.leftAnchor.constraint(equalTo: categoryView!.leftAnchor, constant: 0).isActive = true
        
        }else{
            view.leftAnchor.constraint(equalTo: leftView!.rightAnchor, constant: 0).isActive = true
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        view.tag = tag
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        
        
        return view
    }
    
    private func addColormViewSubCate(_ mView:UIView, gradient1:UIColor = UIColor.white, gradient2:UIColor = UIColor.white){
        if let count = mView.layer.sublayers?.count {
            if count > 1 {
                mView.layer.sublayers?.removeFirst()
            }
        }
        mView.applyGradientHorizon(colours: [gradient1, gradient2])
        
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
                itemCell.nameLabel.textColor = UIColor.darkGray
                
                let color = self.getItemSelectedByCate(self.selectCateItem)[0]["color"] as? UIColor ?? UIColor.white
                itemCell.mView.borderColorProperties(borderWidth: 1, color: color.cgColor)
                
                if let select = self.selectSubcate {
                    if select == indexPath.row {
                        //selected
                        let color1 = self.colorCateLists[selectCateItem]["color1"]
                        let color2 = self.colorCateLists[selectCateItem]["color2"]
                        
                        itemCell.nameLabel.textColor = UIColor.white
                        self.addColormViewSubCate(itemCell.mView, gradient1: color1!, gradient2: color2!)
                        
                        
                    }else{
                        //unselected
                        itemCell.nameLabel.textColor = UIColor.darkGray
                        self.addColormViewSubCate(itemCell.mView)
                    }
                }else{
                    //unselected
                   itemCell.nameLabel.textColor = UIColor.darkGray
                    self.addColormViewSubCate(itemCell.mView)
                }
                
            }
        
        }
        
        if cell == nil {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        self.selectSubcate = indexPath.row
        let index = NSIndexSet(index: 0)
        self.subCategoryCollectionView?.reloadSections(index as IndexSet)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let array = self.dataItemSubCates {
            let name = array[indexPath.row]["name"] as? String ?? ""
            
            var width = widthForView(text: name, font: UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: 15)!)
            width += 30.0
            return CGSize(width: width, height: collectionView.frame.height)
        }
    
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header  = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSectionCell", for: indexPath) as! HeaderSectionCell
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
        
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
