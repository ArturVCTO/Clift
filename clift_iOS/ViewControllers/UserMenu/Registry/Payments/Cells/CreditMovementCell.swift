//
//  CreditMovementCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 3/4/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit

class CreditMovementCell: UITableViewCell {
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var descriptionOrProductLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    func configure(cell: CreditMovement) {
        if cell.movementType == 0 {
            self.amountLabel.textColor = UIColor(named: "RedDanger")
        } else {
            self.amountLabel.textColor = UIColor(named: "SuccessGreen")
        }
        
        let createdAtDateAsDate = cell.createdAt.createdAtStringToDate()
        self.createdAtLabel.text = createdAtDateAsDate.expirationDateFormatter()
        self.amountLabel.text = getPriceStringFormat(value: cell.amount)
    }
    
    func getPriceStringFormat(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
              
        return formatter.string(from: NSNumber(value: value))!
    }
}
