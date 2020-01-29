//
//  SummaryRegistryViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 11/4/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift
import GSMessages

class SummaryRegistryViewController: UIViewController {
    
    var categories = [EventRegistrySummary]()
    @IBOutlet weak var summaryTableView: UITableView!
    var currentEvent = Event()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadEvent()
        self.summaryTableView.delegate = self
        self.summaryTableView.dataSource = self
        self.summaryTableView.rowHeight = UITableView.automaticDimension
        self.getRegistrySummary(event: self.currentEvent)
        self.summaryTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(true)
    }
    
    func loadEvent() {
           let realm = try! Realm()
           let realmEvents = realm.objects(Event.self)
           if let currentEvent = realmEvents.first {
               self.currentEvent = currentEvent
           }
       }
    
    func getRegistrySummary(event: Event) {
        sharedApiManager.getEventSummary(event: event) { (categories, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.categories = categories!
                    self.summaryTableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToSummaryGiftsTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "summaryGiftsVC") as! SummaryGiftsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "summaryGiftsVC") as! SummaryGiftsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SummaryRegistryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "summaryRegistryCell", for: indexPath) as! SummaryRegistryTableViewCell
        cell.setup(category: self.categories[indexPath.row])
        return cell
    }
    
    
    
}
