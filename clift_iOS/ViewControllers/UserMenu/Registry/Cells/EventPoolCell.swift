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
    @IBOutlet weak var poolDescriptionLabel: UILabel!
    
    
    func setup(eventPool: EventPool) {
        self.poolNameLabel.text = eventPool.description
        
        var string = self.getPriceStringFormat(value: Double(eventPool.goal)!)
        let substring = string.suffix(string.count-1)
        self.poolPriceLabel.text = "\u{24}\(substring) MXN"
        self.poolDescriptionLabel.text = eventPool.note 
        
        if let imageURL = URL(string:"\(eventPool.imageUrl)") {
            self.eventPoolImageView.kf.setImage(with: imageURL)
        }
        
        if Float(eventPool.collectedAmount)! >= Float(eventPool.goal)!{
            self.isGiftedLabel.text = "Completado"
            self.giftGreenCheckMarkImageView.isHidden = false
        }else{
            self.isGiftedLabel.text = "Disponible"
            self.giftGreenCheckMarkImageView.isHidden = true
        }
        
        self.progressView.progress = Float(eventPool.collectedAmount)! / Float(eventPool.goal)!
        
        var amountLeft = self.getPriceStringFormat(value: Double(Float(eventPool.goal)! - Float(eventPool.collectedAmount)!))
        let amountLeftFormatted = amountLeft.suffix(amountLeft.count-1)
        
        self.contributionsLabel.text = "Faltan: \u{24}\(amountLeftFormatted) MXN"
        
        
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
