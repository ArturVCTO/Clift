//
//  GiftStoreProductsViewController.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 24/02/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

class GiftStoreProductsViewController: UIViewController {

    @IBOutlet var testLabel: UILabel!
    
    var products: [Product]! = []
    var category = Category()
    var filtersDic: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        getEventAndProducts()
    }
    
    private func setNavBar() {
        
        let titleLabel = UILabel()
        titleLabel.text = category.name.uppercased()
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Mihan-Regular", size: 16.0)!
        titleLabel.addCharactersSpacing(5)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

// MARK: Extension REST APIs
extension GiftStoreProductsViewController {
    
    func getStoreProducts(event: Event) {
        sharedApiManager.getProductsAsLoggedInUserLessParams(event:event, filters: filtersDic) { (products,result) in
            
            if let response = result{
                if (response.isSuccess()) {
                    self.products = products
                    self.testLabel.text = "Se presentarán: \(self.products.count) articulos"
                }
            }
            self.dismissLoader()
        }
    }
        
    func getEventAndProducts() {
        sharedApiManager.getEvents() { (events, result) in
            self.presentLoader()
            if let response = result {
                if (response.isSuccess()) {
                    if let currentEvent = events?.first {
                        self.getStoreProducts(event: currentEvent)
                    }
                }
            } else {
                self.dismissLoader()
            }
        }
    }
}
