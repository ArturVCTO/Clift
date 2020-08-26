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
import GSMessages

class ProductInformationTableViewController: UITableViewController {
    @IBOutlet weak var shopProductLabel: UILabel!
    @IBOutlet weak var brandProductLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var nameColorLabel: UILabel!
    @IBOutlet weak var stepperButton: UIStepper!
    @IBOutlet weak var productColorView: customView!
    @IBOutlet weak var quantityProductLabel: UILabel!
    @IBOutlet weak var descriptionProductLabel: UITextView!
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productImageSlider: ImageSlideshow!
    var event = Event()
    var product = Product()
    var productVC: ProductViewController!
    var eventProduct = EventProduct()
    var collectionView: UICollectionView!
    var selectedIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setProduct(product: self.product)
    }
    
    @IBAction func quantityStepperTapped(_ sender: UIStepper) {
         self.stepperButton.isEnabled = false
        
        sharedApiManager.updateEventProductQuantity(event: event, eventProduct: eventProduct, quantity: Int(sender.value)) { (eventProduct, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.eventProduct.quantity = Int(sender.value)
                    self.quantityProductLabel.text = "Cantidad: \(self.eventProduct.gifted_quantity) de \(Int(sender.value))"
                    
                    self.stepperButton.isEnabled = true
                    
                    self.showMessage(NSLocalizedString("Cantidad de producto actualizado con exito", comment: "Update success"),type: .success)
                    
                    self.collectionView.reloadItems(at: [self.selectedIndexPath!])
                    
                }else{
                    sender.value = Double(self.eventProduct.quantity)
                    self.showMessage(NSLocalizedString("Error, no se puede actualizar la cantidad", comment: "Update error"),type: .error)
                }
                
            }
        }
        
        
//        self.quantityProductLabel.text = "Cantidad: \(Int(sender.value))"
//        self.productVC.quantity = Int(sender.value)
    }
    
    func setProduct(product: Product) {
        self.shopProductLabel.text = product.shop.name
        self.brandProductLabel.text = product.brand.name
        self.productNameLabel.text = product.name
        self.productPriceLabel.text = "$\(product.price)"
        
        if(eventProduct.isCollaborative){ //Es un producto colaborativo
             self.quantityProductLabel.text = "Colaboraciones: \(eventProduct.guestData?["user_info"]?.count ?? 0) de \(eventProduct.collaborators)"
            self.stepperButton.isHidden = true
        }else{
             self.quantityProductLabel.text = "Cantidad: \(eventProduct.gifted_quantity) de \(eventProduct.quantity)"
            self.stepperButton.isHidden = false
            

            self.stepperButton.minimumValue = Double(eventProduct.gifted_quantity + 1)
            self.stepperButton.maximumValue = 20
            self.stepperButton.value = Double(eventProduct.quantity)
        }
        
        self.descriptionProductLabel.text = product.description;
        self.productColorView.backgroundColor = self.hexStringToUIColor(hex: product.color.hexCode)
        self.nameColorLabel.text = product.color.name
        if let imageURL = URL(string:"\(product.imageUrl)") {
            self.productImageView.kf.setImage(with: imageURL,placeholder: UIImage(named: "cliftplaceholder"))
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
