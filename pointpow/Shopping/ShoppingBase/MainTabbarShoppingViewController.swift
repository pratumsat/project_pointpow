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
        
    
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setUpImageView(){
        self.delegate = self
        
        let shadowViewLeft = UIView()
        shadowViewLeft.backgroundColor = UIColor.groupTableViewBackground
        shadowViewLeft.translatesAutoresizingMaskIntoConstraints = false
        
        let shadowViewRight = UIView()
        shadowViewRight.backgroundColor = UIColor.groupTableViewBackground
        shadowViewRight.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImageView()
        image.image = UIImage(named: "ic-tab-logo")
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = false
        image.translatesAutoresizingMaskIntoConstraints = false
        
        let clickView = UIView()
        clickView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tabBar.addSubview(image)
        self.view.addSubview(clickView)
        self.view.addSubview(shadowViewLeft)
        self.view.addSubview(shadowViewRight)
        
        
        self.tabBar.sendSubviewToBack(image)
        
        tabBar.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
        tabBar.topAnchor.constraint(equalTo: image.centerYAnchor, constant: 2).isActive = true
        
        tabBar.centerXAnchor.constraint(equalTo: clickView.centerXAnchor).isActive = true
        tabBar.topAnchor.constraint(equalTo: clickView.centerYAnchor).isActive = true
        
        let height = self.tabBar.frame.height*3
        image.widthAnchor.constraint(equalToConstant: height).isActive = true
        image.heightAnchor.constraint(equalToConstant: height/120*93).isActive = true
        
        clickView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        clickView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        let point = UITapGestureRecognizer(target: self, action: #selector(cartTapped))
        clickView.isUserInteractionEnabled = true
        clickView.addGestureRecognizer(point)
        
        
        
        tabBar.topAnchor.constraint(equalTo: shadowViewLeft.topAnchor, constant: 2).isActive = true
        shadowViewLeft.heightAnchor.constraint(equalToConstant: 2).isActive = true
        shadowViewLeft.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor, constant: 0).isActive = true
        shadowViewLeft.trailingAnchor.constraint(equalTo: image.leadingAnchor, constant: 8).isActive = true
        
        tabBar.topAnchor.constraint(equalTo: shadowViewRight.topAnchor, constant: 2).isActive = true
        shadowViewRight.heightAnchor.constraint(equalToConstant: 2).isActive = true
        shadowViewRight.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor, constant: 0).isActive = true
        shadowViewRight.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: -8).isActive = true
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
        if let vc:PointManageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PointManageViewController") as? PointManageViewController {
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
