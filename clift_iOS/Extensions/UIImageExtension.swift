//
//  UIImageExtension.swift
//  clift_iOS
//
//  Created by Juan Pablo Ramos on 05/11/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import UIKit

extension UIImage {
	
	/**
	 Returns an UIImage with a different fill Color
	 - parameter color: Color to set.
	 - returns: UIImage
	*/
	func maskWith(color: UIColor?) -> UIImage {
		guard let color = color else { return self }
		return modifiedImage { context, rect in
			// draw tint color
			
			context.setBlendMode(.normal)
			color.setFill()
			context.fill(rect)
			
			// mask by alpha values of original image
			context.setBlendMode(.destinationIn)
			if let cg = cgImage {
				context.draw(cg, in: rect)
			}
		}
	}
	
	/**
	Modified Image Context, apply modification on image
	- parameter draw: (CGContext, CGRect) -> ())
	- returns: UIImage
	*/
	fileprivate func modifiedImage(_ draw: (CGContext, CGRect) -> ()) -> UIImage {
		
		// using scale correctly preserves retina images
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		if let context: CGContext = UIGraphicsGetCurrentContext() {
			context.translateBy(x: 0, y: size.height)
			context.scaleBy(x: 1.0, y: -1.0)
			
			let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
			
			draw(context, rect)
			
			let image = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			
			if image != nil {
				return image!
			}
		}
		//assert(context != nil)
		
		// correctly rotate image
		
		
		return UIImage()
	}
}
