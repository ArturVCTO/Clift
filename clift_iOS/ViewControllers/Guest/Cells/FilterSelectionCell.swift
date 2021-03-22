//
//  FilterSelectionCell.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 18/03/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

class FilterSelectionCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            contentView.backgroundColor = UIColor.lightGray
        } else {
            contentView.backgroundColor = UIColor(red: 0.94117647058823528, green: 0.94117647058823528, blue: 0.93725490196078431, alpha: 1)
        }
    }
    
    func configure(title: String, subtitle: String = "") {
        titleLabel.text = title.uppercased()
        subtitleLabel.text = subtitle.uppercased()
    }
}
