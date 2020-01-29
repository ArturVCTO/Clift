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
    
    func configure(cell: MockGiftedProduct) {
        self.giftImageView.image = cell.image
        self.giftName.text = cell.name
        self.giftShop.text = cell.shop
        self.giftBrand.text = cell.brand
        self.giftQuantity.text = "\(cell.quantity)"
    }
}
