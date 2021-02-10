//
//  UserEventProductCell.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 05/02/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

protocol UserProductCellDelegate {
    func didTapStartProduct()
    func didTapMoreOptions()
}

/*enum ProductGuestCellType {
    case EventProduct
    case EventPool
    case EventExternalProduct
}*/

class UserEventProductCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var greenCheckmarkImage: UIImageView!
    @IBOutlet weak var giftTypeLabel: UILabel!
    @IBOutlet weak var starProductButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
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
    var currentProduct: Product!
    var currentPool: EventPool!
    var cellType: ProductGuestCellType?
    
    var cellWidthConstraint: NSLayoutConstraint?
    
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
                    currentProduct = product.product

                    if let imageURL = URL(string:"\(product.product.imageUrl)") {
                        self.productImage.sd_setImage(with: imageURL,
                                                      placeholderImage: UIImage(named: "cliftplaceholder"))
                    }
                
                    setProductType()//////
                    if product.isImportant {/////
                        starProductButton.setImage(UIImage(named: "fullStar"), for: .normal)///
                    } else {
                        starProductButton.setImage(UIImage(named: "star"), for: .normal)///
                    }/////
                    productNameLabel.text = product.product.name
                    shopLabel.text = product.product.shop.name////7
                    brandLabel.text = "-" + product.product.brand_name//////
                    productPriceLabel.text = "$ \(product.product.price) MXN"
                    productQuantityLabel.text = "\(product.gifted_quantity) / \(product.quantity)"
                    setDeliveryCreditButtons(product: product)//////
                }
            case .EventExternalProduct:
                if let product = product {
                    currentProduct = product.product
                
                    if let imageURL = URL(string:"\(product.externalProduct.imageUrl)") {
                        self.productImage.sd_setImage(with: imageURL,
                                                      placeholderImage: UIImage(named: "cliftplaceholder"))
                    }
                
                    productNameLabel.text = product.externalProduct.name
                    productPriceLabel.text = "$ \(product.externalProduct.price) MXN"
                    productQuantityLabel.text = "\(product.gifted_quantity) / \(product.quantity)"
                }
            case .EventPool:
                
                if let pool = pool {
                    productImage.image = UIImage(named: "cashFund")
                    productNameLabel.text = pool.description
                    productPriceLabel.text = pool.note
                    quantityView.isHidden = true
                    deliveryActionButton.setImage(UIImage(named: "whiteGift"), for: .normal)
                }
            default:
                break
        }
    }
    
    private func setProductType() {
        giftTypeLabel.text = "Terminado"
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
            if !product.hasBeenPaid {
                setGreenQuantityView()
            }
        case "credit":
            creditView.backgroundColor = UIColor(named: "SuccessGreen")
            deliveryView.isHidden = true
            if !product.hasBeenPaid {
                setGreenQuantityView()
            }
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
            //productCellDelegate.didTapAddProductToCart(quantity: 1, product: currentProduct)
            print("addproduct")
        case .EventPool:
            //productCellDelegate.didTapCashFundPool(eventPool: currentPool)
            print("addproduct")
        default:
            break
        }
    }
    
    @IBAction func creditButtonPressed(_ sender: UIButton) {
        print("credit")
    }
    
    @IBAction func productStarted(_ sender: UIButton) {
        userProductCellDelegate.didTapStartProduct()
    }
    
    @IBAction func productMoreOptions(_ sender: UIButton) {
        userProductCellDelegate.didTapMoreOptions()
    }
}
