//
//  RootOnboardingPageViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/8/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class RootOnboardingPageViewController: UIPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.gestureRecognizers = []
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnClickOutside))
        view.addGestureRecognizer(tap)
        
        }
}

extension UIPageViewController {
    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        if let currentViewController = viewControllers?[0] {
            if let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) {
                //(self.nextPage as! UIScrollView).contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height)
                setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
                
            }
            
        }
    }
    
    func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        if let currentViewController = viewControllers?[0] {
            if let nextPage = dataSource?.pageViewController(self, viewControllerBefore:  currentViewController) {
                setViewControllers([nextPage], direction: .reverse, animated: animated, completion: completion)
            }
        }
    }
    
    @IBAction func hideKeyboardOnClickOutside(){
        view.endEditing(true)
    }
    
}
