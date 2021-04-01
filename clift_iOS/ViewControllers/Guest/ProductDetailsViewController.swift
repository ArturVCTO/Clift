//
//  ProductDetailsViewController.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 06/01/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit
import Auk

enum ProductDetailType {
    case EventProduct
    case EventExternalProduct
    case Product
}

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imagesView: UIView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productBrandLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var productDetailsLabel: UILabel!
    @IBOutlet weak var productEspecificationsLabel: UILabel!
    @IBOutlet weak var productPriceView: UIView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var currentEventProduct: EventProduct?
    var currentProduct: Product?
    var currentEvent = Event()
    var productDetailType: ProductDetailType?
    var showAddProductToCart = true
    var paymentType: PaymentType = .userGuest
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setNavBar()
        if productDetailType == .EventProduct {
            setEventScrollView()
            configureEventProduct()
        } else if productDetailType == .EventExternalProduct {
            setEventScrollView()
            configureExternalProduct()
        } else {
            setProductScrollView()
            configureProduct()
        }
        
        if !showAddProductToCart {
            addToCartButton.isHidden = true
        }
    }
    
    func setUI() {
        imagesView.layer.cornerRadius = 10
        scrollView.layer.cornerRadius = 10
        imagesView.layer.borderWidth = 1
        imagesView.layer.borderColor = UIColor.gray.cgColor
        productPriceView.addTopBorder(with: UIColor.lightGray, andWidth: 1)
        addToCartButton.layer.cornerRadius = 5
    }
    
    func setNavBar() {
        
        let titleLabel = UILabel()
        titleLabel.text = "PRODUCTO"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Mihan-Regular", size: 16.0)!
        titleLabel.addCharactersSpacing(5)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if showAddProductToCart {
            let cartImage = UIImage(named: "cart")
            let cartButton   = UIBarButtonItem(image: cartImage,  style: .plain, target: self, action: #selector(didTapCartButton(sender:)))
            navigationItem.rightBarButtonItem = cartButton
        }
    }
    
    @objc func didTapCartButton(sender: AnyObject){
        let vc = UIStoryboard.init(name: "Checkout", bundle: nil).instantiateViewController(withIdentifier: "checkoutVC") as! CheckoutViewController
        vc.paymentType = paymentType
        vc.currentEvent = currentEvent
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setEventScrollView() {
        
        //SetUI
        scrollView.auk.settings.pageControl.backgroundColor = .clear
        
        //Set placeholder
        scrollView.auk.settings.placeholderImage = UIImage(named: "cliftplaceholder")
        
        //Set images in scrollView
        if currentEventProduct?.product.imageUrl != "" {
            scrollView.auk.show(url: (currentEventProduct?.product.imageUrl)!)
        }
        
        if currentEventProduct?.product.secondImageUrl != "" {
            scrollView.auk.show(url: (currentEventProduct?.product.secondImageUrl)!)
        }
        
        if currentEventProduct?.product.thirdImageUrl != "" {
            scrollView.auk.show(url: (currentEventProduct?.product.thirdImageUrl)!)
        }
        
        //Set AutoScroll
        scrollView.auk.startAutoScroll(delaySeconds: 2)
    }
    
    func setProductScrollView() {
        
        //SetUI
        scrollView.auk.settings.pageControl.backgroundColor = .clear
        
        //Set placeholder
        scrollView.auk.settings.placeholderImage = UIImage(named: "cliftplaceholder")
        
        //Set images in scrollView
        if currentProduct?.imageUrl != "" {
            scrollView.auk.show(url: (currentProduct?.imageUrl)!)
        }
        
        if currentProduct?.secondImageUrl != "" {
            scrollView.auk.show(url: (currentProduct?.secondImageUrl)!)
        }
        
        if currentProduct?.thirdImageUrl != "" {
            scrollView.auk.show(url: (currentProduct?.thirdImageUrl)!)
        }
        
        //Set AutoScroll
        scrollView.auk.startAutoScroll(delaySeconds: 2)
    }
    
    func configureEventProduct() {
        
        productNameLabel.text = currentEventProduct?.product.name
        productBrandLabel.text = currentEventProduct?.product.brand_name
        
        if let category = currentEventProduct?.product.categories, !category.isEmpty {
            
            let categoryText = "Categría: \(category.first?.name ?? "")"
            
            if let group = currentEventProduct?.product.categories.first?.groups, !group.isEmpty {
                
                let groupText = " | Grupo: \(group.first?.name ?? "")"
                
                productCategoryLabel.colorString(text: categoryText + groupText, coloredText: [category.first?.name, group.first?.name], color: UIColor(named: "PrimaryBlue"))
                
            } else {
                productCategoryLabel.colorString(text: categoryText, coloredText: [category.first?.name], color: UIColor(named: "PrimaryBlue"))
            }
        } else {
            productCategoryLabel.isHidden = true
        }
        
        productDetailsLabel.text = currentEventProduct?.product.description
        productEspecificationsLabel.text = currentEventProduct?.product.specs
        if let price = currentEventProduct?.product.price {
            productPriceLabel.text = "$\(price)"
        } else {
            productPriceLabel.text = "Sin precio"
        }
    }
    
    func configureExternalProduct() {
        
        productNameLabel.text = currentEventProduct?.externalProduct.name
        productBrandLabel.text = currentEventProduct?.externalProduct.shopName
        productCategoryLabel.isHidden = true
        productDetailsLabel.isHidden = true
        productEspecificationsLabel.text = "Producto Externo"
        scrollView.auk.show(url: (currentEventProduct?.externalProduct.imageUrl)!)
        if let price = currentEventProduct?.externalProduct.price {
            productPriceLabel.text = "$\(price)"
        } else {
            productPriceLabel.text = "Sin precio"
        }
    }
    
    func configureProduct() {
        
        productNameLabel.text = currentProduct?.name
        productBrandLabel.text = currentProduct?.brand_name
        
        if let category = currentProduct?.categories, !category.isEmpty {
            
            let categoryText = "Categría: \(category.first?.name ?? "")"
            
            if let group = currentProduct?.categories.first?.groups, !group.isEmpty {
                
                let groupText = " | Grupo: \(group.first?.name ?? "")"
                
                productCategoryLabel.colorString(text: categoryText + groupText, coloredText: [category.first?.name, group.first?.name], color: UIColor(named: "PrimaryBlue"))
                
            } else {
                productCategoryLabel.colorString(text: categoryText, coloredText: [category.first?.name], color: UIColor(named: "PrimaryBlue"))
            }
        } else {
            productCategoryLabel.isHidden = true
        }
        
        productDetailsLabel.text = currentProduct?.description
        productEspecificationsLabel.text = currentProduct?.specs
        if let price = currentProduct?.price {
            productPriceLabel.text = "$\(price)"
        } else {
            productPriceLabel.text = "Sin precio"
        }
    }
    
    @IBAction func addToCartPressed(_ sender: UIButton) {
        
        if paymentType == .userGuest {
            if let eventProduct = currentEventProduct {
                addEventProductToCart(quantity: 1, product: eventProduct)
            }
        } else {
            if let product = currentProduct {
                addProductToCart(product: product, productQuantity: 1)
            }
        }
    }
    
    func addEventProductToCart(quantity: Int, product: EventProduct) {
        sharedApiManager.addItemToCartGuest(quantity: quantity, product: product) { (cartItem, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.red
                    self.showMessage(NSLocalizedString("Producto se ha agregado a tu carrito.", comment: "Login Error"),type: .success)
                } else if (response.isClientError()) {
                    self.showMessage(NSLocalizedString("Producto no se pudo agregar, intente de nuevo más tarde.", comment: "Login Error"),type: .error)
                }
            } else {
                self.showMessage(NSLocalizedString("Producto no se pudo agregar, intente de nuevo más tarde.", comment: "Login Error"),type: .error)
            }
        }
    }
    
    func addProductToCart(product: Product, productQuantity: Int) {
        sharedApiManager.addItemToCart(quantity: productQuantity, product: product) { (cartItem, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.red
                    self.showMessage(NSLocalizedString("Producto agregado a tu carrito.", comment: "Login Error"),type: .success)
                } else if (response.isClientError()) {
                    self.showMessage(NSLocalizedString("Producto no se pudo agregar, intente de nuevo más tarde.", comment: "Login Error"),type: .error)
                }
            }
        }
    }
}
