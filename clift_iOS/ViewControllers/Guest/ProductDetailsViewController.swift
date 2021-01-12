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
    var prueba = ["https://bit.ly/auk_image","https://bit.ly/moa_imagee","https://st1.uvnimg.com/dims4/default/0102b2f/2147483647/resize/1093x820%3E/quality/75/?url=http%3A%2F%2Fuvn-brightspot.s3.amazonaws.com%2Fd4%2F4a%2F006304a74db4902c0b4d8d8026c8%2Fchevrolet-corvette-c8-stingray-2020-1280-08.jpg","https://www.landuum.com/wp-content/uploads/2019/03/cultura_paisajeiluminado_landuum5.jpg","https://www.infobae.com/new-resizer/d09N_vgiOAqH_NojJDsUET2Dk2s=/1200x900/filters:format(jpg):quality(85)//arc-anglerfish-arc2-prod-infobae.s3.amazonaws.com/public/5NQ4QLPS7VFF3A7MYAKGMNE7OA.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setNavBar()
        setScrollView(with: prueba)
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
        
        navigationItem.title = "Por definir"
        
        let cartImage = UIImage(named: "cart")
        let cartButton   = UIBarButtonItem(image: cartImage,  style: .plain, target: self, action: #selector(didTapCartButton(sender:)))
        navigationItem.rightBarButtonItem = cartButton
    }
    
    @objc func didTapCartButton(sender: AnyObject){
        print("Carrito de compras")
    }
    
    func setScrollView(with imagesToDisplay: [String]) {
        
        //SetUI
        scrollView.auk.settings.pageControl.backgroundColor = .clear
        
        //Set placeholder
        scrollView.auk.settings.placeholderImage = UIImage(named: "cliftplaceholder")
        
        //Set images in scrollView
        /*imagesToDisplay.forEach { image in
            scrollView.auk.show(url: image)
        }*/
        scrollView.auk.show(url: (currentEventProduct?.product.imageUrl)!)
        
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
        print("Producto agregado al carrito")
    }
}
