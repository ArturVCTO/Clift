//
//  RegistryGuestCell.swift
//  clift_iOS
//
//  Created by Alejandro González on 21/08/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import UIKit

class RegistryGuestCell: UICollectionViewCell {
    
    public var currentEvent: Event!
    public var currentProduct: EventProduct!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImage: customImageView!
    
   
    
    func setup(product: EventProduct){
        self.currentProduct = product
        productNameLabel.text = product.product.name
   
        if let imageURL = URL(string:"\(product.product.imageUrl)") {
            self.productImage.kf.setImage(with: imageURL,placeholder: UIImage(named: "cliftplaceholder"))
        }
    }
}
