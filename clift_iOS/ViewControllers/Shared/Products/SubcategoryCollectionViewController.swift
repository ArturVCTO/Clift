//
//  SubcategoryCollectionViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 9/12/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class SubcategoryCollectionViewController: UIViewController {
    
    var category = Category()
    var groups: [Group] = []
    
    @IBOutlet weak var groupsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupsCollectionView.delegate = self
        self.groupsCollectionView.dataSource = self
        self.getCategory(category: self.category)
    }
    
    func getCategory(category: Category) {
        sharedApiManager.getCategory(id: category.id) { (category, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.groups = category!.groups
                    self.groupsCollectionView.reloadData()
                }
            }
        }
    }
    
    @IBAction func checkoutButtonTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
          let vc = UIStoryboard.init(name: "Checkout", bundle: nil).instantiateViewController(identifier: "checkoutVC") as! CheckoutViewController
          self.navigationController?.pushViewController(vc, animated: true)
         } else {
          let vc = UIStoryboard.init(name: "Checkout", bundle: nil).instantiateViewController(withIdentifier: "checkoutVC") as! CheckoutViewController
          self.navigationController?.pushViewController(vc, animated: true)
         }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SubcategoryCollectionViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = groupsCollectionView.dequeueReusableCell(withReuseIdentifier: "groupsCell", for: indexPath) as! SubcategoryCollectionViewCell
        cell.setup(group: self.groups[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "productsViewController") as! ProductCollectionViewController
            vc.group = self.groups[indexPath.row]
            vc.category = self.category
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
          // Fallback on earlier versions
          let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "productsViewController") as! ProductCollectionViewController
            vc.group = self.groups[indexPath.row]
            vc.category = self.category
          self.navigationController?.pushViewController(vc, animated: true)
      }
    }
}
