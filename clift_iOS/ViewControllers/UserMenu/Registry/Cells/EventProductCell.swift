//
//  EventProductCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 10/31/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class EventProductCell: UICollectionViewCell {
 
    @IBOutlet weak var eventProductImageView: customImageView!
    @IBOutlet weak var eventProductName: UILabel!
    @IBOutlet weak var shopProductName: UILabel!
    @IBOutlet weak var brandProductName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var eventProductQuantityLabel: UILabel!
    @IBOutlet weak var paidAmount: customProgressView!
    @IBOutlet weak var giftCollaborators: UILabel!
    @IBOutlet weak var topPriorityView: customView!
    @IBOutlet weak var giftedLabel: UILabel!
    @IBOutlet weak var sentImageView: UIImageView!
    @IBOutlet weak var quantityImageView: UIImageView!
    @IBOutlet weak var giftedCheckmark: UIImageView!
    
    func setup(eventProduct: EventProduct) {
        var fulfilled = false
        
        if (eventProduct.isImportant == true) {
            topPriorityView.isHidden = false
        } else {
            topPriorityView.isHidden = true
        }
        if (eventProduct.wishableType == "Product") {
            self.eventProductName.text = eventProduct.product.name
            self.productPrice.text = "\(self.getPriceStringFormat(value: Double(eventProduct.product.price)!))"
            self.paidAmount.barHeight = 0.0
            self.shopProductName.text = eventProduct.product.shop.name
            self.brandProductName.text = eventProduct.product.brand.name
            if let imageURL = URL(string:"\(eventProduct.product.imageUrl)") {
                self.eventProductImageView.kf.setImage(with: imageURL,placeholder: UIImage(named: "cliftplaceholder"))
            }
            var isProductGifted = self.isGifted(price: eventProduct.product.price, paidAmount: eventProduct.paidAmount)
            if isProductGifted {
                self.giftedLabel.text = "Regalado"
                self.giftCollaborators.isHidden = false
                self.quantityImageView.isHidden = false

                self.giftedCheckmark.isHidden = false
            } else {
                self.giftedLabel.text = "Disponible"
                self.giftCollaborators.isHidden = true
                self.quantityImageView.isHidden = true
                self.giftedCheckmark.isHidden = true
            }
            if fulfilled {
                self.sentImageView.isHidden = false
            } else {
                self.sentImageView.isHidden = true
            }
            
        } else {
            self.eventProductName.text = eventProduct.externalProduct.name
            self.productPrice.text = "\(self.getPriceStringFormat(value: Double(eventProduct.externalProduct.price)!))"
            if let imageURL = URL(string:"\(eventProduct.externalProduct.imageUrl)") {
                self.eventProductImageView.kf.setImage(with: imageURL,placeholder: UIImage(named: "cliftplaceholder"))
            }
            
            self.paidAmount.barHeight = 0.0
            
            var isProductGifted = self.isGifted(price: eventProduct.externalProduct.price, paidAmount: eventProduct.paidAmount)
            if isProductGifted {
                self.giftedLabel.text = "Regalado"
                self.giftCollaborators.isHidden = false
                self.quantityImageView.isHidden = false
                self.giftedCheckmark.isHidden = false
            } else {
                self.giftedLabel.text = "Disponible"
                self.giftCollaborators.isHidden = true
                self.quantityImageView.isHidden = true
                self.giftedCheckmark.isHidden = true
            }
            
            if fulfilled {
                self.sentImageView.isHidden = false
            } else {
                self.sentImageView.isHidden = true
            }
        }
        
        self.eventProductQuantityLabel.text = "Necesita: \(eventProduct.quantity)"
    }
    
    func isGifted(price: String,paidAmount: String) -> Bool {
        var bool = Bool()
        
        if paidAmount == price {
            bool = true
        } else {
            bool = false
        }
        
        return bool
    }
    
    func getPriceStringFormat(value: Double) -> String {
           
           let formatter = NumberFormatter()
           formatter.numberStyle = .currency
           
           return formatter.string(from: NSNumber(value: value))!
    }
}
