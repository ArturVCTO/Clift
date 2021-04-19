//
//  FirstColaborativeSummaryTableViewCell.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 07/04/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

class FirstColaborativeSummaryTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var storeLabel: UILabel!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var minimalisticQuantityLabel: UILabel!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet weak var deliveryButton: UIButton!
    @IBOutlet weak var creditButton: UIButton!
    @IBOutlet weak var envelopeImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = UIImage(named: "cashFund")
        envelopeImage.isHidden = false
        envelopeImage.image = UIImage(named: "icthankgray")
        deliveryButton.isHidden = false
        deliveryButton.setImage(UIImage(named: "icdelivergray"), for: .normal)
        creditButton.isHidden = false
        creditButton.setImage(UIImage(named: "iccreditgray"), for: .normal)
    }
    
    func configure(eventProduct: EventProduct) {
        
        if let imageURL = URL(string:"\(eventProduct.product.imageUrl)") {
            self.productImage.sd_setImage(with: imageURL,
                                          placeholderImage: UIImage(named: "cliftplaceholder"))
        }
        
        if let orderItem = eventProduct.orderItems?.first {
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
        
        if let orderItem = eventProduct.orderItems?.first {
            priceLabel.text = "Precio: $\(orderItem.amount)"
        } else {
            priceLabel.text = ""
        }
        
        quantityLabel.text = "Cantidad: \(eventProduct.gifted_quantity) de \(eventProduct.collaborators)"
        
        if let orderItem = eventProduct.orderItems?.first {
            totalLabel.text = "Total: $\(orderItem.amount)"
        } else {
            totalLabel.text = ""
        }
        
        minimalisticQuantityLabel.text = "\(eventProduct.gifted_quantity) - \(eventProduct.collaborators)"
        setButtons(eventProduct: eventProduct)
    }
    
    private func setButtons(eventProduct: EventProduct) {
        let giftStatusHelperOptions = GiftStatusHelper.shared.manageCollaborativeGift(eventProduct: eventProduct)
        
        switch giftStatusHelperOptions.credit {
        case .greenIcon:
            let image = UIImage(named: "iccreditgreen")
            creditButton.setImage(image, for: .normal)
        case .hidden:
            creditButton.isHidden = true
        default:
            break
        }
        
        switch giftStatusHelperOptions.deliver {
        case .greenIcon:
            let image = UIImage(named: "icdeliveredgreen")
            deliveryButton.setImage(image, for: .normal)
        case .hidden:
            deliveryButton.isHidden = true
        default:
            break
        }
        
        switch giftStatusHelperOptions.envelope {
        case .greenIcon:
            envelopeImage.image = UIImage(named: "icthankgreen")
        case .hidden:
            envelopeImage.isHidden = true
        default:
            break
        }
    }
}
