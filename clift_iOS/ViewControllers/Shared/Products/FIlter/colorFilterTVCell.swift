//
//  colorFilterTVCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 10/20/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class ColorFilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var colorNameLabel: UILabel!
    func setup(color: CliftColor) {
        self.colorNameLabel.text = color.name
    }
}
