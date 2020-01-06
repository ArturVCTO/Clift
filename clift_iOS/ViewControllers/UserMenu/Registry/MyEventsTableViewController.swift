//
//  MyEventsViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/28/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift

protocol CurrentEventDelegate: class {
//    var currentEvent: Event { get set }
    func getCurrentEvent(event: Event)
}

class MyEventsTableViewController: UITableViewController {
    
    var events = [Event]()
    var mainRegistryVC: MainRegistryViewController!
    weak var currentEventDelegate: CurrentEventDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getEvents()
    }
    
    func getEvents() {
        sharedApiManager.getEvents() { (events, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.events = events!
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! MyEventsCell
        cell.setup(event: events[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentEventDelegate?.getCurrentEvent(event: self.events[indexPath.row])
        let realm = try! Realm()
        let realmEvents = realm.objects(Event.self)
        if let event = realmEvents.first {
            try! realm.write {
                event.id = self.events[indexPath.row].id
            }
        }
        mainRegistryVC.showEvent(id: self.events[indexPath.row].id)
        dismiss(animated: true, completion: nil)
    }
}
