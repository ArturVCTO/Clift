//
//  CliftStoresCollectionViewCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 9/19/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class CliftStoresCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shopNameLabel: UILabel!
    
    func setup(shop: Shop) {
        self.shopNameLabel.text = shop.name
    }
}
