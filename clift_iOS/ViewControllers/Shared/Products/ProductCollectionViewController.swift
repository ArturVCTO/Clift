//
//  ProductCollectionViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 9/12/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import DropDown
import Realm
import RealmSwift

class ProductCollectionViewController: UIViewController {
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    let categoryDropDown = DropDown()
    @IBOutlet weak var productSubcategoryButton: UIButton!
    
    @IBOutlet weak var productCountLabel: UILabel!
    var groups = [Group]()
    var category = Category()
    var group = Group()
    var brand = Brand()
    var shop = Shop()
    var subgroup = Subgroup()
    var currentEvent = Event()
    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCurrentEvent()
        self.productsCollectionView.delegate = self
        self.productsCollectionView.dataSource = self
        self.setupDropDownStyle()
        self.getProducts(group: self.group, event: self.currentEvent)
        self.getCategory(category: self.category)
    }
    
    func loadCurrentEvent() {
           let realm = try! Realm()
           let realmEvents = realm.objects(Event.self)
           if let currentEvent = realmEvents.first {
               self.currentEvent = currentEvent
           }
    }
    
    func setupDropDownStyle() {
        let appearance = DropDown.appearance()
        appearance.cornerRadius = 4
        appearance.cellHeight = 40
    }
 
    
    func getCategory(category: Category) {
        sharedApiManager.getCategory(id: category.id) { (category,result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.groups = category!.groups
                    self.setupSubCategoryDD(groups: category!.groups)
                }
            }
        }
    }
    
    func setupSubCategoryDD(groups: [Group]) {
        var dataSourceDropDown = [String]()
        categoryDropDown.anchorView = self.productSubcategoryButton
        
        for group in groups {
            dataSourceDropDown.append("\(group.name)")
        }
        categoryDropDown.dataSource = dataSourceDropDown
        categoryDropDown.bottomOffset = CGPoint(x: 0, y: productSubcategoryButton.bounds.height)
        
        categoryDropDown.selectionAction = { [weak self] (index, item) in
            self!.productSubcategoryButton.setTitle(item, for: .normal)
            self!.getProducts(group: groups[index],event: self!.currentEvent)
        }
    }
    
    @IBAction func tapSubcategoryButton(_ sender: Any) {
        self.categoryDropDown.show()
    }
    
    func getProducts(group: Group, event: Event) {
       sharedApiManager.getProductsAsLoggedInUser(group: group, subgroup: self.subgroup,event:event,brand: brand, shop: shop, filters: [:], page: 1) { (products,result) in
            if let response = result{
                if (response.isSuccess()) {
                    self.products = products!
                    self.setupProductsCount(products: products!)
                    self.productsCollectionView.reloadData()
                }
            }
        }
    }
    
    func setupProductsCount(products: [Product]) {
        self.productCountLabel.text = "\(products.count) artículos"
    }
    
    @IBAction func tapFilterButton(_ sender: Any) {
        if #available(iOS 13.0, *) {
              let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "filterProductVC") as! FilterProductViewController
              //vc.product = self.products[indexPath.row]
              self.navigationController?.pushViewController(vc, animated: true)
          } else {
            // Fallback on earlier versions
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "filterProductVC") as! FilterProductViewController
              //vc.product = self.products[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
extension ProductCollectionViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if collectionView == productsCollectionView {
            let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
            cell.setup(product: self.products[indexPath.row])
            return cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
                  let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "productViewController") as! ProductViewController
                  vc.product = self.products[indexPath.row]
            vc.productsCollectionVC = self
            vc.group = self.group
                  self.navigationController?.pushViewController(vc, animated: true)
              } else {
                // Fallback on earlier versions
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "productViewController") as! ProductViewController
                  vc.product = self.products[indexPath.row]
                vc.productsCollectionVC = self
                vc.group = self.group
                self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    
}
