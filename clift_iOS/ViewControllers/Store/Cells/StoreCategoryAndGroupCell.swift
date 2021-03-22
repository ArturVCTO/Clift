//
//  StoreCategoryAndGroupCell.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 23/02/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

class StoreCategoryAndGroupCell: UICollectionViewCell {

    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellLabel: UILabel!
    
    var cellWidthConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var cellWidth: CGFloat? {
        didSet{
            guard let cellWidth = cellWidth else { return }
            cellWidthConstraint?.constant = cellWidth
            cellWidthConstraint?.isActive = true
            contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    func configure(title: String, imageURLString: String) {
        if let imageURL = URL(string:"\(imageURLString)") {
            cellImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "cliftplaceholder"))
            cellImage.layer.cornerRadius = cellImage.frame.height/2
            cellImage.clipsToBounds = true
        }
        cellLabel.text = title.uppercased()
    }
}
