//
//  SummaryRegistryTableViewCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 11/4/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class SummaryRegistryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var giftSummaryLabel: UILabel!
    
    func setup(category: EventRegistrySummary) {
        self.categoryNameLabel.text = category.name
        self.giftSummaryLabel.text = "Te han regalado 0 de \(category.total)"
    }
}
