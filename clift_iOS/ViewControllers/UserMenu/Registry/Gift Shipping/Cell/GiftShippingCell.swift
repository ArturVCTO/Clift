//
//  GiftShippingCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/28/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit

class GiftShippingCell: UITableViewCell {
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var giftName: UILabel!
    @IBOutlet weak var giftShop: UILabel!
    @IBOutlet weak var giftBrand: UILabel!
    @IBOutlet weak var giftQuantity: UILabel!
    
    func configure(cell: EventProduct) {
        if let imageURL = URL(string:"\(cell.product.imageUrl)") {
            self.giftImageView.kf.setImage(with: imageURL)
        }
        self.giftName.text = cell.name
        self.giftShop.text = cell.product.shop.name
        self.giftBrand.text = cell.product.brand.name
        self.giftQuantity.text = "\(cell.quantity)"
    }
}
