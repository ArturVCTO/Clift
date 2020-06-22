//
//  CreditMovementTableViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 3/4/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit

class CreditMovementTableViewController: UITableViewController {
    var shopId = ""
    var eventId = ""
    var creditMovements: [CreditMovement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCreditMovements()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getCreditMovements() {
        sharedApiManager.getCreditMovements(event: eventId, shop: shopId) { (creditMovements, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.creditMovements = creditMovements!
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditMovements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "creditMovementCell", for: indexPath) as! CreditMovementCell
        cell.configure(cell: creditMovements[indexPath.row])
        
        return cell
    }
}
