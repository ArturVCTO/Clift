//
//  MainStoreViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 9/11/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class MainStoreViewController: UIViewController {
        
    @IBOutlet weak var arrowBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var storeCollectionView: UICollectionView!
    
    @IBOutlet weak var checklistCollectionView: UICollectionView!
    
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    var fromRegistry = false
    var shops: [Shop] = []
    var brands: [Brand] = []
    var event = Event()
    
    var filtersStores = Dictionary<String,Any>()
    var filtersBrands = Dictionary<String,Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.comingFromRegistry()
        self.storeCollectionView.delegate = self
        self.storeCollectionView.dataSource = self
        self.storeCollectionView.alwaysBounceHorizontal = true
        
        self.filtersBrands["page"] = 1
        self.filtersStores["page"] = 1
        
        self.brandsCollectionView.delegate = self
        self.brandsCollectionView.dataSource = self
        self.getShops()
        self.getBrands()
    }
    

    
    @IBAction func redirectToWeb(_ sender: Any) {
        if let url = URL(string: "https://www.cliftapp.com") {
            UIApplication.shared.open(url)
        }
    }
    
    func comingFromRegistry() {
        if fromRegistry {
            arrowBarButtonItem.isEnabled = true
        } else {
            arrowBarButtonItem.tintColor = .clear
            arrowBarButtonItem.isEnabled = false
        }
    }
    
    func getShops() {
        sharedApiManager.getShops() { (shops, result) in
            if let response = result {
                if(response.isSuccess()) {
                    self.shops = shops!
                    self.storeCollectionView.reloadData()
                }
            }
        }
    }
    
    func getBrands() {
        sharedApiManager.getBrands(filters: filtersBrands) { (brands, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.brands = brands!
                    self.brandsCollectionView.reloadData()
                }
            }
        }
    }
    
    @IBAction func addExternalProductTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "addProductUrlVC") as! AddProductByUrlViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addProductUrlVC") as! AddProductByUrlViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
extension MainStoreViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case storeCollectionView:
            return self.shops.count
        case checklistCollectionView:
            return 0
        case brandsCollectionView:
            return self.brands.count
        default:
            break
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case storeCollectionView:
            let cell = storeCollectionView.dequeueReusableCell(withReuseIdentifier: "mainShopCell", for: indexPath) as! CliftStoresCollectionViewCell
            cell.setup(shop: shops[indexPath.row])
            return cell
        case checklistCollectionView:
            let cell = UICollectionViewCell()
            return cell
        case brandsCollectionView:
            let cell = brandsCollectionView.dequeueReusableCell(withReuseIdentifier: "mainBrandsCell", for: indexPath) as! MainStoreBrandCollectionViewCell
            cell.setup(brand: brands[indexPath.row])
            return cell
        default:
            break
        }
        let cell = UICollectionViewCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case storeCollectionView:
             if #available(iOS 13.0, *) {
                   let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "firstFilterViewController") as! FirstFilterViewController
                   vc.shop = self.shops[indexPath.row]
                   self.navigationController?.pushViewController(vc, animated: true)
               } else {
                   // Fallback on earlier versions
                   let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "firstFilterViewController") as! FirstFilterViewController
                   vc.shop = self.shops[indexPath.row]
                   self.navigationController?.pushViewController(vc, animated: true)
               }
        case checklistCollectionView:
            return
        case brandsCollectionView:
            if #available(iOS 13.0, *) {
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "firstFilterViewController") as! FirstFilterViewController
                vc.brand = self.brands[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                // Fallback on earlier versions
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "firstFilterViewController") as! FirstFilterViewController
                vc.brand = self.brands[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
}

extension MainStoreViewController: CurrentEventDelegate {
    func getCurrentEvent(event: Event) {
        print("========\(event)")
    }
}
