//
//  AddressesTableViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/10/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit

class AddressesTableViewController: UITableViewController {
    var addresses: [Address] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAddresses()
    }
    
    func getAddresses() {
        sharedApiManager.getAddresses() { (addresses, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.addresses = addresses!
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func addAddressesButtonTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
           let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "addAddressVC") as! AddAddressViewController
           self.navigationController?.pushViewController(vc, animated: true)
        } else {
           let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addAddressVC") as! AddAddressViewController
           self.navigationController?.pushViewController(vc, animated: true)
       }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addresses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressTVCell", for: indexPath) as! AddressCell
        cell.setup(address: addresses[indexPath.row])
        return cell
    }
}

