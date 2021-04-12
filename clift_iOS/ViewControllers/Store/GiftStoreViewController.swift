//
//  GiftStoreViewController.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 23/03/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

class GiftStoreViewController: UIViewController {

    @IBOutlet weak var storeSearchBar: UISearchBar!
    @IBOutlet weak var storeCollectionView: UICollectionView! {
        didSet {
            storeCollectionView.delegate = self
            storeCollectionView.dataSource = self
        }
    }
    @IBOutlet var dismissKeyboardTapGesture: UITapGestureRecognizer!
    
    var currentEvent = Event()
    var categories: [Category]! = []
    var shops: [Shop]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        getCurrentEvent()
        getCategories()
        getShops()
        registerCells()
        storeSearchBar.delegate = self
        setTapGesture()
    }
    
    private func registerCells() {
        storeCollectionView.register(UINib(nibName: "StoreCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "StoreCollectionReusableView")
        storeCollectionView.register(UINib(nibName: "StoreCategoryAndGroupCell", bundle: nil), forCellWithReuseIdentifier: "StoreCategoryAndGroupCell")
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
        
        let cartImage = UIImage(named: "cart")
        let cartButton   = UIBarButtonItem(image: cartImage,  style: .plain, target: self, action: #selector(didTapCartButton(sender:)))
        navigationItem.rightBarButtonItems = [cartButton]
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
    }
    
    @objc func didTapCartButton(sender: AnyObject){
        let vc = UIStoryboard.init(name: "Checkout", bundle: nil).instantiateViewController(withIdentifier: "checkoutVC") as! CheckoutViewController
        vc.paymentType = .userLogIn
        vc.currentEvent = currentEvent
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setTapGesture() {
        dismissKeyboardTapGesture.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardVisible(sender:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden(sender:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    @objc func keyboardVisible(sender: AnyObject) {
        dismissKeyboardTapGesture.isEnabled = true
    }

    @objc func keyboardHidden(sender: AnyObject) {
        dismissKeyboardTapGesture.isEnabled = false
    }
    
    @IBAction func didTapToDismissKeyboard(_ sender: UITapGestureRecognizer) {
        storeSearchBar.endEditing(true)
    }
}

// MARK: Extension StoreHeaderDelegate
extension GiftStoreViewController: StoreHeaderDelegate {
    func didTapSeeAllCategories() {
        let giftStoreProductsVC = UIStoryboard(name: "GiftStore", bundle: nil).instantiateViewController(withIdentifier: "GiftStoreCategoryVC") as! GiftStoreCategoryViewController
        giftStoreProductsVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(giftStoreProductsVC, animated: true)
    }
    
    func didTapSeeAllShops() {
        let giftStoreProductsVC = UIStoryboard(name: "GiftStore", bundle: nil).instantiateViewController(withIdentifier: "GiftStoreShopVC") as! GiftStoreShopViewController
        giftStoreProductsVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(giftStoreProductsVC, animated: true)
    }
}

// MARK: Extension Collection View Delegate
extension GiftStoreViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print(kind)
        print(UICollectionView.elementKindSectionHeader)
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "StoreCollectionReusableView", for: indexPath) as! StoreCollectionReusableView
            if indexPath.section == 0 {
                header.configure(title: "Categorías", headerType: .categoryHeader, delegate: self)
            } else {
                header.configure(title: "Tiendas", headerType: .shopHeader, delegate: self)
            }
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = storeCollectionView.dequeueReusableCell(withReuseIdentifier: "StoreCategoryAndGroupCell", for: indexPath) as? StoreCategoryAndGroupCell {
            
            cell.cellWidth = (collectionView.bounds.width - 100) / 3.0
            
            if indexPath.section == 0 {
                cell.configure(title: categories[indexPath.row].name, imageURLString: categories[indexPath.row].imageUrl)
            } else {
                cell.configure(title: shops[indexPath.row].name, imageURLString: shops[indexPath.row].imageURL)
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            if categories[indexPath.row].groups.isEmpty {
                let giftStoreProductsVC = UIStoryboard(name: "GiftStore", bundle: nil).instantiateViewController(withIdentifier: "GiftStoreProductsVC") as! GiftStoreProductsViewController
                giftStoreProductsVC.modalPresentationStyle = .fullScreen
                giftStoreProductsVC.navBarTitle = categories[indexPath.row].name
                giftStoreProductsVC.subgroupNameString = categories[indexPath.row].name
                giftStoreProductsVC.filtersDic["category"] = categories[indexPath.row].id
                self.navigationController?.pushViewController(giftStoreProductsVC, animated: true)
            } else {
                let giftStoreGroupsVC = UIStoryboard(name: "GiftStore", bundle: nil).instantiateViewController(withIdentifier: "GiftStoreGroupVC") as! GiftStoreGroupViewController
                giftStoreGroupsVC.category = categories[indexPath.row]
                giftStoreGroupsVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(giftStoreGroupsVC, animated: true)
            }
        } else {
            let giftStoreProductsVC = UIStoryboard(name: "GiftStore", bundle: nil).instantiateViewController(withIdentifier: "GiftStoreProductsVC") as! GiftStoreProductsViewController
            giftStoreProductsVC.modalPresentationStyle = .fullScreen
            giftStoreProductsVC.navBarTitle = shops[indexPath.row].name
            giftStoreProductsVC.subgroupNameString = shops[indexPath.row].name
            giftStoreProductsVC.filtersDic["shop"] = shops[indexPath.row].id
            self.navigationController?.pushViewController(giftStoreProductsVC, animated: true)
        }
    }
}

// MARK: Extension Collection Data Source
extension GiftStoreViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if categories.count > 6 {
                return 6
            } else {
                return categories.count
            }
        } else {
            if shops.count > 6 {
                return 6
            } else {
                return shops.count
            }
        }
    }
}

// MARK: Extension Collection View Delegate Flow Layout
extension GiftStoreViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let top = CGFloat(10)
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

// MARK: Extension UISearchBarDelegate 
extension GiftStoreViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text == "" {
            
            searchBar.endEditing(true)
            self.children.forEach {
                $0.willMove(toParent: nil)
                $0.view.removeFromSuperview()
                $0.removeFromParent()
            }
        } else {
            
            searchBar.endEditing(true)
            
            let giftStoreProductsVC = UIStoryboard(name: "GiftStore", bundle: nil).instantiateViewController(withIdentifier: "GiftStoreProductsVC") as! GiftStoreProductsViewController
            
            giftStoreProductsVC.fromSearch = true

            // Send query to GiftStoreProductsViewController
            if let query = searchBar.text {
                giftStoreProductsVC.queryFromStoreVC = query
            }
            
            // Add as a childviewcontroller
            addChild(giftStoreProductsVC)

            // Add the child's View as a subview
            self.view.addSubview(giftStoreProductsVC.view)
            giftStoreProductsVC.view.frame = view.bounds
            giftStoreProductsVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            // Tell the childviewcontroller it's contained in it's parent
            giftStoreProductsVC.didMove(toParent: self)
            
            // Set up of child view controller position and size
            giftStoreProductsVC.view.frame = CGRect(x: 0, y: storeCollectionView.frame.origin.y, width: self.view.frame.size.width, height: storeCollectionView.frame.height)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let text = searchBar.text {
            if text == "" {
                searchBar.endEditing(true)
                self.children.forEach {
                    $0.willMove(toParent: nil)
                    $0.view.removeFromSuperview()
                    $0.removeFromParent()
                }
            }
        }
    }
}

// MARK: Extension REST APIs
extension GiftStoreViewController {
    
    func getCurrentEvent() {
        sharedApiManager.getEvents() { (events, result) in
            if let response = result {
                if (response.isSuccess()) {
                    if let currentEvent = events?.first {
                        self.currentEvent = currentEvent
                    }
                }
            }
        }
    }
    
    func getCategories() {
        sharedApiManager.getCategories() { [self] (categories, result) in
            if let response = result{
                if response.isSuccess() {
                    self.categories = categories
                    let indexSet = IndexSet(integer: 0)
                    self.storeCollectionView.reloadSections(indexSet)
                }
            }
        }
    }
    
    func getShops() {
        let shopFilters = ["per_page":"all","simple_format":"true","sort_by":sortKeys.nameAscending.rawValue]
        sharedApiManager.getShops(filters: shopFilters) { (shops, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.shops = shops
                    let indexSet = IndexSet(integer: 1)
                    self.storeCollectionView.reloadSections(indexSet)
                }
            }
        }
    }
}
