//
//  EventProductFilterViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 11/6/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class EventProductFilterViewController: UIViewController {
    let filters = ["Colaborativo","Tiendas","Marcas"]
    @IBOutlet weak var filterTitleTableView: UITableView!
    @IBOutlet weak var filterOptionsTableView: UITableView!
    var productRegistryVC: ProductsRegistryViewController!
    var shops: [Shop] = []
    var brands: [Brand] = []
    var eventProductFilters = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        self.getShops()
        self.getBrands()
        filterTitleTableView.delegate = self
        filterTitleTableView.dataSource = self
        filterOptionsTableView.delegate = self
        filterOptionsTableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
             super.viewWillDisappear(true)
             self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 117/255, green: 126/255, blue: 106/255, alpha: 1.0)
       }
    
    
    func getShops() {
        sharedApiManager.getShops() { (shops, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.shops = shops!
                    self.filterOptionsTableView.reloadData()
                }
            }
            
        }
    }
    
    func getBrands() {
        sharedApiManager.getBrands() { (brands, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.brands = brands!
                    self.filterOptionsTableView.reloadData()
                }
            }
        }
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func applyFiltersButtonTapped(_ sender: Any) {
        self.productRegistryVC.getEventProducts(event: self.productRegistryVC.currentEvent, available: "", gifted: "", filters: self.eventProductFilters)
        self.navigationController?.popViewController(animated: true)
    }
}
extension EventProductFilterViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = Int()
        if tableView == filterTitleTableView {
            return filters.count
        }
        else if tableView == filterOptionsTableView {
            if filterTitleTableView.indexPathForSelectedRow == [0,0] {
                return 1
            } else if filterTitleTableView.indexPathForSelectedRow == [0,1] {
                return  self.shops.count
            } else if filterTitleTableView.indexPathForSelectedRow == [0,2] {
                return self.brands.count
            }
            
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == filterTitleTableView {
            let categoryCell = tableView.dequeueReusableCell(withIdentifier: "filterTVCell") as! FilterTableViewCell
            categoryCell.setup(title: filters[indexPath.row])
            return categoryCell
        }
        else if tableView == filterOptionsTableView {
            if filterTitleTableView.indexPathForSelectedRow == [0,0] {
                let collaborativeCell = tableView.dequeueReusableCell(withIdentifier: "collaborativeTVCell") as! CollaborativeCell
                collaborativeCell.collaborativeLabel.text = "Mostrar colaborativos"
                return collaborativeCell
            } else if filterTitleTableView.indexPathForSelectedRow == [0,1] {
                let shopsCell = tableView.dequeueReusableCell(withIdentifier: "eventProductShopTV") as! EventProductShopCell
                shopsCell.setup(shop: self.shops[indexPath.row])
                return shopsCell
            } else if filterTitleTableView.indexPathForSelectedRow == [0,2] {
                let brandsCell = tableView.dequeueReusableCell(withIdentifier: "eventProductBrandTV") as! EventProductBrandCell
                brandsCell.setup(brand: self.brands[indexPath.row])
                return brandsCell
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          if (tableView == filterOptionsTableView) {
            return 50.0
          }
          return 50.0
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == filterOptionsTableView) {
            if let cell = filterOptionsTableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
            }
            if filterTitleTableView.indexPathForSelectedRow == [0,0] {
                if filterOptionsTableView.indexPathForSelectedRow == [0,0] {
                    eventProductFilters["collaborative"] = true
                }
            }
        }
        filterOptionsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
          if (tableView == filterOptionsTableView) {
              if let cell = filterOptionsTableView.cellForRow(at: indexPath) {
                  cell.accessoryType = .none
              }
          }
      }
    
    
}
