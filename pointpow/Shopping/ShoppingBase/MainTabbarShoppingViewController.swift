//
//  MainTabbarShoppingViewController.swift
//  pointpow
//
//  Created by thanawat on 25/6/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class MainTabbarShoppingViewController: UITabBarController , UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpImageView()
        
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            self.navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
        
        }
        NotificationCenter.default.addObserver(self, selector: #selector(addBadgeToCart(_:)), name: NSNotification.Name(rawValue: Constant.DefaultConstansts.UPDATE_BADGE), object: nil)
    
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var image:UIImageView?
    
    func setUpImageView(){
        self.delegate = self
        
        let shadowViewLeft = UIView()
        shadowViewLeft.backgroundColor = UIColor.groupTableViewBackground
        shadowViewLeft.translatesAutoresizingMaskIntoConstraints = false
        
        let shadowViewRight = UIView()
        shadowViewRight.backgroundColor = UIColor.groupTableViewBackground
        shadowViewRight.translatesAutoresizingMaskIntoConstraints = false
        
        image = UIImageView()
        image!.image = UIImage(named: "ic-shopping-logo-cart")
        image!.contentMode = .scaleAspectFit
        image!.isUserInteractionEnabled = false
        image!.translatesAutoresizingMaskIntoConstraints = false
        
        let clickView = UIView()
        clickView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tabBar.addSubview(image!)
        self.view.addSubview(clickView)
        self.view.addSubview(shadowViewLeft)
        self.view.addSubview(shadowViewRight)
        
        
        self.tabBar.sendSubviewToBack(image!)
        
        tabBar.centerXAnchor.constraint(equalTo: image!.centerXAnchor).isActive = true
        tabBar.topAnchor.constraint(equalTo: image!.centerYAnchor, constant: 2).isActive = true
        
        tabBar.centerXAnchor.constraint(equalTo: clickView.centerXAnchor).isActive = true
        tabBar.topAnchor.constraint(equalTo: clickView.centerYAnchor).isActive = true
        
        let height = self.tabBar.frame.height*3
        image!.widthAnchor.constraint(equalToConstant: height).isActive = true
        image!.heightAnchor.constraint(equalToConstant: height/120*93).isActive = true
        
        clickView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        clickView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        let point = UITapGestureRecognizer(target: self, action: #selector(cartTapped))
        clickView.isUserInteractionEnabled = true
        clickView.addGestureRecognizer(point)
        
        
        
        tabBar.topAnchor.constraint(equalTo: shadowViewLeft.bottomAnchor, constant: 0).isActive = true
        shadowViewLeft.heightAnchor.constraint(equalToConstant: 1).isActive = true
        shadowViewLeft.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor, constant: 0).isActive = true
        shadowViewLeft.trailingAnchor.constraint(equalTo: image!.leadingAnchor, constant: 8).isActive = true
        
        tabBar.topAnchor.constraint(equalTo: shadowViewRight.bottomAnchor, constant: 0).isActive = true
        shadowViewRight.heightAnchor.constraint(equalToConstant: 1).isActive = true
        shadowViewRight.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor, constant: 0).isActive = true
        shadowViewRight.leadingAnchor.constraint(equalTo: image!.trailingAnchor, constant: -8).isActive = true
    }
    
    var badgeView:CustomBadgeView?
    
    
    @objc func addBadgeToCart(_ notification:NSNotification){
        
        if let userInfo = notification.userInfo as? [String:AnyObject] {
            badgeView?.removeFromSuperview()
            
            let count = userInfo["count"] as? Int ?? 0
            if count > 0 {
                badgeView = CustomBadgeView()
                badgeView?.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(badgeView!)
                
                
                badgeView?.centerXAnchor.constraint(equalTo: image!.centerXAnchor, constant: 25).isActive = true
                badgeView?.centerYAnchor.constraint(equalTo: image!.centerYAnchor, constant: -30).isActive = true
                badgeView?.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
                badgeView?.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
                
                let countLabel = UILabel()
                countLabel.textColor = Constant.Colors.PRIMARY_COLOR
                countLabel.font = UIFont(name: Constant.Fonts.THAI_SANS_BOLD, size: Constant.Fonts.Size.CART_BADGE)
                countLabel.text = "\(count)"
                countLabel.translatesAutoresizingMaskIntoConstraints = false
                badgeView?.addSubview(countLabel)
                
                countLabel.centerYAnchor.constraint(equalTo: badgeView!.centerYAnchor, constant: 0).isActive = true
                countLabel.centerXAnchor.constraint(equalTo: badgeView!.centerXAnchor, constant: 0).isActive = true
            }
            
        }
    }
    
    
    class CustomBadgeView : UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        func setup(){
            self.backgroundColor = UIColor.white
            self.layer.cornerRadius = 15
            self.layer.borderColor =  Constant.Colors.PRIMARY_COLOR.cgColor
            self.layer.borderWidth = 1.0
            self.clipsToBounds = true;
            
         
        }
        
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
    }

    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if  viewController is EmptyShoppingViewController {
            self.showCart()
        }
        return !(viewController is EmptyShoppingViewController)
    }
    
    @objc func cartTapped(){
        self.showCart()
    }
    
    func showCart(){
        if let vc:CartViewController = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

}
