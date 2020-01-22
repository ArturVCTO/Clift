//
//  CheckoutProductCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/17/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit

class CheckoutProductCell: UITableViewCell {
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productCostLabel: UILabel!
    @IBOutlet weak var productQuantityLabel: UILabel!
    
     func configure(with product: MockProduct) {
        self.productNameLabel.text = product.name
        self.productImageView.image = product.image
        self.productCostLabel.text = "\(self.getPriceStringFormat(value: product.price))"
        self.productQuantityLabel.text = "\(product.quantity)"
    }
    
    func getPriceStringFormat(value: Double) -> String {
      let formatter = NumberFormatter()
      formatter.numberStyle = .currency
      
      return formatter.string(from: NSNumber(value: value))!
    }
}