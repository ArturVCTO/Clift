//
//  StoreProductCell.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 02/03/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit
import SDWebImage

protocol StoreProductCellDelegate {
    func didTapProductQuantity(currentStoreProductCell: StoreProductCell)
    func didTapAddProductToRegistry(product: Product, productQuantity: Int)
    func didTapAddProductToCart(product: Product, productQuantity: Int)
}

class StoreProductCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var addCartView: UIView!
    @IBOutlet var giftView: UIView!
    
    var storeProductCellDelegate: StoreProductCellDelegate!
    var cellWidthConstraint: NSLayoutConstraint?
    var currentProduct = Product()
    
    var cellWidth: CGFloat? {
        didSet{
            guard let cellWidth = cellWidth else { return }
            cellWidthConstraint?.constant = cellWidth
            cellWidthConstraint?.isActive = true
            contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        cellWidthConstraint = contentView.widthAnchor.constraint(equalToConstant: 0)
        setup()
        addGestureRecognizer()
    }
    
    func addGestureRecognizer() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(self.didTapQuantity))
        tap.cancelsTouchesInView = false
        quantityView.addGestureRecognizer(tap)
    }
    
    func setup() {
        quantityView.layer.cornerRadius = 5
        quantityView.layer.borderWidth = 1
        quantityView.layer.borderColor = UIColor(named: "PrimaryBlue")?.cgColor
        addCartView.layer.cornerRadius = 5
        giftView.layer.cornerRadius = 5
        productImage.contentMode = .scaleAspectFit
    }
    
    func configure(product: Product) {
        
        currentProduct = product
        
        if let imageURL = URL(string:"\(product.imageUrl)") {
            self.productImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "cliftplaceholder"))
        }
        productNameLabel.text = product.name
        productPriceLabel.text = "$ \(product.price) MXN"
    }
    
    @objc func didTapQuantity() {
        storeProductCellDelegate.didTapProductQuantity(currentStoreProductCell: self)
    }
    
    @IBAction func didTapAddToCart(_ sender: Any) {
        if let currentQuantity = Int(productQuantityLabel.text ?? "1") {
            storeProductCellDelegate.didTapAddProductToCart(product: currentProduct, productQuantity: currentQuantity)
        }
    }
    
    @IBAction func didTapGift(_ sender: Any) {
        if let currentQuantity = Int(productQuantityLabel.text ?? "1") {
            storeProductCellDelegate.didTapAddProductToRegistry(product: currentProduct, productQuantity: currentQuantity)
        }
    }
}
