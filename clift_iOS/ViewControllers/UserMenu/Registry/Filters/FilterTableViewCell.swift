//
//  FilterTableViewCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 11/11/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class FilterTableViewCell: UITableViewCell {
    @IBOutlet weak var filterTitleLabel: UILabel!
    
    func setup(title: String) {
        self.filterTitleLabel.text = title
    }
}
