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
        
        guard let orderItem = eventProduct.orderItems?[numberOfPerson] else {
            nameLabel.text = ""
            priceLabel.text = ""
            totalLabel.text = ""
            envelopeImage.image = UIImage(named: "icthankgray")
            return
        }
        
        nameLabel.text = orderItem.guestData.name + " " + orderItem.guestData.lastName
            
        
        storeLabel.text = eventProduct.product.shop.name
        productNameLabel.text = eventProduct.product.name
        
        if let category = eventProduct.product.categories.first {
            categoryLabel.text = "Categoría: \(category.name)"
        } else {
            categoryLabel.text = ""
        }
        
        priceLabel.text = "Precio: $\(orderItem.amount)"
        
        quantityLabel.text = "Cantidad: \(eventProduct.gifted_quantity) de \(eventProduct.collaborators)"
        
        totalLabel.text = "Total: $\(orderItem.amount)"
        
        envelopeImage.image = orderItem.hasBeenThanked ? UIImage(named: "icthankgreen") : UIImage(named: "icthankgray")
    }
}
