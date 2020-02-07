//
//  SummaryGiftsViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/24/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit

class SummaryGiftsViewController: UIViewController,UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String,
                                    name: EventProduct? = nil) {
      filteredProducts = eventProducts.filter { (eventProduct: EventProduct) -> Bool in
        return eventProduct.name.lowercased().contains(searchText.lowercased())
      }
      
      giftsTableView.reloadData()
    }
    
    @IBOutlet weak var thankedGiftsSegment: UISegmentedControl!
    @IBOutlet weak var barView1: UIView!
    @IBOutlet weak var barView2: UIView!
    @IBOutlet weak var giftsTableView: UITableView!
    var filteredProducts: [EventProduct] = []
    let searchController = UISearchController(searchResultsController: nil)
    var eventProducts: [EventProduct] = []
    var event: Event?
    @IBOutlet weak var searchHeaderView: UIView!
    
    var isSearchBarEmpty: Bool {
         return searchController.searchBar.text?.isEmpty ?? true
       }
       
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.giftsTableView.tableHeaderView = self.searchController.searchBar
           self.searchController.searchBar.sizeToFit()
           self.searchController.searchBar.searchBarStyle = .minimal
           searchController.searchResultsUpdater = self
           searchController.hidesNavigationBarDuringPresentation = true
           searchController.obscuresBackgroundDuringPresentation = false
     
           definesPresentationContext = true
        self.loadGiftedNotThanked()
        self.giftsTableView.delegate = self
        self.giftsTableView.dataSource = self
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadGiftedNotThanked() {
        sharedApiManager.getGiftThanksSummary(event: self.event!, hasBeenThanked: false, hasBeenPaid: true) {(eventProducts, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.eventProducts = eventProducts!
                    self.giftsTableView.reloadData()
                }
            }
        }
    }
    
    func loadGiftedAndThanked() {
        sharedApiManager.getGiftThanksSummary(event: self.event!, hasBeenThanked: true, hasBeenPaid: true) {(eventProducts, result) in
           if let response = result {
               if (response.isSuccess()) {
                   self.eventProducts = eventProducts!
                   self.giftsTableView.reloadData()
               }
           }
       }
    }
    
    @IBAction func thankedSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.loadGiftedNotThanked()
            self.barView1.backgroundColor = UIColor(red: 177/255, green: 211/255, blue: 246/255, alpha: 1.0)
            self.barView2.backgroundColor = UIColor(red: 123/255, green: 123/255,blue: 130/255, alpha: 0.16)
        } else {
            self.loadGiftedNotThanked()
            self.barView2.backgroundColor = UIColor(red: 177/255, green: 211/255, blue: 246/255, alpha: 1.0)
            self.barView1.backgroundColor = UIColor(red: 123/255, green: 123/255,blue: 130/255, alpha: 0.16)
        }
    }
}
extension SummaryGiftsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventProducts.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (thankedGiftsSegment.selectedSegmentIndex == 0) {
            if #available(iOS 13.0, *) {
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "thankGuestVC") as! ThankGuestViewController
                vc.summaryGiftsVC = self
                vc.event = self.event
                vc.gift = eventProducts[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "thankGuestVC") as! ThankGuestViewController
                vc.summaryGiftsVC = self
                vc.event = self.event
                vc.gift = eventProducts[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            self.showMessage("No puedes seleccionar un regalo ya agradecido.", type: .error)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = giftsTableView.dequeueReusableCell(withIdentifier: "giftSummaryCell", for: indexPath) as! GiftSummaryCell
        cell.configure(with: eventProducts[indexPath.row])
        return cell
    }
}
