//
//  EventPoolCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 11/8/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class EventPoolCell: UICollectionViewCell {
    
    @IBOutlet weak var eventPoolImageView: customImageView!
    @IBOutlet weak var isGiftedLabel: UILabel!
    @IBOutlet weak var giftGreenCheckMarkImageView: UIImageView!
    @IBOutlet weak var isPriorityImageView: customView!
    @IBOutlet weak var poolNameLabel: UILabel!
    @IBOutlet weak var poolPriceLabel: UILabel!
    @IBOutlet weak var progressView: customProgressView!
    @IBOutlet weak var contributionsLabel: UILabel!
    
    
    func setup(eventPool: EventPool) {
        self.poolNameLabel.text = eventPool.name
        self.poolPriceLabel.text = "\(self.getPriceStringFormat(value: Double(eventPool.amount)))"
        if let imageURL = URL(string:"\(eventPool.imageUrl)") {
            self.eventPoolImageView.kf.setImage(with: imageURL)
        }
        
        
        self.isGiftedLabel.text = "Disponible"
        self.giftGreenCheckMarkImageView.isHidden = true
        
        if (eventPool.isImportant == true) {
            isPriorityImageView.isHidden = false
        } else {
            isPriorityImageView.isHidden = true
        }
    }
    
    func isGifted(price: String,paidAmount: String) -> Bool {
       var bool = Bool()
        
        if paidAmount == price {
            bool = true
        } else {
            bool = false
        }
        
        return bool
    }
    
    func getPriceStringFormat(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
             
        return formatter.string(from: NSNumber(value: value))!
    }
}
