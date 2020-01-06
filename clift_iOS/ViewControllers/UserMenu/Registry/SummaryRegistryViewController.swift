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
        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        self.loadEvent()
        self.summaryTableView.delegate = self
        self.summaryTableView.dataSource = self
        self.summaryTableView.rowHeight = UITableView.automaticDimension
        self.getRegistrySummary(event: self.currentEvent)
        self.summaryTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(true)
          self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 117/255, green: 126/255, blue: 106/255, alpha: 1.0)
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
