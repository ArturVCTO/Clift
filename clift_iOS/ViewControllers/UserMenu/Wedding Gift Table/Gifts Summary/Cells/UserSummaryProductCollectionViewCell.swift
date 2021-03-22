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
        envelopeImage.isHidden = true
        deliveryActionButton.isHidden = false
        creditActionButton.isHidden = false
        deliveryActionButton.isEnabled = true
        creditActionButton.isEnabled = true
    }
        
    func configure(pool: EventPool? = nil, summaryItem: GiftSummaryItem? = nil) {
        
        switch cellType {
            case .EventProduct:
                if let product = summaryItem?.eventProduct {
                    currentEventProduct = product

                    if let imageURL = URL(string:"\(product.product.imageUrl)") {
                        self.productImage.sd_setImage(with: imageURL,
                                                      placeholderImage: UIImage(named: "cliftplaceholder"))
                    }
                    
                    if let userData = summaryItem?.order.userData {
                        nameLabel.text = userData.name + " " + userData.lastName
                    }
                    
                    if let category = summaryItem?.eventProduct.product.categories.first {
                        categoryLabel.text = "Categoría: \(category.name)"
                    }
                    
                    setProductType(eventProduct: product)
                    setEnvelopeImage(eventProduct: product)
                    productNameLabel.text = product.product.name
                    shopLabel.text = product.product.shop.name + " - " + product.product.brand_name
                    if product.gifted_quantity > 0 {
                        productPriceLabel.text = "Precio: $\(Double(product.product.price)/Double(product.gifted_quantity)) MXN"
                    } else {
                        productPriceLabel.text = "Precio: $\(product.product.price) MXN"
                    }
                    totalLabel.text = "Total: $\(product.product.price)"
                    if product.isCollaborative {
                        productQuantityLabel.text = "Cantidad: \(product.gifted_quantity) de \(product.collaborators)"
                    } else {
                        productQuantityLabel.text = "Cantidad: \(product.gifted_quantity) de \(product.quantity)"
                    }
                    setDeliveryCreditButtons(product: product)
                    
                }
            case .EventExternalProduct:
                if let product = summaryItem?.eventProduct {
                    currentEventProduct = product
                
                    if let imageURL = URL(string:"\(product.externalProduct.imageUrl)") {
                        self.productImage.sd_setImage(with: imageURL,
                                                      placeholderImage: UIImage(named: "cliftplaceholder"))
                    }
                    
                    setProductType(eventProduct: product)
            
                    
                    setEnvelopeImage(eventProduct: product)
                    productNameLabel.text = product.externalProduct.name
                    shopLabel.text = product.externalProduct.shopName
                    
                    if product.gifted_quantity > 0 {
                        productPriceLabel.text = "Precio: $\(Double(product.product.price)/Double(product.gifted_quantity)) MXN"
                    } else {
                        productPriceLabel.text = "Precio: $\(product.product.price) MXN"
                    }
                    
                    totalLabel.text = "Precio: $\(product.externalProduct.price) MXN"
                    
                    if let category = summaryItem?.eventProduct.product.categories.first {
                        categoryLabel.text = "Categoría: \(category.name)"
                    }
                    
                    if product.isCollaborative {
                        productQuantityLabel.text = "Cantidad: \(product.gifted_quantity) de \(product.collaborators)"
                    } else {
                        productQuantityLabel.text = "Cantidad: \(product.gifted_quantity) de \(product.quantity)"
                    }
                    setDeliveryCreditButtons(product: product)
                }
            case .EventPool:
                
                if let pool = pool {
                    currentPool = pool
                    productImage.image = UIImage(named: "cashFund")
                    productNameLabel.text = pool.description
                    productPriceLabel.text = "Precio: $ \(pool.goal) MXN"
                    shopLabel.isHidden = true
                    productQuantityLabel.isHidden = true
                    envelopeImage.isHidden = true
                    deliveryActionButton.isHidden = true
                    creditActionButton.isHidden = true
                }
            default:
                break
        }
    }
    
    private func setProductType(eventProduct: EventProduct) {
//        if eventProduct.isCollaborative && !eventProduct.hasBeenPaid && eventProduct.status == "pending" {
//            giftTypeLabel.text = "Regalo grupal"
//        } else if eventProduct.hasBeenPaid {
//            greenCheckmarkImage.isHidden = false
//            giftTypeLabel.text = "Regalado"
//        } else if !eventProduct.hasBeenPaid && eventProduct.status != "pending" {
//            greenCheckmarkImage.isHidden = false
//            giftTypeLabel.text = "Terminado"
//        } else {
//            giftTypeLabel.text = ""
//        }
    }
    
    private func setEnvelopeImage(eventProduct: EventProduct) {
        
        if !eventProduct.hasBeenThanked && (eventProduct.hasBeenPaid || eventProduct.status != "pending") {
            envelopeImage.isHidden = false
            envelopeImage.image = UIImage(named: "icthankgray")
        } else if eventProduct.hasBeenThanked {
            envelopeImage.isHidden = false
            envelopeImage.image = UIImage(named: "icthankgreen")
        } else {
            envelopeImage.isHidden = true
        }
    }
    
    private func setDeliveryCreditButtons(product: EventProduct) {
        
        switch product.status {
        case "requested":
            if let image = UIImage(named: "icdeliveredgreen") {
                deliveryActionButton.setImage(image, for: .normal)
            }
            deliveryActionButton.isHidden = false
            creditActionButton.isHidden = true
            
        case "credit":
            let image = UIImage(named: "iccreditgreen")
            creditActionButton.setImage(image, for: .normal)
            creditActionButton.isHidden = false
            deliveryActionButton.isHidden = true
    
        case "pending":
            if !(product.hasBeenPaid && product.product.shop.shipsNational) {
                deliveryActionButton.isHidden = true
            }
            
            if !product.hasBeenPaid {
                creditActionButton.isHidden = true
            }
        default:
            break
        }
    }

    @IBAction func deliveryButtonPressed(_ sender: UIButton) {
        switch cellType {
        case .EventProduct, .EventExternalProduct:
            print("delivery")
        case .EventPool:
            print("delivery")
        default:
            break
        }
    }
    
    @IBAction func creditButtonPressed(_ sender: UIButton) {
        print("credit")
    }
    
    @IBAction func productStarted(_ sender: UIButton) {
        switch cellType {
        case .EventProduct, .EventExternalProduct:
            userProductCellDelegate.didTapStarProduct(eventProduct: currentEventProduct)
        case .EventPool:
            userProductCellDelegate.didTapStarPool(eventPool: currentPool)
        default:
            break
        }
    }
    
    @IBAction func productMoreOptions(_ sender: UIButton) {
        userProductCellDelegate.didTapMoreOptions(cellType: cellType ?? .EventProduct, eventPool: currentPool ?? EventPool(), eventProduct: currentEventProduct ?? EventProduct())
    }
}
