//
//  FirstFilterCollectionViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 10/18/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift

class FirstFilterViewController: UIViewController {
	@IBOutlet weak var filterButton: UIButton!
	
	@IBOutlet weak var firstFilterProductsCollectionView: UICollectionView!
	var products: [Product] = []
	var brand = Brand()
	var shop = Shop()
	var group = Group()
	var subgroup = Subgroup()
	var currentEvent = Event()
	var filters = [String : Any]()
	@IBOutlet weak var productCountLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.loadCurrentEvent()
		self.getProducts(group: self.group,brand: self.brand, shop: self.shop,event: self.currentEvent)
		self.firstFilterProductsCollectionView.delegate = self
		self.firstFilterProductsCollectionView.dataSource = self
	}
	
	func loadCurrentEvent() {
		let realm = try! Realm()
		let realmEvents = realm.objects(Event.self)
		if let currentEvent = realmEvents.first {
			self.currentEvent = currentEvent
		}
	}
	
	func getProducts(group: Group, brand: Brand, shop: Shop,event: Event) {
		sharedApiManager.getProductsAsLoggedInUser(group: group, subgroup: self.subgroup,event:event,brand: brand, shop: shop, filters: [:], page: 1) { (products,result) in
			if let response = result{
				if (response.isSuccess()) {
					DispatchQueue.main.async {
						self.products = products!
						self.setupProductsCount(products: products!)
						self.firstFilterProductsCollectionView.reloadData()
					}
				}
			}
		}
	}
	
	func setupProductsCount(products: [Product]) {
		self.productCountLabel.text = "\(products.count) artículos"
	}
	
	@IBAction func backButtonTapped(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func filterButtonTapped(_ sender: Any) {
		if #available(iOS 13.0, *) {
			let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "filterProductVC") as! FilterProductViewController
			//vc.product = self.products[indexPath.row]
			vc.firstFilterParentVC = self
			
			self.navigationController?.pushViewController(vc, animated: true)
		} else {
			// Fallback on earlier versions
			let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "filterProductVC") as! FilterProductViewController
			//vc.product = self.products[indexPath.row]
			vc.firstFilterParentVC = self
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
	
}
extension  FirstFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.products.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		var cell = UICollectionViewCell()
		
		if collectionView == firstFilterProductsCollectionView {
			let cell = firstFilterProductsCollectionView.dequeueReusableCell(withReuseIdentifier: "filteredProductCell", for: indexPath) as! ProductCollectionViewCell
			cell.setup(product: self.products[indexPath.row])
			return cell
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if #available(iOS 13.0, *) {
			let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "productViewController") as! ProductViewController
			vc.product = self.products[indexPath.row]
			vc.firstFilterProductVC = self
			vc.brand = self.brand
			vc.shop = self.shop
			
			self.navigationController?.pushViewController(vc, animated: true)
		} else {
			// Fallback on earlier versions
			let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "productViewController") as! ProductViewController
			vc.product = self.products[indexPath.row]
			vc.firstFilterProductVC = self
			vc.brand = self.brand
			vc.shop = self.shop
			
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
	
}
