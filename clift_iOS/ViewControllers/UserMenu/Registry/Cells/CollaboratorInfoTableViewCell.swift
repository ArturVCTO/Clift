 //
//  CollaboratorInfoTableViewCell.swift
//  clift_iOS
//
//  Created by Lizzie Guajardo on 24/08/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import UIKit

class CollaboratorInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var collaboratorNameLabel: UILabel!
    @IBOutlet weak var collaboratorEmailLabel: UILabel!
    @IBOutlet weak var collaboratorTelephoneLabel: UILabel!
    @IBOutlet weak var collaboratorAmountLabel: UILabel!
    @IBOutlet weak var collaboratorQuantityLabel: UILabel!
    @IBOutlet weak var collaboratorThankMessageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(user: ThankYouUser, order: OrderItem){

        collaboratorQuantityLabel.text = "Cantidad: \(String(order.quantity))"
        collaboratorNameLabel.text = user.name! + " " + user.lastName!
        collaboratorEmailLabel.text = user.email
        collaboratorTelephoneLabel.text = user.phone
        
        let string = self.getPriceStringFormat(value: Double(order.amount)!)
        let substring = string.suffix(string.count-1)
        self.collaboratorAmountLabel.text = "\u{24}\(substring) MXN"
        
        collaboratorThankMessageLabel.text = "\u{22}\(user.note!)\u{22}"
            
    }
    
    func getPriceStringFormat(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
             
        return formatter.string(from: NSNumber(value: value))!
    }

}
