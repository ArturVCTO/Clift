//
//  GuestEventProductCell.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 04/01/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

protocol ProductCellDelegate {
    func didTapAddProductToCart(quantity:Int, product: Product)
    func didTapCashFundPool(eventPool: EventPool)
}

enum ProductGuestCellType {
    case Eventproduct
    case Eventpool
}

class GuestEventProductCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var addCartView: UIView!
    @IBOutlet weak var productActionButton: UIButton!
    
    var productCellDelegate: ProductCellDelegate!
    var currentProduct: Product!
    var currentPool: EventPool!
    var cellType: ProductGuestCellType?
    
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
    
    func configure(pool: EventPool? = nil, product: EventProduct? = nil) {
        
        switch cellType {
            case .Eventproduct:
                
                if let product = product {
                    currentProduct = product.product
                
                    if let imageURL = URL(string:"\(product.product.imageUrl)") {
                        self.productImage.kf.setImage(with: imageURL,placeholder: UIImage(named: "cliftplaceholder"))
                    }
                
                    productNameLabel.text = product.product.name
                    productPriceLabel.text = "$ \(product.product.price) MXN"
                    productQuantityLabel.text = "\(product.gifted_quantity) / \(product.quantity)"
                }
            case .Eventpool:
                
                if let pool = pool {
                    productImage.image = UIImage(named: "cashFund")
                    productNameLabel.text = pool.description
                    productPriceLabel.text = pool.note
                    quantityView.isHidden = true
                    productActionButton.setImage(UIImage(named: "whiteGift"), for: .normal)
                }
            default:
                break
        }
    }

    @IBAction func addProductToCart(_ sender: UIButton) {
        switch cellType {
        case .Eventproduct:
            productCellDelegate.didTapAddProductToCart(quantity: 1, product: currentProduct)
        case .Eventpool:
            productCellDelegate.didTapCashFundPool(eventPool: currentPool)
        default:
            break
        }
    }
}
