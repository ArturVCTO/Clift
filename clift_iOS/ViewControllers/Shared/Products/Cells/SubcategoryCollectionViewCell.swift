//
//  SubcategoryCollectionViewCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 9/17/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class SubcategoryCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var subcategoryImageView: customImageView!
    
    func setup(group: Group) {
        self.groupNameLabel.text = group.name
    }
}
