//
//  CustomPaymentAmountPreviewCell.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 26/06/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

class CustomPaymentAmountPreviewCell: UITableViewCell {

    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(subtotalAmount: Double?, totalAmount: Double) {
        if let subtotalAmount = subtotalAmount {
            subtotalLabel.text = "Subtotal: " + String(subtotalAmount) + " MXN"
        }
        totalLabel.text = "Total: " + String(totalAmount) + " MXN"
    }
}
