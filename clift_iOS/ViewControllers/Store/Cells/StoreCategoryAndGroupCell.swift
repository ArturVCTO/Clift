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
        setCell()
    }
    
    func setCell() {
        cellImageView.layer.borderWidth = 1
        cellImageView.layer.masksToBounds = false
        cellImageView.layer.borderColor = UIColor.lightGray.cgColor
        cellImageView.layer.cornerRadius = 50//cellImageView.bounds.height / 2
        cellImageView.clipsToBounds = true
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
    }
}
