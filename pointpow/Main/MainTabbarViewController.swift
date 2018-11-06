//
//  MainTabbarViewController.swift
//  pointpow
//
//  Created by thanawat on 6/11/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit

class MainTabbarViewController: UITabBarController {

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
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = UIColor.blue
        image.widthAnchor.constraint(equalToConstant: 50).isActive = true
        image.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        tabBar.addSubview(image)
        tabBar.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
        tabBar.topAnchor.constraint(equalTo: image.centerYAnchor).isActive = true
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
