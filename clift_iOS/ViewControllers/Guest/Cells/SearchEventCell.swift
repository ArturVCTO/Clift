//
//  TableViewCell.swift
//  clift_iOS
//
//  Created by Alejandro González on 18/08/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import UIKit

class SearchEventCell: UITableViewCell {

    var currentEvent = Event()
    var parentVC : SearchEventTableViewController!
    
    @IBOutlet weak var eventImage: customImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUp(event: Event){
        self.currentEvent = event
        self.eventNameLabel.text = event.name
        
        if let imageURL = URL(string:"\(event.eventImageUrl)") {
            self.eventImage.kf.setImage(with: imageURL,placeholder: UIImage(named: "cliftplaceholder"))
        }
    }
    @IBAction func showEventGuest(_ sender: UIButton) {
        let eventGuest = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "guestViewController") as! GuestGiftListViewController
        
        eventGuest.currentEvent  = self.currentEvent
        
        eventGuest.modalPresentationStyle = .fullScreen
        self.parentVC.navigationController?.pushViewController(eventGuest, animated: true)
        //self.parentVC.present(eventGuest, animated: true, completion: nil)
        
    }
}
