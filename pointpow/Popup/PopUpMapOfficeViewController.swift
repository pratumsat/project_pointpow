//
//  PopUpMapOfficeViewController.swift
//  pointpow
//
//  Created by thanawat on 26/2/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import UIKit

class PopUpMapOfficeViewController: BaseViewController {

    var openMap:(()->Void)?
    
    @IBOutlet weak var viewMapFullView: UIView!
    @IBOutlet weak var viewMapView: UIView!
    @IBOutlet weak var photoMapImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundImage?.image = nil
        
        
        let googlemap = UITapGestureRecognizer(target: self, action: #selector(googleMapTapped))
        self.viewMapView.isUserInteractionEnabled  = true
        self.viewMapView.addGestureRecognizer(googlemap)
        
        let fullMap = UITapGestureRecognizer(target: self, action: #selector(fullMapTapped))
        self.viewMapFullView.isUserInteractionEnabled  = true
        self.viewMapFullView.addGestureRecognizer(fullMap)
    }
    @objc func fullMapTapped(){
        // Open and show coordinate
        
        super.dismissPoPup()
        self.dismiss(animated: true, completion: {
            self.openMap?()
        })
    }
    @objc func googleMapTapped(){
        // Open and show coordinate
        let latitude = "13.740047"
        let longitude = "100.541439"
        let url = "http://maps.apple.com/maps?saddr=&daddr=\(latitude),\(longitude)"
        UIApplication.shared.openURL(URL(string:url)!)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.viewMapFullView?.borderBlackolorProperties(borderWidth: 1)
        self.viewMapView?.borderBlackolorProperties(borderWidth: 1)
    }
 
    override func dismissPoPup() {
        super.dismissPoPup()
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCloseBlackView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismissPoPup()
    }
    
}
