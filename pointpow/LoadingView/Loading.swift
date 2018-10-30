//
//  Loading.swift
//  pointpow
//
//  Created by thanawat on 30/10/2561 BE.
//  Copyright © 2561 abcpoint. All rights reserved.
//

import UIKit
import Foundation

class Loading {
    var mRootView:UIView
    var loadingView:UIActivityIndicatorView?
    
    init(rootView: UIView) {
        self.mRootView = rootView
    }
    
    func showLoading(){
        if loadingView == nil {
            loadingView = UIActivityIndicatorView(style: .gray)
            loadingView?.center = self.mRootView.center
            loadingView?.startAnimating()
            
            self.mRootView.addSubview(loadingView!)
            self.mRootView.bringSubviewToFront(loadingView!)
        }
    }
    
    func hideLoading(){
        if let view = loadingView {
            view.stopAnimating()
            view.removeFromSuperview()
            
            loadingView = nil
        }
    }
}


