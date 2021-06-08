//
//  customProgressView.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 10/23/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable class customProgressView: UIProgressView {
    
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var barHeight : CGFloat {
          get {
              return transform.d * 2.0
          }
          set {
              // 2.0 Refers to the default height of 2
              let heightScale = newValue / 2.0
              let c = center
            transform = CGAffineTransform(scaleX: 1.0, y: heightScale)
              center = c
          }
      }
}
