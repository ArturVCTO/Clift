//
//  SearchEventTableViewController.swift
//  clift_iOS
//
//  Created by Alejandro González on 16/08/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import UIKit
import RealmSwift
import GSMessages

class SearchEventTableViewController: UITableViewController, UISearchBarDelegate {
    
    var currentEvents: [Event] = []

    @IBOutlet var eventTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
        
        self.searchEvent.showsCancelButton = false
        searchEvent.delegate = self
        self.searchEvent.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnClickOutside))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func hideKeyboardOnClickOutside(){
        view.endEditing(true)
    }
	
    // MARK: - Table view data source
    @IBAction func BackButtonPressed(_ sender: UIBarButtonItem) {
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
	
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    @IBOutlet weak var searchEvent: UISearchBar!

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        
        let session = Session()
        session.token = ""
        let realm = try! Realm()
        
        let users = realm.objects(Session.self)
        
        if(users.isEmpty){
            print("EMPTY")
            try! realm.write {
                realm.add(session)
            }
            sharedApiManager.getGuestToken() {(session,result) in
                if let response = result{
                    if response.isSuccess(){
                        print("Session",session!.token)
                        try! realm.write {
                            realm.deleteAll()
                        }
                        try! realm.write {
                            realm.add(session!)
                        }
                        self.searchEvents(searchBar: searchBar)
                    }
                }
            }
        }else{
            print(users.first!.accountType)
            self.searchEvents(searchBar: searchBar)
        }
    }
    
    func searchEvents(searchBar: UISearchBar){
        view.endEditing(true)
        if let query = searchBar.text{
            sharedApiManager.getEventsSearch(query: query) { (events, result) in
                if let response = result{
                    if response.isSuccess() {
                        self.currentEvents = events!
                        if events!.count == 0 {
                            self.showMessage(NSLocalizedString("No se encontraron eventos", comment: "No se encontraron eventos"),type: .error)
                            self.eventTable.reloadData()
                        }else{
                            self.eventTable.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentEvents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! SearchEventCell

        cell.eventImage.image = UIImage(named: "logo")
        cell.setUp(event: currentEvents[indexPath.row], delegate: self, indexPath: indexPath)

        return cell
    }

}

extension SearchEventTableViewController: SearchEventCellDelegate {
	
	func didSelectEvent(at indexPath: IndexPath) {
		let eventGuestVC = UIStoryboard(name: "Guest", bundle: nil).instantiateViewController(withIdentifier: "EventGiftListVC") as! EventGiftListViewController
		eventGuestVC.currentEvent = currentEvents[indexPath.row]
		eventGuestVC.modalPresentationStyle = .fullScreen
		self.navigationController?.pushViewController(eventGuestVC, animated: true)
	}
}
