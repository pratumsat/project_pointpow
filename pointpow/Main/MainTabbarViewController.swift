//
//  MainTabbarViewController.swift
//  pointpow
//
//  Created by thanawat on 6/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class MainTabbarViewController: UITabBarController , UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
 
        if let items = self.tabBar.items {
            for item in  items {
                item.image = item.image?.withRenderingMode(.alwaysOriginal)
            }
        }
        
        self.setUpImageView()
    }
    
    
    func setUpImageView(){
        self.delegate = self
        
        let image = UIImageView()
        image.image = UIImage(named: "ic-tab-logo")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        
        let clickView = UIView()
        clickView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(clickView)
        self.view.addSubview(image)
        tabBar.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
        tabBar.topAnchor.constraint(equalTo: image.centerYAnchor).isActive = true
        
        tabBar.centerXAnchor.constraint(equalTo: clickView.centerXAnchor).isActive = true
        tabBar.topAnchor.constraint(equalTo: clickView.centerYAnchor).isActive = true
        
        image.widthAnchor.constraint(equalToConstant: 130).isActive = true
        image.heightAnchor.constraint(equalToConstant: 130/444*344).isActive = true
        
        clickView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        clickView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        let point = UITapGestureRecognizer(target: self, action: #selector(pointTapped))
        clickView.isUserInteractionEnabled = true
        clickView.addGestureRecognizer(point)
        
        
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return !(viewController is EmptyViewController)
    }
    @objc func pointTapped(){
        if let vc:PointManageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PointManageViewController") as? PointManageViewController {
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
