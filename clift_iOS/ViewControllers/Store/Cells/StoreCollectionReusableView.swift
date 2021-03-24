//
//  StoreCollectionReusableView.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 23/03/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

protocol StoreHeaderDelegate {
    func didTapSeeAllCategories()
    func didTapSeeAllShops()
}

enum storeHeaderType {
    case categoryHeader
    case shopHeader
}

class StoreCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    
    var storeHeaderDelegate: StoreHeaderDelegate!
    var storeHeaderType: storeHeaderType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(title:String, headerType: storeHeaderType, delegate: StoreHeaderDelegate) {
        storeHeaderDelegate = delegate
        storeHeaderType = headerType
        titleLabel.text = title
    }
    
    @IBAction func seeAllPressed(_ sender: UIButton) {
        
        switch storeHeaderType {
        case .categoryHeader:
            storeHeaderDelegate.didTapSeeAllCategories()
        case .shopHeader:
            storeHeaderDelegate.didTapSeeAllShops()
        default:
            break
        }
    }
}
