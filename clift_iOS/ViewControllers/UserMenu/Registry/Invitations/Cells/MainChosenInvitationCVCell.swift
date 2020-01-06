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
    
    @IBOutlet weak var invitationNameLabel: UILabel!
    func setup(invitation: Invitation) {
        self.invitationNameLabel.text = invitation.invitationTemplate?.name
    }
}
