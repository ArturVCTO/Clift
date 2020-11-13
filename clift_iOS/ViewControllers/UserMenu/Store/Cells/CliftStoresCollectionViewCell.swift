//
//  CliftStoresCollectionViewCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 9/19/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class CliftStoresCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopImageUrl: customImageView!
    
    func setup(shop: Shop) {
        
        self.shopNameLabel.text = shop.name
        
		shopImageUrl.contentMode = .scaleAspectFit
        if let imageURL = URL(string:"\(shop.imageURL)") {
                   self.shopImageUrl.kf.setImage(with: imageURL, placeholder: UIImage(named: "profilePlaceHolder"), options: [
                       .scaleFactor(UIScreen.main.scale),
                       .transition(.fade(1)),
                       .cacheOriginalImage
                   ])
        }
    }
}
