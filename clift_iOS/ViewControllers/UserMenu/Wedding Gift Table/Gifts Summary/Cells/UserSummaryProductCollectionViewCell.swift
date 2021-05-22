//
//  UserSummaryProductCollectionViewCell.swift
//  clift_iOS
//
//  Created by David Mar on 3/19/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

protocol UserSummaryProductTableViewCellDelegate {
    func didTapDeliveryButton(cellIndex: Int)
    func didTapCreditButton(cellIndex: Int)
    func didTapEnvelopeButton(cellIndex: Int)
}

class UserSummaryProductCollectionViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var envelopeActionButton: UIButton!
    @IBOutlet weak var deliveryActionButton: UIButton!
    @IBOutlet weak var creditActionButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var currentEventProduct: EventProduct!
    var currentPool: EventPool!
    var cellType: ProductCellType?
    var delegate: UserSummaryProductTableViewCellDelegate?
    var currentCellIndex = -1
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = UIImage(named: "cashFund")
        shopLabel.isHidden = false
        envelopeActionButton.isHidden = false
        envelopeActionButton.setImage(UIImage(named: "icthankgray"), for: .normal)
        deliveryActionButton.isHidden = false
        deliveryActionButton.setImage(UIImage(named: "icdelivergray"), for: .normal)
        creditActionButton.isHidden = false
        creditActionButton.setImage(UIImage(named: "iccreditgray"), for: .normal)
        totalLabel.isHidden = false
        categoryLabel.isHidden = false
        envelopeActionButton.isEnabled = true
        creditActionButton.isEnabled = true
        deliveryActionButton.isEnabled = true
    }
        
    func configure(cashGiftItem: CashGiftItem? = nil, summaryItem: GiftSummaryItem? = nil, currentIndex: Int = -1, delegate: UserSummaryProductTableViewCellDelegate? = nil) {
        
        switch cellType {
            case .EventProduct:
                
                currentCellIndex = currentIndex
                self.delegate = delegate
                
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
                
                if let cashGiftItem = cashGiftItem {
                    currentPool = cashGiftItem.eventPool
                    productImage.image = UIImage(named: "cashFund")
                    nameLabel.text = cashGiftItem.order.userData.name + " " + cashGiftItem.order.userData.lastName
                    shopLabel.isHidden = true
                    productNameLabel.text = currentPool.description
                    categoryLabel.isHidden = true
                    productPriceLabel.text = "Contribución: \(cashGiftItem.amount) MXN"
                    productQuantityLabel.isHidden = true
                    totalLabel.isHidden = true
                    envelopeActionButton.isHidden = true
                    deliveryActionButton.isHidden = true
                    creditActionButton.isHidden = true
                }
            default:
                break
        }
    }
    
    private func setButtons(summaryItem: GiftSummaryItem) {
        let giftStatusHelperOptions = GiftStatusHelper.shared.manageSimpleGift(giftSummaryItem: summaryItem)
        
        switch giftStatusHelperOptions.credit {
        case .greenIcon:
            let image = UIImage(named: "iccreditgreen")
            creditActionButton.isEnabled = false
            creditActionButton.setImage(image, for: .disabled)
        case .hidden:
            creditActionButton.isHidden = true
        default:
            break
        }
        
        switch giftStatusHelperOptions.deliver {
        case .greenIcon:
            let image = UIImage(named: "icdeliveredgreen")
            deliveryActionButton.isEnabled = false
            deliveryActionButton.setImage(image, for: .disabled)
        case .hidden:
            deliveryActionButton.isHidden = true
        default:
            break
        }
        
        switch giftStatusHelperOptions.envelope {
        case .greenIcon:
            let image = UIImage(named: "icthankgreen")
            envelopeActionButton.isEnabled = false
            envelopeActionButton.setImage(image, for: .disabled)
        case .hidden:
            envelopeActionButton.isHidden = true
        default:
            break
        }
    }
    
    @IBAction func deliveryButtonPressed(_ sender: Any) {
        delegate?.didTapDeliveryButton(cellIndex: currentCellIndex)
    }
    
    @IBAction func creditButtonPressed(_ sender: Any) {
        delegate?.didTapCreditButton(cellIndex: currentCellIndex)
    }
    @IBAction func envelopeButtonPressed(_ sender: Any) {
        delegate?.didTapEnvelopeButton(cellIndex: currentCellIndex)
    }
}
