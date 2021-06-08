//
//  shopFilterTVCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 10/20/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class ShopFilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shopNameLabel: UILabel!
    func setup(shop: Shop) {
        self.shopNameLabel.text = shop.name
    }
}
