//
//  ProductTableViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 9/5/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import ImageSlideshow
import Kingfisher

class ProductInformationTableViewController: UITableViewController {
    @IBOutlet weak var shopProductLabel: UILabel!
    @IBOutlet weak var brandProductLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var nameColorLabel: UILabel!
    @IBOutlet weak var productColorView: customView!
    @IBOutlet weak var quantityProductLabel: UILabel!
    @IBOutlet weak var descriptionProductLabel: UITextView!
    @IBOutlet weak var specsProductLabel: UITextView!
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productImageSlider: ImageSlideshow!
    var product = Product()
    var productVC: ProductViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setProduct(product: self.product)
    }
    
    @IBAction func quantityStepperTapped(_ sender: UIStepper) {
        
        self.quantityProductLabel.text = "Cantidad: \(Int(sender.value))"
        self.productVC.quantity = Int(sender.value)
    }
    
    func setProduct(product: Product) {
        self.shopProductLabel.text = product.shop.name
        self.brandProductLabel.text = product.brand.name
        self.productNameLabel.text = product.name
        self.productPriceLabel.text = "$\(product.price)"
        self.descriptionProductLabel.text = product.description
        self.specsProductLabel.text = product.specs
        self.productColorView.backgroundColor = self.hexStringToUIColor(hex: product.color.hexCode)
        self.nameColorLabel.text = product.color.name
        if let imageURL = URL(string:"\(product.imageUrl)") {
            self.productImageView.kf.setImage(with: imageURL)
        }
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
//  Check with design team if they should upload more than one image
//
//    func setupProductImageSlider() {
//        let pageIndicator = UIPageControl()
//        pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
//        pageIndicator.pageIndicatorTintColor = UIColor.white
//        productImageSlider.pageIndicator = pageIndicator
//        productImageSlider.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .customBottom(padding: 25.0))
//    }
    
}
