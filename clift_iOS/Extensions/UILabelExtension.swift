//
//  UILabelExtension.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 08/01/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {

      func colorString(text: String?, coloredText: [String?], color: UIColor? = .red) {

      let attributedString = NSMutableAttributedString(string: text!)
        
        coloredText.forEach { colorText in
            let range = (text! as NSString).range(of: colorText!)
              attributedString.setAttributes([NSAttributedString.Key.foregroundColor: color!],
                                     range: range)
        }
        
      self.attributedText = attributedString
  }
    
    func addCharactersSpacing(_ value: CGFloat = 1.15) {
        if let textString = text {
            let attrs: [NSAttributedString.Key : Any] = [.kern: value]
            attributedText = NSAttributedString(string: textString, attributes: attrs)
        }
    }

    func underline() {
        if let textString = self.text {
          let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
          attributedText = attributedString
        }
    }
    
    func deleteUnderline() {
        if let textString = self.text {
          let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: 0,
                                          range: NSRange(location: 0, length: attributedString.length))
          attributedText = attributedString
        }
    }
    
}
