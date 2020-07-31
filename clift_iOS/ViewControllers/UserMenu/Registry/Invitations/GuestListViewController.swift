//
//  GuestListViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 11/20/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import DropDown
import RealmSwift
import Realm
import Contacts
import ContactsUI

class GuestListViewController: UIViewController, CNContactPickerDelegate,UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String,
                                    name: EventGuest? = nil) {
      filteredGuests = eventGuests.filter { (eventGuest: EventGuest) -> Bool in
        return eventGuest.name.lowercased().contains(searchText.lowercased())
      }
      
      guestTableView.reloadData()
    }
    var eventInformation = Event()
    var filteredGuests: [EventGuest] = []
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var searchBar: UISearchBar!
    var eventGuests: [EventGuest] = []
    var currentEvent = Event()
    var currentFilters = [String : Any]()
    @IBOutlet weak var guestStatusSegmentControl: UISegmentedControl!
    @IBOutlet weak var guestTableView: UITableView!
    @IBOutlet weak var sentInvitationGuestStatusSegment: UISegmentedControl!
    @IBOutlet weak var barView1: UIView!
    @IBOutlet weak var barView2: UIView!
    @IBOutlet weak var searchAndFilterView: UIView!
    @IBOutlet weak var totalGuestCountLabel: UILabel!
    var invitationsVC: InvitationsViewController!
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.guestTableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.searchBarStyle = .minimal
        searchController.searchResultsUpdater = self
        // 2
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
      
       
        // 4
        // 5
        definesPresentationContext = true
        self.guestTableView.delegate = self
        self.guestTableView.dataSource = self
        self.styleSegmentControl()
        self.loadEvent()
        self.getGuests(event: self.currentEvent,filters: [:])
        self.initialLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }
    
      func styleSegmentControl() {
            self.guestStatusSegmentControl.backgroundColor = .white
            self.guestStatusSegmentControl.tintColor = .white
            self.guestStatusSegmentControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "OpenSans-Regular",size: 15)!,NSAttributedString
                .Key.foregroundColor: UIColor(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0)], for: .normal)
            self.guestStatusSegmentControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "OpenSans-Regular", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 177/255, green: 211/255, blue: 246/255, alpha: 1.0)], for: .selected)
        }
    
    func initialLayout() {
        searchAndFilterView.isHidden = false
        sentInvitationGuestStatusSegment.isHidden = true
    }
    
    func getGuests(event: Event,filters: [String : Any]) {
        sharedApiManager.getGuests(event: event,filters: filters) {(guests, result) in
            if let response = result {
                if response.isSuccess() {
                    self.eventGuests = guests!
                    self.totalGuestCountLabel.text = "\(guests!.count) invitados"
                    self.guestTableView.reloadData()
                }
            }
        }
    }
    
    func loadEvent() {
          let realm = try! Realm()
          let realmEvents = realm.objects(Event.self)
          if let currentEvent = realmEvents.first {
              self.currentEvent = currentEvent
          }
      }
    
    @IBAction func addGuestsButtonTapped(_ sender: Any) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let addManually = UIAlertAction(title: "Agregar manualmente", style: .default,handler: importFromGmailButtonPressed(alert:))
        let addFromPhoneBook = UIAlertAction(title: "Agregar de tus contactos de tu telefono", style: .default,handler: phoneBookButtonPressed(alert:))
         let cancelAction = UIAlertAction(title: "CANCELAR", style: .cancel)
         
        addManually.setValue(UIColor.init(displayP3Red: 49/255, green: 48/255, blue: 60/255, alpha: 1.0), forKey: "titleTextColor")
        
          addFromPhoneBook.setValue(UIColor.init(displayP3Red: 49/255, green: 48/255, blue: 60/255, alpha: 1.0), forKey: "titleTextColor")
        
        
          cancelAction.setValue(UIColor.init(displayP3Red: 177/255, green: 211/255, blue: 246/255, alpha: 1.0), forKey: "titleTextColor")
         sheet.addAction(addManually)
         sheet.addAction(addFromPhoneBook)
         sheet.addAction(cancelAction)
         
         present(sheet, animated: true, completion: nil)
    }
    
    func phoneBookButtonPressed(alert: UIAlertAction) {
          let contactPicker = CNContactPickerViewController()
           contactPicker.delegate = self
           present(contactPicker,animated: true, completion: nil)
    }
    
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        var guests: [EventGuest] = []
        for contact in contacts {
            let guest = EventGuest()
            guest.name = "\(contact.givenName) \(contact.familyName)"
            
            if let phoneBookEmailAddress = contact.emailAddresses.first {
                guest.email = phoneBookEmailAddress.value as String
            }
            
            if let phoneBookNumber = contact.phoneNumbers.first {
                guest.cellPhoneNumber = phoneBookNumber.value.stringValue
            }
            guest.eventId = self.eventInformation.id
            if let creator = self.eventInformation.creator {
                guest.userId = creator.id
            }
            guests.append(guest)
            
            
        }
        
        sharedApiManager.addGuests(event: self.eventInformation, guest: guests) { (emptyObject,result) in
            if let response = result {
                if response.isSuccess() {
                    if #available(iOS 13.0, *) {
                                    
                                self.showMessage(NSLocalizedString("Se han agregado tus invitados", comment: ""),type: .success)
                        self.getGuests(event: self.eventInformation, filters: self.currentFilters)
                                } else {
                                  // Fallback on earlier versions
                                  self.getGuests(event: self.eventInformation, filters: self.currentFilters)
                                    
                                self.showMessage(NSLocalizedString("Se han agregado tus invitados", comment: ""),type: .success)
                              }
                } else {
                    self.showMessage(NSLocalizedString("\(emptyObject!.errors.first!)", comment: ""),type: .error)
                }
            }
        }
    }
    
    
    func importFromGmailButtonPressed(alert: UIAlertAction) {
           if #available(iOS 13.0, *) {
                      let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "addGuestsVC") as! AddGuestsViewController
            vc.currentEvent = self.currentEvent
                     self.navigationController?.pushViewController(vc, animated: true)
                  } else {
                    // Fallback on earlier versions
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addGuestsVC") as! AddGuestsViewController
            vc.currentEvent = self.currentEvent
                    self.navigationController?.pushViewController(vc, animated: true)
                }
       }
    
    @IBAction func guestStatusSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.currentFilters.removeAll()
            searchAndFilterView.isHidden = false
            sentInvitationGuestStatusSegment.isHidden = true
            self.barView1.backgroundColor = UIColor(red: 177/255, green: 211/255, blue: 246/255, alpha: 1.0)
            self.barView2.backgroundColor = UIColor(red: 123/255, green: 123/255,blue: 130/255, alpha: 0.16)
            
            self.getGuests(event: self.currentEvent, filters: currentFilters)
        }
        else if sender.selectedSegmentIndex == 1 {
            searchAndFilterView.isHidden = false
            sentInvitationGuestStatusSegment.isHidden = false
            self.barView2.backgroundColor = UIColor(red: 177/255, green: 211/255, blue: 246/255, alpha: 1.0)
            self.barView1.backgroundColor = UIColor(red: 123/255, green: 123/255,blue: 130/255, alpha: 0.16)
            
            if sentInvitationGuestStatusSegment.selectedSegmentIndex == 0 {
                self.currentFilters["is_confirmed"] = [3]
                self.getGuests(event: self.currentEvent, filters: self.currentFilters)
                self.currentFilters.removeAll()
            } else if sentInvitationGuestStatusSegment.selectedSegmentIndex == 1 {
                self.currentFilters["is_confirmed"] = [1]
                self.getGuests(event: self.currentEvent, filters: self.currentFilters)
                self.currentFilters.removeAll()
            } else  if sentInvitationGuestStatusSegment.selectedSegmentIndex == 2 {
                self.currentFilters["is_confirmed"] = [2]
                self.getGuests(event: self.currentEvent, filters: self.currentFilters)
                self.currentFilters.removeAll()
            }
        }
    }
    
    @IBAction func backbuttonTapped(_ sender: Any) {
        self.invitationsVC.getEvents()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func assistSegmentControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
                    self.currentFilters.removeAll()
                    self.currentFilters["is_confirmed"] = [3]
                    self.getGuests(event: self.currentEvent, filters: self.currentFilters)
                   } else if sender.selectedSegmentIndex == 1 {
                    self.currentFilters.removeAll()
                    self.currentFilters["is_confirmed"] = [1]
                    self.getGuests(event: self.currentEvent, filters: self.currentFilters)
                   } else  if sender.selectedSegmentIndex == 2 {
                        self.currentFilters.removeAll()
                        self.currentFilters["is_confirmed"] = [2]
                        self.getGuests(event: self.currentEvent, filters: self.currentFilters)
                   }
    }
    
}
extension GuestListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredGuests.count
        }
        return self.eventGuests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "guestListTVCell", for: indexPath) as! GuestListTableViewCell
        cell.currentEvent = self.currentEvent
        cell.currentFilters = self.currentFilters
        cell.vc = self
        cell.guestListAssitingStatusImageView?.image = nil
        cell.guestListAssitingStatusStackView.isHidden = false
        cell.indexCell = indexPath
        if isFiltering {
            cell.setup(eventGuest: self.filteredGuests[indexPath.row])
            cell.setupMenuDropDown()
        } else {
            cell.setup(eventGuest: self.eventGuests[indexPath.row])
            cell.setupMenuDropDown()
        }
        return cell
    }
    
    
}
