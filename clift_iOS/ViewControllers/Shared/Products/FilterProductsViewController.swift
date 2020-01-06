//
//  FilterProductsViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 9/9/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class FilterProductViewController: UIViewController {
    let filters = ["Ordenar por:","Precio","Tienda","Marcas","Color","Grupo"]
    let sorts = ["Precio: bajo - alto", "Precio: alto - bajo", "A - Z", "Z - A"]
    
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var categoryResultsTableView: UITableView!
    
    var firstFilterParentVC: FirstFilterViewController?
    var productsCollectionVC: ProductCollectionViewController?
    var brands: [Brand] = []
    var group = Group()
    var subgroupsAsGroup: [Subgroup] = []
    var shops: [Shop] = []
    var colors: [CliftColor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryResultsTableView.allowsMultipleSelection = true
        categoryTableView.delegate = self
        categoryResultsTableView.delegate = self
        categoryTableView.dataSource = self
        categoryResultsTableView.dataSource = self
        self.getBrands()
        self.getShops()
        self.getColors()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getShops() {
        sharedApiManager.getShops() { (shops, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.shops = shops!
                    self.categoryResultsTableView.reloadData()
                }
            }
            
        }
    }
    
    func getBrands() {
        sharedApiManager.getBrands() { (brands, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.brands = brands!
                    self.categoryResultsTableView.reloadData()
                }
            }
        }
    }
    
    func getGroup(group: Group) {
        sharedApiManager.getGroup(id: group.id) { (group, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.subgroupsAsGroup = group!.subgroups
                    self.categoryResultsTableView.reloadData()
                }
            }
        }
    }
    
    func getColors() {
        sharedApiManager.getColors() { (colors, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.colors = colors!
                }
            }
        }
    }
    @IBAction func applyFilters(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension FilterProductViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = Int()
        if tableView == categoryTableView {
            return filters.count
        }
        else if tableView == categoryResultsTableView {
            if categoryTableView.indexPathForSelectedRow == [0,0] {
                return self.sorts.count
            } else if categoryTableView.indexPathForSelectedRow == [0,1] {
                return 1
            } else if categoryTableView.indexPathForSelectedRow == [0,2]  {
                return self.shops.count
            } else if categoryTableView.indexPathForSelectedRow == [0,3] {
                return self.brands.count
            } else if categoryTableView.indexPathForSelectedRow == [0,4] {
                return 1
            } else if categoryTableView.indexPathForSelectedRow == [0,5] {
                return 1
            }
        }
        
        return numberOfRows
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()

        if tableView == categoryTableView {
            let categoryCell = tableView.dequeueReusableCell(withIdentifier: "categoryTVCell") as! CategoryTableViewCell
            categoryCell.setup(category: filters[indexPath.row])
            return categoryCell
        }
        else if tableView == categoryResultsTableView {
            if categoryTableView.indexPathForSelectedRow == [0,1] {
                let priceTVCell = tableView.dequeueReusableCell(withIdentifier: "priceTVCell")!
                return priceTVCell
            } else if categoryTableView.indexPathForSelectedRow == [0,5] {
                let categoryResultCell = tableView.dequeueReusableCell(withIdentifier: "categoryResultsTVCell") as! CategoryResultsTableViewCell
                
                return categoryResultCell
            } else if categoryTableView.indexPathForSelectedRow == [0,0] {
                let sortFilterTVCell = tableView.dequeueReusableCell(withIdentifier: "sortFilterTVCell") as! SortFilterTableViewCell
                sortFilterTVCell.setup(sort: sorts[indexPath.row])
                return sortFilterTVCell
            } else if categoryTableView.indexPathForSelectedRow == [0,2] {
                let shopFilterTVCell = tableView.dequeueReusableCell(withIdentifier: "shopFilterTVCell") as! ShopFilterTableViewCell
                shopFilterTVCell.setup(shop: shops[indexPath.row])
                return shopFilterTVCell
            } else if categoryTableView.indexPathForSelectedRow == [0,3] {
                let brandFilterTVCell = tableView.dequeueReusableCell(withIdentifier: "brandFilterTVCell") as! BrandFilterTableViewCell
                brandFilterTVCell.setup(brand: brands[indexPath.row])
                return brandFilterTVCell
            }  else if categoryTableView.indexPathForSelectedRow == [0,4] {
               let colorTVCell = tableView.dequeueReusableCell(withIdentifier: "colorFilterTVCell") as! ColorFilterTableViewCell
                colorTVCell.setup(color: colors[indexPath.row])
                return colorTVCell
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (tableView == categoryResultsTableView) {
            return 100.0
        }
        return 50.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == categoryResultsTableView) {
            if let cell = categoryResultsTableView.cellForRow(at: indexPath) {
                if categoryTableView.indexPathForSelectedRow == [0,1] {
                    cell.accessoryType = .none
                } else {
                    cell.accessoryType = .checkmark
                }
            }
        }
        categoryResultsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if (tableView == categoryResultsTableView) {
            if let cell = categoryResultsTableView.cellForRow(at: indexPath) {
                cell.accessoryType = .none
            }
        }
    }
    
    
    
}
