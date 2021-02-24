//
//  GiftStoreCategoryViewController.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 23/02/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

class GiftStoreCategoryViewController: UIViewController {

    @IBOutlet var categoriesCollectionView: UICollectionView! {
        didSet {
            categoriesCollectionView.delegate = self
            categoriesCollectionView.dataSource = self
        }
    }
    
    var categories: [Category]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCategories()
        setNavBar()
        registerCells()
    }
    
    private func setNavBar() {
        
        let titleLabel = UILabel()
        titleLabel.text = "TIENDA"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Mihan-Regular", size: 16.0)!
        titleLabel.addCharactersSpacing(5)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func registerCells() {
        categoriesCollectionView.register(UINib(nibName: "StoreCategoryAndGroupCell", bundle: nil), forCellWithReuseIdentifier: "StoreCategoryAndGroupCell")
    }
}

// MARK: Extension Collection View Delegate
extension GiftStoreCategoryViewController: UICollectionViewDelegate {
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "StoreCategoryAndGroupCell", for: indexPath) as? StoreCategoryAndGroupCell {
            
            cell.configure(title: categories[indexPath.row].name, imageURLString: categories[indexPath.row].imageUrl)
            cell.cellWidth = (collectionView.frame.size.width - 25) / 4
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Indexpath es: \(indexPath.row)")
        /*if eventPools.count > indexPath.row {
            goToEnvelopeInformation(eventPool: eventPools[indexPath.row])
        } else {
            let productDetailsVC = UIStoryboard(name: "Guest", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsViewController
            productDetailsVC.currentEventProduct = eventRegistries[indexPath.row - eventPools.count]
            productDetailsVC.currentEvent = currentEvent
            productDetailsVC.productDetailType = eventRegistries[indexPath.row - eventPools.count].wishableType == "ExternalProduct" ? .EventExternalProduct : .EventProduct
            productDetailsVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(productDetailsVC, animated: true)
        }*/
    }
}

// MARK: Extension Collection Data Source
extension GiftStoreCategoryViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
}

// MARK: Extension REST APIs
extension GiftStoreCategoryViewController {
    
    func getCategories() {
        sharedApiManager.getCategories() { (categories, result) in
            self.presentLoader()
            if let response = result{
                if response.isSuccess() {
                    self.categories = categories
                    self.categoriesCollectionView.reloadData()
                }
                self.dismissLoader()
            }
        }
    }
}
