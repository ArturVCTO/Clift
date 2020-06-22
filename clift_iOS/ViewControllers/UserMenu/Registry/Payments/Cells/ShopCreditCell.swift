//
//  ShopCreditCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 3/4/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit

class ShopCreditCell: UITableViewCell {
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var shopId = ""
    var eventId = ""
    var navigationController: UINavigationController?
    
    
    func configure(cell: ShopCredit) {
        let expirationDateAsDate = cell.expirationDate.fullStringToDate()
        
        self.shopNameLabel.text = cell.shop.name
        self.dateLabel.text = expirationDateAsDate.expirationDateFormatter()
        self.amountLabel.text = getPriceStringFormat(value: cell.balance)
    }
    
    func getPriceStringFormat(value: Double) -> String {
           let formatter = NumberFormatter()
           formatter.numberStyle = .currency
           
           return formatter.string(from: NSNumber(value: value))!
    }
    
    @IBAction func creditCardButtonTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
              let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "creditMovementsTableVC") as! CreditMovementTableViewController
            vc.shopId = shopId
            vc.eventId = eventId
            self.navigationController!.pushViewController(vc, animated: true)
                         
               } else {
                         // Fallback on earlier versions
              let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "creditMovementsTableVC") as! CreditMovementTableViewController
            vc.shopId = shopId
            vc.eventId = eventId
            self.navigationController!.pushViewController(vc, animated: true)
          }
    }
}
