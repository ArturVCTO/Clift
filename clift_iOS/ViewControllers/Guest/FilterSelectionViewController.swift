//
//  FilterSelectionViewController.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 13/01/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

enum filterSreenShown {
    case filterMainCategory
    case filterByCategory
    case filterByPrice
    case filterByShop
}

protocol SideFilterSelectionDelegate {
    func didTapCleanFilters()
    func didTapCategoryFilter(categoryId: String)
    func didTapPriceFilter(priceQuery: String)
    func didTapShopFilter(shopId: String)
}

class FilterSelectionViewController: UIViewController {
    
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var filterCategoryStackView: UIStackView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var shopView: UIView!
    
    @IBOutlet weak var filterTableView: UITableView! {
        didSet {
            filterTableView.delegate = self
            filterTableView.dataSource = self
        }
    }
    @IBOutlet var filterTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var filterTableViewBottomConstraint: NSLayoutConstraint!
    
    var sideFilterSelectionDelegate: SideFilterSelectionDelegate!
    var categories: [Category]! = []
    var shops: [Shop] = []
    let prices: [String] = ["Menos de $1000","$1000 - $2500","$2500 - $4000","$4000 - $6500","$6500 - $8000","$8000 - $10000","Más de $10000"]
    let pricesDic: [Int:String] = [0:"price < 1000",1:"price >= 1000 AND price <= 2500",2:"price >= 2500 AND price <= 4000",3:"price >= 4000 AND price <= 6500",4:"price >= 6500 AND price <= 8000",5:"price >= 8000 AND price <= 10000",6:"price >= 10000"]
    var categorySelectedId = ""
    var priceSelectedId = ""
    var shopSelectedId = ""
    
    var filterMainCategoryFlag = true
    var filterScreenShown: filterSreenShown = .filterMainCategory

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getShops()
        getCategories()
        registerCells()
        SetUI()
    }
    
    private func registerCells() {
        filterTableView.register(UINib(nibName: "FilterSelectionCell", bundle: nil), forCellReuseIdentifier: "FilterSelectionCell")
    }
    
    func SetUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        categoryView.layer.cornerRadius = 15
        priceView.layer.cornerRadius = 15
        shopView.layer.cornerRadius = 15
        tableViewContainer.layer.cornerRadius = 15
        filterTableView.layer.cornerRadius = 15
        self.view.layer.cornerRadius = 15
    }
    

    func getCategories() {
        sharedApiManager.getCategories() { (categories, result) in
            if let response = result{
                if response.isSuccess() {
                    self.categories = categories
                }
            }
        }
    }
    
    func getShops() {
        let shopFilters = ["per_page":"all","simple_format":"true","sort_by":sortKeys.nameAscending.rawValue]
        sharedApiManager.getShops(filters: shopFilters) { (shops, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.shops = shops!
                    self.filterTableView.reloadData()
                }
            }
        }
    }
    
    func setTableViewHeight(numberOfRows: Int) {
        let maxHeight = Double(UIScreen.main.bounds.height) - 180
        let heightForNRows = Double(numberOfRows) * 40
        
        if heightForNRows >= maxHeight {
            filterTableViewHeightConstraint.isActive = false
            filterTableViewBottomConstraint.isActive = true
            //filterTableViewHeightConstraint.constant = CGFloat(maxHeight)
        } else {
            filterTableViewBottomConstraint.isActive = false
            filterTableViewHeightConstraint.isActive = true
            filterTableViewHeightConstraint.constant = CGFloat(heightForNRows)
        }
    }

    @IBAction func cleanFilterButtonTapped(_ sender: UIButton) {
        sideFilterSelectionDelegate.didTapCleanFilters()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func categoryButtonTapped(_ sender: Any) {
        filterScreenShown = .filterByCategory
        setTableViewHeight(numberOfRows: categories.count)
        updateScreen()
        categorySelected(item: categorySelectedId)
    }
    
    @IBAction func priceButtonTapped(_ sender: Any) {
        filterScreenShown = .filterByPrice
        setTableViewHeight(numberOfRows: prices.count)
        updateScreen()
        priceSelected(item: priceSelectedId)
    }
    
    @IBAction func shopButtonTapped(_ sender: Any) {
        filterScreenShown = .filterByShop
        setTableViewHeight(numberOfRows: shops.count)
        updateScreen()
        shopSelected(item: shopSelectedId)
    }
    
    @IBAction func returnToMainCategories(_ sender: Any) {
        filterScreenShown = .filterMainCategory
        updateScreen()
    }
    
    func categorySelected(item: String) {
        if let indexItem = categories.firstIndex(where: {$0.id == item}) {
            let indexPath = IndexPath(row: indexItem, section: 0)
            filterTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }
    
    func priceSelected(item: String) {

        let keys = pricesDic
        .filter { (k, v) -> Bool in v == item }
        .map { (k, v) -> Int in k }
        
        if let indexItem = keys.first {
            let indexPath = IndexPath(row: indexItem, section: 0)
            filterTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }
    
    func shopSelected(item: String) {
        if let indexItem = shops.firstIndex(where: {$0.id == item}) {
            let indexPath = IndexPath(row: indexItem, section: 0)
            filterTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }
    
    func updateScreen() {
        
        switch filterScreenShown {
        
        case .filterMainCategory:
            tableViewContainer.isHidden = true
            filterCategoryStackView.isHidden = false
        default:
            filterCategoryStackView.isHidden = true
            tableViewContainer.isHidden = false
            filterTableView.reloadData()
        }
    }
}

extension FilterSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection seleton: Int) -> Int {
        switch filterScreenShown {
        case .filterByCategory:
            return categories.count
        case .filterByPrice:
            return prices.count
        case .filterByShop:
            return shops.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = filterTableView.dequeueReusableCell(withIdentifier: "FilterSelectionCell", for: indexPath) as? FilterSelectionCell {
            
            switch filterScreenShown {
                case .filterByCategory:
                    cell.configure(title: categories[indexPath.row].name)
                case .filterByPrice:
                    cell.configure(title: prices[indexPath.row])
                case .filterByShop:
                    cell.configure(title: shops[indexPath.row].name)
                default:
                    break
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch filterScreenShown {
        case .filterByCategory:
            sideFilterSelectionDelegate.didTapCategoryFilter(categoryId: categories[indexPath.row].id)
            categorySelectedId = categories[indexPath.row].id
        case .filterByPrice:
            if let priceQuery = pricesDic[indexPath.row] {
                sideFilterSelectionDelegate.didTapPriceFilter(priceQuery: priceQuery)
                priceSelectedId = priceQuery
            }
        case .filterByShop:
            sideFilterSelectionDelegate.didTapShopFilter(shopId: shops[indexPath.row].id)
            shopSelectedId = shops[indexPath.row].id
        default:
            break
        }
    }
    
}
