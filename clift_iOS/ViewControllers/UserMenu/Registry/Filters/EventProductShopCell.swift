//
//  EventProductShopCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 11/11/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class EventProductShopCell: UITableViewCell {
    
    @IBOutlet weak var shopNameLabel: UILabel!
    
    func setup(shop: Shop) {
        self.shopNameLabel.text = shop.name
    }
}
