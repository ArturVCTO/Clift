//
//  AddressCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/10/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit

class AddressCell: UITableViewCell {
    @IBOutlet weak var defaultAddressView: customView!
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    func setup(address: Address) {
        self.addressNameLabel.text = address.name
        self.addressLabel.text = "\(address.street1) \(address.city.name) \(address.state.name) \(address.country.name)"
    }
}
