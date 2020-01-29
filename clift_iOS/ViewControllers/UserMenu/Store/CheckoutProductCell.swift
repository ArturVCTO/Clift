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
    var productQuantity: Int?
    var productPrice: Double?
    
     func configure(with product: MockProduct) {
        self.productNameLabel.text = product.name
        self.productImageView.image = product.image
        self.productCostLabel.text = "\(self.getPriceStringFormat(value: product.price))"
        self.productQuantity = product.quantity
        self.productPrice = product.price
        self.productQuantityLabel.text = "\(product.quantity)"
    }
    
    func getPriceStringFormat(value: Double) -> String {
      let formatter = NumberFormatter()
      formatter.numberStyle = .currency
      
      return formatter.string(from: NSNumber(value: value))!
    }
    
    
    @IBAction func addProductQuantity(_ sender: Any) {
        let newQuant = self.productQuantity! + 1
        self.productQuantity = newQuant
        self.productCostLabel.text = "\(self.getPriceStringFormat(value: productPrice! * Double(newQuant)))"
        self.productQuantityLabel.text = "\(newQuant)"
    }
    
    @IBAction func reduceProductQuantity(_ sender: Any) {
        if self.productQuantity! < 1 {
            self.showMessage("No se puede reducir a 0.", type: .error)
        } else {
            let newQuant = (self.productQuantity)! - 1
            self.productQuantity = newQuant
            self.productCostLabel.text = "\(self.getPriceStringFormat(value: productPrice! * Double(newQuant)))"
            self.productQuantityLabel.text = "\(newQuant)"
        }
    }
}
