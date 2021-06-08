//
//  MainChosenInvitationCVCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 12/15/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class MainChosenInvitationCVCell: UICollectionViewCell {
    
    @IBOutlet weak var templateImageView: customImageView!
    @IBOutlet weak var invitationNameLabel: UILabel!
    func setup(invitation: Invitation) {
        self.invitationNameLabel.text = invitation.invitationTemplate?.name
        if let imageURL = URL(string:"\(invitation.invitationTemplate!.thumbnailUrl)") {
            self.templateImageView.kf.setImage(with: imageURL)
        }
    }
}
