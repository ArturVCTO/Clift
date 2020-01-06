//
//  EventProductBrandCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 11/11/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class EventProductBrandCell: UITableViewCell {
    
    @IBOutlet weak var brandNameLabel: UILabel!
    
    func setup(brand: Brand) {
        self.brandNameLabel.text = brand.name
    }
}
