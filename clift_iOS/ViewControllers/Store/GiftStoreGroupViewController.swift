//
//  GiftStoreGroupViewController.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 24/02/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

class GiftStoreGroupViewController: UIViewController {

    @IBOutlet var categoriesCollectionView: UICollectionView! {
        didSet {
            categoriesCollectionView.delegate = self
            categoriesCollectionView.dataSource = self
        }
    }
    
    var category = Category()
    var selectedGroupIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar()
        registerCells()
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
    
    private func registerCells() {
        categoriesCollectionView.register(UINib(nibName: "StoreCategoryAndGroupCell", bundle: nil), forCellWithReuseIdentifier: "StoreCategoryAndGroupCell")
    }
    
    func presentPickerAlert() {
        
        let alertView = UIAlertController(title: "Selecciona", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertController.Style.actionSheet);
        let pickerView = UIPickerView()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        alertView.view.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.leftAnchor.constraint(equalTo: alertView.view.leftAnchor, constant: 20.0).isActive = true
        pickerView.rightAnchor.constraint(equalTo: alertView.view.rightAnchor, constant: -20.0).isActive = true
        
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in self.presentProducts(subgroupIndex: pickerView.selectedRow(inComponent: 0))})
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alertView.addAction(action)
        present(alertView, animated: true, completion: nil)
    }
    
    func presentProducts(subgroupIndex: Int) {
        let giftStoreProductsVC = UIStoryboard(name: "GiftStore", bundle: nil).instantiateViewController(withIdentifier: "GiftStoreProductsVC") as! GiftStoreProductsViewController
        giftStoreProductsVC.modalPresentationStyle = .fullScreen
        giftStoreProductsVC.category = category
        giftStoreProductsVC.subgroupNameString = category.groups[selectedGroupIndex].subgroups[subgroupIndex].name
        giftStoreProductsVC.filtersDic["subgroup"] = category.groups[selectedGroupIndex].subgroups[subgroupIndex].id
        self.navigationController?.pushViewController(giftStoreProductsVC, animated: true)
    }
}

// MARK: Extension Collection View Delegate
extension GiftStoreGroupViewController: UICollectionViewDelegate {
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "StoreCategoryAndGroupCell", for: indexPath) as? StoreCategoryAndGroupCell {
            
            cell.cellWidth = (collectionView.bounds.width - 100) / 3.0
            cell.configure(title: category.groups[indexPath.row].name, imageURLString: category.groups[indexPath.row].imageUrl)
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if category.groups[indexPath.row].subgroups.isEmpty {
            let giftStoreProductsVC = UIStoryboard(name: "GiftStore", bundle: nil).instantiateViewController(withIdentifier: "GiftStoreProductsVC") as! GiftStoreProductsViewController
            giftStoreProductsVC.modalPresentationStyle = .fullScreen
            giftStoreProductsVC.category = category
            giftStoreProductsVC.filtersDic["group"] = category.groups[indexPath.row].id
            self.navigationController?.pushViewController(giftStoreProductsVC, animated: true)
        } else {
            selectedGroupIndex = indexPath.row
            presentPickerAlert()
        }
    }
}

// MARK: Extension Collection Data Source
extension GiftStoreGroupViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.groups.count
    }
}

// MARK: Extension Collection View Delegate Flow Layout
extension GiftStoreGroupViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let top = collectionView.bounds.height / 8
        let left = CGFloat(40)
        let bottom = CGFloat(10)
        let right = CGFloat(40)
        
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.bounds.width - 100) / 3.0
        let height = CGFloat(160)

        return CGSize(width: width, height: height)
    }
}

extension GiftStoreGroupViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category.groups[selectedGroupIndex].subgroups.count
    }
}

extension GiftStoreGroupViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category.groups[selectedGroupIndex].subgroups[row].name
    }
}
