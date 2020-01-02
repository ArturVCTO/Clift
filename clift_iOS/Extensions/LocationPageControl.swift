//
//  LocationPageControl.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/7/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class LocationPageControl: UIPageControl {
    
    let locationArrow: UIImage = UIImage(named: "gift")!
    let pageCircle: UIImage = UIImage(named: "ovalCopy")!
    
    override var numberOfPages: Int {
        didSet {
            updateDots()
        }
    }
    
    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pageIndicatorTintColor = UIColor.clear
        self.currentPageIndicatorTintColor = UIColor.clear
        self.clipsToBounds = false
    }
    
    func updateDots() {
        var i = 0
        for view in self.subviews {
            if let imageView = self.imageView(forSubview: view) {
                if i == self.currentPage {
                    imageView.image = self.locationArrow
                } else {
                    imageView.image = self.pageCircle
                }
                i += 1
            } else {
                var dotImage = self.pageCircle
                if i == self.currentPage {
                    dotImage = self.locationArrow
                }
                view.clipsToBounds = false
                view.addSubview(UIImageView(image:dotImage))
                i += 1
            }
        }
    }
    
    fileprivate func imageView(forSubview view: UIView) -> UIImageView? {
        var dot: UIImageView?
        if let dotImageView = view as? UIImageView {
            dot = dotImageView
        } else {
            for foundView in view.subviews {
                if let imageView = foundView as? UIImageView {
                    dot = imageView
                    break
                }
            }
        }
        return dot
    }
}
