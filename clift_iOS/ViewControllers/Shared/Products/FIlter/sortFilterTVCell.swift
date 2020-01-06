//
//  sortFilterTVCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 10/20/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class SortFilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sortNameLabel: UILabel!
    func setup(sort: String) {
        self.sortNameLabel.text = sort
    }
}
