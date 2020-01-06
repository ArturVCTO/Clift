//
//  ProductSubcategoryCollectionViewCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 9/12/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class ProductSubcategoryCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var subcategoryNameLabel: UILabel!
    
    func setup(group: Group) {
        self.subcategoryNameLabel.text = group.name
    }
}
