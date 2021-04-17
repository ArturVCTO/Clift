//
//  ColaborativeSummaryTableViewCell.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 07/04/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

class ColaborativeSummaryTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var storeLabel: UILabel!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet weak var envelopeImage: UIImageView!
    
    func configure(eventProduct: EventProduct, numberOfPerson: Int) {
        
        if let orderItem = eventProduct.orderItems?[numberOfPerson] {
            nameLabel.text = orderItem.guestData.name + " " + orderItem.guestData.lastName
        } else {
            nameLabel.text = ""
        }
        
        storeLabel.text = eventProduct.product.shop.name
        productNameLabel.text = eventProduct.product.name
        
        if let category = eventProduct.product.categories.first {
            categoryLabel.text = "Categoría: \(category.name)"
        } else {
            categoryLabel.text = ""
        }
        
        if let orderItem = eventProduct.orderItems?[numberOfPerson] {
            priceLabel.text = "Precio: $\(orderItem.amount)"
        } else {
            priceLabel.text = ""
        }
        
        quantityLabel.text = "Cantidad: \(eventProduct.gifted_quantity) de \(eventProduct.collaborators)"
        
        if let orderItem = eventProduct.orderItems?[numberOfPerson] {
            totalLabel.text = "Total: $\(orderItem.amount)"
        } else {
            totalLabel.text = ""
        }
        
        if eventProduct.hasBeenThanked {
            envelopeImage.image = UIImage(named: "icthankgreen")
        } else {
            envelopeImage.image = UIImage(named: "icthankgray")
        }
    }
}
