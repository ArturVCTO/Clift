//
//  GuestEventProductCell.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 04/01/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

class GuestEventProductCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var addCartView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    func setup() {
        quantityView.layer.cornerRadius = 5
        quantityView.layer.borderWidth = 1
        quantityView.layer.borderColor = UIColor(named: "PrimaryBlue")?.cgColor
        addCartView.layer.cornerRadius = 5
    }
    
    func configure(product: EventProduct) {
        
        if let imageURL = URL(string:"\(product.product.imageUrl)") {
            self.productImage.kf.setImage(with: imageURL,placeholder: UIImage(named: "cliftplaceholder"))
        }
        
        productNameLabel.text = product.product.name
        productPriceLabel.text = "$ \(product.product.price) MXN"
        productQuantityLabel.text = "\(product.gifted_quantity) / \(product.quantity)"
    }

    @IBAction func addProductToCart(_ sender: UIButton) {
        print("Product added to cart")
    }
}
