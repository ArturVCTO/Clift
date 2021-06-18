//
//  CustomPaymentCardImageCell.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 17/06/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

enum cardPosition: String {
    case frontCard = "cardFormFront"
    case backCard = "cardFormBack"
}

class CustomPaymentCardImageCell: UITableViewCell {

    @IBOutlet weak var cardFormImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func animateCardImage(newCardPosition: cardPosition) {
        let newImage = UIImage(named: newCardPosition.rawValue)
        let animationTransition: UIView.AnimationOptions = newCardPosition == .frontCard ? .transitionFlipFromLeft : .transitionFlipFromRight
        
        UIView.transition(
            with: cardFormImageView,
            duration: 0.2,
            options: animationTransition,
            animations: {
                self.cardFormImageView.image = newImage
            })
    }
}
