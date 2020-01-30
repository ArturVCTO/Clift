//
//  GiftSummaryCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/24/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit

class GiftSummaryCell: UITableViewCell {
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var gifterEmailLabel: UILabel!
    @IBOutlet weak var gifterDateLabel: UILabel!
    @IBOutlet weak var giftCategoryLabel: UILabel!
    
    func configure(with gift: EventProduct) {
        if let imageURL = URL(string:"\(gift.product.imageUrl)") {
            self.giftImageView.kf.setImage(with: imageURL)
        }
//        if gift.giftersEmail.count > 1 {
//            self.gifterEmailLabel.text = "\(gift.giftersEmail.first ?? ""), +\(gift.giftersEmail.count - 1)"
//        } else {
//            self.gifterEmailLabel.text = gift.giftersEmail.first
//        }
//        self.gifterDateLabel.text = gift.product.
        self.giftCategoryLabel.text = gift.product.categories.first?.name
    }
}
