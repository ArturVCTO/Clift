//
//  UserSummaryProductCollectionViewCell.swift
//  clift_iOS
//
//  Created by David Mar on 3/19/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

protocol UserSummaryProductCollectionViewCellDelegate {
    func didTapStarProduct(eventProduct: EventProduct)
    func didTapStarPool(eventPool: EventPool)
    func didTapMoreOptions(cellType: ProductCellType, eventPool: EventPool, eventProduct: EventProduct)
}

class UserSummaryProductCollectionViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var envelopeImage: UIImageView!
    @IBOutlet weak var deliveryActionButton: UIButton!
    @IBOutlet weak var creditActionButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var userProductCellDelegate: UserProductCellDelegate!
    var currentEventProduct: EventProduct!
    var currentPool: EventPool!
    var cellType: ProductCellType?
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = UIImage(named: "cashFund")
        shopLabel.isHidden = false
        envelopeImage.isHidden = false
        envelopeImage.image = UIImage(named: "icthankgray")
        deliveryActionButton.isHidden = false
        deliveryActionButton.setImage(UIImage(named: "icdelivergray"), for: .normal)
        creditActionButton.isHidden = false
        creditActionButton.setImage(UIImage(named: "iccreditgray"), for: .normal)
    }
        
    func configure(pool: EventPool? = nil, summaryItem: GiftSummaryItem? = nil) {
        
        switch cellType {
            case .EventProduct:
                if let currentSummaryItem = summaryItem {
                    currentEventProduct = currentSummaryItem.eventProduct

                    if let imageURL = URL(string:"\(currentEventProduct.product.imageUrl)") {
                        self.productImage.sd_setImage(with: imageURL,
                                                      placeholderImage: UIImage(named: "cliftplaceholder"))
                    }
                    
                    nameLabel.text = currentSummaryItem.order.userData.name + " " + currentSummaryItem.order.userData.lastName
                    
                    if let category = currentEventProduct.product.categories.first {
                        categoryLabel.text = "Categoría: \(category.name)"
                    }
                    
                    productNameLabel.text = currentEventProduct.product.name
                    shopLabel.text = currentEventProduct.product.shop.name + " - " + currentEventProduct.product.brand_name
                    if currentEventProduct.gifted_quantity > 0 {
                        productPriceLabel.text = "Precio: $\(Double(currentEventProduct.product.price)/Double(currentEventProduct.gifted_quantity)) MXN"
                    } else {
                        productPriceLabel.text = "Precio: $\(currentEventProduct.product.price) MXN"
                    }
                    totalLabel.text = "Total: $\(currentEventProduct.product.price)"
                    
                    productQuantityLabel.text = "Cantidad: \(currentEventProduct.gifted_quantity) de \(currentEventProduct.quantity)"
                    setButtons(summaryItem: currentSummaryItem)
                }
            case .EventExternalProduct:
                if let currentSummaryItem = summaryItem {
                    currentEventProduct = currentSummaryItem.eventProduct
                
                    if let imageURL = URL(string:"\(currentEventProduct.externalProduct.imageUrl)") {
                        self.productImage.sd_setImage(with: imageURL,
                                                      placeholderImage: UIImage(named: "cliftplaceholder"))
                    }
                    
                    productNameLabel.text = currentEventProduct.externalProduct.name
                    shopLabel.text = currentEventProduct.externalProduct.shopName
                    
                    if currentEventProduct.gifted_quantity > 0 {
                        productPriceLabel.text = "Precio: $\(Double(currentEventProduct.product.price)/Double(currentEventProduct.gifted_quantity)) MXN"
                    } else {
                        productPriceLabel.text = "Precio: $\(currentEventProduct.product.price) MXN"
                    }
                    
                    totalLabel.text = "Precio: $\(currentEventProduct.externalProduct.price) MXN"
                    
                    if let category = currentEventProduct.product.categories.first {
                        categoryLabel.text = "Categoría: \(category.name)"
                    }
        
                    productQuantityLabel.text = "Cantidad: \(currentEventProduct.gifted_quantity) de \(currentEventProduct.quantity)"
                    setButtons(summaryItem: currentSummaryItem)
                }
                break
            case .EventPool:
                
                /*if let pool = pool {
                    currentPool = pool
                    productImage.image = UIImage(named: "cashFund")
                    productNameLabel.text = pool.description
                    productPriceLabel.text = "Precio: $ \(pool.goal) MXN"
                    shopLabel.isHidden = true
                    productQuantityLabel.isHidden = true
                    envelopeImage.isHidden = true
                    deliveryActionButton.isHidden = true
                    creditActionButton.isHidden = true
                }*/
                break
            default:
                break
        }
    }
    
    private func setButtons(summaryItem: GiftSummaryItem) {
        let giftStatusHelperOptions = GiftStatusHelper.shared.manageSimpleGift(giftSummaryItem: summaryItem)
        
        switch giftStatusHelperOptions.credit {
        case .greenIcon:
            let image = UIImage(named: "iccreditgreen")
            creditActionButton.setImage(image, for: .normal)
        case .hidden:
            creditActionButton.isHidden = true
        default:
            break
        }
        
        switch giftStatusHelperOptions.deliver {
        case .greenIcon:
            let image = UIImage(named: "icdeliveredgreen")
            deliveryActionButton.setImage(image, for: .normal)
        case .hidden:
            deliveryActionButton.isHidden = true
        default:
            break
        }
        
        switch giftStatusHelperOptions.envelope {
        case .greenIcon:
            envelopeImage.image = UIImage(named: "icthankgreen")
        case .hidden:
            envelopeImage.isHidden = true
        default:
            break
        }
    }
}
