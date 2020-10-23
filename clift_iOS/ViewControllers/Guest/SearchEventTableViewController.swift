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
        
        self.searchEvent.showsCancelButton = false
        searchEvent.delegate = self
        self.searchEvent.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnClickOutside))
        view.addGestureRecognizer(tap)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func hideKeyboardOnClickOutside(){
        view.endEditing(true)
    }
    // MARK: - Table view data source

    @IBAction func BackButtonPressed(_ sender: UIBarButtonItem) {
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    @IBOutlet weak var searchEvent: UISearchBar!
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //print("END")
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //print("START")
    }
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
        // #warning Incomplete implementation, return the number of rows
        return currentEvents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! SearchEventCell
        

        // Configure the cell...
        cell.eventImage.image = UIImage(named: "logo")
        cell.parentVC = self
        
        cell.setUp(event: currentEvents[indexPath.row])

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
