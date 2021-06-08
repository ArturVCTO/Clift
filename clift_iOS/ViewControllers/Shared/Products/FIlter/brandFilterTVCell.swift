//
//  brandFilterTVCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 10/20/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class BrandFilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var brandNameLabel: UILabel!
    func setup(brand: Brand) {
        self.brandNameLabel.text = brand.name
    }
}

