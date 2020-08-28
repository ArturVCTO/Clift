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
    @IBOutlet weak var thankButton: customButton!
    @IBOutlet weak var collaboratorThankMessageLabel: UILabel!
    
    public var parentVC: CollaboratorsViewController!
    var thankedUser: ThankYouUser!
    var currentOrder: OrderItem!
    var currentEvent: Event!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(user: ThankYouUser, order: OrderItem){
        
        self.currentOrder = order
        
        collaboratorQuantityLabel.text = "Cantidad: \(String(order.quantity))"
        collaboratorNameLabel.text = user.name! + " " + user.lastName!
        collaboratorEmailLabel.text = user.email
        collaboratorTelephoneLabel.text = user.phone
        
        self.thankedUser = user
        
        let string = self.getPriceStringFormat(value: Double(order.amount)!)
        let substring = string.suffix(string.count-1)
        self.collaboratorAmountLabel.text = "\u{24}\(substring) MXN"
        
        collaboratorThankMessageLabel.text = "\u{22}\(user.note!)\u{22}"
        if(order.hasBeenThanked){
            self.thankButton.setImage(UIImage(named: "icthankgreen.png"), for: .normal)
            self.thankButton.imageEdgeInsets = UIEdgeInsets(top: 35, left: 35, bottom: 40, right: 40)
            self.thankButton.borderWidth = CGFloat(0)
            self.thankButton.isEnabled = false
        }
        else{
            self.thankButton.setImage(UIImage(named: "icthankblack.png"), for: .normal)
            self.thankButton.borderWidth = CGFloat(2)
            self.thankButton.isEnabled = true
        }
    }
    @IBAction func thankButtonTapped(_ sender: Any) {
        
        let thankCollaboratorVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "thankCollaboratorVC") as!
         ThankCollaboratorViewController
        
        thankCollaboratorVC.thankedUser = self.thankedUser
        thankCollaboratorVC.event = self.currentEvent
        thankCollaboratorVC.orderItem = self.currentOrder
        thankCollaboratorVC.collabVC = parentVC
        self.parentVC.parent?.addChild(thankCollaboratorVC)
        thankCollaboratorVC.view.frame = self.parentVC.view.frame
        self.parentVC.parent?.view.addSubview(thankCollaboratorVC.view)
        thankCollaboratorVC.didMove(toParent: self.parentVC.parent)
    }
    
    func getPriceStringFormat(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
             
        return formatter.string(from: NSNumber(value: value))!
    }

}
