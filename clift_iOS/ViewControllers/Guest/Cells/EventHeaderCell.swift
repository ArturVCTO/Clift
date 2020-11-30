//
//  EventHeaderCell.swift
//  clift_iOS
//
//  Created by Juan Pablo Ramos on 29/11/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import UIKit

class EventHeaderCell: UITableViewCell {
	
	@IBOutlet weak var backgroundImageView: customImageView!
	@IBOutlet weak var eventImageView: customImageView!
	@IBOutlet weak var eventNameLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var typeLabel: UILabel!
	
	private func configureUI() {
		eventImageView.layer.cornerRadius = eventImageView.frame.height / 2
		eventImageView.layer.borderWidth = 0.5
		eventImageView.layer.borderColor = UIColor.black.cgColor
	}
	
	func setup(event: Event) {
		configureUI()
		
		if let coverURL = URL(string: event.coverImageUrl) {
			backgroundImageView.kf.setImage(with: coverURL, placeholder: UIImage(named: "cliftplaceholder"))
		}
		
		if let eventURL = URL(string: event.eventImageUrl) {
			eventImageView.kf.setImage(with: eventURL, placeholder: UIImage(named: "profilePlaceHolder"))
		}
		
		eventNameLabel.text = event.name
		dateLabel.text = event.date
	}
}
