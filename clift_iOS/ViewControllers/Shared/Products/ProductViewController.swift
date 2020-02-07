//
//  ProductViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 9/5/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift
import GSMessages

class ProductViewController: UIViewController {
    
    var productAddedToRegistry = false
    var product = Product()
    var currentEvent = Event()
    var quantity = 1
    var group = Group()
    var brand = Brand()
    var shop = Shop()
    
    @IBOutlet weak var addToRegistryButton: customButton!
    @IBOutlet weak var productContainerView: UIView!
    var firstFilterProductVC: FirstFilterViewController?
    var productsCollectionVC: ProductCollectionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadContainerView()
        self.loadCurrentEvent()
        self.isProductInRegistry(product: self.product)
    }
    
    func loadCurrentEvent() {
      let realm = try! Realm()
      let realmEvents = realm.objects(Event.self)
      if let currentEvent = realmEvents.first {
          self.currentEvent = currentEvent
      }
    }
    
    func isProductInRegistry(product: Product) {
        if product.isInEvent {
            productAddedToRegistry = true
            self.addToRegistryButton.setTitle("QUITAR DE MESA", for: .normal)
        } else {
            productAddedToRegistry = false
            self.addToRegistryButton.setTitle("AGREGAR A MESA", for: .normal)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToRegistryButtonTapped(_ sender: Any) {
        if (productAddedToRegistry == true){
            productAddedToRegistry = false
            self.addToRegistryButton.setTitle("AGREGAR A MESA", for: .normal)
            
            let sheet = UIAlertController(title: "Estás seguro de quitar producto de tu mesa", message: nil, preferredStyle: .alert)
            
            let acceptAction = UIAlertAction(title: "Aceptar", style: .destructive,handler: removeProductButtonPressed(alert:))
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
            sheet.addAction(acceptAction)
            sheet.addAction(cancelAction)
            present(sheet, animated: true, completion: nil)
            
        }else {
            productAddedToRegistry = true
            self.addProductToRegistry(product: self.product, event: self.currentEvent)
            self.addToRegistryButton.setTitle("QUITAR DE MESA", for: .normal)
        }
    }
    
    @IBAction func addProductToShoppingCartTapped(_ sender: Any) {
        self.addProductToCart(quantity: self.quantity, product: self.product)
    }
    
    
    func removeProductButtonPressed(alert: UIAlertAction) {
        self.removeProductFromRegistry(product: self.product, event: self.currentEvent)
    }
    
    func addProductToRegistry(product: Product, event: Event) {
        sharedApiManager.addProductToRegistry(productId: product.id, eventId: event.id, quantity: self.quantity, paidAmount: 0) { (eventProduct, result) in
            if let response = result {
                if (response.isSuccess()) {
                     self.showMessage(NSLocalizedString("Producto se ha agregado a tu mesa.", comment: "Login Error"),type: .success)
                    if (self.productsCollectionVC != nil) {
                        self.productsCollectionVC?.getProducts(group: self.group, event: self.currentEvent)
                        self.productsCollectionVC?.productsCollectionView.reloadData()
                    } else {
                        self.firstFilterProductVC?.getProducts(group: self.group, brand: self.brand, shop: self.shop, event: self.currentEvent)
                        self.firstFilterProductVC?.firstFilterProductsCollectionView.reloadData()
                    }
                } else {
                    self.showMessage(NSLocalizedString("Producto no se pudo agregar, intente de nuevo más tarde.", comment: "Login Error"),type: .error)
                }
            }
        }
    }
    
    func addProductToCart(quantity: Int, product: Product) {
        sharedApiManager.addItemToCart(quantity: self.quantity, product: product) { (cartItem, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.showMessage(NSLocalizedString("Producto se ha agregado a tu carrito.", comment: "Login Error"),type: .success)
                } else if (response.isClientError()) {
                    self.showMessage(NSLocalizedString("Producto no se pudo agregar, intente de nuevo más tarde.", comment: "Login Error"),type: .error)

                }
            }
        }
    }
    
    func removeProductFromRegistry(product: Product,event: Event) {
        sharedApiManager.deleteProductFromRegistry(productId: product.id, eventId: event.id) { (emptyObject, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.showMessage(NSLocalizedString("Producto se ha quitado de tu mesa", comment: "Login Error"),type: .success)
                    if (self.productsCollectionVC != nil) {
                        self.productsCollectionVC?.getProducts(group: self.group, event: self.currentEvent)
                        self.productsCollectionVC?.productsCollectionView.reloadData()
                    } else {
                       
                       self.firstFilterProductVC?.getProducts(group: self.group, brand: self.brand, shop: self.shop, event: self.currentEvent)
                        self.firstFilterProductVC?.firstFilterProductsCollectionView.reloadData()
                    }
                } else {
                    self.showMessage(NSLocalizedString("\(emptyObject?.errors.first ?? "Error, intente de nuevo más tarde.")", comment: "Login Error"),type: .error)
                }
            }
        }
    }
    
    func loadContainerView() {
        if #available(iOS 13.0, *) {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "productInfoVC") as!        ProductInformationTableViewController
            vc.product = self.product
            self.addChild(vc)
            vc.productVC = self
            vc.view.frame = CGRect(x: 0, y: 0, width: self.productContainerView.frame.size.width, height: self.productContainerView.frame.size.height)
            self.productContainerView.addSubview(vc.view)
            vc.didMove(toParent: self)
        } else {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "productInfoVC") as! ProductInformationTableViewController
            vc.product = self.product
            vc.productVC = self
            self.addChild(vc)
           vc.view.frame = CGRect(x: 0, y: 0, width: self.productContainerView.frame.size.width, height: self.productContainerView.frame.size.height)
            self.productContainerView.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }
    
    @IBAction func checkoutButtonTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
          let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "checkoutVC") as! CheckoutViewController
          self.navigationController?.pushViewController(vc, animated: true)
         } else {
          let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "checkoutVC") as! CheckoutViewController
          self.navigationController?.pushViewController(vc, animated: true)
         }
    }
}
