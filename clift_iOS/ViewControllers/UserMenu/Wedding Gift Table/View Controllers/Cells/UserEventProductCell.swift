//
//  UserEventProductCell.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 05/02/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

protocol UserProductCellDelegate {
    func didTapStarProduct(eventProduct: EventProduct)
    func didTapStarPool(eventPool: EventPool)
    func didTapMoreOptions(cellType: ProductCellType, eventPool: EventPool, eventProduct: EventProduct)
}

class UserEventProductCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var greenCheckmarkImage: UIImageView!
    @IBOutlet weak var giftTypeLabel: UILabel!
    @IBOutlet weak var starProductButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet var shopAndBrandStackView: UIStackView!
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var quantityStackView: UIStackView!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var envelopeImage: UIImageView!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var deliveryActionButton: UIButton!
    @IBOutlet weak var creditView: UIView!
    @IBOutlet weak var creditActionButton: UIButton!
    
    var userProductCellDelegate: UserProductCellDelegate!
    var currentEventProduct: EventProduct!
    var currentPool: EventPool!
    var cellType: ProductCellType?
    
    var cellWidthConstraint: NSLayoutConstraint?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = UIImage(named: "cashFund")
        greenCheckmarkImage.isHidden = true
        giftTypeLabel.isHidden = false
        giftTypeLabel.text = ""
        starProductButton.setImage(UIImage(named: "star"), for: .normal)
        shopAndBrandStackView.isHidden = false
        brandLabel.text = ""
        envelopeImage.isHidden = false
        quantityView.isHidden = false
        deliveryView.isHidden = false
        creditView.isHidden = false
        deliveryView.backgroundColor = UIColor(named: "PrimaryBlue")
        creditView.backgroundColor = UIColor(named: "PrimaryBlue")
        quantityView.layer.borderColor = UIColor(named: "PrimaryBlue")?.cgColor
        productQuantityLabel.textColor = UIColor(named: "PrimaryBlue")
        deliveryActionButton.isEnabled = true
        creditActionButton.isEnabled = true
    }
    
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
    }
    
    func setup() {
        quantityView.layer.cornerRadius = 5
        quantityView.layer.borderWidth = 1
        quantityView.layer.borderColor = UIColor(named: "PrimaryBlue")?.cgColor
        deliveryView.layer.cornerRadius = 5
        creditView.layer.cornerRadius = 5
        productImage.contentMode = .scaleAspectFit
    }
    
    func configure(pool: EventPool? = nil, product: EventProduct? = nil) {
        
        switch cellType {
            case .EventProduct:
                if let product = product {
                    currentEventProduct = product

                    if let imageURL = URL(string:"\(product.product.imageUrl)") {
                        self.productImage.sd_setImage(with: imageURL,
                                                      placeholderImage: UIImage(named: "cliftplaceholder"))
                    }
                
                    setProductType(eventProduct: product)
                    if product.isImportant {
                        starProductButton.setImage(UIImage(named: "fullStar"), for: .normal)
                    }
                    productNameLabel.text = product.product.name
                    shopLabel.text = product.product.shop.name
                    brandLabel.text = " - " + product.product.brand_name
                    productPriceLabel.text = "$ \(product.product.price) MXN"
                    if product.isCollaborative {
                        productQuantityLabel.text = "\(product.gifted_quantity) / \(product.collaborators)"
                    } else {
                        productQuantityLabel.text = "\(product.gifted_quantity) / \(product.quantity)"
                    }
                    setDeliveryCreditButtons(product: product)
                }
            case .EventExternalProduct:
                if let product = product {
                    currentEventProduct = product
                
                    if let imageURL = URL(string:"\(product.externalProduct.imageUrl)") {
                        self.productImage.sd_setImage(with: imageURL,
                                                      placeholderImage: UIImage(named: "cliftplaceholder"))
                    }
                    
                    setProductType(eventProduct: product)
                    
                    if product.isImportant {
                        starProductButton.setImage(UIImage(named: "fullStar"), for: .normal)
                    }
                    productNameLabel.text = product.externalProduct.name
                    shopLabel.text = product.externalProduct.shopName
                    productPriceLabel.text = "$ \(product.externalProduct.price) MXN"
                    if product.isCollaborative {
                        productQuantityLabel.text = "\(product.gifted_quantity) / \(product.collaborators)"
                    } else {
                        productQuantityLabel.text = "\(product.gifted_quantity) / \(product.quantity)"
                    }
                    setDeliveryCreditButtons(product: product)
                }
            case .EventPool:
                
                if let pool = pool {
                    currentPool = pool
                    productImage.image = UIImage(named: "cashFund")
                    greenCheckmarkImage.isHidden = true
                    giftTypeLabel.isHidden = true
                    if pool.isImportant {
                        starProductButton.setImage(UIImage(named: "fullStar"), for: .normal)
                    }
                    productNameLabel.text = pool.description
                    productPriceLabel.text = "$ \(pool.goal) MXN"
                    shopAndBrandStackView.isHidden = true
                    quantityView.isHidden = true
                    envelopeImage.isHidden = true
                    deliveryView.isHidden = true
                    creditView.isHidden = true
                }
            default:
                break
        }
    }
    
    private func setProductType(eventProduct: EventProduct) {
        if eventProduct.hasBeenPaid {
            greenCheckmarkImage.isHidden = false
            giftTypeLabel.text = "Regalado"
        } else if eventProduct.status != "approved" && !eventProduct.hasBeenPaid {
            greenCheckmarkImage.isHidden = false
            giftTypeLabel.text = "Terminado"
        } else if eventProduct.isCollaborative {
            giftTypeLabel.text = "Regalo grupal"
        }
    }
    
    private func setGreenQuantityView() {
        quantityView.layer.borderColor = UIColor(named: "SuccessGreen")?.cgColor
        productQuantityLabel.textColor = UIColor(named: "SuccessGreen")
    }
    
    private func setDeliveryCreditButtons(product: EventProduct) {
        if product.isCollaborative {
            if !(product.collaborators == product.gifted_quantity) {
                deliveryView.isHidden = true
                creditView.isHidden = true
            }
        }
        
        switch product.status {
        case "requested":
            deliveryView.backgroundColor = UIColor(named: "SuccessGreen")
            creditView.isHidden = true
            setGreenQuantityView()
            deliveryActionButton.isEnabled = false
        case "credit":
            creditView.backgroundColor = UIColor(named: "SuccessGreen")
            deliveryView.isHidden = true
            setGreenQuantityView()
            creditActionButton.isEnabled = false
        case "pending":
            if !(product.hasBeenPaid && product.gifted_quantity >= 1) {
                deliveryView.isHidden = true
                creditView.isHidden = true
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
