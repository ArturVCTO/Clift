//
//  InvitationTemplateCollectionViewCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 11/21/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class InvitationTemplateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var templateNameLabel: UILabel!
    @IBOutlet weak var templateImageView: customImageView!
    
    func setup(invitationTemplate: InvitationTemplate) {
        self.templateNameLabel.text = invitationTemplate.name
        if let imageURL = URL(string:"\(invitationTemplate.thumbnailUrl)") {
            self.templateImageView.kf.setImage(with: imageURL)
        }
    }
}
