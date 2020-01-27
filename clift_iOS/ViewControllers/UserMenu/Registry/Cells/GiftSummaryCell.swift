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
    
    func configure(with gift: MockGift) {
        self.giftImageView.image = gift.image
        if gift.giftersEmail.count > 1 {
            self.gifterEmailLabel.text = "\(gift.giftersEmail.first ?? ""), +\(gift.giftersEmail.count - 1)"
        } else {
            self.gifterEmailLabel.text = gift.giftersEmail.first
        }
        self.gifterDateLabel.text = gift.dateGifted
        self.giftCategoryLabel.text = gift.category
    }
}
