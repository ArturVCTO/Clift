//
//  MainInvitationTemplateCVCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 12/15/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class MainInvitationTemplateCVCell: UICollectionViewCell {
    
    @IBOutlet weak var templateImageView: customImageView!
    @IBOutlet weak var templateNameLabel: UILabel!
    func setup(invitationTemplate: InvitationTemplate) {
        self.templateNameLabel.text = invitationTemplate.name
        if let imageURL = URL(string:"\(invitationTemplate.thumbnailUrl)") {
                   self.templateImageView.kf.setImage(with: imageURL)
        }
    }
}
