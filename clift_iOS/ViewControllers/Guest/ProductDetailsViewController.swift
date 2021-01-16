//
//  ProductDetailsViewController.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 06/01/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit
import Auk

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setNavBar()
        setScrollView()
        configure()
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
        
        navigationItem.title = "Producto"
        
        let cartImage = UIImage(named: "cart")
        let cartButton   = UIBarButtonItem(image: cartImage,  style: .plain, target: self, action: #selector(didTapCartButton(sender:)))
        navigationItem.rightBarButtonItem = cartButton
    }
    
    @objc func didTapCartButton(sender: AnyObject){
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "checkoutVC") as! CheckoutViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setScrollView() {
        
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
    
    func configure() {
        
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
    
    @IBAction func addToCartPressed(_ sender: UIButton) {
        if let product = currentEventProduct?.product {
            addProductToCart(quantity: 1, product: product)
        }
    }
    
    func addProductToCart(quantity: Int, product: Product) {
        sharedApiManager.addItemToCart(quantity: quantity, product: product) { (cartItem, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.showMessage(NSLocalizedString("Producto se ha agregado a tu carrito.", comment: "Login Error"),type: .success)
                } else if (response.isClientError()) {
                    self.showMessage(NSLocalizedString("Producto no se pudo agregar, intente de nuevo más tarde.", comment: "Login Error"),type: .error)
                }
            }
        }
    }
}
