//
//  AddProductByUrlViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 10/24/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import SwiftSoup
import GSMessages

class AddProductByUrlViewController: UIViewController {
    typealias Item = (text: String, html: String)
    
    @IBOutlet weak var urlTextField: UITextField!
    var document: Document = Document.init("")
    var productsRegistryVC: ProductsRegistryViewController!
    var productPrice = ""
    var productName = ""
    var imageURL = ""
    var priceItems: [Item] = []
    var nameItems: [Item] = []
    var urlItems: [Item] = []
    
    override func viewDidLoad() {
           super.viewDidLoad()
        self.urlTextField.delegate = self
           self.navigationController?.navigationBar.barTintColor = UIColor.white
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(true)
           self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 117/255, green: 126/255, blue: 106/255, alpha: 1.0)
       }
   
    
    func hideKeyboardForURL() {
        urlTextField.resignFirstResponder()
    }
    
    func downloadURLInfo() {
        guard let url = URL(string: urlTextField.text ?? "") else {
            self.showMessage(NSLocalizedString("Error \(urlTextField.text ?? "") no parece ser un URL valido.", comment: ""), type: .error)
            return
        }
        
        do {
            if (url.host! == "www.amazon.com" || url.host! == "www.amazon.com.mx") {
                let html = try String.init(contentsOf: url)
                document = try SwiftSoup.parse(html)
                print(document)
              parseAmazon()
                
            }
            else {
                let html = try String.init(contentsOf: url)
                document = try SwiftSoup.parse(html)
              
                parse()
            }
        } catch let error {
            
             self.showMessage(NSLocalizedString("Error \(error)", comment: ""), type: .error)
        }
    }
    
    func parse() {
           do {
               //empty old items
               priceItems = []
            guard let priceElements = try? document.getElementsMatchingOwnText(String("^\\$?([1-9]{1,3},([0-9]{3},)*[0-9]{3}|[0-9]+)(.[0-9][0-9])?$")) else {
                return
            }
                          
                        
            
            guard let metaTitle = try? document.getElementsByAttributeValue("property", "og:title") else {
                return
            }
            
            guard let metaProductImageUrl = try? document.getElementsByAttributeValue("property", "og:image") else {
                return
            }
            
            
            
            let ogTitle: String = try metaTitle.attr("content")
            let ogProductImageUrl: String = try metaProductImageUrl.attr("content")
            
            for element in priceElements {
                print(element)
            }
            
            
               // firn css selector
//               //transform it into a local object (Item)
//               for element in priceElements {
//                   let text = try element.text()
//                   let html = try element.outerHtml()
//                   priceItems.append(Item(text: text, html: html))
//               }
            redirectToProductInfoVC(productPrice: "", productName: ogTitle, productImageUrl: ogProductImageUrl)
           } catch let error {
               self.showMessage(NSLocalizedString("Error \(error)", comment: ""), type: .error)
           }

       }
    
    func parseAmazon() {
        do {
            priceItems = []
//            guard let priceElement = try? document.getElementById("price-large") else {
//                return
//            }
            guard let priceElements = try? document.getElementsMatchingOwnText(String("^\\$?([1-9]{1,3},([0-9]{3},)*[0-9]{3}|[0-9]+)(.[0-9][0-9])?$")) else {
                return
            }
            guard let nameElement = try? document.getElementById("product-title") else {
                return
            }
            guard let imageUrlElement = try? document.getElementById("detailImg") else {
                return
            }
            
            let encodedImageUrl: String = try imageUrlElement.attr("src")


                    for element in priceElements {
                        let text = try element.text()
                        let html = try element.outerHtml()
                        priceItems.append(Item(text: text, html: html))
                    }
            
            let nameText = try nameElement.text()
            
            redirectToProductInfoVC(productPrice: "", productName: nameText, productImageUrl: encodedImageUrl)
        } catch let error {
            self.showMessage(NSLocalizedString("Error \(error)", comment: ""), type: .error)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func redirectToProductInfoVC(productPrice: String,productName: String, productImageUrl: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            let productInfoVC = storyboard.instantiateViewController(identifier: "productInfoByUrlVC") as! ProductInfoByUrlViewController
            productInfoVC.productsRegistryVC = self.productsRegistryVC
            productInfoVC.productName = productName
            productInfoVC.productPrice = productPrice
            productInfoVC.productUrl = self.urlTextField.text!
            productInfoVC.productImageUrl = productImageUrl
            self.navigationController?.pushViewController(productInfoVC, animated: true)
        } else {
            // Fallback on earlier versions
            let productInfoVC = storyboard.instantiateViewController(withIdentifier: "productInfoByUrlVC") as! ProductInfoByUrlViewController
            productInfoVC.productsRegistryVC = self.productsRegistryVC
            productInfoVC.productName = productName
            productInfoVC.productPrice = productPrice
            productInfoVC.productUrl = self.urlTextField.text!
            productInfoVC.productImageUrl = productImageUrl
            self.navigationController?.pushViewController(productInfoVC, animated: true)
        }
    }

}

extension AddProductByUrlViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       var bool = false
        
        if textField == urlTextField {
            hideKeyboardForURL()
            bool = true
        }
        
        return bool
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == urlTextField {
            downloadURLInfo()
        }
    }
}
