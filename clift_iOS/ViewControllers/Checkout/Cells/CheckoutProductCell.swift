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
    @IBOutlet weak var productQuantityTextField: UITextField!
    @IBOutlet weak var imageContainerView: UIView!
    
    var vc: CheckoutViewController!
    var productQuantity: Int?
    var productPrice: Double?
    var productId: String?
    var cartItem = CartItem()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productQuantityTextField.delegate = self
        imageContainerView.layer.cornerRadius = 10
        imageContainerView.layer.borderWidth = 1
        imageContainerView.layer.borderColor = UIColor(named: "PrimaryBlue")?.cgColor
    }
    
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
        productQuantityTextField.text = "\(cartItem.quantity ?? 0)"
    }
    
    func getPriceStringFormat(value: Double) -> String {
      let formatter = NumberFormatter()
      formatter.numberStyle = .currency
      
      return formatter.string(from: NSNumber(value: value))!
    }
    
    @IBAction func didTapRemoveProduct(_ sender: UIButton) {
        vc.deleteCartItem(cartItem: cartItem)
    }
    
    func updateProductQuantity(cartItem: CartItem, quantity: Int) {
        sharedApiManager.updateCartQuantity(cartItem: cartItem, quantity: quantity) { (cartItem, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.vc.getCartItems()
                    self.vc.checkoutProductTableView.reloadData()
                    self.productCostLabel.text = "\(self.getPriceStringFormat(value: self.productPrice! * Double(quantity)))"
                } else if (response.isClientError()) {
                    self.vc.showMessage("Error actualizando cantidad.", type: .error)
                }
            }
        }
    }
}

extension CheckoutProductCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let quantityText = productQuantityTextField.text, !quantityText.isEmpty else {
            self.showMessage(NSLocalizedString("Error", comment: ""),type: .error)
            return
        }
        
        if Int(quantityText)! < 1 {
            productQuantityTextField.text = "1"
        } else if Int(quantityText)! > 50 {
            productQuantityTextField.text = "50"
        }
        updateProductQuantity(cartItem: cartItem, quantity: Int(quantityText)!)
    }
}
