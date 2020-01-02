//
//  CategoryTableViewCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 9/9/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    func setup(category: String) {
        self.categoryLabel.text = category
    }
}
