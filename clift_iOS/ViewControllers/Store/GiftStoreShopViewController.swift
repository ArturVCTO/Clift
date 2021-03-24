//
//  GiftStoreShopViewController.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 23/03/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

class GiftStoreShopViewController: UIViewController {

    @IBOutlet var shopsCollectionView: UICollectionView! {
        didSet {
            shopsCollectionView.delegate = self
            shopsCollectionView.dataSource = self
        }
    }
    
    var shops: [Shop]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getShops()
        setNavBar()
        registerCells()
    }
    
    private func setNavBar() {
        
        let titleLabel = UILabel()
        titleLabel.text = "TIENDAS"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Mihan-Regular", size: 16.0)!
        titleLabel.addCharactersSpacing(5)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func registerCells() {
        shopsCollectionView.register(UINib(nibName: "StoreCategoryAndGroupCell", bundle: nil), forCellWithReuseIdentifier: "StoreCategoryAndGroupCell")
    }
}

// MARK: Extension Collection View Delegate
extension GiftStoreShopViewController: UICollectionViewDelegate {
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = shopsCollectionView.dequeueReusableCell(withReuseIdentifier: "StoreCategoryAndGroupCell", for: indexPath) as? StoreCategoryAndGroupCell {
            
            cell.cellWidth = (collectionView.bounds.width - 100) / 3.0
            cell.configure(title: shops[indexPath.row].name, imageURLString: shops[indexPath.row].imageURL)
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let giftStoreProductsVC = UIStoryboard(name: "GiftStore", bundle: nil).instantiateViewController(withIdentifier: "GiftStoreProductsVC") as! GiftStoreProductsViewController
        giftStoreProductsVC.modalPresentationStyle = .fullScreen
        giftStoreProductsVC.navBarTitle = shops[indexPath.row].name
        giftStoreProductsVC.filtersDic["shop"] = shops[indexPath.row].id
        self.navigationController?.pushViewController(giftStoreProductsVC, animated: true)
    }
}

// MARK: Extension Collection Data Source
extension GiftStoreShopViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shops.count
    }
}

// MARK: Extension Collection View Delegate Flow Layout
extension GiftStoreShopViewController: UICollectionViewDelegateFlowLayout {
    
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
extension GiftStoreShopViewController {
    
    func getShops() {
        let shopFilters = ["per_page":"all","simple_format":"true","sort_by":sortKeys.nameAscending.rawValue]
        sharedApiManager.getShops(filters: shopFilters) { (shops, result) in
            self.presentLoader()
            if let response = result {
                if (response.isSuccess()) {
                    self.shops = shops
                    self.shopsCollectionView.reloadData()
                }
                self.dismissLoader()
            }
        }
    }
}
