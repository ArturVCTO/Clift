//
//  TableViewCell.swift
//  clift_iOS
//
//  Created by Alejandro González on 18/08/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import UIKit

protocol SearchEventCellDelegate: class {
	func didSelectEvent(at indexPath: IndexPath)
}

class SearchEventCell: UITableViewCell {
    
    @IBOutlet weak var eventImage: customImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
	weak var delegate: SearchEventCellDelegate?
	private var indexPath: IndexPath?

	func setUp(event: Event, delegate: SearchEventCellDelegate, indexPath: IndexPath){
		self.delegate = delegate
		self.indexPath = indexPath
		
        self.eventNameLabel.text = event.name
        if let imageURL = URL(string:"\(event.eventImageUrl)") {
            self.eventImage.kf.setImage(with: imageURL,placeholder: UIImage(named: "cliftplaceholder"))
        }
    }
	
    @IBAction func showEventGuest(_ sender: UIButton) {
		guard let indexPath = indexPath else {
			return
		}
		delegate?.didSelectEvent(at: indexPath)
    }
}
