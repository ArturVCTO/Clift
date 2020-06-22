//
//  MainStoreCategoryCollectionViewCell.swift
//  
//
//  Created by Juan Carlos Garza on 9/19/19.
//

import Foundation
import UIKit

class MainStoreCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImageView: customImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    func setup(category: Category) {
        self.categoryNameLabel.text = category.name
        if let imageURL = URL(string:"\(category.imageUrl)") {
                   self.categoryImageView.kf.setImage(with: imageURL)
        }
    }
}
