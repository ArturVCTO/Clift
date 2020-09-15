//
//  MainStoreBrandCollectionViewCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 9/19/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class MainStoreBrandCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var brandImageView: customImageView!
    
    func setup(brand: Brand) {
        
        
        self.brandNameLabel.text = brand.name
        if let imageURL = URL(string:"\(brand.imageUrl)") {
                   self.brandImageView.kf.setImage(with: imageURL)
        }
    }
}
