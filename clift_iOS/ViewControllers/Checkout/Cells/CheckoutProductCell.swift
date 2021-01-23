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
    //@IBOutlet weak var productQuantityLabel: UILabel!
    var vc: CheckoutViewController!
    var productQuantity: Int?
    var productPrice: Double?
    var productId: String?
    var cartItem = CartItem()
    
     func configure(with cartItem: CartItem) {
        self.cartItem = cartItem
        self.productId = cartItem.id
        self.productNameLabel.text = cartItem.product!.name
        if let imageURL = URL(string:"\(cartItem.product!.imageUrl)") {
            self.productImageView.kf.setImage(with: imageURL)
        }
        self.productCostLabel.text = "\(self.getPriceStringFormat(value: Double(cartItem.product!.price)))"
        self.productQuantity = cartItem.quantity
        self.productPrice = Double(cartItem.product!.price)
        //self.productQuantityLabel.text = "\(cartItem.quantity ?? 0)"
    }
    
    func getPriceStringFormat(value: Double) -> String {
      let formatter = NumberFormatter()
      formatter.numberStyle = .currency
      
      return formatter.string(from: NSNumber(value: value))!
    }
    
    /*@IBAction func addProductQuantity(_ sender: Any) {
        let newQuant = self.productQuantity! + 1
        self.productQuantity = newQuant
        self.productCostLabel.text = "\(self.getPriceStringFormat(value: productPrice! * Double(newQuant)))"
        self.updateProductQuantity(cartItem: self.cartItem, quantity: newQuant)
    }
    
    @IBAction func reduceProductQuantity(_ sender: Any) {
        if self.productQuantity! <= 1 {
            self.vc.showMessage("No se puede reducir a 0.", type: .error)
        } else {
            let newQuant = (self.productQuantity)! - 1
            self.productQuantity = newQuant
            self.productCostLabel.text = "\(self.getPriceStringFormat(value: productPrice! * Double(newQuant)))"
            self.updateProductQuantity(cartItem: self.cartItem, quantity: newQuant)
        }
    }*/
    
    func updateProductQuantity(cartItem: CartItem, quantity: Int) {
        sharedApiManager.updateCartQuantity(cartItem: cartItem, quantity: quantity) { (cartItem, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.vc.getCartItems()
                    self.vc.checkoutProductTableView.reloadData()
                } else if (response.isClientError()) {
                    self.vc.showMessage("Error actualizando cantidad.", type: .error)
                }
            }
        }
    }
}
