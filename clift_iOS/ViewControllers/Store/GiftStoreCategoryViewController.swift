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
        titleLabel.text = "CATEGORÍAS"
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
            
            cell.cellWidth = (collectionView.bounds.width - 100) / 3.0
            cell.configure(title: categories[indexPath.row].name, imageURLString: categories[indexPath.row].imageUrl)
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if categories[indexPath.row].groups.isEmpty {
            let giftStoreProductsVC = UIStoryboard(name: "GiftStore", bundle: nil).instantiateViewController(withIdentifier: "GiftStoreProductsVC") as! GiftStoreProductsViewController
            giftStoreProductsVC.modalPresentationStyle = .fullScreen
            giftStoreProductsVC.navBarTitle = categories[indexPath.row].name
            giftStoreProductsVC.filtersDic["category"] = categories[indexPath.row].id
            self.navigationController?.pushViewController(giftStoreProductsVC, animated: true)
        } else {
            let giftStoreGroupsVC = UIStoryboard(name: "GiftStore", bundle: nil).instantiateViewController(withIdentifier: "GiftStoreGroupVC") as! GiftStoreGroupViewController
            giftStoreGroupsVC.category = categories[indexPath.row]
            giftStoreGroupsVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(giftStoreGroupsVC, animated: true)
        }
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

// MARK: Extension Collection View Delegate Flow Layout
extension GiftStoreCategoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let top = collectionView.bounds.height / 8
        let left = CGFloat(40)
        let bottom = CGFloat(10)
        let right = CGFloat(40)
        
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.bounds.width - 100) / 3.0
        let height = CGFloat(150)

        return CGSize(width: width, height: height)
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
