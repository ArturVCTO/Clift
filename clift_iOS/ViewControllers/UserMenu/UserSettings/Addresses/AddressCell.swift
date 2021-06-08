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
        if address.isDefault {
            self.defaultAddressView.isHidden = false
        } else {
            self.defaultAddressView.isHidden = true
        }
        self.addressNameLabel.text = "\(address.firstName ?? "") \(address.lastName ?? "")"
        self.addressLabel.text = "\(address.streetAndNumber ?? "") \(address.city.name ?? "") \(address.state.name ?? "") \(address.country.name ?? "") \(address.zipCode ?? "")"
    }
}
