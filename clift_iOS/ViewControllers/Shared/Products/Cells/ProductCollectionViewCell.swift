//
//  ProductCollectionViewCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 9/17/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    
    @IBOutlet weak var productPriceLabel: UILabel!
    
    @IBOutlet weak var brandProductLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var outOfStockView: customView!
    
    @IBOutlet weak var inEventView: customView!
    
	func setup(product: Product) {
		if product.inStock {
			self.outOfStockView.isHidden = true
		} else {
			self.outOfStockView.isHidden = false
		}
		
		if product.isInEvent {
			self.inEventView.isHidden = false
		} else {
			self.inEventView.isHidden = true
		}
		self.productLabel.text = product.name
		self.storeLabel.text = product.shop.name
		self.brandProductLabel.text = product.brand.name
		self.productPriceLabel.text = "$\(product.price)"
		productImageView.contentMode = .scaleAspectFit
		if let imageURL = URL(string:"\(product.imageUrl)") {
			self.productImageView.kf.setImage(with: imageURL)
		}
	}
}
