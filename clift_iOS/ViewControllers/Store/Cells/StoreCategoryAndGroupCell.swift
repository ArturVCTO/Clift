//
//  StoreCategoryAndGroupCell.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 23/02/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

class StoreCategoryAndGroupCell: UICollectionViewCell {

    @IBOutlet var cellImageView: UIView!
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellLabel: UILabel!
    
    var cellWidthConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCell() {
        cellImageView.layer.borderWidth = 1
        cellImageView.layer.masksToBounds = true
        cellImageView.layer.borderColor = UIColor.lightGray.cgColor
        if let width = cellWidth {
            cellImageView.layer.cornerRadius = (width - 6) / 2
            cellImageView.layer.shadowColor = UIColor.black.cgColor
            cellImageView.layer.shadowOpacity = 0.3
            cellImageView.layer.shadowOffset = .zero
            cellImageView.layer.shadowRadius = 3
        }
        cellImageView.clipsToBounds = false
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
        }
        cellLabel.text = title
        setCell()
    }
}
