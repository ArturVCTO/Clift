//
//  UIViewControllerExtension.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 12/01/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentLoader() {
        // Avoid multiple presentations
        if let _ = view.viewWithTag(777) { return }
        let loadingView = UIView()
        loadingView.alpha = 0
        loadingView.tag = 777
        loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
        loadingView.center =  self.view.center
        loadingView.backgroundColor = UIColor.lightGray.withAlphaComponent(1)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        actInd.hidesWhenStopped = true
        actInd.style = UIActivityIndicatorView.Style.whiteLarge
        
        
        loadingView.addSubview(actInd)
        
        self.view.addSubview(loadingView)
        actInd.startAnimating()
        
        UIView.animate(withDuration: 0.3) {
            loadingView.alpha = 1
        }
    }
    
    func dismissLoader() {
        if let foundView = view.viewWithTag(777) {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    foundView.alpha = 0
                }) { _ in
                    foundView.removeFromSuperview()
                }
            }
        }
    }
}
