//
//  OnboardingInterestCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/14/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class OnboardingInterestCell: UICollectionViewCell {
    
    @IBOutlet weak var interestImage: UIImageView!
    @IBOutlet weak var interestName: UILabel!
    @IBOutlet weak var interestButton: UIButton!
    var parentVC: FourthStepOnboardingViewController!
    var interest = Interest()
    var interestId = ""
    let cellInterest = Interest()

    func setupInterest(interest: Interest) {
        cellInterest.interestId = interest.id
        self.interest = cellInterest
        if let imageURL = URL(string:"\(interest.imageUrl)") {
            self.interestImage.kf.setImage(with: imageURL)
        }
        self.interestId = interest.id
        self.interestName.text = interest.name
    }
    
    @IBAction func interestButtonTapped(_ sender: Any) {
        let onboardingUser = self.parentVC.rootParentVC.onboardingUser
        
        if interestButton.isSelected == true {
            onboardingUser.event.interests = onboardingUser.event.interests.dropLast()
           interestButton.isSelected = false
            interestImage.layer.borderWidth = 0.0
        } else {
            onboardingUser.event.interests.append(cellInterest)
           interestButton.isSelected = true
            interestImage.layer.borderWidth = 2.0
            interestImage.layer.borderColor = UIColor(red: 52/255, green: 179/255, blue: 69/255, alpha: 1.0).cgColor
        }
    }
}
